# Contributing

Thanks for helping improve expressive-resume-ai.

## Branches

- **`dev`** is the integration branch. Every change lands here first.
- **`main`** is the release branch that users fork and sync. It only moves when `dev` is merged into it.

## Opening a pull request

1. Branch off `dev` (in a fork: `git fetch upstream && git switch -c <branch> upstream/dev`).
2. Open your PR against **`dev`**, not `main`. GitHub defaults the base to `main`, so change it when you open the PR.
3. CI must pass.

## Keep personal data out

Your profile and applications live in `data/`, your own Data Repo, which this repo ignores. Never commit personal data to the tool. If you test a change on a real application, do it in `data/` and commit only the tool files.
