Create tailored `resume.tex` and `coverletter.tex` for a job application, then record it in `applications.md`.

## Argument

`$ARGUMENTS` is the application directory path, e.g. `applications/26.04.24_pydev@yousician`.

This command can be invoked automatically by `/review-job` after confirmation, or manually to resume an interrupted session.

## Steps

1. **Read context:**
   - `profile/contact.md` — canonical source for all personal header details (name, email, phone, LinkedIn, GitHub, city, country)
   - `$ARGUMENTS/description.md` — job description and fit analysis
   - `profile/experience.md` — full work history
   - All files in `profile/projects/` — project details
2. **Create `$ARGUMENTS/resume.tex`:**
   - Use `templates/placeholder/resume.tex` as the structural starting point
   - Fill `\resumeheader[...]` with the user's personal details from `profile/contact.md`
   - Rewrite `\objective{}` to address the specific role and company by name
   - Tailor `\achievement{}` bullets in the most relevant experience entries to emphasise the top 3–5 requirements from the job description. Use only achievements that exist in the source profile — do not invent or embellish.
   - Set `qrcode=../../profile/images/qr_code.png`
   - Use `$\sim$` for the tilde/approximately symbol (never `\~`, which is a LaTeX accent command and will cause a build error)

3. **Create `$ARGUMENTS/coverletter.tex`:**
   - Use `templates/placeholder/coverletter.tex` as the structural base
   - Fill `\coverletterheader[...]` with the user's personal details from `profile/contact.md`
   - Write three paragraphs:
     - **Hook** — why this specific role at this specific company (reference something concrete from the job description or company context)
     - **Evidence** — 2–3 concrete, quantified achievements from `profile/` that directly address the top requirements
     - **Close** — express genuine enthusiasm, invite next steps, professional sign-off

4. **Append a row to `applications.md`:**
   Parse the date (`YY.MM.DD` → `20YY-MM-DD`), company, and role from the directory name.
   ```
   | YYYY-MM-DD | <Company> | <Role> | Applied | |
   ```

5. **Build the PDFs** using the Bash tool. Run from the repo root:
   ```bash
   cd $ARGUMENTS && latexmk -pdf -r "$(git rev-parse --show-toplevel)/.latexmkrc" resume.tex
   ```
   Then, if `coverletter.tex` exists:
   ```bash
   cd $ARGUMENTS && latexmk -pdf -r "$(git rev-parse --show-toplevel)/.latexmkrc" coverletter.tex
   ```
   If either build fails, show the full error output and print the manual build command so the user can retry after fixing the issue.

6. **Confirm completion:**
   ```
   Created:
   - $ARGUMENTS/resume.tex  →  $ARGUMENTS/resume.pdf
   - $ARGUMENTS/coverletter.tex  →  $ARGUMENTS/coverletter.pdf
   - Row added to applications.md
   ```
