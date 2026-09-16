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

**1. Get your own copy, then clone it**

Your profile and applications are personal, so the recommended copy is a **private** one. GitHub cannot make a fork of a public repo private, so create a private duplicate instead — see [Keeping your Private Fork in sync](#keeping-your-private-fork-in-sync) for the three commands. A plain public fork works too if you don't mind your applications being public.
```bash
git clone https://github.com/<your-github-username>/expressive-resume.git
cd expressive-resume
```

**2. Run the setup script**
```bash
./setup.sh
```
It symlinks the `.cls` files into `~/texmf` so LaTeX finds them from any directory, seeds `profile/` from the fictional example in `examples/profile/`, and installs the git hooks that keep personal data out of anything you might push back to this template.

#### Option B — Dev Container (all platforms, including Windows)

**Prerequisites:** Docker must be running before opening the container.
- Linux: install [Docker Engine](https://docs.docker.com/engine/install/)
- Windows / macOS: install [Docker Desktop](https://www.docker.com/products/docker-desktop/)

1. Install [VS Code](https://code.visualstudio.com/) and the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension
2. Get your own copy (see Option A, step 1) and clone it, then open the folder in VS Code
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

`setup.sh` seeded `profile/` with a fictional example (the same files live under `examples/profile/` for reference). Replace the contents with your own data — this is what Claude reads when tailoring your CVs. `profile/` is a Personal Path: in this template it is empty and git-ignored, so nothing you put there can end up in the public repo by accident.

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

If you say yes, Claude creates `resume.tex` and `coverletter.tex` tailored to the role and marks the application `Applied` in `applications/README.md`.

> **Tip:** Use a "Copy as Markdown" browser extension when copying job descriptions — markdown formatting helps Claude parse requirements more accurately. Plain text works fine too.

### Manual flow — directory first

```bash
# Create the directory with today's date prefix and a Draft row in applications/README.md
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
src/                    # Shared: LaTeX document classes (do not modify)
  scaffold/             # Structural resume.tex / coverletter.tex that /create-application starts from
examples/               # Shared: fictional data showing the expected shape of the Personal Paths
  profile/              # Copied into profile/ by setup.sh
  applications/
    README.md           # Example application tracker
    26.04.26_mleng@ExampleCompany/  # Worked example: description, resume, cover letter, notes
sync.conf               # Declares the Personal Paths below — sourced by hooks, sync scripts and CI
hooks/                  # pre-commit / pre-push leak guard, installed by setup.sh
sync-down.sh            # Pull template improvements into your Private Fork
sync-up.sh              # Send shared improvements from your Private Fork back as a PR

# Personal Paths — empty and git-ignored in this template, yours in your Private Fork
profile/                # Your data — seeded from examples/profile/ by setup.sh
  contact.md            # Your name, email, phone, LinkedIn, GitHub
  experience.md         # Your work history (LinkedIn Experience format)
  projects/             # Reusable project write-ups
  images/               # qr_code.png — replace with your own LinkedIn QR
  certificates.md       # Your degrees and certifications
applications/           # One directory per job application
  README.md             # Application tracker (created by new-application.sh)
  YY.MM.DD_role@company/
    description.md      # Job description + fit analysis
    resume.tex / .pdf
    coverletter.tex / .pdf
    notes.md            # Interview prep, conversation logs
templates/              # Your own role templates, if you keep any
```

## Tracking Applications

`applications/README.md` is the single tracker, newest first (see `examples/applications/README.md` for the shape). `new-application.sh` prepends a `Draft` row when it creates the directory; `/create-application` sets it to `Applied`. Update the `Status` column manually from there.

Valid statuses: `Draft` · `Applied` · `Screening` · `Interview` · `Offer` · `Rejected` · `Withdrawn`

## Keeping your Private Fork in sync

Your copy holds two kinds of content. **Personal Paths** (`profile/`, `applications/`, `templates/`, declared once in `sync.conf`) are yours and never leave your repo. Everything else is a **Shared Path** that flows both ways: template improvements down to you, your fixes back up as a PR. The layout makes the split structural, and three guards enforce it.

### Create the private copy (once)

GitHub can't turn a fork of a public repo private, so duplicate instead. Create an **empty private repo** on GitHub (say `expressive-resume`), then:

```bash
git clone --bare https://github.com/raadon96/expressive-resume-ai.git
cd expressive-resume-ai.git
git push --mirror https://github.com/<you>/expressive-resume.git
cd .. && rm -rf expressive-resume-ai.git

git clone https://github.com/<you>/expressive-resume.git
cd expressive-resume
git remote add upstream https://github.com/raadon96/expressive-resume-ai.git
./setup.sh
```

### Un-ignore the Personal Paths (once)

In the template the Personal Paths are git-ignored. In your copy you want them tracked, so override the root rule with a nested `.gitignore` in each:

```bash
for p in profile applications templates; do printf '!*\n' > "$p/.gitignore"; git add -f "$p/.gitignore"; done
git commit -m "Track Personal Paths in this Private Fork"
```

From now on plain `git add` tracks everything under those paths. The template never has files there, so pulling it down can't conflict with your data. (Don't want generated PDFs tracked? Add `*.pdf` as a second line to `applications/.gitignore`.)

### Pull template improvements down

```bash
./sync-down.sh        # on main: git fetch upstream && git merge upstream/main
git push origin main
```

Always a merge, never a rebase — your `main` is a pushed, durable store.

### Push a shared fix up

Commit shared changes on their own (the pre-commit hook refuses to mix them with personal files), then:

```bash
./sync-up.sh --list               # commits on main not yet upstream, touching only Shared Paths
./sync-up.sh <sha> [<sha>…]       # cherry-picks onto a branch off upstream/main, runs the guard,
                                  # pushes the branch to upstream and opens the PR
```

Once the PR is merged, `./sync-down.sh` brings it back and the branch can be deleted. If you know a change is shared before you start, it's simpler to make it in a checkout of the template and pull it down. Without an `upstream` remote (another machine), `git format-patch` / `git am` is the fallback.

### The guards

| Layer | Where | What it refuses |
|---|---|---|
| pre-commit | `hooks/pre-commit`, installed by `setup.sh` | A commit that mixes a Personal Path with anything else; a shared commit whose diff contains your name, email, phone or handles from `profile/contact.md` |
| pre-push | `hooks/pre-push`, only for the `upstream` remote | Any pushed commit touching a Personal Path; the same string check over the whole push |
| CI | this repo's `personal-paths-empty` job | Any PR that tracks a file under a Personal Path other than `.gitkeep` |

The string check is inert while `profile/contact.md` is still the shipped example, so working in a checkout of the template itself never trips it.
