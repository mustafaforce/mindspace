-- =============================================
-- MOOD LOGGING SCHEMA
-- Tables: mood_logs, mood_questions, mood_question_responses, custom_mood_labels
-- =============================================

-- Mood Logs: Core daily mood entries
CREATE TABLE public.mood_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  mood_score integer NOT NULL CHECK (mood_score >= 1 AND mood_score <= 5),
  mood_label text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now())
);

-- Mood Questions: The 7 predefined mood detection questions
CREATE TABLE public.mood_questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  question_text text NOT NULL,
  display_order integer NOT NULL,
  category text NOT NULL CHECK (category IN ('emotional', 'physical', 'social', 'cognitive')),
  is_active boolean NOT NULL DEFAULT true
);

-- Mood Question Responses: User answers to the 7 questions per mood log
CREATE TABLE public.mood_question_responses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  mood_log_id uuid NOT NULL REFERENCES public.mood_logs(id) ON DELETE CASCADE,
  question_id uuid NOT NULL REFERENCES public.mood_questions(id) ON DELETE CASCADE,
  response_value integer NOT NULL CHECK (response_value >= 1 AND response_value <= 5),
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  UNIQUE (mood_log_id, question_id)
);

-- Custom Mood Labels: User-defined labels for each mood score
CREATE TABLE public.custom_mood_labels (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  mood_score integer NOT NULL CHECK (mood_score >= 1 AND mood_score <= 5),
  label text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT timezone('utc', now()),
  UNIQUE (user_id, mood_score)
);

-- =============================================
-- ROW LEVEL SECURITY
-- =============================================

ALTER TABLE public.mood_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mood_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mood_question_responses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.custom_mood_labels ENABLE ROW LEVEL SECURITY;

-- mood_logs: Users can CRUD their own
CREATE POLICY "Users can CRUD own mood logs"
  ON public.mood_logs FOR ALL
  TO authenticated
  USING (auth.uid() = user_id);

-- mood_questions: Anyone can read active questions (for the app to display)
CREATE POLICY "Anyone can view active mood questions"
  ON public.mood_questions FOR SELECT
  TO authenticated
  USING (is_active = true);

-- mood_question_responses: Users can CRUD their own
CREATE POLICY "Users can CRUD own question responses"
  ON public.mood_question_responses FOR ALL
  TO authenticated
  USING (auth.uid() = user_id);

-- custom_mood_labels: Users can CRUD their own
CREATE POLICY "Users can CRUD own custom mood labels"
  ON public.custom_mood_labels FOR ALL
  TO authenticated
  USING (auth.uid() = user_id);

-- =============================================
-- SEED: Pre-populate the 7 mood detection questions
-- =============================================

INSERT INTO public.mood_questions (question_text, display_order, category) VALUES
  ('How would you describe your overall mood today?', 1, 'emotional'),
  ('How much stress did you feel today?', 2, 'emotional'),
  ('How energetic or motivated did you feel today?', 3, 'physical'),
  ('How focused or attentive were you today?', 4, 'cognitive'),
  ('How social or isolated did you feel today?', 5, 'social'),
  ('How calm or relaxed did you feel today?', 6, 'emotional'),
  ('How strong or resilient did you feel mentally today?', 7, 'cognitive');