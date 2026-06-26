# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

An Obsidian vault of personal software engineering notes, published as a static website via [Quartz v5](https://quartz.jzhao.xyz). The vault root holds all `.md` notes; the `quartz/` subdirectory is the static site generator that reads the vault and builds the site.

Deployment is automatic: pushing to `master` triggers the GitHub Actions workflow (`.github/workflows/deploy.yml`), which builds the site inside `quartz/` using `..` as the content source and deploys it to GitHub Pages at `limzishen.github.io/Everything-Bank`.

## Local Development

All commands run from the `quartz/` directory:

```bash
cd quartz
npm ci                         # install dependencies
npx quartz plugin install      # install Quartz plugins (required after npm ci)
npx quartz build --serve --directory ..   # dev server with hot reload on http://localhost:8080
npx quartz build --directory .. --output public   # production build
```

Type-check and format:

```bash
npm run check    # tsc --noEmit + prettier check
npm run format   # prettier --write
npm run test     # tsx --test
```

## Architecture

```
Everything-Bank/          ← Obsidian vault root; all .md notes live here
├── quartz/               ← Quartz SSG (Node, TypeScript)
│   ├── quartz.config.yaml       ← site config: title, URL, theme, enabled plugins
│   ├── quartz/                  ← Quartz core (plugins, components, CLI, styles)
│   └── package.json
├── Attachments/          ← images pasted from Obsidian
├── <Topic>/              ← note directories (DB/, OS/, Concurrency/, etc.)
└── Index.md              ← vault home page
```

**Content → Site pipeline:** Quartz reads from `..` (vault root), ignores `.obsidian/`, `quartz/`, `README.md`, and `private/` (see `ignorePatterns` in `quartz.config.yaml`), then builds HTML into `quartz/public/`.

**Plugins** are declared in `quartz/quartz.config.yaml` under `plugins:`. They are sourced from GitHub (`github:quartz-community/<name>`) and installed locally via `npx quartz plugin install`. Active ones include Obsidian-flavored Markdown, syntax highlighting, KaTeX LaTeX, backlinks, search, explorer, breadcrumbs, and table of contents.

**Note format:** standard Markdown with Obsidian wiki-links (`[[Note Name]]`), resolved by the `crawl-links` plugin using `markdownLinkResolution: shortest`.

## Key Config

`quartz/quartz.config.yaml` is the single place to change:
- Site title / base URL
- Theme colors and fonts
- Which plugins are enabled and their options
- Layout positions of UI components

`.gitignore` excludes `workspace.json` (Obsidian state), `quartz/node_modules/`, `quartz/public/`, and `quartz/.quartz-cache/` — never commit these.
