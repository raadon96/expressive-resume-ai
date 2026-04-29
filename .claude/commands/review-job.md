Analyse a job description against the user's profile, write a fit analysis, and optionally create tailored application files.

## Invocation modes

The argument (`$ARGUMENTS`) determines the mode:

- **No argument** — interactive: ask the user to paste the job description as the next message. After receiving it, infer `<role>` and `<company>` from the content, propose a directory name in the format `YY.MM.DD_<role>@<company>` (using today's date), and ask for confirmation before creating anything.
- **Directory path** (e.g. `applications/26.04.24_pydev@yousician`) — read `description.md` already present in that directory.
- **URL** (starts with `http`) — fetch the page via WebFetch and extract the job description from the content. If the page requires authentication (e.g. LinkedIn), inform the user and ask them to paste the description manually instead.

## Steps

1. **Obtain the job description** via the appropriate mode above.

2. **Read the user's profile:**
   - `profile/experience.md`
   - All files in `profile/projects/`

3. **Determine the application directory:**
   - If invoked with a directory path: use that path
   - Otherwise: construct `applications/YY.MM.DD_<role>@<company>/` using today's date. Normalize `<role>` and `<company>` to lowercase with no spaces (e.g. `pydev`, `octopusenergy`). In interactive mode, propose the name and wait for user confirmation before proceeding.

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

6. **Create `notes.md`** (with a `# Notes` heading) if it does not already exist.

7. **End with this exact prompt:**

   ```
   Proceed with creating a tailored CV and cover letter?
   - Yes  → I will create the application files now
   - No   → I will save description.md and close
   - Or ask me anything about the analysis
   ```

   - If **Yes**: run `/create-application <directory_path>` inline.
   - If **No**: confirm that `description.md` and `notes.md` are saved. Do not offer to delete the directory.
