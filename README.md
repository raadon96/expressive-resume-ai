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

## How it's organised

Two git repos share one folder:

- **The tool** (this repo, or your fork or clone of it): document classes, the Scaffold, the Claude Code commands and scripts. It never holds personal data.
- **Your data** in `data/`: your profile, your applications and the Application Index. It's a separate git repo that the tool ignores, so a `git add .` in the tool can't publish it. You can back it up to a private GitHub repo.

`example/` has the same layout as `data/` and holds a fictional profile and a worked example application.

## Setup, first time

### 1. Get the tool

**Fork** this repository on GitHub, then clone your fork. Forking keeps the project history, lets you get updates with one click (**Sync fork**), and lets you open pull requests:
```bash
git clone https://github.com/<your-github-username>/expressive-resume-ai.git
cd expressive-resume-ai
```

No GitHub account? **Clone** this repository directly instead:
```bash
git clone https://github.com/raadon96/expressive-resume-ai.git
cd expressive-resume-ai
```

### 2. Run setup

#### Option A — Local (Linux / macOS)

```bash
./setup.sh
```

This creates `data/` from `src/scaffold/data/` and the example profile, and runs `git init` there without making a commit. It also symlinks the `.cls` files into `~/texmf` so LaTeX can find them from any directory. It's safe to re-run: an existing `data/` is left untouched.

#### Option B — Dev Container (all platforms, including Windows)

