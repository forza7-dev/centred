# Centred — Project Context

## What this is
Flutter app for completing Person-Centred Planning (PCP) tools. Users pick a
tool, fill in each section step by step, and get a polished generated
document they can edit, personalise, export as PDF, or share.

`design-reference/` holds Noe's original Nuxt/Vue prototype — a frozen UX/
content reference, not deployed anywhere, not the product being built.

## Stack
- Flutter + Dart, Riverpod (`flutter_riverpod`, hand-written providers, no
  codegen) + go_router
- Data: fully ephemeral, in-memory only for the session — no backend, no
  local persistence of any kind. Entry data is deleted the instant its PDF
  is exported.
- PDF export: `RepaintBoundary` → image → `pdf` + `printing` packages
- Voice input: `speech_to_text`. Photos: `image_picker` (bytes read into
  memory immediately, never left on disk).

## Design rules
- Palette: Teal `#72B9CF`, Coral `#CF8872`, Navy dark `#161F38`, Sand `#FAF6F0`
- Fonts via `google_fonts`: Quicksand (app-chrome headings), DM Sans (body/
  document default), Marcellus and Caveat (document personalisation options
  only)
- No em dashes in copy
- European English throughout
- No Americanisms

## Flutter rules
Follows the mandatory rules in the root `/home/testuser/development/forza7/CLAUDE.md`
(every widget a class, no `Widget _buildX()` functions, one class widget per
file, Riverpod-only state, `const` everywhere, go_router-only navigation,
theme-driven styling, pinned pubspec versions, tests per screen/provider).

## Architecture
- `lib/src/theme/` — `AppColors`, `AppText`, `AppTheme`
- `lib/src/models/` — `ToolDefinition`/`ToolStep`/`ToolField`/`FieldType`,
  `FieldValue` (sealed), `SavedEntry`, `PersonalisationSettings`
- `lib/src/providers/` — cross-cutting only: tool catalog (static), saved
  entries (the ephemeral in-memory store)
- `lib/src/components/` — **pure, presentational widgets only**: constructor
  data in, callbacks out, no `ref.watch`, no business logic. This is where
  buttons/fields/chips/cards/etc. live.
- `lib/src/features/` — one folder per feature (`dashboard`, `fill_wizard`,
  `document`, `gdpr_confirmation`, `speech`, `photo`), each owning its own
  page(s), providers, and feature-specific (non-pure) widgets
- `lib/src/features/document/layouts/` — the 9 bespoke per-tool generated-
  document layouts, plus a generic fallback for future tools
- `lib/src/app/router.dart` — central `routerProvider`

Full implementation plan: `~/.claude/plans/lovely-nibbling-map.md`.

## Key design decisions
- Each tool is a reusable template (not single-use). Users create multiple
  entries per tool.
- No "Completed" status. Dashboard shows saved entries by name and date.
- Final step button says "Generate", not "Finish".
- Routes key off `entryId` only (`/fill/:entryId`, `/view/:entryId`);
  `toolId` is resolved from the entry, never duplicated in the URL.
- GDPR confirmation is its own route (`/gdpr-confirmation`), reached only
  after a successful PDF export + entry deletion.

## Tool naming
Uses custom names to avoid reproducing copyrighted framework names. Reference:
`PCP_Tool_Naming_Reference.docx` in the parent directory.

## Tools (v1, full parity with the Nuxt prototype)
Micro: About Me, What Matters & What Helps, My People, My Best Day / My Worst
Day, What's Working, How I Communicate, My Perfect Week
Macro: My Direction (PATH-style), My Story (MAPS-style)
