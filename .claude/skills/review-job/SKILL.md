---
name: review-job
description: Analyse a Job Posting against your Profile, write a Fit Analysis, and optionally create the tailored resume and cover letter.
argument-hint: "[URL | Job Posting text]"
disable-model-invocation: true
---

Write a Fit Analysis of a Job Posting against the user's Profile into a new Application, then offer to create the resume and cover letter with `/create-application`.

If `data/` doesn't exist, stop and tell the user to run `./setup.sh` first.

## Steps

1. **Get the Job Posting** from `$ARGUMENTS`:
   - **URL** (starts with `http`): fetch it with WebFetch and extract the Job Posting. If the page needs a login (e.g. LinkedIn), ask the user to paste the Job Posting.
   - **Empty:** ask the user to paste the Job Posting as the next message.
   - **Anything else:** the argument is the Job Posting.

   Done when you hold the Job Posting's full text.

2. **Read the Profile:** `data/profile/experience.md`, `data/profile/qualifications.md` and every file in `data/profile/projects/`.

3. **Create the Application directory:** `data/applications/YY.MM.DD_<role>@<company>/` with today's date, a short lowercase `<role>` slug (`pydev`, `mleng`) and the company name in lowercase without spaces (`octopusenergy`), without asking. For a recruiter with an unnamed client, use the recruiter, and name the likely client in the Fit Analysis.

4. **Write `description.md`** in the Application directory from the template below. Done when every requirement in the Job Posting appears in Strengths or Gaps.

   ```
   # Job Description

   <the Job Posting, as received>

   ## Fit Analysis

   ### Strengths

   | Requirement | Match from Profile |
   |-------------|-------------------|
   | ...         | ...               |

   ### Gaps

   | Requirement | Gap | Severity |
   |-------------|-----|----------|
   | ...         | ... | Low / Medium / High |

   ### Framing Recommendation

   <2–3 sentences on how to position this application>

   ## Verdict

   <One sentence: recommend applying or not, and why>
   ```

   The file name and the `# Job Description` heading stay as they are, so existing Applications still read.

5. **Confirm** with this prompt:

   ```
   Proceed with creating a tailored CV and cover letter?
   - Yes  → I will create the application files now
   - No   → I will save description.md and close
   - Or ask me anything about the analysis
   ```

   - **Yes:** call `/create-application <directory>` with the Skill tool.
   - **No:** confirm that `description.md` is saved, and stop. The Application directory stays.
   - **A question:** answer it, then show the prompt again.
