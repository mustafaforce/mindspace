-- =============================================
-- JOURNAL SCHEMA
-- Table: journal_entries
-- =============================================

CREATE TABLE public.journal_entries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  mood_log_id uuid REFERENCES public.mood_logs(id) ON DELETE SET NULL,
  entry_text text NOT NULL,
  entry_type text NOT NULL CHECK (entry_type IN ('free_write', 'guided', 'reflection')),
  prompt_question text,
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  updated_at timestamptz NOT NULL DEFAULT timezone('utc', now())
);

-- =============================================
-- ROW LEVEL SECURITY
-- =============================================

ALTER TABLE public.journal_entries ENABLE ROW LEVEL SECURITY;

-- Users can CRUD their own journal entries
CREATE POLICY "Users can CRUD own journal entries"
  ON public.journal_entries FOR ALL
  TO authenticated
  USING (auth.uid() = user_id);

-- Trigger to auto-update updated_at
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = timezone('utc', now());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_journal_entry_updated_at
  BEFORE UPDATE ON public.journal_entries
  FOR EACH ROW
  EXECUTE FUNCTION public.set_updated_at();