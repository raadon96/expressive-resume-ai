# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A LaTeX resume and cover letter system based on the [Expressive Resume](https://github.com/thehale/expressive-resume) template. The `profile/` files shipped with this repo are a fictional example — replace them with your own data before using the slash commands.

### Directory Structure

```
src/
├── Expressive.cls                      # shared base class (don't touch)
├── ExpressiveResume.cls                # resume document class (don't touch)
└── ExpressiveCoverLetter.cls           # cover letter document class (don't touch)

templates/
└── placeholder/                        # structural scaffold used by /create-application
    ├── resume.tex
    └── coverletter.tex

applications/
└── YY.MM.DD_<job>@<company>/          # specific job application (all files flat in root)
    ├── description.md                  # job description + fit analysis (appended as ## Fit Analysis)
    ├── resume.tex / resume.pdf
    ├── coverletter.tex / coverletter.pdf
    └── notes.md                        # interview prep, conversation logs

profile/                                # ⚠ Replace with your own data — shipped files are fictional
├── contact.md                          # personal details (name, email, phone, LinkedIn, GitHub, city, country)
├── experience.md                       # work history (LinkedIn Experience section format)
├── certificates.md                     # degree certificates and diplomas
├── projects/                           # reusable project write-ups
│                                       # Structure per file: Summary → Context & Pain Points →
│                                       # Spoken Narrative (bullet points) → Architecture → Q&A Cheat Sheet
└── images/                             # shared assets (qr_code.png — replace with your own)
```

## Setup

```bash
./setup.sh
```

Checks for LaTeX, creates `~/texmf` symlinks for the `.cls` files, and verifies the setup. Safe to re-run.

## Building PDFs

Build from within the application directory:

```bash
cd applications/YY.MM.DD_<job>@<company>
latexmk -pdf -r "$(git rev-parse --show-toplevel)/.latexmkrc" resume.tex
latexmk -C resume.tex             # clean auxiliary files manually if needed
```

The `.cls` files resolve via `~/texmf` symlinks, so `\documentclass{ExpressiveResume}` works from any subdirectory without copying files.

**VS Code / LaTeX Workshop:** Configured to auto-build on save (`latex-workshop.latex.autoBuild.run: "onSave"`) and automatically picks up the root `.latexmkrc` via `%WORKSPACE_FOLDER%/.latexmkrc`. No manual build step needed.

**Artifact cleanup:** `.latexmkrc` at the repo root automatically deletes build artifacts (`.aux`, `.log`, `.fls`, etc.) after each successful build, keeping only the PDF. To disable (e.g. for faster incremental rebuilds), set `$cleanup_after_build = 0` in `.latexmkrc`.

### QR code path

All application directories are one level deep under `applications/`, so the path is always:

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

**LaTeX gotcha:** use `$\sim$` for a tilde/approximately symbol. Never use `\~` — it is a LaTeX accent command and will cause a build error.

**ExpressiveCoverLetter:**
```tex
\coverletterheader[firstname=, lastname=, email=, phone=, linkedin=, github=, city=, state=]
```

## Profile Sources of Truth

When tailoring a CV, read these to understand the full profile:
- `profile/contact.md` — canonical personal details for `\resumeheader` and `\coverletterheader` (name, email, phone, LinkedIn, GitHub, city, country)
- `profile/experience.md` — LinkedIn Experience section with additional detail
- `profile/projects/` — reusable project write-ups
- `profile/certificates.md` — degrees and certifications

## Application Tracker

`applications.md` at the repo root tracks all applications. `/create-application` appends rows automatically. Valid statuses: `Applied` / `Screening` / `Interview` / `Offer` / `Rejected` / `Withdrawn`.

## Claude Code Commands

### `/review-job`

Analyses a job description against the profile, writes a fit analysis to `description.md`, and optionally proceeds to create application files. Three invocation modes:

```
/review-job                                          # interactive: paste description as next message
/review-job applications/26.04.26_mleng@nexusai    # uses existing description.md in directory
/review-job https://company.com/careers/some-role    # fetches via WebFetch (LinkedIn may require interactive fallback)
```

### `/create-application`

Creates tailored `resume.tex` and `coverletter.tex` from the fit analysis and profile. Called automatically by `/review-job` on confirmation, or manually to resume an interrupted session:

```
/create-application applications/26.04.26_mleng@nexusai
```

## Workflow for New Job Applications

**Primary flow (recommended):**
1. Run `/review-job` — Claude asks you to paste the job description
2. Review the fit analysis; confirm to proceed
3. Claude runs `/create-application` automatically
4. Build: save in VS Code (auto-builds), or run from within the application directory:
   ```bash
   latexmk -pdf -r "$(git rev-parse --show-toplevel)/.latexmkrc" resume.tex
   ```

**Manual flow (directory first):**
1. `./new-application.sh <role> <company>` — scaffolds `applications/YY.MM.DD_<role>@<company>/`
2. Paste the job description into `description.md`
3. `/review-job applications/YY.MM.DD_<role>@<company>`

**Resume interrupted session:**
```
/create-application applications/YY.MM.DD_<role>@<company>
```
