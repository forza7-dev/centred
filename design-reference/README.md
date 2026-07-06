# CENTRED — design reference (Nuxt prototype)

> This is Noe's original Nuxt/Vue prototype, kept as a frozen UX/content
> reference. The real product is the Flutter app at the repo root.

Interactive web app for completing Person-Centred Planning tools. Users pick a tool, fill it in step by step, and get a polished generated document they can edit, export as a PDF, or share.

Built by Forza7 (Noe Giacari, David Coldeira).

## GitHub

Repo: [`forza7-dev/centred`](https://github.com/forza7-dev/centred) (public)

There is no hosted/live version. This app is not deployed anywhere (previously on Vercel, now removed). To see it running, clone the repo and run it locally — see below.

## Running locally

Requires Node.js (v24 recommended).

```bash
git clone https://github.com/forza7-dev/centred.git
cd centred/design-reference
npm install
npm run dev
```

Then open the URL printed in the terminal (defaults to `http://localhost:3000`).

## Stack

- Nuxt 4 + TypeScript + Tailwind CSS
- Client-only app (`ssr: false`) — no server rendering
- PDF export: html2pdf.js
- Voice input: Web Speech API (Chrome/Edge/Safari only, hidden in Firefox)

## Data & privacy

Fully ephemeral by design: there is no backend and no localStorage. All entry data lives only in memory for the current session. Closing the tab, refreshing, or navigating away loses any unsaved entry. After a PDF export, the entry is automatically cleared.

## Tools

**Micro-tools:** About Me, What Matters & What Helps, My People, My Best Day / My Worst Day, What's Working, How I Communicate, My Perfect Week

**Macro-tools:** My Direction (PATH-style), My Story (MAPS-style)

More macro-tools planned: How I Live (Essential Lifestyle Planning), My Next Chapter (Personal Futures Planning).

## Design

- Palette: Teal `#72B9CF`, Coral `#CF8872`, Navy dark `#161F38`, Sand `#FAF6F0`
- Fonts: DM Sans (body), Marcellus (headings), Caveat (handwritten option)
- European English throughout, no em dashes in copy
