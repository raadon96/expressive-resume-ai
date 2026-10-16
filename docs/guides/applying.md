# Applying for a job

From job posting to PDFs, and what to do when you need more than the default path.

## The default path

```
/review-job
```

Claude asks you to paste the job posting, then:

1. creates `data/applications/YY.MM.DD_<role>@<company>/`
2. writes the fit analysis to `description.md`: strengths, gaps, how to frame your experience, which [Role Template](role-templates.md) to start from, and the posting's language
3. asks whether to create the documents

Confirm, and Claude writes `resume.tex` and `coverletter.tex`, builds the PDFs and adds a row to your Application Index, `data/index.md`. At the prompt you can also pick another Role Template, or ask for the resume to be written from scratch. Cover letters are always written from scratch.

Your applications are files in `data/`. Commit them there: `cd data && git add . && git commit`.

## Other ways to pass the job posting

> **Tip:** copy job postings with a "Copy as Markdown" browser extension. Claude reads requirements more accurately from Markdown, but plain text works too.

| Command | Job posting |
|---------|-------------|
| `/review-job <job posting>` | pasted inline |
| `/review-job https://company.com/careers/some-role` | fetched from the URL. LinkedIn needs a login, so Claude asks you to paste it instead |
| `/review-job data/applications/<folder>` | read from `description.md` in that folder |

## Resuming an application

If a session ends after the fit analysis but before the documents are written, continue with:

```
/create-application data/applications/26.04.26_pydev@examplecompany
```

## Postings in another language

If the posting's language differs from your profile's (e.g. a German posting, an English profile), Claude writes the documents in your profile's language and translates them, keeping both: `resume.tex` and `resume_de.tex`, `coverletter.tex` and `coverletter_de.tex`. If the Role Template already has a version in the posting's language (`resume_de.tex`), the resume is tailored from that directly, and there's only `resume_de.tex`.

You can also translate any `.tex` or `.md` file yourself:

```
/translate data/applications/26.04.26_pydev@examplecompany/coverletter.tex german
```

Claude writes `coverletter_de.tex` next to the original, phrased the way a native speaker would write it rather than word for word, and builds the PDF. Like `/copyedit`, it works in a fresh context that sees only the input and the translation rules, so the job posting's keywords can't creep into the translation. The original is never overwritten; if `coverletter_de.tex` already exists, it stops and says so, and `/translate <file> german overwrite` replaces it. Given text instead of a path, it returns the translation.

## Copyediting

Claude writes by one set of rules, `.claude/skills/copyedit/rules.md`, so the text reads like you wrote it for a recruiter rather than like a template: no stock phrases, inflated verbs or empty claims. `/copyedit` then checks the result in a fresh context that sees only the text, the rules and your voice file, never the conversation that wrote it. It keeps every fact and number, and never makes the text longer.

`/create-application` runs it on what Claude wrote: the resume's objective and any bullets added from your profile (or the whole resume, if written from scratch), and the cover letter in every language. Bullets from your Role Template are left alone.

You can run it on any file, optionally with your voice file:

```
/copyedit data/applications/26.04.26_pydev@examplecompany/coverletter.tex data/profile/voice.md
```

It edits the file in place, so rebuild the PDF afterwards. Given text instead of a path, it returns the edited text.

## Building the PDFs

Claude builds the PDFs when it writes the documents. To rebuild after your own edits:

**VS Code:** the [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension rebuilds on save, with no further configuration. It comes preinstalled in the Dev Container; on a local install, install it yourself.

**Terminal**, from the repo root:

```bash
src/build.sh data/applications/YY.MM.DD_<role>@<company>/resume.tex data/applications/YY.MM.DD_<role>@<company>/coverletter.tex
```

It prints each PDF with its page count, or the LaTeX errors if a build fails. Only the `.pdf` is kept next to the `.tex` source; build artifacts are deleted after each successful build.

**Other editors:** run `src/build.sh`, or pass `-r <tool folder>/src/latexmkrc` to latexmk.
