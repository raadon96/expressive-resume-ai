expressive-resume-ai: Claude Code commands that tailor LaTeX resumes and cover letters to job postings. Terms (Tool Repo, Data Repo, Profile, Application, Role Template, Scaffold, Application Index) are defined in `GLOSSARY.md`.

## Two repos in one folder

- **Tool Repo** (this repo): document classes, Scaffold, commands and scripts. Keep it free of personal data.
- **Data Repo** (`data/`): the user's Profile, Role Templates, Applications and Application Index. Its own git repo, gitignored by the Tool Repo: commit data changes inside `data/`.
- `example/` mirrors `data/` with fictional content.

Searches from the repo root skip the gitignored `data/`, so search explicit `data/…` paths.

`git clean -ffdx` in the Tool Repo deletes `data/` with its history; `.claude/settings.json` denies `git clean`. Remove build artifacts with `latexmk -C <file>.tex`.

## Editing documents

`/review-job`, `/create-application` and `/translate` carry their own steps. When editing resumes or cover letters outside them:

- Read the Profile in `data/profile/` first. `experience.md` is the source of truth for work history; `contact.md` holds the header details and wins over any `.tex` file.
- Keep bullets that come from a Role Template word for word; wording fixes belong in `data/templates/<Name>/`.
- For LaTeX syntax, read the Scaffold in `src/scaffold/application/` and the worked example in `example/applications/`.
- Change layout in the `.tex` documents. The `.cls` files in `src/` come from upstream Expressive Resume and stay unchanged.

## Building

From the document's directory:

```bash
latexmk -pdf -r ../../../src/latexmkrc resume.tex
```

`../../../src/latexmkrc` reaches the Tool Repo's rc file from any `data/applications/<dir>/`, `data/templates/<Name>/` or `example/applications/<dir>/`. `git rev-parse --show-toplevel` resolves to `data/` inside the Data Repo, where latexmk fails with "RC file does not exist". The `.cls` files resolve through `~/texmf` symlinks created by `./setup.sh`.
