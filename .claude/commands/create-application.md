Create tailored `resume.tex` and `coverletter.tex` for a job application, then record it in `data/index.md`.

## Argument

`$ARGUMENTS` is the application directory path, e.g. `data/applications/26.04.24_pydev@yousician`.

This command can be invoked automatically by `/review-job` after confirmation, or manually to resume an interrupted session.

## Data Repo

All user data lives in `data/`, the user's Data Repo: a separate git repo that the Tool Repo gitignores. Grep and `grep`/`ugrep` skip `data/` when searching from the repo root, so always read and search with explicit `data/…` paths (e.g. search in `data/profile/`, not in `.`).

If `data/` does not exist, stop and tell the user: "no data/ found; run ./setup.sh first". Do not create `data/` yourself.

## Steps

1. **Read context:**
   - `data/profile/contact.md` — canonical source for all personal header details (name, email, phone, LinkedIn, GitHub, city, country)
   - `$ARGUMENTS/description.md` — job description and fit analysis
   - `data/profile/experience.md` — full work history
   - All files in `data/profile/projects/` — project details
2. **Create `$ARGUMENTS/resume.tex`:**
   - Use `src/scaffold/application/resume.tex` as the structural starting point
   - Fill `\resumeheader[...]` with the user's personal details from `data/profile/contact.md`
   - Rewrite `\objective{}` to address the specific role and company by name
   - Tailor `\achievement{}` bullets in the most relevant experience entries to emphasise the top 3–5 requirements from the job description. Use only achievements that exist in the source profile — do not invent or embellish.
   - Set `qrcode=../../profile/images/qr_code.png` (relative to `data/applications/<dir>/`, this resolves to `data/profile/images/qr_code.png`)
   - Use `$\sim$` for the tilde/approximately symbol (never `\~`, which is a LaTeX accent command and will cause a build error)

3. **Create `$ARGUMENTS/coverletter.tex`:**
   - Use `src/scaffold/application/coverletter.tex` as the structural base
   - Fill `\coverletterheader[...]` with the user's personal details from `data/profile/contact.md`
   - Write three paragraphs:
     - **Hook** — why this specific role at this specific company (reference something concrete from the job description or company context)
     - **Evidence** — 2–3 concrete, quantified achievements from `data/profile/` that directly address the top requirements
     - **Close** — express genuine enthusiasm, invite next steps, professional sign-off

4. **Prepend a row to the Application Index, `data/index.md`:**
   Parse the date (`YY.MM.DD` → `20YY-MM-DD`), company, and role from the directory name. Insert the row directly below the table's header separator line (`|------|…`), so the newest application comes first. The folder is a link relative to `data/index.md`:
   ```
   | YYYY-MM-DD | <Company> | <Role> | [<dir>](applications/<dir>/) |
   ```
   If a row for this folder already exists (e.g. when resuming a session), leave it as is.

5. **Build the PDFs** using the Bash tool. Run from the repo root. The rc path is relative to `data/applications/<dir>/` and points at the Tool Repo's `.latexmkrc`; don't use `git rev-parse --show-toplevel`, which resolves to `data/` inside the Data Repo:
   ```bash
   (cd $ARGUMENTS && latexmk -pdf -r ../../../.latexmkrc resume.tex)
   ```
   Then, if `coverletter.tex` exists:
   ```bash
   (cd $ARGUMENTS && latexmk -pdf -r ../../../.latexmkrc coverletter.tex)
   ```
   The subshell keeps the working directory at the repo root, so the second command's relative `cd` still works.
   If either build fails, show the full error output and print the manual build command so the user can retry after fixing the issue.

6. **Confirm completion:**
   ```
   Created:
   - $ARGUMENTS/resume.tex  →  $ARGUMENTS/resume.pdf
   - $ARGUMENTS/coverletter.tex  →  $ARGUMENTS/coverletter.pdf
   - Row added to data/index.md
   ```
