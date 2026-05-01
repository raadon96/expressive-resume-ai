<div align="center">

# expressive-resume-ai

Paste a job description. [Claude Code](https://claude.ai/code) analyses the fit against your profile, then generates a tailored CV and cover letter as clean LaTeX you own. Built on [thehale/expressive-resume](https://github.com/thehale/expressive-resume).
![Example Expressive Resume](/artifacts/expressive_resume_readme_banner.svg)
</div>

## Prerequisites

- **LaTeX** with `latexmk` — choose one setup path:
  - **Linux/macOS (local):** install LaTeX directly
    - Linux: `sudo apt install texlive-full latexmk`
    - macOS: Install [MacTeX](https://www.tug.org/mactex/), then `brew install latexmk`
  - **All platforms via Dev Container (recommended for Windows):** install [VS Code](https://code.visualstudio.com/) and the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension — LaTeX and Claude Code are pre-installed inside the container
- **Claude Code** — [install instructions](https://claude.ai/code) (not needed if using the Dev Container)

## Setup (once)

### 1.Install

#### Option A — Local (Linux / macOS)

```bash
# 1. Fork this repository, then clone your fork
git clone https://github.com/<your-github-username>/expressive-resume-ai.git
cd expressive-resume-ai

# 2. Symlink the .cls files into ~/texmf so LaTeX can find them from any directory
./setup.sh
```

#### Option B — Dev Container (all platforms, including Windows)

**Prerequisites:** Docker must be running before opening the container.
- Linux: install [Docker Engine](https://docs.docker.com/engine/install/)
- Windows / macOS: install [Docker Desktop](https://www.docker.com/products/docker-desktop/)

1. Install [VS Code](https://code.visualstudio.com/) and the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
2. Fork and clone this repository, then open the folder in VS Code
3. When prompted, click **Reopen in Container** (or run `Remote-Containers: Reopen in Container` from the command palette)
4. VS Code builds the container — LaTeX, Claude Code CLI, and all extensions are installed automatically
5. Authenticate Claude Code — see **Step 3** below

> **VS Code extension (recommended):** Install the [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) extension to interact with Claude Code directly in the VS Code sidebar instead of the integrated terminal — avoids terminal crashes that can occur inside Dev Containers.


### 2. Authenticate Claude Code

**Option A — Claude Pro / Max subscription** — run in a terminal (or the Claude Code panel if using the VS Code extension):
```
claude
/login
```

Follow the browser prompt to authorise.

**Option B — API key** — export your key before running Claude:
```bash
export ANTHROPIC_API_KEY=sk-ant-...   # add to ~/.bashrc or ~/.zshrc to persist
```

Dev Container users: set `ANTHROPIC_API_KEY` in your **host** environment before opening the container — it is forwarded automatically via `containerEnv`.


### 3.Fill in your profile

The `profile/` files shipped with this repo are a fictional example. Replace them with your own data — this is what Claude reads when tailoring your CVs.

| File | What to put in it |
|------|-------------------|
| `profile/contact.md` | Your name, email, phone, LinkedIn handle, GitHub handle, city, country |
| `profile/experience.md` | Your work history in LinkedIn Experience section format |
| `profile/projects/*.md` | One file per project you want Claude to reference — see the included examples for the expected structure |
| `profile/certificates.md` | Your degrees and certifications |
| `profile/images/qr_code.png` | Your LinkedIn QR code (or any URL QR you want on the resume) |



## Applying for a Job

### Primary flow — paste job description directly into Claude Code

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
# Example: ./new-application.sh pydev ExampleCompany
# Creates: applications/26.04.26_pydev@ExampleCompany/

# Paste the job description into the created description.md, then run:
/review-job applications/26.04.26_pydev@ExampleCompany
```

### Resume an interrupted session

If a session ended after the fit analysis but before the files were created:

```
/create-application applications/26.04.26_pydev@ExampleCompany
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
  26.04.26_mleng@ExampleCompany/  # ← included as a worked example
    description.md      # Job description + fit analysis (fictional)
    resume.tex / .pdf   # Tailored CV (fictional)
    coverletter.tex / .pdf  # Cover letter (fictional)
    notes.md            # Interview prep notes (fictional)
  YY.MM.DD_role@company/    # Your applications go here
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
