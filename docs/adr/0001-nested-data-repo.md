---
status: accepted
---

# User data lives in a gitignored nested Data Repo, not a submodule

Each user's Profile, Applications and Role Templates live in a private Data Repo cloned into a gitignored folder inside their Tool Repo folder. Git's repo boundary is the only separation: tool changes are committed in the outer repo and data changes in the inner one, with no sync scripts, hooks or CI guard. This lets a fix be made and tested on a real Application in the same folder it is applied from, without any personal data reaching the public Tool Repo. It only holds if every personal file lands in the data folder, so no command may write personal data anywhere else.

## Considered Options

- **Submodule**: rejected. It would put a user-specific gitlink and a private URL into the public fork, and every data commit would need a pointer bump.
- **Two separate folders (fix in the Tool Repo, pull into the data folder)**: rejected. A fix can't be tested on a real Application before it is published.
- **One repo with fixes cherry-picked out to the Tool Repo**: rejected. Personal data could leak, and it needs sync tooling that ships into every user's repo (the design in closed PR #8).
- **Tool distributed as a Claude Code plugin/package**: rejected. It adds a release step between a fix and testing it, and had the most unknowns.

## Consequences

- Grep and Claude's `grep` skip the gitignored data folder when searching from the root, so commands must search explicit data-folder paths.
- Inside the Data Repo, `git rev-parse --show-toplevel` resolves to the data folder, so build commands must not use it to find the root `.latexmkrc`.
- `git clean -ffdx` in the outer repo deletes the Data Repo. Keep it pushed; a tracked `.claude/settings.json` denies `git clean`.
- Agents isolated in a worktree don't see the data folder, so tool changes are tested against real data in the main folder.

Decided in https://github.com/raadon96/expressive-resume-ai/issues/11.
