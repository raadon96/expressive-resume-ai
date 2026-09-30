# AGENTS.md

This file provides guidance to AI coding agents working in this repository.

## What This Repo Is

A LaTeX resume and cover letter system based on the [Expressive Resume](https://github.com/thehale/expressive-resume) template (Adnene Boumessouer, ML Engineer).

Two git repos share this folder (terms in `CONTEXT.md`, decision in `docs/adr/0001-nested-data-repo.md`):

- **Tool Repo** (this repo): document classes, Scaffold, commands, scripts. No personal data.
- **Data Repo** (`data/`): the user's Profile, Applications and Application Index. Its own git repo, gitignored by the Tool Repo. Commit data changes inside `data/`, tool changes in the outer repo.

Grep and `grep`/`ugrep` skip the gitignored `data/` when searching from the repo root, so always search explicit `data/…` paths.

### Directory Structure

```
src/
├── Expressive.cls                      # shared base class (don't touch)
├── ExpressiveResume.cls                # resume document class (don't touch)
├── ExpressiveCoverLetter.cls           # cover letter document class (don't touch)
└── scaffold/
    ├── application/                    # copied by /create-application for each new Application
    │   ├── resume.tex
    │   └── coverletter.tex
    └── data/                           # copied into data/ by setup.sh (README.md, .gitignore, index.md)

example/                                # fictional example, same layout as data/
├── index.md
├── profile/
├── templates/MLEng/                    # example Role Template (not copied by setup.sh)
└── applications/26.04.26_mleng@ExampleCompany/

data/                                   # Data Repo (gitignored, own git repo, created by setup.sh)
├── index.md                            # Application Index
├── profile/
│   ├── contact.md                      # canonical personal details for the headers
│   ├── experience.md                   # LinkedIn Experience section (source of truth for work history)
│   ├── qualifications.md               # degrees, certifications, spoken languages
│   ├── projects/                       # reusable project write-ups (English + German _de variants)
│   │                                   # Structure per file: Summary → Context & Pain Points →
│   │                                   # Spoken Narrative (bullet points) → Architecture → Q&A Cheat Sheet
│   └── images/                         # shared assets (e.g. QR code: qr_code.png)
├── templates/                          # optional Role Templates, created by hand
│   └── <Name>/                         # one job family, e.g. MLOps
│       ├── resume.tex                  # in the Profile's language
│       └── resume_de.tex               # optional, in another language
└── applications/
    └── YY.MM.DD_<job>@<company>/       # specific job application (all files flat in root)
        ├── description.md              # job description + fit analysis (appended as ## Fit Analysis)
        ├── resume.tex / resume.pdf
        ├── coverletter.tex / coverletter.pdf
        └── resume_de.tex, coverletter_de.tex   # when the posting's language differs
```

## Role Templates

Resumes follow the hybrid model (`docs/adr/0002-hybrid-resume-generation.md`). A Role Template is the user's reviewed resume for a job family in `data/templates/<Name>/`. `/review-job` recommends the closest one (or `none: from-scratch`) in the fit analysis; `/create-application` copies it and tailors it: rewrite the objective; reorder, remove, or add bullets from the Profile; **never reword a bullet already in the Role Template**. Without a match, the resume is written from the Profile. Cover letters are always written from scratch.

Languages: documents are written in the Profile's language and translated to the posting's language with `/translate`, keeping both versions. If the Role Template has a version in the posting's language (`resume_de.tex`), the resume is tailored from it directly and there's no Profile-language resume.

Role Templates are created by hand: copy a reviewed resume into `data/templates/<Name>/resume.tex`, make the objective generic, build and proofread it. Role Templates and Applications are at the same depth, so the QR code path and `../../../.latexmkrc` work in both.

## Setup

```bash
./setup.sh
```

If `data/` is absent, creates it from `src/scaffold/data/` and `example/profile/` and runs `git init` there (no commit). If `data/` exists, leaves it untouched. Then checks for LaTeX, creates `~/texmf` symlinks for the `.cls` files, and verifies the setup. Safe to re-run.

Never run `git clean -ffdx` in the outer repo: it deletes `data/`. `.claude/settings.json` denies `git clean`.

## Building PDFs

Build from within the application directory:

```bash
cd data/applications/YY.MM.DD_<job>@<company>
latexmk -pdf -r ../../../.latexmkrc resume.tex
latexmk -C resume.tex             # clean auxiliary files manually if needed
```

Don't use `-r "$(git rev-parse --show-toplevel)/.latexmkrc"`: inside `data/` it resolves to the Data Repo root, and latexmk fails with "RC file does not exist". `../../../.latexmkrc` points at the Tool Repo root from any `data/applications/<dir>/` (and `example/applications/<dir>/`).

The `.cls` files resolve via `~/texmf` symlinks, so `\documentclass{ExpressiveResume}` works from any subdirectory without copying files.

**VS Code / LaTeX Workshop:** Configured to auto-build on save (`latex-workshop.latex.autoBuild.run: "onSave"`) and automatically picks up the root `.latexmkrc` via `%WORKSPACE_FOLDER%/.latexmkrc`. No manual build step needed.

**Artifact cleanup:** `.latexmkrc` at the repo root automatically deletes build artifacts (`.aux`, `.log`, `.fls`, etc.) after each successful build, keeping only the PDF. To disable (e.g. for faster incremental rebuilds), set `$cleanup_after_build = 0` in `.latexmkrc`.

### QR code path

All application directories are one level deep under `data/applications/`, so the path is always:

```tex
qrcode=../../profile/images/qr_code.png
```

## Key LaTeX Commands

**ExpressiveResume:**
```tex
\resumeheader[firstname=, lastname=, email=, phone=, linkedin=, github=, city=, state=, qrcode=]
\objective{...}
\section{Section Name}
\experience{Company Name}{
    \role{Title}{Date Range}{
        \achievement{...}
    }
}
\project{Name}{Date Range}{\achievement{...}}
\degree{Name \honors{...}}{Institution}{Year}{}
\award{Name}{Institution}{Year}{}
\tech{TechnologyName}   % inline highlight for a tool/language
```

**ExpressiveCoverLetter:**
```tex
\coverletterheader[firstname=, lastname=, email=, phone=, linkedin=, github=, city=, state=]
```

## Profile Sources of Truth

When tailoring a CV, read these to understand the full profile:
- `data/profile/contact.md` — canonical personal details for `\resumeheader` and `\coverletterheader` (name, email, phone, LinkedIn, GitHub, city, country)
- `data/profile/qualifications.md` — education, certifications, spoken languages
- `data/profile/projects` — detailed description of projects that the user was part of
- `data/profile/experience.md` — LinkedIn Experience section with additional detail

## Application Index

`data/index.md` lists all Applications, newest first: `| Date | Company | Role | Folder |`, with the folder as a relative link. `/create-application` inserts the row by date. It records that an Application was created, not its status.

## Claude Code Commands

Both commands stop with "no data/ found; run ./setup.sh first" when `data/` is missing.

### `/review-job`

Analyses a job description against the profile, writes a fit analysis to `description.md` (including the recommended Role Template and the posting's language), and optionally proceeds to create application files. Four invocation modes:

```
/review-job                                               # interactive: paste description as next message
/review-job <job description>                             # uses the pasted text as the description
/review-job data/applications/26.04.24_pydev@yousician    # uses existing description.md in directory
/review-job https://company.com/careers/some-role         # fetches via WebFetch (LinkedIn may require interactive fallback)
```

### `/create-application`

Creates tailored `resume.tex` and `coverletter.tex` from the Role Template chosen in the fit analysis (or from scratch, using the Profile), translating them when the posting's language differs. Called automatically by `/review-job` on confirmation, or manually to resume an interrupted session:

```
/create-application data/applications/26.04.24_pydev@yousician
```

## Workflow for New Job Applications

**Primary flow (recommended):**
1. Run `/review-job` — Claude asks you to paste the job description
2. Review the fit analysis and the recommended Role Template; confirm, or pick another Role Template, or choose from scratch
3. Claude runs `/create-application` automatically
4. Build: save in VS Code (auto-builds), or run from within the application directory:
   ```bash
   latexmk -pdf -r ../../../.latexmkrc resume.tex
   ```

**Manual flow (directory first):**
1. `./new-application.sh <role> <company>` — scaffolds `data/applications/YY.MM.DD_<role>@<company>/`
2. Paste the job description into `description.md`
3. `/review-job data/applications/YY.MM.DD_<role>@<company>`

**Resume interrupted session:**
```
/create-application data/applications/YY.MM.DD_<role>@<company>
```

## Git rules

### Branches

`dev` is the integration branch; `main` is the release branch. Branch off `dev` and open PRs against `dev`. Releases are `dev` → `main` PRs merged with a merge commit, never squashed.

### Commits and PRs

Don't add Co-Authored-By or "Generated with Claude Code" lines to commits or PRs.

## Sibling repo

[Sibling private repo](expressive-resume-ai.code-workspace)
