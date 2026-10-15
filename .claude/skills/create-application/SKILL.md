---
name: create-application
description: Create an Application's tailored resume and cover letter from its Fit Analysis, then record it in the Application Index. Use once /review-job is confirmed, or to resume or redo an Application.
argument-hint: <Application directory>
---

`$ARGUMENTS` is the Application directory, e.g. `data/applications/26.04.24_pydev@yousician`.

If `data/` doesn't exist, stop and tell the user to run `./setup.sh` first.

## Steps

1. **Read** `$ARGUMENTS/description.md` (the Job Posting and its Fit Analysis), `data/profile/contact.md` (the header details) and `.claude/skills/copyedit/rules.md` (steps 3 and 4 write by it). Read Profile files only as the steps below say, and only those you haven't read this session or whose text you no longer have.

   **Job title:** the objective, the cover letter and the index row use the job title as written in the Job Posting. If it has none (e.g. a LinkedIn paste starting at "About the job"), infer it from the responsibilities and say so in the final report.

2. **Choose the case** from the `**Role Template:**` and `**Posting language:**` lines in the Fit Analysis. If they're missing, read `.claude/skills/review-job/fit-analysis.md` and the Role Templates (each `data/templates/<Name>/` is one, named after its directory; its `resume.tex` is in the Profile's language and `resume_<code>.tex` in another), then write the two lines and confirm as it says; on "No", stop. If the named Role Template isn't in `data/templates/`, list the ones that are and ask.

   The source language is the Profile's, the target the Job Posting's, and `<code>` the target's ISO 639-1 code (`de`).

   | Case | When | Resume | Output |
   |------|------|--------|--------|
   | **A** | same language | tailor `data/templates/<Name>/resume.tex`, or from scratch | `resume.tex`, `coverletter.tex` |
   | **B** | languages differ, Role Template has `resume_<code>.tex` | tailor `data/templates/<Name>/resume_<code>.tex`; no source-language resume | `resume_<code>.tex`, `coverletter.tex`, `coverletter_<code>.tex` |
   | **C** | languages differ, no Role Template in the target language | tailor `data/templates/<Name>/resume.tex`, or from scratch; then translate | `resume.tex`, `resume_<code>.tex`, `coverletter.tex`, `coverletter_<code>.tex` |

   **Existing files:** if any file in the case's Output column already exists in `$ARGUMENTS/`, list them all and ask once: "These files already exist and will be overwritten: … Overwrite them?" On no, stop. Done when the case is known and every Output file is free to write.

3. **Write the resume** in `$ARGUMENTS/`: `resume.tex`, or `resume_<code>.tex` in case B.

   **From a Role Template:** copy the Role Template's file, then tailor it.
   - Reorder experience, projects and bullets so the top 3–5 requirements come first; remove what's irrelevant or over the page count.
   - For requirements the Role Template doesn't cover, search the Profile (`grep -il '<keyword>' data/profile/*.md data/profile/projects/*.md`) and read only the matching files. Add bullets in the Role Template's style. In case B, write them in the source language, then translate all of them in one call: `/translate <bullets> <language>` with the Skill tool, replacing each with its returned line.
   - **Copy Role Template bullets verbatim.** Their wording is reviewed, and unchanged bullets keep the diff against the Role Template small (ADR 0002). Never reword one, not even for a typo or a keyword; if one looks wrong, tell the user to fix it in `data/templates/<Name>/`.
   - Keep the Role Template's commented-out entries commented out and unchanged.
   - Check `\resumeheader[...]` against `contact.md`, which wins.
   - In case B, if the copied file lacks the `babel` line or the objective label from the Preamble in `.claude/skills/translate/latex.md`, add them and tell the user to add them to the Role Template too.

   **From scratch:** read `data/profile/experience.md`, `qualifications.md` and all of `projects/`. Start from `src/scaffold/application/resume.tex`, fill `\resumeheader[...]` from `contact.md`, and emphasise the top 3–5 requirements in the most relevant experience entries.

   **Both:**
   - Rewrite `\objective{}` to name the role and the company.
   - Every achievement comes from the Profile as it stands there.
   - `qrcode=../../profile/images/qr_code.png` (Applications and Role Templates are both one level below `data/<folder>/`).
   - Write `$\sim$` for "approximately"; `\~` is an accent command and breaks the build.
   - **Copyedit what you wrote.** From a Role Template: call `/copyedit` once in text mode on the `\objective{}` line and the bullets you added, as they stand in the file, and replace each with its returned line; the Role Template's own bullets stay out of the call. From scratch: `/copyedit $ARGUMENTS/<resume>.tex`.

   Done when each of the top 3–5 requirements is addressed in the resume or listed as a Gap in the Fit Analysis.

