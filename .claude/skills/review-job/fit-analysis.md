# Fit Analysis

An Application's `description.md` holds the Job Posting and its Fit Analysis. The file name, the `# Job Description` heading and the `**Posting language:**` line keep their names so existing Applications still read.

## Template

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

- **Role Template:** <Name> (<reason>) | none: from-scratch (<reason>)
- **Posting language:** <language> (Profile: <language>)

## Verdict

<One sentence: recommend applying or not, and why>
```

## The two lines

`/create-application` chooses its case from them.

- **Role Template:** choose the one whose job family is closest to the Job Posting, e.g. `MLOps (deployment and monitoring are the core of the role)`. A from-scratch resume beats a stretched match: if none is close, or none exist, write `none: from-scratch` with the reason. When the languages differ, say whether the Role Template exists in the Job Posting's language, e.g. `MLOps (…; has resume_de.tex)`.
- **Posting language:** the Job Posting's language, then the Profile's, which is the language of `data/profile/experience.md`.

## Confirming the choice

End with this prompt:

```
Proceed with creating a tailored CV and cover letter?
- Yes  → I will create the application files now, <starting from the <Name> Role Template | written from scratch>
- Yes, but from <another Role Template> or from scratch → I will record your choice and create the files
- No   → I will save description.md and close
- Or ask me anything about the analysis
```

- **Yes:** go on.
- **Another Role Template or from scratch:** if the named Role Template isn't in `data/templates/`, list the ones that are and ask again, leaving `description.md` as it is. Once the user names one that exists or chooses from scratch, replace the `**Role Template:**` line with the choice plus `(chosen by the user)`, then go on.
- **No:** confirm that `description.md` is saved, and stop. The Application directory stays.
