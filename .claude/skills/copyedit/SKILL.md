---
name: copyedit
description: Copyedit resume or cover-letter prose so it reads like its author wrote it for a recruiter. Use on a file or a few lines of text, e.g. after writing an objective, added bullets or a cover letter.
argument-hint: <file | text> [voice file]
disable-model-invocation: false
context: fork
background: false
---

Copyedit the input against one set of rules, so it reads like a specific person wrote it for a human recruiter. You see only this file, the input and the voice file; the conversation that wrote the text isn't available, and nothing else is needed.

## Argument

`$ARGUMENTS` is `<file | text> [voice file]`.

- **Voice file:** if the last word is the path to an existing `.md` file and something comes before it, it's the voice file. Otherwise there's none.
- **File mode:** the rest is the path to an existing file, e.g. `data/applications/<dir>/coverletter.tex`.
- **Text mode:** anything else is the text itself, one or more lines, e.g. an `\objective{...}` line and two `\achievement{...}` bullets.

## Steps

1. **Read** `${CLAUDE_SKILL_DIR}/rules.md`, and in file mode the file.

2. **Read the voice file,** if given. Its `## Samples` show how the author writes; match their sentence length, register and word choice. Its `## Notes` override `rules.md` where they conflict. A file whose sections hold only HTML comments is empty: write in a neutral voice, as without one.

3. **Edit** the prose until every rule in `rules.md` is applied. Done when a final read as the recruiter finds nothing left to fix.
   - **Facts are fixed.** Keep every achievement, number, date, name and technology; add none. A stock self-description with no evidence behind it ("I work reliably") is not a fact and may be cut.
   - **Length stays the same or shrinks.**
   - **In LaTeX, edit only the prose.** Keep commands, `\resumeheader[...]` and `\coverletterheader[...]` blocks, `\href` targets, `\tech{}` values, comments and escapes (`\%`, `$\sim$`) exactly as they are.
   - **Text mode keeps the lines:** the same number of lines, in the same order, each still wrapped in its own LaTeX command, so the caller can put each one back where it came from.
   - Edit in the input's language, looking for that language's own form of each pattern.

4. **Return**, with no list of the fixes:
   - **File mode:** write the edits to the file in place, then reply with one line, `Copyedited <file>`. For a `.tex` file, add a second line: `Rebuild it: src/build.sh <file>`.
   - **Text mode:** reply with only the edited lines, no preamble or commentary, so the caller can insert them as is.
