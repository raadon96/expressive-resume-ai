---
name: create-application
description: Create an Application's tailored resume and cover letter from its Fit Analysis, then record it in the Application Index. Use once /review-job is confirmed, or to resume or redo an Application.
argument-hint: <Application directory>
---

`$ARGUMENTS` is the Application directory, e.g. `data/applications/26.04.24_pydev@yousician`.

If `data/` doesn't exist, stop and tell the user to run `./setup.sh` first.

## Terms

- **Source Language:** the language of `data/profile/experience.md`. `<source>` is its ISO 639-1 code (`en`).
- **Target Language:** the Job Posting's language. `<target>` is its ISO 639-1 code (`de`).
- **Output files:** `resume_<source>.tex` and `coverletter_<source>.tex`, plus `resume_<target>.tex` and `coverletter_<target>.tex` if the languages differ, each with its PDF.

## Content

Every achievement, number and caveat comes from the Profile, with nothing invented.

## Steps

1. **Read** `$ARGUMENTS/description.md` (the Job Posting and its Fit Analysis), the whole Profile (`data/profile/contact.md`, `experience.md`, `qualifications.md` and all of `projects/`) and `.claude/skills/copyedit/rules.md`, which step 3 writes by. Skip only files whose text you still have from this session. If `description.md` has no `## Fit Analysis`, stop and tell the user to run `/review-job`.

2. **Work out the languages** and the Output files. If any Output file already exists in `$ARGUMENTS/`, list them all and ask once: "These files already exist and will be overwritten: … Overwrite them?" On no, stop.

3. **Write `$ARGUMENTS/resume_<source>.tex` and `$ARGUMENTS/coverletter_<source>.tex`** in the Source Language, from `src/scaffold/application/resume.tex` and `coverletter.tex`. The Scaffold's content is fictional: replace all of it, commented-out entries included.

   **Job title:** the objective, the cover letter and the index row use the job title as written in the Job Posting. If it has none (e.g. a LinkedIn paste starting at "About the job"), infer it from the responsibilities and say so in the final report.

   **Resume:**
   - Fill `\resumeheader[...]` from `contact.md`, with `qrcode=../../profile/images/qr_code.png`.
   - Write `\objective{}` to name the role and the company.
   - Order experience, projects and bullets so the top 3–5 requirements come first.
   - **Choose the projects** in `\section{Technical Projects}` to suit the Job Posting, judging each Project Description by its content, since it may name a requirement in other words ("object detection" for "machine vision"). A project takes its name and dates from its Project Description; `experience.md` wins on titles, dates and employers. For a project, its Project Description decides what can be claimed.
   - Fill Education, Skills and Languages from the Profile. Keep Awards only if the Profile holds awards.
   - Write `$\sim$` for "approximately"; `\~` is an accent command and breaks the build.

   **Cover letter:** fill `\coverletterheader[...]` from `contact.md`, then write three paragraphs:
   - **Hook:** tie something concrete in the Job Posting to the user's own work.
   - **Evidence:** usually two quantified achievements that address the top requirements.
   - **Close:** one sentence on what the user would like to work on or ask about, then the Scaffold's contact line filled from `contact.md`, and the sign-off.

   Done when each of the top 3–5 requirements is addressed in the resume or listed as a Gap in the Fit Analysis, and the Evidence paragraph addresses at least two of them with numbers from the Profile.

4. **Copyedit both:** call `/copyedit $ARGUMENTS/resume_<source>.tex` and `/copyedit $ARGUMENTS/coverletter_<source>.tex` with the Skill tool.

5. **If the languages differ,** call `/translate $ARGUMENTS/resume_<source>.tex <language> overwrite` and `/translate $ARGUMENTS/coverletter_<source>.tex <language> overwrite` with the Skill tool, `<language>` being the Target Language's English name (`german`). Then call `/copyedit` on `resume_<target>.tex` and on `coverletter_<target>.tex`.

6. **Build** every Output file in one call from the repo root:
   ```bash
   src/build.sh $ARGUMENTS/resume_<source>.tex $ARGUMENTS/coverletter_<source>.tex [$ARGUMENTS/resume_<target>.tex $ARGUMENTS/coverletter_<target>.tex]
   ```
   If a build fails, show the script's output and the same command so the user can retry after fixing the issue. Done when every Output file prints a page count.

7. **Add a row to `data/index.md`,** keeping it newest first: insert it above the first row with an older date, or at the end if none is older; usually that's directly below the header separator (`|------|…`). The date comes from the directory name (`YY.MM.DD` → `20YY-MM-DD`); the company and full job title as written in the Job Posting (`Octopus Energy`, `Python Developer`), not the slugs. Skip if a row for this directory exists.
   ```
   | YYYY-MM-DD | <Company> | <Role> | [<dir>](applications/<dir>/) |
   ```

8. **Report** every Output file with its page count, flagging a resume over 2 pages or a cover letter over 1 for the user to shorten:
   ```
   Created:
   - $ARGUMENTS/resume_en.pdf (2 pages)
   - $ARGUMENTS/coverletter_en.pdf (1 page)
   - $ARGUMENTS/resume_de.pdf (3 pages: over 2, shorten it by hand)
   - $ARGUMENTS/coverletter_de.pdf (1 page)
   - Row added to data/index.md
   ```
