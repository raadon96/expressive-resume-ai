---
status: accepted
---

# Resumes start from a Role Template and are tailored within fixed limits

An Application's resume is copied from the user's closest Role Template, then tailored. A Role Template in the job posting's language is used directly; otherwise the one in the Profile's language is used and the tailored resume is translated. The objective is always rewritten, and bullets may be reordered, removed, or added from the Profile, but **bullets already in the Role Template are never reworded**. Without a matching Role Template, the resume is written from the Profile (bespoke). This fixes the two real costs of bespoke generation: reviewed wording drifting between Applications, and re-proofreading a resume that is 85–90% identical to the last one. With the no-rewording rule, a diff against the Role Template shows exactly what needs review.

## Considered Options

- **Bespoke from the Profile every time** (the previous model): rejected. It loses polished wording and hand-tuned layout, and every resume needs a full review.
- **Role Template only, with just the objective changed**: rejected. It can't cover a requirement that the Role Template doesn't.
- **Bullet library in the Profile, every resume assembled from it**: rejected. It means restructuring the Profile and doesn't keep hand-tuned layout.

## Consequences

- The Profile is the source for facts, and each Role Template is the source for its own bullets' wording. They can drift apart. Keeping them in sync is the user's job, and `/create-application` warns when the Profile has something newer that a Role Template lacks.
- Resumes and cover letters are written in the Profile's language and, when the posting's language differs, translated by `/translate` in a separate pass, keeping both versions. The exception is a Role Template that already exists in the posting's language: the resume is tailored from it directly, with no Profile-language resume, and bullets added from the Profile are translated as they're inserted. Cover letters are always bespoke.

## Workflow by language

Example: English Profile, German posting.

```
                  /create-application
                          │
            source = Profile language   (e.g. en)
            target = posting language   (e.g. de)
                          │
                          ▼
              ┌─────────────────────────┐
              │   source == target ?    │
              └─────────────────────────┘
                 yes │           │ no
                     │           ▼
                     │   ┌────────────────────────────────┐
                     │   │ Role Template exists in the    │
                     │   │ posting's language?            │
                     │   │ (e.g. MLOps/resume_de.tex)     │
                     │   └────────────────────────────────┘
                     │       yes │              │ no
                     ▼           ▼              ▼
    ┌──────────────────────┐ ┌─────────────────────────┐ ┌──────────────────────────┐
    │ A: same language     │ │ B: template in          │ │ C: no template in        │
    │                      │ │ posting's language      │ │ posting's language       │
    ├──────────────────────┤ ├─────────────────────────┤ ├──────────────────────────┤
    │ RESUME               │ │ RESUME                  │ │ RESUME                   │
    │  Role Template match?│ │  copy resume_de.tex     │ │  Role Template match in  │
    │   yes → tailor it    │ │  from Role Template     │ │  Profile's language?     │
    │   no  → bespoke from │ │  and tailor it; bullets │ │   yes → tailor it        │
    │         the Profile  │ │  added from the Profile │ │   no  → bespoke from     │
    │  → resume.tex        │ │  → /translate (text     │ │         the Profile      │
    │                      │ │    mode) per bullet     │ │  → resume.tex            │
    │                      │ │                         │ │          │               │
    │                      │ │  no English resume      │ │  /translate (file mode)  │
    │                      │ │                         │ │  → resume_de.tex         │
    ├──────────────────────┤ ├─────────────────────────┤ ├──────────────────────────┤
    │ COVER LETTER         │ │ COVER LETTER            │ │ COVER LETTER             │
    │  bespoke             │ │  bespoke, in en         │ │  bespoke, in en          │
    │  → coverletter.tex   │ │  → coverletter.tex      │ │  → coverletter.tex       │
    │                      │ │          │              │ │          │               │
    │                      │ │  /translate (file mode) │ │  /translate (file mode)  │
    │                      │ │  → coverletter_de.tex   │ │  → coverletter_de.tex    │
    ├──────────────────────┤ ├─────────────────────────┤ ├──────────────────────────┤
    │ OUTPUT               │ │ OUTPUT                  │ │ OUTPUT                   │
    │  resume.tex          │ │  resume_de.tex          │ │  resume.tex              │
    │  coverletter.tex     │ │  coverletter.tex        │ │  resume_de.tex           │
    │                      │ │  coverletter_de.tex     │ │  coverletter.tex         │
    │                      │ │                         │ │  coverletter_de.tex      │
    └──────────────────────┘ └─────────────────────────┘ └──────────────────────────┘
```

Tailoring always means: rewrite the objective; reorder, remove, or add bullets from the Profile; never reword bullets already in the Role Template.

Decided in https://github.com/raadon96/expressive-resume-ai/issues/4.
