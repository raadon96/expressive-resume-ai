# Dev Container

The Dev Container for expressive-resume-ai: LaTeX, Claude Code and the VS Code extensions the tool uses, ready in one container. Setup and login are in the main [README](../README.md#option-a--dev-container-recommended).

Based on [qdm12/latexdevcontainer](https://github.com/qdm12/latexdevcontainer) by Quentin McGaw, under the MIT licence in [LICENSE](LICENSE).

## What the container gets from the host

- **The workspace**, bind-mounted at `/workspace`. This is the only host folder the container sees.
- **Git identity**: VS Code copies your host `~/.gitconfig` into the container.
- **SSH**: VS Code forwards your host SSH agent, so `git push` over SSH works without mounting `~/.ssh`. Add your key to the agent on the host (`ssh-add`) if it isn't already.
- **`ANTHROPIC_API_KEY`**, if set on the host.

The Docker socket is not mounted, so the container can't control the host's Docker.

## Claude Code state

Claude Code keeps its login and global config in the named volume `expressive-resume-ai-claude-code`, mounted at `/root/.claude`. `CLAUDE_CONFIG_DIR` points there, so the global config file `.claude.json` lands in the volume too. A `/login` made in the container survives rebuilds, and none of your host Claude Code setup (settings, plugins, user `CLAUDE.md`, history) enters the container.

To log out for good and start fresh, close the container and remove the volume:

```sh
docker volume rm expressive-resume-ai-claude-code
```

## Files

- [Dockerfile](Dockerfile): the LaTeX base image plus Node.js and Claude Code.
- [docker-compose.yml](docker-compose.yml): the workspace mount, the Claude Code volume and environment.
- [devcontainer.json](devcontainer.json): VS Code extensions and settings under `customizations.vscode`, the `ANTHROPIC_API_KEY` forwarding, and `./setup.sh` as the post-create step.

After editing any of them, run **Dev Containers: Rebuild Container** from the command palette.

## Checking a change

The automated checks don't cover the VS Code integration. Before merging a change to this folder, open the folder in the container and check:

1. `git config user.name` shows your host identity (`.gitconfig` copied by VS Code).
2. `git push` over SSH works from inside the container (SSH agent forwarding).
3. After `/login` in the container, **Dev Containers: Rebuild Container** brings back neither a login prompt nor first-run prompts.
