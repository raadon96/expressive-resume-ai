# Setup

The full setup, step by step, with every option. The [README](../../README.md#setup) has the short version.

## Prerequisites

Everyone needs **git** and a **Claude Pro or Max subscription or an Anthropic API key** (billed per use). Then pick one way to run the tool:

| | Dev Container (recommended) | Local |
|---|---|---|
| Platforms | Windows, macOS, Linux | Linux, macOS |
| You install | Docker, VS Code and the Dev Containers extension | LaTeX with `latexmk`, Claude Code v2.1.218 or later |
| Comes ready | LaTeX, Claude Code, VS Code extensions; `./setup.sh` runs automatically | — |

Choose the Dev Container on Windows, or if you don't want LaTeX on your machine.

## 1. Get the tool

**Fork** this repository on GitHub, then clone your fork. Forking lets you [get updates](#getting-updates) with one click (**Sync fork**) and keep your own changes to the tool:

```bash
git clone https://github.com/<your-github-username>/expressive-resume-ai.git
cd expressive-resume-ai
```

No GitHub account? **Clone** this repository directly instead:

```bash
git clone https://github.com/raadon96/expressive-resume-ai.git
cd expressive-resume-ai
```

## 2. Run setup

### Option A: Dev Container (recommended)

1. Install and start Docker: [Docker Engine](https://docs.docker.com/engine/install/) on Linux, [Docker Desktop](https://www.docker.com/products/docker-desktop/) on Windows and macOS.
2. Install [VS Code](https://code.visualstudio.com/) and the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.
3. Open the folder in VS Code and click **Reopen in Container** when prompted, or run **Dev Containers: Reopen in Container** from the command palette.

The first container start downloads a LaTeX image of several GB and takes a few minutes; later starts are fast. When the container is created, it installs Claude Code and runs `./setup.sh`, which sets up `data/` as described in [Option B](#option-b-local-linux-macos). Use Claude Code from the [Claude Code extension](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code) in the sidebar: the integrated terminal can crash inside Dev Containers.

The container sees only this folder. VS Code copies your host git identity into it and forwards your SSH agent, so `git push` over SSH works if your key is loaded on the host (`ssh-add`). See [.devcontainer/README.md](../../.devcontainer/README.md) for details.

A Claude Code login made in the container is kept in the Docker volume `expressive-resume-ai-claude-code`, so it survives container rebuilds. To reset it, close the VS Code window, then on the host remove the container using the volume, and the volume itself:

```bash
docker rm -f $(docker ps -aq --filter volume=expressive-resume-ai-claude-code)
docker volume rm expressive-resume-ai-claude-code
```

### Option B: Local (Linux, macOS)

1. Install LaTeX with `latexmk`:
   - Linux: `sudo apt install texlive-full latexmk`
   - macOS: install [MacTeX](https://www.tug.org/mactex/), then `brew install latexmk`
2. [Install Claude Code](https://claude.ai/code) (if not installed yet).
3. Run setup:
   ```bash
   ./setup.sh
   ```

Setup creates `data/`, the folder for your profile and applications, starting from a fictional example profile. It's safe to re-run: an existing `data/` is left untouched.

## 3. Log in to Claude Code

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

## 4. Replace the example profile

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

Commit your applications the same way as you create them.

## 5. Back up your data

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

## Setup on another machine

To use your backed-up `data/` on another machine, or to get it back after losing your local copy:

1. Get the tool: clone your fork, or clone this repository.
2. Clone your data into `data/` **before** running setup, or before opening the folder in the Dev Container, which runs setup when it's created:
   ```bash
   git clone <your-data-repo> data
   ```
3. Run `./setup.sh`, or open the folder in the Dev Container. Setup leaves your `data/` untouched and only checks for LaTeX.

If setup ran first, it created a `data/` from the example, and the clone fails. Delete that `data/` and clone again.

## Getting updates

- **Fork:** click **Sync fork** on your fork's `main` branch on GitHub, then `git pull`.
- **Clone:** `git pull`.

Your `data/` isn't affected by either.