**Prerequisites:** Docker must be running before opening the container.
- Linux: install [Docker Engine](https://docs.docker.com/engine/install/)
- Windows / macOS: install [Docker Desktop](https://www.docker.com/products/docker-desktop/)

1. Install [VS Code](https://code.visualstudio.com/) and the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
2. Open the folder in VS Code
3. When prompted, click **Reopen in Container** (or run `Remote-Containers: Reopen in Container` from the command palette)
4. VS Code builds the container. LaTeX, Claude Code CLI and all extensions are installed automatically, and `./setup.sh` runs on creation.
5. Authenticate Claude Code (see **step 3** below)

> **VS Code extension (recommended):** Install the [Claude Code](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) extension to interact with Claude Code directly in the VS Code sidebar instead of the integrated terminal — avoids terminal crashes that can occur inside Dev Containers.

### 3. Authenticate Claude Code

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

### 4. Replace the example profile

`data/profile/` starts as a copy of the fictional example. Replace it with your own data. This is what Claude reads when tailoring your CVs.

| File | What to put in it |
|------|-------------------|
| `data/profile/contact.md` | Your name, email, phone, LinkedIn handle, GitHub handle, city, country |
| `data/profile/experience.md` | Your work history in LinkedIn Experience section format |
| `data/profile/projects/*.md` | One file per project you want Claude to reference. **Delete the example projects**, or their fictional content can end up in your resumes |
| `data/profile/certificates.md` | Your degrees and certifications |
| `data/profile/images/qr_code.png` | Your LinkedIn QR code (or any URL QR you want on the resume) |

### 5. Back up `data/` (optional)

Push `data/` to a **private** GitHub repo so you can restore it on another machine. `data/README.md` has the steps.

> [!WARNING]
> `git clean -ffdx` in the tool folder deletes `data/`, including its history. Keep `data/` pushed. Claude Code is blocked from running `git clean` here by `.claude/settings.json`.

## Setup, another machine

If you already have a Data Repo:

1. Get the tool: clone your fork, or clone this repository.
2. Clone your data into `data/` **before** running setup:
   ```bash
   git clone <your-data-repo> data
   ```
3. Run `./setup.sh`. It leaves your `data/` untouched and only sets up LaTeX.

## Getting updates

- **Fork:** click **Sync fork** on your fork's `main` branch on GitHub, then `git pull`. Or, from the command line: `git pull upstream main`.
- **Clone:** `git pull`.

Your `data/` isn't affected by either.

## Applying for a Job

### Primary flow — paste job description directly into Claude Code

```
/review-job
```

Claude asks you to paste the job description. You can also pass it inline: `/review-job <job description>`. Claude will then:
1. Infer the role and company and create `data/applications/YY.MM.DD_<role>@<company>/`
2. Write a fit analysis (`description.md`) — strengths table, gaps table, framing recommendation
3. Ask whether to proceed with the CV and cover letter

If you have Role Templates (see below), the fit analysis also recommends the closest one, or none, in which case the resume is written from your profile. At the prompt you can accept it, pick another one, or ask for the resume to be written from scratch.

If you say yes, Claude creates `resume.tex` and `coverletter.tex` tailored to the role, builds both PDFs, and adds a row to the Application Index, `data/index.md`. The cover letter is always written from scratch.

If the posting is in another language than your profile (e.g. a German posting, an English profile), Claude writes the documents in your profile's language and translates them with `/translate`, keeping both: `resume.tex` and `resume_de.tex`, `coverletter.tex` and `coverletter_de.tex`. If the Role Template already has a version in the posting's language (`resume_de.tex`), the resume is tailored from that directly, and there's no English resume.

### Role Templates

A Role Template is your own reviewed resume for a job family you apply to often, e.g. `PyDev` or `MLOps`. Most of your resumes repeat the same bullets, so instead of writing each one from scratch, Claude copies the closest Role Template and tailors it: it rewrites the objective, and reorders, removes, or adds bullets from your profile. **It never rewords a bullet that's already in the Role Template,** so your reviewed wording stays as it is, and a diff shows exactly what changed:

```bash
diff data/templates/MLOps/resume.tex data/applications/26.04.26_mlops@ExampleCompany/resume.tex
```

Role Templates are optional. Without them, or when none fits, the resume is written from scratch, using your profile.

**Create one by hand:**

1. Pick a resume you're happy with, e.g. from a past application, and copy it into `data/templates/<Name>/resume.tex`. The name is the job family, e.g. `MLOps`.
2. Make it generic: write an objective without a company name, and keep the bullets that fit most postings in this family.
3. Build it and proofread it carefully. Every application from this family reuses its wording.
   ```bash
   cd data/templates/<Name>
   latexmk -pdf -r ../../../.latexmkrc resume.tex
   ```
4. Optional: add a version in another language as `resume_<code>.tex`, e.g. with `/translate data/templates/<Name>/resume.tex german`, then proofread it too.

`resume.tex` is in your profile's language. `example/templates/MLEng/` is a Role Template built from the fictional example profile. `setup.sh` doesn't copy it into `data/`.

When your profile gains something new, e.g. a new role or certificate, update your Role Templates by hand. Nothing checks this for you.

> **Tip:** Use a "Copy as Markdown" browser extension when copying job descriptions — markdown formatting helps Claude parse requirements more accurately. Plain text works fine too.

### Manual flow — directory first

```bash
# Create the directory with today's date prefix
./new-application.sh <role> <company>
# Example: ./new-application.sh pydev ExampleCompany
# Creates: data/applications/26.04.26_pydev@ExampleCompany/

# Paste the job description into the created description.md, then run:
/review-job data/applications/26.04.26_pydev@ExampleCompany
```

### Resume an interrupted session

If a session ended after the fit analysis but before the files were created:

```
/create-application data/applications/26.04.26_pydev@ExampleCompany
```

### Review a job by URL

```
/review-job https://company.com/careers/some-role
```

> LinkedIn URLs require a login — Claude will fall back to asking you to paste the description.

### Translate a document

```
/translate data/applications/26.04.26_pydev@ExampleCompany/coverletter.tex german
```

Claude writes `coverletter_de.tex` next to the original, phrased the way a native speaker would write it rather than word for word, and builds the PDF. The original is never overwritten. It works on any `.tex` or `.md` file, e.g. a project in `data/profile/projects/`. Given text instead of a path, it returns the translation.

Your applications are files in `data/`. Commit them there (`cd data && git add . && git commit`), not in the tool.

## Building the PDF

**VS Code (recommended):** Install the [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension. It auto-builds on save. No further configuration needed — the repo's `.vscode/settings.json` and `.latexmkrc` are already wired up.

**Terminal:**
```bash
cd data/applications/YY.MM.DD_<role>@<company>
latexmk -pdf -r ../../../.latexmkrc resume.tex
latexmk -pdf -r ../../../.latexmkrc coverletter.tex
```

`../../../.latexmkrc` is the tool's build config at the tool root. Don't use `$(git rev-parse --show-toplevel)` here: inside `data/` it points at your Data Repo, not the tool.

Build artifacts (`.aux`, `.log`, etc.) are deleted automatically after each successful build — only the `.pdf` is kept alongside the `.tex` source.

## Repository Layout

```
src/                    # LaTeX document classes (do not modify)
  scaffold/
    application/        # resume.tex, coverletter.tex: copied by /create-application
    data/               # README.md, .gitignore, index.md: copied into data/ by setup.sh
example/                # Fictional example, same layout as data/
  index.md
  profile/
  templates/MLEng/      # example Role Template (not copied by setup.sh)
  applications/26.04.26_mleng@ExampleCompany/
data/                   # Your Data Repo: its own git repo, ignored by the tool
  index.md              # Application Index (updated by /create-application)
  profile/              # ⚠ Starts as the fictional example: replace with your own data
    contact.md          # Your name, email, phone, LinkedIn, GitHub
    experience.md       # Your work history (LinkedIn Experience format)
    projects/           # Reusable project write-ups
    images/             # qr_code.png — replace with your own LinkedIn QR
    certificates.md     # Your degrees and certifications
  templates/            # Optional Role Templates, one folder per job family
    <Name>/
      resume.tex        # in your profile's language
      resume_de.tex     # optional, in another language
  applications/
    YY.MM.DD_role@company/
      description.md    # Job description + fit analysis
      resume.tex / .pdf
      coverletter.tex / .pdf
      resume_de.tex / coverletter_de.tex   # when the posting's language differs
```

## Application Index

`data/index.md` lists your applications, newest first: one row per application with its date, company, role and a link to its folder. `/create-application` adds the row. It records that you created an application, not whether you sent it or how it's going.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). In short: branch off `dev` and open PRs against `dev`.
