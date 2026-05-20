# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A single-file static Korean-language USA travel guide (`index.html`). All HTML, CSS, and JavaScript live in that one file — no build system, no package manager, no framework.

`실습CODEX_0.txt` is reference/exercise material for OpenAI Codex setup; treat it as read-only documentation, not runtime source.

## Running the Site

Open directly in a browser:
```sh
xdg-open index.html
```

Or serve locally for browser API testing:
```sh
python3 -m http.server 8000
# Then visit http://localhost:8000
```

No install step required.

## Architecture

`index.html` is structured in five sections (each with a matching `<section id="...">` and nav anchor): `#cities`, `#itinerary`, `#budget`, `#tips`, `#faq`.

The embedded `<script>` block runs five self-contained behaviors in an IIFE:
1. **Smooth scroll** — intercepts `<a href="#...">` clicks
2. **City filter** — toggles `.hidden` on `.city-card` elements by `data-category`
3. **FAQ accordion** — expands/collapses `.faq-answer` via `max-height`; closes others on open
4. **Scroll reveal** — `IntersectionObserver` adds `.visible` to `.reveal` elements
5. **Active nav highlight** — second `IntersectionObserver` adds `.active` to matching nav `<a>` tags

CSS is embedded in `<style>` in `<head>`. All variables are defined on `:root`. Class names use kebab-case (`city-card`, `filter-btn`, `timeline-item`). Related styles are grouped with short section comments.

## Conventions

- 2-space indentation throughout HTML, CSS, and JavaScript
- Korean user-facing copy must be preserved unless a change explicitly requires translation
- New source files go at the repo root unless folders become necessary (`assets/`, `styles/`, `scripts/`)
- Commit messages are short and imperative (e.g. `Update travel guide layout`)

## Testing

No automated test framework. After changes, manually verify in a browser:
- Filter buttons show/hide city cards correctly
- FAQ items expand and collapse (only one open at a time)
- Nav links scroll smoothly and highlight the active section
- Layout is correct at mobile widths (≤640px)
- Browser console has no errors
