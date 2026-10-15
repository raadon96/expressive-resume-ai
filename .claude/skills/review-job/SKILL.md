---
name: review-job
description: Analyse a Job Posting against your Profile, write a Fit Analysis, and optionally create the tailored resume and cover letter.
argument-hint: "[URL | Application directory | Job Posting text]"
disable-model-invocation: true
---

Write a Fit Analysis of a Job Posting against the user's Profile into a new Application, then offer to create the resume and cover letter with `/create-application`.

If `data/` doesn't exist, stop and tell the user to run `./setup.sh` first.

## Steps

1. **Get the Job Posting** from `$ARGUMENTS`:
   - **URL** (starts with `http`): fetch it with WebFetch and extract the Job Posting. If the page needs a login (e.g. LinkedIn), ask the user to paste the Job Posting.
   - **Application directory** (e.g. `data/applications/26.04.24_pydev@yousician`): the Job Posting is in its `description.md`.
   - **Empty:** ask the user to paste the Job Posting as the next message.
   - **Anything else:** the argument is the Job Posting.

   Done when you hold the Job Posting's full text.

2. **Read the Profile:** `data/profile/experience.md`, `data/profile/qualifications.md` and every file in `data/profile/projects/`. Read only the files you haven't read this session, or whose text you no longer have.

3. **Read `${CLAUDE_SKILL_DIR}/fit-analysis.md` and the Role Templates:** each `data/templates/<Name>/` is one, named after its directory; its `resume.tex` is in the Profile's language and `resume_<code>.tex` in another (`resume_de.tex`). Read each one's resumes for its job family and languages. None may exist.

4. **Choose the Application directory:** in directory mode, the given one. Otherwise `data/applications/YY.MM.DD_<role>@<company>/` with today's date, a short lowercase `<role>` slug (`pydev`, `mleng`) and the company name in lowercase without spaces (`octopusenergy`); create it without asking. Done when the directory exists. For a recruiter with an unnamed client, use the recruiter, and name the likely client in the Fit Analysis.

5. **Write `description.md`** in the Application directory from the template in `fit-analysis.md`. In directory mode, keep the Job Posting as it is, add `# Job Description` above it if missing, and replace any existing `## Fit Analysis` and `## Verdict`. Done when every requirement in the Job Posting appears in Strengths or Gaps, and both lines under Framing Recommendation are filled.

6. **Confirm** with the prompt in `fit-analysis.md`. To go on, call `/create-application <directory>` with the Skill tool.
