Translate a file or a piece of text into another language, adapting the phrasing idiomatically rather than literally.

This command knows nothing about Applications, Role Templates, or the Profile. It translates what it's given; the caller decides which files to translate. `/create-application` calls it, and the user can call it directly.

## Argument

`$ARGUMENTS` is `<file | text> <language>`. The last word is the target language, e.g. `german`, `french`, `english`. Everything before it is the input:

- **File mode:** the input is the path to an existing file, e.g. `data/templates/MLOps/resume.tex german` or `data/profile/projects/FJSS.md german`.
- **Text mode:** anything else is the text to translate, e.g. `\achievement{Cut machine downtime by 17\%} german`. Another command can use this mode to translate a single bullet.

## Steps

1. **Resolve the language code** from the target language using this table. If the language isn't listed, use its ISO 639-1 code and its babel language name.

   | Language | Code | babel name |
   |----------|------|------------|
   | english  | en   | english    |
   | german   | de   | ngerman    |
   | french   | fr   | french     |
   | spanish  | es   | spanish    |

2. **Translate** following the rules below.

3. **Text mode:** return only the translation, with no preamble or commentary, so a calling command can insert it as is. Stop here.

4. **File mode, write the result** next to the source as `<name>_<code>.<ext>`, e.g. `resume.tex` → `resume_de.tex`, `FJSS.md` → `FJSS_de.md`. If the source name already ends in a language suffix, replace it: `resume_de.tex` → `resume_en.tex`. Never overwrite the source. If the target file already exists, show the user its path and ask before overwriting it.

5. **File mode, build `.tex` files** from the repo root:
   ```bash
   (cd <dir> && latexmk -pdf -r ../../../.latexmkrc <name>_<code>.tex)
   ```
   `../../../.latexmkrc` points at the Tool Repo's `.latexmkrc` from any `data/applications/<dir>/`, `data/templates/<Name>/`, or `example/applications/<dir>/`. For a file at another depth, adjust the number of `../`. Don't use `git rev-parse --show-toplevel`, which resolves to `data/` inside the Data Repo.
   If the build fails, show the full error output and print the manual build command so the user can retry after fixing the issue.
   Translations usually run longer than the source. If the source's PDF exists and the translated PDF has more pages (`pdfinfo <file>.pdf | grep Pages`), tell the user, so they can shorten it by hand.

6. **File mode, confirm completion** with each file created and its build status:
   ```
   Created:
   - <dir>/<name>_<code>.tex  →  <dir>/<name>_<code>.pdf (2 pages; the source has 1)
   ```

## Translation rules

### All inputs

- **Adapt, don't transliterate.** Rewrite each sentence the way a native speaker would phrase the same content, instead of carrying over the source's sentence structure word for word. A literal translation reads stiff even when every word is correct. That is the failure this command exists to avoid.
- **Don't change the content.** Add no claims, drop none, and keep every number, metric, and date.
- **Keep the style.** Keep the tone, length, and paragraph structure. Terse, parallel resume bullets stay terse and parallel. If the source avoids em dashes, so does the translation.
- **Keep unchanged:** company, product, and person names; technology names; URLs; email addresses; code and commands.
- Leave established English technical terms in English when a native speaker would (e.g. `Pipeline`, `Deployment`, `Machine Learning` in German).

### LaTeX (`.tex` files and LaTeX text)

- For a target language other than English, add `babel` directly below `\documentclass{...}`, with the babel name from the table in step 1:
  ```tex
  \usepackage[shorthands=off,<babel name>]{babel}
  ```
  Without it, words are hyphenated by English rules (`Reg-istrierung`) and `\today` prints an English date. `shorthands=off` keeps `"` a plain quote character.
- For a resume, also relabel the objective, since the class prints "Objective" whatever the language. Below the `babel` line:
  ```tex
  \renewcommand{\objective}[1]{\tagline{<label>}{#1}}
  ```
  The label is `Profil` in German; for other languages use the usual heading for a resume summary.
- Keep macro names, arguments, and document structure unchanged. Translate only the human-readable text inside the macros.
- Keep `\tech{}` values unchanged, and keep every `\resumeheader[...]` and `\coverletterheader[...]` field unchanged.
- Translate section titles, role titles where the target language has an established equivalent, and date text (month names, "Present").
- Write accented characters as raw UTF-8 (the class loads `inputenc[utf8]`). LaTeX accents already in the source, like `\"{a}`, can stay.
- Use straight quotes (`"..."`). The class doesn't load `T1` font encoding, so typographic quotes like German `„…“` fail to build.
- Use `$\sim$` for "approximately", never `\~`.

### Markdown (`.md` files)

- Keep headings, lists, tables, links, and front matter structure. Translate heading text and prose.
- Leave fenced code blocks and inline code unchanged, except for comments in natural language.

### Language-specific

**German:**
- Salutation and sign-off follow German convention, not a literal rendering: "Dear X Team" → "Liebes X-Team" (or "Sehr geehrte Damen und Herren" when the source is formal and addresses no one), "Sincerely" → "Mit freundlichen Grüßen".
- Thin space before the percent sign in LaTeX: `17\,\%`. In Markdown: `17 %`.
- Decimal comma: `1.5` → `1,5`. Thousands separator: `110k+` stays as is, `10,000` → `10.000`.
- Compound nouns join with hyphens when they mix an English term and a German one: `Machine-Learning-Pipeline`, `Python-Entwickler`.
- Use the formal "Sie" when addressing the reader.
