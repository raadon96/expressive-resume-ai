# Coding standards

Judgement calls for reviewing a diff to the Tool Repo. Mechanical rules (ShellCheck, no personal data, the `git clean` deny) run in `.github/workflows/ci.yml`; skip them here.

## Complexity pays for itself

One maintainer keeps this repo running. Each new mechanism (CI job, hook, script, config branch) carries a stated reason that outweighs its upkeep. Reach for the platform's built-in feature before custom logic: GitHub's `paths:` filter over a compare-API gate, VS Code's `.gitconfig` copy over a host mount.

## Docs move with the change

When a diff changes a path, file, mechanism or behaviour, the same diff updates every doc that describes it: `README.md`, `AGENTS.md`, `.devcontainer/README.md`, `.claude/commands/*.md`, `src/scaffold/data/README.md`, `docs/agents/` and `CLAUDE.local.md`. Grep for the old name.

## Each file serves its reader

- `README.md`: users setting up and using the tool.
- `AGENTS.md`: loaded on every turn in every user's fork. Holds only what any user's agent needs on every task, mostly pointers.
- `.claude/commands/*.md`: self-contained; each carries the gotchas its own steps need.
- `CLAUDE.local.md` and `docs/agents/`: maintainer-only material.

## Comments say why

Comment where the config or code can't explain itself: a constraint, a workaround, a non-obvious consequence ("the base image has wget but no curl", "Not a required check: the path filter skips it"). Leave self-explanatory lines bare.

## Glossary terms

Docs, commits and PRs name domain concepts with the terms in `GLOSSARY.md` (Tool Repo, Data Repo, Profile, Role Template, Scaffold, ...).
