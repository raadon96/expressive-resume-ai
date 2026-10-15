---
name: translate
description: Translate a file or a few lines of text into another language, phrased the way a native speaker writes it. Use for a resume, cover letter, Role Template or Profile file, or bullets added to a resume in another language.
argument-hint: <file | text> <language> [overwrite]
context: fork
---

Translate the input into the target language. You see only this file, the files it points to and the input; the conversation that asked for the translation isn't available, and nothing else is needed. The caller decides what to translate; translate exactly that.

## Argument

`$ARGUMENTS` is `<file | text> <language> [overwrite]`.

- **`overwrite`:** if the last word is `overwrite`, remove it; the caller allows replacing an existing target file.
- **Language:** the last remaining word, in English, e.g. `german`, `french`, `english`. Its **code** is its ISO 639-1 code (`de`, `fr`, `en`).
- **File mode:** the rest is the path to an existing file, e.g. `data/templates/MLOps/resume.tex`.
- **Text mode:** anything else is the text itself, one or more lines, e.g. two `\achievement{...}` bullets.

## Steps

1. **Read the rules:** `.claude/skills/copyedit/rules.md`; `${CLAUDE_SKILL_DIR}/languages/<language>.md` if it exists; `${CLAUDE_SKILL_DIR}/latex.md` for a `.tex` file or LaTeX text. In file mode, also read the file.

2. **Check the target** (file mode). It sits next to the source as `<name>_<code>.<ext>`: `resume.tex` → `resume_de.tex`, `FJSS.md` → `FJSS_de.md`. A source name that already ends in a language suffix swaps it: `resume_de.tex` → `resume_en.tex`. If that makes the target the source itself, write nothing and reply that the file is already in that language. If the target exists and `overwrite` wasn't given, write nothing and reply only: `<target> already exists. Call /translate again with overwrite to replace it.`

3. **Translate** until every rule below and in the files from step 1 is applied. Done when a final read as a native-speaking recruiter finds no sentence that reads as translated.

4. **Return:**
   - **Text mode:** reply with only the translated lines, the same number and order as the input, with no preamble or commentary, so the caller can insert them as is.
   - **File mode:** write the target. For a `.tex` file, build it from the repo root with the source in the same call, so both page counts print:
     ```bash
     src/build.sh <dir>/<name>.tex <dir>/<name>_<code>.tex
     ```
     Reply with the file, its PDF and the page counts, e.g. `Created <dir>/resume_de.tex → <dir>/resume_de.pdf (2 pages; the source has 1)`. If the translation has more pages than the source, say so: the user shortens it by hand. If the build fails, reply with the script's output and the command, so the user can retry after fixing it.

## Rules

### All inputs

- **Adapt.** Rewrite each sentence the way a native speaker phrases the same content, in that language's own sentence structure. A literal translation reads stiff even when every word is correct; that is the failure this skill exists to prevent.
- **Content is fixed.** Every claim, number, metric and date stays; add none.
- **Keep the style:** tone, length and paragraph structure. Terse, parallel resume bullets stay terse and parallel.
- **Write by `rules.md`** in the target language, so the result reads as written in that language, not as a translated application.
- **Keep unchanged:** company, product and person names; technology names; URLs; email addresses; code and commands.
- **Keep established English technical terms** in English where a native speaker would (`Pipeline`, `Deployment`, `Machine Learning` in German).

### Markdown

- Keep headings, lists, tables, links and front matter structure; translate heading text and prose.
- Keep fenced code blocks and inline code as they are, translating only comments in natural language.
