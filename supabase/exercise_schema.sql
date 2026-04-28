-- Guided Exercises Schema
-- Public readable exercises, user-owned session tracking

-- Guided Exercises (public to authenticated users)
CREATE TABLE IF NOT EXISTS guided_exercises (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('breathing', 'grounding', 'gratitude', 'cognitive', 'body_scan')),
  duration_seconds INTEGER NOT NULL DEFAULT 300,
  steps JSONB NOT NULL DEFAULT '[]',
  target_mood_scores INTEGER[] DEFAULT NULL,
  display_order INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Exercise Sessions (user-owned)
CREATE TABLE IF NOT EXISTS exercise_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  exercise_id UUID NOT NULL REFERENCES guided_exercises(id) ON DELETE CASCADE,
  started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ DEFAULT NULL,
  mood_before INTEGER CHECK (mood_before >= 1 AND mood_before <= 5),
  mood_after INTEGER CHECK (mood_after >= 1 AND mood_after <= 5),
  notes TEXT DEFAULT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Index for user session queries
CREATE INDEX IF NOT EXISTS idx_exercise_sessions_user_id ON exercise_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_exercise_sessions_exercise_id ON exercise_sessions(exercise_id);

-- RLS
ALTER TABLE guided_exercises ENABLE ROW LEVEL SECURITY;

-- Exercises are publicly readable by authenticated users
CREATE POLICY "Exercises are publicly readable"
  ON guided_exercises FOR SELECT
  TO authenticated
  USING (is_active = true);

-- Users can do anything with their own sessions
ALTER TABLE exercise_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users manage their own sessions"
  ON exercise_sessions FOR ALL
  TO authenticated
  USING (auth.uid() = user_id);

-- Seed: 5 predefined exercises
INSERT INTO guided_exercises (title, description, category, duration_seconds, steps, display_order) VALUES
(
  'Box Breathing',
  'A calming technique that regulates your breath to reduce stress and bring focus.',
  'breathing',
  240,
  '[
    {"instruction": "Inhale slowly through your nose for 4 seconds", "duration_seconds": 4},
    {"instruction": "Hold your breath for 4 seconds", "duration_seconds": 4},
    {"instruction": "Exhale slowly through your mouth for 4 seconds", "duration_seconds": 4},
    {"instruction": "Hold empty for 4 seconds", "duration_seconds": 4},
    {"instruction": "Repeat for 6 cycles", "duration_seconds": 224}
  ]'::jsonb,
  1
),
(
  '5-4-3-2-1 Grounding',
  'A sensory awareness technique to anchor you in the present moment.',
  'grounding',
  180,
  '[
    {"instruction": "Look around and name 5 things you can see", "duration_seconds": 30},
    {"instruction": "Notice 4 things you can physically feel", "duration_seconds": 30},
    {"instruction": "Listen for 3 sounds around you", "duration_seconds": 30},
    {"instruction": "Identify 2 things you can smell", "duration_seconds": 30},
    {"instruction": "Notice 1 thing you can taste", "duration_seconds": 30},
    {"instruction": "Take 3 deep breaths and return to the room", "duration_seconds": 30}
  ]'::jsonb,
  2
),
(
  'Gratitude Reflection',
  'A guided journaling exercise to cultivate appreciation and positive emotions.',
  'gratitude',
  300,
  '[
    {"instruction": "Think of 3 things you are grateful for today", "duration_seconds": 60},
    {"instruction": "Why does each of these matter to you?", "duration_seconds": 90},
    {"instruction": "Write or think about one person who made a positive impact on your life recently", "duration_seconds": 60},
    {"instruction": "If you could thank them right now, what would you say?", "duration_seconds": 60},
    {"instruction": "Take 3 deep breaths and carry this appreciation with you", "duration_seconds": 30}
  ]'::jsonb,
  3
),
(
  'Cognitive Reframe',
  'A structured technique to reframe negative thoughts into balanced perspectives.',
  'cognitive',
  360,
  '[
    {"instruction": "Identify a negative thought or worry on your mind", "duration_seconds": 45},
    {"instruction": "Write down the thought exactly as it feels", "duration_seconds": 45},
    {"instruction": "Ask: Is this thought 100% true? What evidence says yes? What evidence says no?", "duration_seconds": 90},
    {"instruction": "Rewrite the thought in a more balanced, realistic way", "duration_seconds": 90},
    {"instruction": "Take 3 deep breaths and acknowledge that thoughts are not facts", "duration_seconds": 90}
  ]'::jsonb,
  4
),
(
  'Body Scan',
  'A progressive relaxation technique to release tension and increase body awareness.',
  'body_scan',
  420,
  '[
    {"instruction": "Close your eyes and take 3 slow breaths. Relax your body.", "duration_seconds": 30},
    {"instruction": "Focus attention on your feet. Notice any sensations, tension, or warmth.", "duration_seconds": 45},
    {"instruction": "Slowly move awareness up through your legs, knees, and thighs.", "duration_seconds": 60},
    {"instruction": "Notice your hips, lower back, and stomach area. Release any tension.", "duration_seconds": 60},
    {"instruction": "Scan your chest, upper back, and shoulders. Breathe into these areas.", "duration_seconds": 60},
    {"instruction": "Move awareness through your arms, elbows, wrists, and hands.", "duration_seconds": 45},
    {"instruction": "Notice your neck, jaw, and face. Soften any lingering tension.", "duration_seconds": 45},
    {"instruction": "Take 3 deep breaths and slowly open your eyes. Return to the room.", "duration_seconds": 75}
  ]'::jsonb,
  5
);