4. **Write `$ARGUMENTS/coverletter.tex`**, always from scratch and in the source language. Start from `src/scaffold/application/coverletter.tex` and fill `\coverletterheader[...]` from `contact.md`. If `data/profile/voice.md` holds more than comments, read it and write in that voice. Three paragraphs:
   - **Hook:** tie something concrete in the Job Posting to the user's own work.
   - **Evidence:** usually two quantified achievements that address the top requirements. Take them from the resume and the Fit Analysis' Strengths; look up the Profile only if those aren't enough.
   - **Close:** one sentence on what the user would like to work on or ask about, then the Scaffold's contact line filled from `contact.md`, and the sign-off.

   Then call `/copyedit $ARGUMENTS/coverletter.tex data/profile/voice.md`, leaving out the voice file when it's missing or holds only comments.

5. **Build the PDFs** from the repo root:
   ```bash
   src/build.sh $ARGUMENTS/<resume>.tex $ARGUMENTS/coverletter.tex
   ```
   If a build fails, show the script's output and the same command so the user can retry after fixing the issue. Done when both print a page count.

6. **Translate** (cases B and C): call `/translate $ARGUMENTS/coverletter.tex <language> overwrite` with the Skill tool, and in case C also `/translate $ARGUMENTS/resume.tex <language> overwrite`; step 2 already asked about overwriting. Each writes and builds its `_<code>` file. Pass on any page growth or build failure it reports.

   Then call `/copyedit $ARGUMENTS/coverletter_<code>.tex` with the voice file as in step 4, and rebuild it with `src/build.sh $ARGUMENTS/coverletter_<code>.tex`. `resume_<code>.tex` stays as `/translate` wrote it: most of its bullets come from the Role Template.

7. **Add a row to `data/index.md`,** keeping it newest first: insert it above the first row with an older date, or at the end if none is older; usually that's directly below the header separator (`|------|…`). The date comes from the directory name (`YY.MM.DD` → `20YY-MM-DD`); the company and full job title as written in the Job Posting (`Octopus Energy`, `Python Developer`), not the slugs. Skip if a row for this directory exists.
   ```
   | YYYY-MM-DD | <Company> | <Role> | [<dir>](applications/<dir>/) |
   ```

8. **Report** every file created, e.g. for case C:
   ```
   Created from the MLOps Role Template:
   - $ARGUMENTS/resume.tex  →  $ARGUMENTS/resume.pdf
   - $ARGUMENTS/resume_de.tex  →  $ARGUMENTS/resume_de.pdf
   - $ARGUMENTS/coverletter.tex  →  $ARGUMENTS/coverletter.pdf
   - $ARGUMENTS/coverletter_de.tex  →  $ARGUMENTS/coverletter_de.pdf
   - Row added to data/index.md

   Review what changed from the Role Template:
     diff data/templates/MLOps/resume.tex $ARGUMENTS/resume.tex
   ```
   The diff compares the file copied in step 3 with the resume written from it; in case B that's `resume_<code>.tex` on both sides. For a from-scratch resume, write "Created from scratch:" and leave out the diff.
