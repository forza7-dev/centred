# PCP Tools — Project Context

## What this is
Interactive web app for completing Person-Centred Planning tools. Users pick a tool, fill in each section step by step, and get a polished generated document they can edit, export as PDF, or share.

## Stack
- Nuxt 4 + TypeScript + Tailwind CSS
- Data: localStorage (no backend yet)
- PDF export: html2pdf.js
- Dev server: `PATH="/home/noe/.nvm/versions/node/v24.14.0/bin:$PATH" npm run dev -- --port 3333`

## Design rules
- Palette: Teal `#72B9CF`, Coral `#CF8872`, Navy dark `#161F38`, Sand `#FAF6F0`
- Fonts: DM Sans (body), Marcellus (headings)
- No em dashes in copy
- European English throughout
- No Americanisms

## Architecture
- `app/composables/useTools.ts` — tool definitions (steps, fields, field types)
- `app/composables/useToolData.ts` — localStorage CRUD, multi-instance entries
- `app/pages/index.vue` — dashboard listing all tools and saved entries
- `app/pages/fill/[id].vue` — step-by-step wizard
- `app/pages/view/[id].vue` — generated summary with Edit/PDF/Delete

## Key design decisions
- Each tool is a reusable template (not single-use). Users create multiple entries per tool.
- No "Completed" status. Dashboard shows saved entries by name and date.
- Final step button says "Generate", not "Finish".
- Entry data must load in `onMounted()` (not setup level) because localStorage is unavailable during SSR.

## Tool naming
Uses custom names to avoid reproducing copyrighted framework names. Reference: `PCP_Tool_Naming_Reference.docx` in parent directory.

## Current tools (micro)
About Me, What Matters & What Helps, My People, My Best Day / My Worst Day, What's Working, Roles & Boundaries, How I Communicate

## Still to build
- Remaining micro-tools: Decision-making profile, Learning log, Matching support, 4+1 Questions, Perfect week, Presence to contribution
- Macro-planning tools: My Direction (PATH), My Story (MAPS), How I Live (ELP), My Next Chapter (PFP)
