<div align="center">

# expressive-resume-ai

Paste a job description. [Claude Code](https://claude.ai/code) analyses the fit against your profile, then generates a tailored CV and cover letter as clean LaTeX you own. Built on [thehale/expressive-resume](https://github.com/thehale/expressive-resume).
![Example Expressive Resume](/docs/images/expressive_resume_readme_banner.svg)
</div>

## Features

- **Fit analysis:** your strengths and gaps for the posting, and how to frame your experience, saved next to the job description.
- **Tailored resume and cover letter** as LaTeX, built to PDF.
- **Role Templates:** start each resume from your own reviewed resume for that job family. Claude tailors it without rewording your bullets.
- **Translation:** for a posting in another language, you get your documents in both languages.
- **Your data stays private:** your profile and applications live in their own git repo, separate from the tool.

See the fictional [example application](example/applications/26.04.26_mleng@examplecompany/): its [fit analysis](example/applications/26.04.26_mleng@examplecompany/description.md), [resume](example/applications/26.04.26_mleng@examplecompany/resume.pdf) and [cover letter](example/applications/26.04.26_mleng@examplecompany/coverletter.pdf).

## Quick start

1. Fork this repository and clone your fork.
2. Open the folder in the Dev Container, or run `./setup.sh` for a local install.
3. Replace the example profile in `data/profile/` with your own.
4. Start Claude Code in the folder and run `/review-job`.
5. Paste a job description, and confirm when Claude asks to create the documents.

The sections below cover each step.

## Prerequisites

Everyone needs **git** and a **Claude Pro or Max subscription or an Anthropic API key** (billed per use). Then pick one way to run the tool:

| | Dev Container (recommended) | Local |
|---|---|---|
| Platforms | Windows, macOS, Linux | Linux, macOS |
| You install | Docker, VS Code and the Dev Containers extension | LaTeX with `latexmk`, Claude Code |
| Comes ready | LaTeX, Claude Code, VS Code extensions; `./setup.sh` runs automatically | — |

Choose the Dev Container on Windows, or if you don't want LaTeX on your machine. The first container start downloads a LaTeX image of several GB and takes a few minutes; later starts are fast.

## Setup

### 1. Get the tool

**Fork** this repository on GitHub, then clone your fork. Forking lets you get updates with one click (**Sync fork**) and keep your own changes to the tool:

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

#### Option A — Dev Container (recommended)

1. Install and start Docker: [Docker Engine](https://docs.docker.com/engine/install/) on Linux, [Docker Desktop](https://www.docker.com/products/docker-desktop/) on Windows and macOS.
2. Install [VS Code](https://code.visualstudio.com/) and the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.
3. Open the folder in VS Code and click **Reopen in Container** when prompted, or run **Dev Containers: Reopen in Container** from the command palette.

When the container is created, it installs Claude Code and runs `./setup.sh`, which sets up `data/` as described in Option B. Use Claude Code from the [Claude Code extension](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) in the sidebar: the integrated terminal can crash inside Dev Containers.

The container sees only this folder. VS Code copies your host git identity into it and forwards your SSH agent, so `git push` over SSH works if your key is loaded on the host (`ssh-add`). See [.devcontainer/README.md](.devcontainer/README.md) for details.

A Claude Code login made in the container is kept in the Docker volume `expressive-resume-ai-claude-code`, so it survives container rebuilds. To reset it, close the VS Code window, then on the host remove the container using the volume, and the volume itself:

```bash
docker rm -f $(docker ps -aq --filter volume=expressive-resume-ai-claude-code)
docker volume rm expressive-resume-ai-claude-code
```

#### Option B — Local (Linux, macOS)

1. Install LaTeX with `latexmk`:
   - Linux: `sudo apt install texlive-full latexmk`
   - macOS: install [MacTeX](https://www.tug.org/mactex/), then `brew install latexmk`
2. [Install Claude Code](https://claude.ai/code) (if not installed yet).
3. Run setup:
   ```bash
   ./setup.sh
   ```

Setup creates `data/`, the folder for your profile and applications, starting from a fictional example profile. It's safe to re-run: an existing `data/` is left untouched.

### 3. Log in to Claude Code

**Claude Pro or Max subscription:** run in a terminal, or in the Claude Code panel of the VS Code extension:

```
claude
/login
```

Follow the browser prompt to authorise.

In the Dev Container, log in inside the container; your host login isn't shared with it.

**API key:** export your key before running Claude:

```bash
export ANTHROPIC_API_KEY=sk-ant-...   # add to ~/.bashrc or ~/.zshrc to persist
```

In the Dev Container, set `ANTHROPIC_API_KEY` on your **host** before opening the container. It's forwarded automatically.

### 4. Replace the example profile

`data/profile/` starts as a copy of the fictional example. Replace it with your own data. This is what Claude reads when tailoring your documents.

| File | What to put in it |
|------|-------------------|
| `data/profile/contact.md` | Your name, email, phone, LinkedIn handle, GitHub handle, city, country |
| `data/profile/experience.md` | Your work history in LinkedIn Experience section format |
| `data/profile/projects/*.md` | One file per project you want Claude to reference. **Delete the example projects**, or their fictional content can end up in your resumes |
| `data/profile/qualifications.md` | Your degrees, certifications and spoken languages |
| `data/profile/images/qr_code.png` | Your LinkedIn QR code (or a QR code for any URL you want on the resume) |
| `data/profile/voice.md` | Optional: samples of your own writing and notes on your style, used for cover letters. If your `data/profile/` predates this file, copy it from `example/profile/voice.md` |

`data/` is its own git repo, separate from the tool, so a `git add .` in the tool can't publish your data. Commit your profile there:

```bash
cd data
git add .
git commit -m "Add my profile"
```

### 5. Back up your data (recommended)

`data/` isn't part of the tool's repository, so your fork doesn't hold it. Push it to its own **private** repository: that keeps it safe if your disk fails or `data/` gets deleted, and lets you [use it on another machine](#setup-on-another-machine). With the [GitHub CLI](https://cli.github.com/), from the tool folder:

```bash
gh repo create <name> --private --source=data --push
```

Or create an empty **private** repository in the GitHub UI, then:

```bash
cd data
git remote add origin git@github.com:<you>/<name>.git
git push -u origin HEAD
```

Use a new repository for this, not a fork: a fork of a public repository is always public.

> [!WARNING]
> `git clean -ffdx` in the tool folder deletes `data/`, including its history. Keep `data/` pushed.

## Applying for a job

```
/review-job
```

Claude asks you to paste the job description, then:

1. creates `data/applications/YY.MM.DD_<role>@<company>/`
2. writes the fit analysis to `description.md`: strengths, gaps, how to frame your experience, which Role Template to start from, and the posting's language
3. asks whether to create the documents

Confirm, and Claude writes `resume.tex` and `coverletter.tex`, builds the PDFs and adds a row to your Application Index, `data/index.md`. At the prompt you can also pick another Role Template, or ask for the resume to be written from scratch. Cover letters are always written from scratch.

> **Tip:** copy job descriptions with a "Copy as Markdown" browser extension. Claude reads requirements more accurately from Markdown, but plain text works too.

Other ways to pass the job description:

| Command | Job description |
|---------|-----------------|
| `/review-job <job description>` | pasted inline |
| `/review-job https://company.com/careers/some-role` | fetched from the URL. LinkedIn needs a login, so Claude asks you to paste it instead |
| `/review-job data/applications/<folder>` | read from `description.md` in that folder |

If a session ends after the fit analysis but before the documents are written, continue with:

```
/create-application data/applications/26.04.26_pydev@examplecompany
```

Your applications are files in `data/`. Commit them there: `cd data && git add . && git commit`.

### Postings in another language

If the posting's language differs from your profile's (e.g. a German posting, an English profile), Claude writes the documents in your profile's language and translates them, keeping both: `resume.tex` and `resume_de.tex`, `coverletter.tex` and `coverletter_de.tex`. If the Role Template already has a version in the posting's language (`resume_de.tex`), the resume is tailored from that directly, and there's only `resume_de.tex`.

You can also translate any `.tex` or `.md` file yourself:

```
/translate data/applications/26.04.26_pydev@examplecompany/coverletter.tex german
```

Claude writes `coverletter_de.tex` next to the original, phrased the way a native speaker would write it rather than word for word, and builds the PDF. The original is never overwritten. Given text instead of a path, it returns the translation.

### Copyediting

Claude writes by one set of rules, `.claude/skills/copyedit/rules.md`, so the text reads like you wrote it for a recruiter rather than like a template: no stock phrases, inflated verbs or empty claims. `/copyedit` then checks the result in a fresh context that sees only the text, the rules and your voice file, never the conversation that wrote it. It keeps every fact and number, and never makes the text longer.

`/create-application` runs it on what Claude wrote: the resume's objective and any bullets added from your profile (or the whole resume, if written from scratch), and the cover letter in every language. Bullets from your Role Template are left alone.

You can run it on any file, optionally with your voice file:

```
/copyedit data/applications/26.04.26_pydev@examplecompany/coverletter.tex data/profile/voice.md
```

It edits the file in place, so rebuild the PDF afterwards. Given text instead of a path, it returns the edited text.

## Role Templates

A Role Template is your own reviewed resume for a job family you apply to often, e.g. `PyDev` or `MLOps`. Most of your resumes repeat the same bullets, so instead of writing each one from scratch, Claude copies the closest Role Template and tailors it: it rewrites the objective, and reorders, removes, or adds bullets from your profile. **It never rewords a bullet that's already in the Role Template,** so your reviewed wording stays as it is, and a diff shows exactly what changed:

```bash
diff data/templates/MLOps/resume.tex data/applications/26.04.26_mlops@examplecompany/resume.tex
```

Role Templates are optional. Without them, or when none fits, the resume is written from your profile.

**Create one by hand:**

1. Pick a resume you're happy with, e.g. from a past application, and copy it into `data/templates/<Name>/resume.tex`. The name is the job family, e.g. `MLOps`.
2. Make it generic: write an objective without a company name, and keep the bullets that fit most postings in this family.
3. Build it and proofread it carefully. Every application from this family reuses its wording.
   ```bash
   src/build.sh data/templates/<Name>/resume.tex
   ```
4. Copyedit it once with `/copyedit data/templates/<Name>/resume.tex`, review the changes with `git diff` in `data/`, and rebuild it.
5. Optional: add a version in another language as `resume_<code>.tex`, e.g. with `/translate data/templates/<Name>/resume.tex german`, then proofread it too.

`resume.tex` is in your profile's language. `example/templates/MLEng/` is a Role Template built from the fictional example profile.

When your profile gains something new, e.g. a new role or certificate, update your Role Templates by hand. Nothing checks this for you.

## Building the PDFs

Claude builds the PDFs when it writes the documents. To rebuild after your own edits:

**VS Code:** the [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension rebuilds on save, with no further configuration. It comes preinstalled in the Dev Container; on a local install, install it yourself.

**Terminal**, from the repo root:

```bash
src/build.sh data/applications/YY.MM.DD_<role>@<company>/resume.tex data/applications/YY.MM.DD_<role>@<company>/coverletter.tex
```

It prints each PDF with its page count, or the LaTeX errors if a build fails. Only the `.pdf` is kept next to the `.tex` source; build artifacts are deleted after each successful build.

**Other editors:** run `src/build.sh`, or pass `-r <tool folder>/src/latexmkrc` to latexmk.

## Getting updates

- **Fork:** click **Sync fork** on your fork's `main` branch on GitHub, then `git pull`.
- **Clone:** `git pull`.

Your `data/` isn't affected by either.

If you set up the tool before LaTeX found its document classes through `src/latexmkrc`, you can delete `~/texmf/tex/latex/expressive-resume-ai`: it's no longer used.

## Setup on another machine

To use your backed-up `data/` on another machine, or to get it back after losing your local copy:

1. Get the tool: clone your fork, or clone this repository.
2. Clone your data into `data/` **before** running setup, or before opening the folder in the Dev Container, which runs setup when it's created:
   ```bash
   git clone <your-data-repo> data
   ```
3. Run `./setup.sh`, or open the folder in the Dev Container. Setup leaves your `data/` untouched and only checks for LaTeX.

If setup ran first, it created a `data/` from the example, and the clone fails. Delete that `data/` and clone again.

## Issues and changes

Found a bug or have an idea? [Open an issue](https://github.com/raadon96/expressive-resume-ai/issues). Pull requests aren't accepted: to change the tool, change it in your own fork.

## Acknowledgments

The LaTeX document classes come from [Expressive Resume](https://github.com/thehale/expressive-resume).

## License

MIT. See [LICENSE](LICENSE).
