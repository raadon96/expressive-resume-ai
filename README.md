# expressive-resume

An AI-assisted LaTeX resume and cover letter system, built on [thehale/expressive-resume](https://github.com/thehale/expressive-resume). Use [Claude Code](https://claude.ai/code) as your AI engine to analyse job descriptions, assess fit, and generate tailored CVs and cover letters — all from a clean LaTeX source you control.

## Prerequisites

- **LaTeX** with `latexmk` — choose one setup path:
  - **Linux/macOS (local):** install LaTeX directly
    - Linux: `sudo apt install texlive-full latexmk`
    - macOS: Install [MacTeX](https://www.tug.org/mactex/), then `brew install latexmk`
  - **All platforms via Dev Container (recommended for Windows):** install [VS Code](https://code.visualstudio.com/) and the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension — LaTeX and Claude Code are pre-installed inside the container
- **Claude Code** — [install instructions](https://claude.ai/code) (not needed if using the Dev Container)

## Setup (once)

### Option A — Local (Linux / macOS)

```bash
# 1. Fork this repository, then clone your fork
git clone https://github.com/<your-github-username>/expressive-resume-ai.git
cd expressive-resume-ai

# 2. Symlink the .cls files into ~/texmf so LaTeX can find them from any directory
./setup.sh

# 3. Fill in your profile (the files shipped are a fictional example — replace them)
#    - profile/contact.md         ← your name, email, phone, LinkedIn, GitHub
#    - profile/experience.md      ← your work history (LinkedIn Experience format)
#    - profile/projects/*.md      ← one file per project you want to reference
#    - profile/images/qr_code.png ← your LinkedIn QR code (or any URL QR)
#    - profile/certificates.md    ← your degrees and certifications
```

### Option B — Dev Container (all platforms, including Windows)

1. Install [VS Code](https://code.visualstudio.com/) and the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
2. Fork and clone this repository, then open the folder in VS Code
3. When prompted, click **Reopen in Container** (or run `Remote-Containers: Reopen in Container` from the command palette)
4. VS Code builds the container — LaTeX, Claude Code CLI, and all extensions are installed automatically
5. Authenticate Claude Code: open the integrated terminal and run `claude` then `/login`
6. Replace the fictional profile files (same list as Option A step 3 above)

> **API key users:** set `ANTHROPIC_API_KEY` in your host environment before opening the container — it is forwarded automatically via `containerEnv`.

## Applying for a Job

### Primary flow — paste directly into Claude Code

```
/review-job
```

Claude asks you to paste the job description. After you paste it, Claude will:
1. Infer the role and company, propose a directory name, and ask you to confirm
2. Write a fit analysis (`description.md`) — strengths table, gaps table, framing recommendation
3. Ask whether to proceed with the CV and cover letter

If you say yes, Claude creates `resume.tex` and `coverletter.tex` tailored to the role and appends a row to `applications.md`.

> **Tip:** Use a "Copy as Markdown" browser extension when copying job descriptions — markdown formatting helps Claude parse requirements more accurately. Plain text works fine too.

### Manual flow — directory first

```bash
# Create the directory with today's date prefix
./new-application.sh <role> <company>
# Example: ./new-application.sh pydev yousician
# Creates: applications/26.04.26_pydev@yousician/

# Paste the job description into the created description.md, then run:
/review-job applications/26.04.26_pydev@yousician
```

### Resume an interrupted session

If a session ended after the fit analysis but before the files were created:

```
/create-application applications/26.04.26_pydev@yousician
```

### Review a job by URL

```
/review-job https://company.com/careers/some-role
```

> LinkedIn URLs require a login — Claude will fall back to asking you to paste the description.

## Building the PDF

**VS Code (recommended):** Install the [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension. It auto-builds on save. No further configuration needed — the repo's `.vscode/settings.json` and `.latexmkrc` are already wired up.

**Terminal:**
```bash
cd applications/YY.MM.DD_<role>@<company>
latexmk -pdf -r "$(git rev-parse --show-toplevel)/.latexmkrc" resume.tex
latexmk -pdf -r "$(git rev-parse --show-toplevel)/.latexmkrc" coverletter.tex
```

Build artifacts (`.aux`, `.log`, etc.) are deleted automatically after each successful build — only the `.pdf` is kept alongside the `.tex` source.

## Repository Layout

```
src/                    # LaTeX document classes (do not modify)
templates/
  placeholder/          # Structural scaffold used by /create-application
applications/           # One directory per job application
  YY.MM.DD_role@company/
    description.md      # Job description + fit analysis
    resume.tex / .pdf
    coverletter.tex / .pdf
    notes.md            # Interview prep, conversation logs
applications.md         # Application tracker (auto-updated by /create-application)
profile/                # ⚠ Replace with your own data — shipped files are fictional
  contact.md            # Your name, email, phone, LinkedIn, GitHub
  experience.md         # Your work history (LinkedIn Experience format)
  projects/             # Reusable project write-ups
  images/               # qr_code.png — replace with your own LinkedIn QR
  certificates.md       # Your degrees and certifications
```

## Tracking Applications

`applications.md` at the repo root is the single tracker. `/create-application` appends rows automatically. Update the `Status` column manually as applications progress.

Valid statuses: `Applied` · `Screening` · `Interview` · `Offer` · `Rejected` · `Withdrawn`
