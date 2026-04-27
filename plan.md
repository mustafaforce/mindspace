# Mind Space - Implementation Plan

## Context

The Mind Space mental wellness app currently has only authentication and profile management working. The proposal outlines 6 major features. We will build **Phase 1 (Mood Logging) + Phase 3 (Guided Exercises) + Phase 4 (Wellness Resources)** together since they share infrastructure and can be developed in parallel.

---

## Architecture Overview (Existing)

- **Pattern:** Clean Architecture with `data/domain/presentation` layers per feature
- **State:** `ChangeNotifier` + `ListenableBuilder`
- **Routing:** Manual `NavigationService` + `AppRoutes` switch statement
- **Backend:** Supabase (Auth + PostgreSQL)
- **UI:** Material 3 with custom theme (`primary #2A7A78`, `secondary #2E5EAA`)

---

## Database Schema (11 tables)

### Mood Logging
- **`mood_logs`** — id, user_id, mood_score (1-5), mood_label, created_at
- **`mood_question_responses`** — id, user_id, mood_log_id, question_id, response_value (1-5), created_at
- **`custom_mood_labels`** — id, user_id, mood_score (1-5), label, created_at

### Journaling
- **`journal_entries`** — id, user_id, mood_log_id (nullable), entry_text, entry_type (free_write/guided/reflection), prompt_question, created_at, updated_at

### Mood Questions
- **`mood_questions`** — id, question_text, display_order, category, is_active (pre-seeded with 7 questions)

### Guided Exercises
- **`guided_exercises`** — id, title, description, category, duration_seconds, steps (JSON), target_mood_scores, display_order, is_active (public read)
- **`exercise_sessions`** — id, user_id, exercise_id, started_at, completed_at, mood_before, mood_after, notes

### Wellness Resources
- **`resource_categories`** — id, name, icon, display_order
- **`wellness_resources`** — id, category_id, title, summary, content (markdown), thumbnail_url, read_time_minutes, tags, is_featured, display_order, is_active
- **`saved_resources`** — user_id, resource_id (composite PK), saved_at

### Notifications
- **`notification_preferences`** — user_id, daily_reminder_enabled, daily_reminder_time, weekly_insight_enabled, exercise_reminder_enabled, created_at, updated_at

All tables: RLS enabled (users own their data). `guided_exercises` and `wellness_resources` are publicly readable to authenticated users.

---

## Features to Build

### Feature 1: Mood Logging & Journaling
- 5-emoji mood selector on home screen
- 7 mood detection questions (1-5 scale each)
- Custom mood labels per user
- Text journal entries (free_write, guided, reflection types)
- Journal history list with filtering

### Feature 2: Guided Journaling & Mindfulness
- Predefined exercises (breathing, grounding, gratitude, cognitive, body scan)
- Timer UI with step-by-step instructions
- Exercise session tracking (mood before/after)

### Feature 3: Wellness Resources
- Resource categories with icons
- Article list with thumbnails and summaries
- Bookmark/save functionality
- Markdown content rendering

### Feature 4: Notifications & Reminders (table only)
- Notification preferences table
- Daily reminder, weekly insight, exercise reminder toggles

---

## UI Structure

**Bottom Navigation (5 tabs):**
```
[Home] [Journal] [Insights] [Resources] [Profile]
```

- **Home:** Quick mood selector → 7 questions → save + suggested exercise
- **Journal:** Entry list + FAB for new entry (free write or guided)
- **Insights:** Simple mood history chart (placeholder this phase)
- **Resources:** Category chips + featured + article list + bookmarks
- **Profile:** Existing profile screen + notification settings

---

## Routes to Add

