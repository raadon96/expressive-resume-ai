Analyse a job description against the user's profile, write a fit analysis, and optionally create tailored application files.

## Invocation modes

The argument (`$ARGUMENTS`) determines the mode:

- **Pasted text** (any other argument) — treat the argument itself as the job description.
- **Directory path** (e.g. `data/applications/26.04.24_pydev@yousician`) — read `description.md` already present in that directory.
- **URL** (starts with `http`) — fetch the page via WebFetch and extract the job description from the content. If the page requires authentication (e.g. LinkedIn), inform the user and ask them to paste the description manually instead.
- **No argument** — interactive: ask the user to paste the job description as the next message.

## Data Repo

All user data lives in `data/`, the user's Data Repo: a separate git repo that the Tool Repo gitignores. Grep and `grep`/`ugrep` skip `data/` when searching from the repo root, so always read and search with explicit `data/…` paths (e.g. search in `data/profile/`, not in `.`).

If `data/` does not exist, stop and tell the user: "no data/ found; run ./setup.sh first". Do not create `data/` yourself.

## Steps

1. **Obtain the job description** via the appropriate mode above.

2. **Read the user's profile:**
   - `data/profile/experience.md`
   - All files in `data/profile/projects/`

3. **Determine the application directory:**
   - If invoked with a directory path: use that path
   - Otherwise: construct `data/applications/YY.MM.DD_<role>@<company>/` using today's date. `<role>` is a short lowercase slug with no spaces; abbreviate if helpful (e.g. `pydev` for Python Developer, `mleng` for Machine Learning Engineer). `<company>` is the company name in lowercase with no spaces (e.g. `octopusenergy`). Don't ask the user to confirm the name; create the directory directly. If the company is ambiguous (e.g. a recruiter with an unnamed client), use the named company and note the likely client in `description.md`.

4. **Create the application directory** if it does not already exist.

5. **Write `description.md`** with the following structure:
   ```
   # Job Description

   <raw job description, preserved as-is>

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

6. **End with this exact prompt:**

   ```
   Proceed with creating a tailored CV and cover letter?
   - Yes  → I will create the application files now
   - No   → I will save description.md and close
   - Or ask me anything about the analysis
   ```

   - If **Yes**: run `/create-application <directory_path>` inline.
   - If **No**: confirm that `description.md` is saved. Do not offer to delete the directory.
