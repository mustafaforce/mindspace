-- Wellness Resources Schema
-- Public readable resources, user-owned bookmarks

-- Resource Categories
CREATE TABLE IF NOT EXISTS resource_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  icon TEXT NOT NULL DEFAULT '📚',
  display_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Wellness Resources (public to authenticated users)
CREATE TABLE IF NOT EXISTS wellness_resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id UUID NOT NULL REFERENCES resource_categories(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  summary TEXT NOT NULL DEFAULT '',
  content TEXT NOT NULL DEFAULT '',
  thumbnail_url TEXT DEFAULT NULL,
  read_time_minutes INTEGER NOT NULL DEFAULT 5,
  tags TEXT[] DEFAULT '{}',
  is_featured BOOLEAN NOT NULL DEFAULT false,
  display_order INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Saved Resources (user-owned bookmarks)
CREATE TABLE IF NOT EXISTS saved_resources (
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  resource_id UUID NOT NULL REFERENCES wellness_resources(id) ON DELETE CASCADE,
  saved_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, resource_id)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_wellness_resources_category_id ON wellness_resources(category_id);
CREATE INDEX IF NOT EXISTS idx_wellness_resources_is_featured ON wellness_resources(is_featured) WHERE is_featured = true;
CREATE INDEX IF NOT EXISTS idx_saved_resources_user_id ON saved_resources(user_id);

-- RLS
ALTER TABLE resource_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE wellness_resources ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_resources ENABLE ROW LEVEL SECURITY;

-- Categories are publicly readable
CREATE POLICY "Categories are publicly readable"
  ON resource_categories FOR SELECT
  TO authenticated
  USING (true);

-- Resources are publicly readable by authenticated users
CREATE POLICY "Resources are publicly readable"
  ON wellness_resources FOR SELECT
  TO authenticated
  USING (is_active = true);

-- Users manage their own saved resources
CREATE POLICY "Users manage their own saved resources"
  ON saved_resources FOR ALL
  TO authenticated
  USING (auth.uid() = user_id);

-- Seed: categories
INSERT INTO resource_categories (name, icon, display_order) VALUES
  ('Articles', '📖', 1),
  ('Videos', '🎬', 2),
  ('Exercises', '🧘', 3),
  ('Podcasts', '🎙️', 4),
  ('Tips', '💡', 5);

-- Seed: wellness resources
INSERT INTO wellness_resources (category_id, title, summary, content, read_time_minutes, tags, is_featured, display_order) VALUES
  (
    (SELECT id FROM resource_categories WHERE name = 'Articles' LIMIT 1),
    'Understanding Anxiety: A Comprehensive Guide',
    'Learn what anxiety is, how it affects your body and mind, and evidence-based strategies to manage it effectively.',
    '# Understanding Anxiety\n\nAnxiety is a natural response to stress, but when it becomes overwhelming, it can interfere with daily life.\n\n## What is Anxiety?\n\nAnxiety is your body''s natural response to perceived threats. It triggers the "fight or flight" response, releasing cortisol and adrenaline.\n\n## Common Symptoms\n\n- Excessive worry\n- Restlessness\n- Difficulty concentrating\n- Sleep problems\n- Physical symptoms like rapid heartbeat\n\n## Coping Strategies\n\n1. **Deep Breathing**: Practice box breathing (inhale 4s, hold 4s, exhale 4s, hold 4s)\n2. **Grounding**: Use the 5-4-3-2-1 technique to anchor yourself in the present\n3. **Exercise**: Regular physical activity reduces anxiety by 20-40%\n4. **Sleep**: Aim for 7-9 hours of quality sleep\n5. **Limit Caffeine**: Reduce stimulants that can trigger anxiety',
    8,
    ARRAY['anxiety', 'mental-health', 'coping', 'beginner'],
    true,
    1
  ),
  (
    (SELECT id FROM resource_categories WHERE name = 'Articles' LIMIT 1),
    'The Science of Sleep: Why Rest Matters',
    'Discover why quality sleep is essential for mental health, and learn practical tips to improve your sleep hygiene.',
    '# The Science of Sleep\n\nSleep is not passive—your brain is actively processing emotions, consolidating memories, and repairing itself.\n\n## Sleep Stages\n\n1. **Light Sleep (N1-N2)**: Body temperature drops, heart rate slows\n2. **Deep Sleep (N3)**: Growth hormone release, tissue repair, immune function\n3. **REM Sleep**: Dreaming, emotional processing, memory consolidation\n\n## Why Sleep Matters for Mental Health\n\n- Sleep deprivation increases cortisol (stress hormone)\n-REM sleep helps process emotional memories\n- Poor sleep is linked to increased anxiety and depression\n\n## Sleep Hygiene Tips\n\n1. Stick to a consistent sleep schedule\n2. Keep your bedroom cool (65-68°F / 18-20°C)\n3. Avoid screens 1 hour before bed\n4. Limit caffeine after 2pm\n5. Create a relaxing bedtime routine',
    6,
    ARRAY['sleep', 'mental-health', 'wellness', 'beginner'],
    true,
    2
  ),
  (
    (SELECT id FROM resource_categories WHERE name = 'Tips' LIMIT 1),
    '5-Minute Mindfulness Exercises for Busy People',
    'Short on time? These quick mindfulness exercises can be done anywhere, anytime to reduce stress and increase focus.',
    '# 5-Minute Mindfulness Exercises\n\nYou don''t need 30 minutes to practice mindfulness. Try these micro-exercises:\n\n## 1. Box Breathing (1 minute)\nInhale 4 counts, hold 4 counts, exhale 4 counts, hold 4 counts. Repeat 4 times.\n\n## 2. Body Scan (2 minutes)\nClose your eyes. Starting from your toes, notice sensations in each body part, moving up to your head.\n\n## 3. Mindful Observation (1 minute)\nChoose an object near you. Focus entirely on its colors, textures, and details for 60 seconds.\n\n## 4. Gratitude Check-in (1 minute)\nName 3 things you are grateful for right now. Be specific about why.\n\n## 5. Mindful Walking (if space allows)\nWalk slowly, focusing on each step. Feel your feet touching the ground.\n\n---\n*Consistency matters more than duration. Even 1 minute of daily practice builds neural pathways for calm.*',
    5,
    ARRAY['mindfulness', 'stress', 'quick', 'beginner'],
    false,
    3
  ),
  (
    (SELECT id FROM resource_categories WHERE name = 'Exercises' LIMIT 1),
    'Progressive Muscle Relaxation Guide',
    'A step-by-step guide to progressive muscle relaxation, a technique that helps release physical tension and calm your mind.',
    '# Progressive Muscle Relaxation\n\nThis technique involves tensing and releasing muscle groups to reduce physical tension and promote relaxation.\n\n## How It Works\n\nBy intentionally tensing muscles followed by relaxation, you become more aware of physical sensations and learn to release tension you didn''t know you were holding.\n\n## The Sequence\n\n1. **Feet**: Curl toes tightly for 5 seconds, then release\n2. **Calves**: Point toes toward shin, hold, release\n3. **Thighs**: Squeeze thigh muscles, release\n4. **Glutes**: Tighten buttocks, release\n5. **Stomach**: Pull navel toward spine, release\n6. **Chest**: Take a deep breath, hold, exhale fully\n7. **Hands**: Make tight fists, release\n8. **Arms**: Bend elbows, tense biceps, release\n9. **Shoulders**: Raise toward ears, release\n10. **Face**: Scrunch muscles (eyes, nose, mouth), release\n\n## Tips\n\n- Practice in a quiet, comfortable space\n- Don''t strain muscles—tense firmly but not to the point of cramping\n- Focus on the contrast between tension and relaxation\n- Practice daily for best results',
    7,
    ARRAY['relaxation', 'body', 'stress', 'beginner'],
    false,
    4
  ),
  (
    (SELECT id FROM resource_categories WHERE name = 'Articles' LIMIT 1),
    'Building a Support System: Why Connections Matter',
    'Human connection is vital for mental health. Learn how to build and maintain meaningful relationships that support your wellbeing.',
    '# Building a Support System\n\nStrong social connections are one of the strongest predictors of mental health and longevity.\n\n## The Research\n\nHarvard''s 85-year study found that quality of relationships is the strongest predictor of life satisfaction and health outcomes—even more than genetics or environment.\n\n## Types of Support\n\n1. **Emotional Support**: People who listen without judgment\n2. **Informational Support**: People who share knowledge and resources\n3. **Practical Support**: People who help with tasks or logistics\n\n## How to Build Connections\n\n- **Reach out regularly**: Send a text, make a call, schedule coffee\n- **Be vulnerable**: Share your struggles alongside your successes\n- **Practice active listening**: Focus fully on the other person\n- **Join communities**: Clubs, classes, groups aligned with your interests\n- **Quality over quantity**: 3-5 deep connections matter more than 100 shallow ones\n\n## When to Seek Help\n\nIf you feel isolated despite effort, or if social situations cause severe anxiety, consider speaking with a therapist who can help identify barriers and strategies.',
    9,
    ARRAY['relationships', 'social', 'community', 'intermediate'],
    false,
    5
  );