| Route | Screen |
|-------|--------|
| `/home` | HomeScreen (updated with bottom nav + mood selector) |
| `/mood-log` | MoodLoggerScreen |
| `/journal` | JournalScreen |
| `/journal/new` | JournalEntryScreen |
| `/journal/:id` | JournalEntryScreen (edit) |
| `/exercises` | ExerciseListScreen |
| `/exercises/:id` | ExercisePlayerScreen |
| `/resources` | ResourcesScreen |
| `/resources/:id` | ResourceDetailScreen |
| `/insights` | InsightsScreen |

---

## Files to Create

### Mood Feature (`lib/features/mood/`)
```
data/datasources/mood_remote_datasource.dart
data/models/mood_log_model.dart
data/models/journal_entry_model.dart
data/models/mood_question_model.dart
data/repositories/mood_repository_impl.dart
domain/entities/mood_log.dart
domain/entities/journal_entry.dart
domain/repositories/mood_repository.dart
domain/usecases/log_mood_usecase.dart
domain/usecases/get_mood_history_usecase.dart
domain/usecases/create_journal_entry_usecase.dart
domain/usecases/get_journal_entries_usecase.dart
presentation/controllers/mood_view_model.dart
presentation/controllers/journal_view_model.dart
presentation/pages/mood_logger_screen.dart
presentation/pages/journal_screen.dart
presentation/pages/journal_entry_screen.dart
presentation/widgets/mood_selector.dart
presentation/widgets/mood_history_list.dart
presentation/widgets/journal_entry_card.dart
```

### Exercises Feature (`lib/features/exercises/`)
```
data/datasources/exercise_remote_datasource.dart
data/models/guided_exercise_model.dart
data/models/exercise_session_model.dart
data/repositories/exercise_repository_impl.dart
domain/entities/guided_exercise.dart
domain/entities/exercise_session.dart
domain/repositories/exercise_repository.dart
domain/usecases/get_exercises_usecase.dart
domain/usecases/start_exercise_session_usecase.dart
presentation/controllers/exercise_view_model.dart
presentation/pages/exercise_list_screen.dart
presentation/pages/exercise_player_screen.dart
presentation/widgets/exercise_card.dart
presentation/widgets/breathing_animation.dart
```

### Resources Feature (`lib/features/resources/`)
```
data/datasources/resource_remote_datasource.dart
data/models/resource_category_model.dart
data/models/wellness_resource_model.dart
data/repositories/resource_repository_impl.dart
domain/entities/resource_category.dart
domain/entities/wellness_resource.dart
domain/repositories/resource_repository.dart
domain/usecases/get_categories_usecase.dart
domain/usecases/get_resources_usecase.dart
domain/usecases/save_resource_usecase.dart
presentation/controllers/resource_view_model.dart
presentation/pages/resources_screen.dart
presentation/pages/resource_detail_screen.dart
presentation/widgets/resource_card.dart
presentation/widgets/category_chips.dart
```

### SQL Files (`supabase/`)
```
mood_schema.sql
journal_schema.sql
exercise_schema.sql
resource_schema.sql
notification_schema.sql
```

### Updates to Existing Files
```
lib/core/routing/app_routes.dart — add new routes
lib/features/home/presentation/pages/home_screen.dart — add bottom nav + mood selector
lib/core/theme/app_theme.dart — add exercise/resource colors if needed
```

---

## Dependencies to Add

```yaml
# pubspec.yaml
dependencies:
  fl_chart: ^0.69.0
```

---

## Implementation Order

1. **SQL schemas** (`supabase/` folder)
2. **Mood feature** (foundation — all others depend on it)
3. **Journal feature** (reuses mood infrastructure)
4. **Exercises feature** (uses journal entry type)
5. **Resources feature** (independent, can parallel)
6. **Home screen** (bottom nav + mood selector widget)
7. **Routing** (wire everything together)

---

## Verification

- App runs → Login → Home shows 5-emoji mood selector
- Tap mood → 7 questions appear → answer → saved to Supabase
- Journal tab → create entry → saved
- Resources tab → browse + bookmark articles
- Exercises tab → view + start guided exercise → timer works
- All data persists after logout/login