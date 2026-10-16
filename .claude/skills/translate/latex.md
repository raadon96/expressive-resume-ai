# LaTeX rules

For `.tex` files and LaTeX text.

## Preamble

Both lines go directly below `\documentclass{...}`.

- **`babel`**, for a target language other than English:
  ```tex
  \usepackage[shorthands=off,<babel name>]{babel}
  ```
  It makes words hyphenate by the language's rules (English rules give `Reg-istrierung`) and `\today` print a local date. `shorthands=off` keeps `"` a plain quote character. Babel names:

  | Language | babel name |
  |----------|------------|
  | english  | english    |
  | german   | ngerman    |
  | french   | french     |
  | spanish  | spanish    |

  For another language, use its babel name from the babel documentation.

- **Objective label**, for a resume: the class prints "Objective" whatever the language, so relabel it below the `babel` line with the usual heading for a resume summary in the target language (`Profil` in German):
  ```tex
  \renewcommand{\objective}[1]{\tagline{<label>}{#1}}
  ```

## Body

- Translate only the human-readable text inside the macros: macro names, arguments and document structure stay as they are.
- `\tech{}` values and every `\resumeheader[...]` and `\coverletterheader[...]` field stay as they are.
- Translate section titles, role titles where the target language has an established equivalent, and date text (month names, "Present").
- Write accented characters as raw UTF-8 (the class loads `inputenc[utf8]`). LaTeX accents already in the source, like `\"{a}`, can stay.
- Write straight quotes (`"..."`). The class doesn't load `T1` font encoding, so typographic quotes like German `„…“` break the build.
- Write `$\sim$` for "approximately". `\~` is an accent command and breaks the build.
