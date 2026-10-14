# Dev Container

The Dev Container for expressive-resume-ai: LaTeX, Claude Code and the VS Code extensions the tool uses, ready in one container. Setup is in the main [README](../README.md#option-a--dev-container-recommended).

Based on [qdm12/latexdevcontainer](https://github.com/qdm12/latexdevcontainer) by Quentin McGaw, under the MIT licence in [LICENSE](LICENSE).

## What the container gets from the host

- **The workspace**, bind-mounted at `/workspace`. This is the only host folder the container sees.
- **Git identity**: VS Code copies your host `~/.gitconfig` into the container.
- **SSH**: VS Code forwards your host SSH agent, so `git push` over SSH works without mounting `~/.ssh`. Add your key to the agent on the host (`ssh-add`) if it isn't already.
- **`ANTHROPIC_API_KEY`**, if set on the host.

The Docker socket is not mounted, so the container can't control the host's Docker.

## Claude Code state

Claude Code keeps its login and global config in the named volume `expressive-resume-ai-claude-code`, mounted at `/root/.claude`. `CLAUDE_CONFIG_DIR` points there, so the global config file `.claude.json` lands in the volume too. A `/login` made in the container survives rebuilds, and none of your host Claude Code setup (settings, plugins, user `CLAUDE.md`, history) enters the container.

To reset the login, remove the volume as described in the main [README](../README.md#option-a--dev-container-recommended).

## Files

- [docker-compose.yml](docker-compose.yml): the LaTeX base image `qmcgaw/latexdevcontainer:latest-full`, the workspace mount, the Claude Code volume and environment.
- [devcontainer.json](devcontainer.json): VS Code extensions and settings under `customizations.vscode`, the `ANTHROPIC_API_KEY` forwarding, `/root/.local/bin` on `PATH`, and the post-create step: Claude Code's native installer, then `./setup.sh`.

There is no Dockerfile, so keep the service free of `build:`. Dev Containers builds such a service through a Dockerfile it generates under `/tmp`, and recent Compose versions (v5.6), which build through `buildx bake`, refuse to read a file outside the build context.

Claude Code lives in the container's filesystem, so every rebuild reinstalls the current version. Its auto-updates between rebuilds are lost on the next rebuild.

After editing any of them, run **Dev Containers: Rebuild Container** from the command palette.

## Checking a change

The `Dev Container` workflow creates the container with the Dev Container CLI and runs `tests/test-setup.sh` inside it, on PRs that touch this folder, `setup.sh`, `tests/` or the workflow, and weekly.

CI can't drive VS Code. After changing anything in this folder, rebuild the container and check:

1. `git config user.name` shows your host identity (`.gitconfig` copied by VS Code).
2. `git push` over SSH works from inside the container (SSH agent forwarding).
3. After `/login` in the container, **Dev Containers: Rebuild Container** brings back neither a login prompt nor first-run prompts.
