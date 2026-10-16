# Role Templates

A Role Template is your own reviewed resume for a job family you apply to often, e.g. `PyDev` or `MLOps`. Most of your resumes repeat the same bullets, so instead of writing each one from scratch, Claude copies the closest Role Template and tailors it: it rewrites the objective, and reorders, removes, or adds bullets from your profile. **It never rewords a bullet that's already in the Role Template,** so your reviewed wording stays as it is, and a diff shows exactly what changed:

```bash
diff data/templates/MLOps/resume.tex data/applications/26.04.26_mlops@examplecompany/resume.tex
```

Role Templates are optional. Without them, or when none fits, the resume is written from your profile.

## Creating one by hand

1. Pick a resume you're happy with, e.g. from a past application, and copy it into `data/templates/<Name>/resume.tex`. The name is the job family, e.g. `MLOps`.
2. Make it generic: write an objective without a company name, and keep the bullets that fit most postings in this family.
3. Build it and proofread it carefully. Every application from this family reuses its wording.
   ```bash
   src/build.sh data/templates/<Name>/resume.tex
   ```
4. Copyedit it once with `/copyedit data/templates/<Name>/resume.tex`, review the changes with `git diff` in `data/`, and rebuild it.
5. Optional: add a version in another language as `resume_<code>.tex`, e.g. with `/translate data/templates/<Name>/resume.tex german`, then proofread it too.

`resume.tex` is in your profile's language. [`example/templates/MLEng/`](../../example/templates/MLEng/) is a Role Template built from the fictional example profile.

## Keeping them up to date

When your profile gains something new, e.g. a new role or certificate, update your Role Templates by hand. Nothing checks this for you.
