# Expressive Resume AI

An AI-assisted LaTeX resume and cover-letter generator, driven by Claude Code slash-commands, meant to be forked and used for a real job search.

## Language

**Application**:
A single job application's working directory, `applications/YY.MM.DD_<role>@<company>/`, holding that application's job posting, fit analysis, generated resume, cover letter, and notes.
_Avoid_: "the application" for the software/repo itself — always say "this repo" or "expressive-resume-ai" instead; job, posting, submission.

**Profile**:
The user's canonical personal/career source data (`profile/`), kept once and drawn on by every Application. Not itself an Application, and not a generated document.
_Avoid_: resume data, master resume.

**Public Template Repo**:
This repo, expressive-resume-ai, kept generic and free of personal data so anyone can fork it.
_Avoid_: the template, the base repo, upstream (on its own, ambiguous about direction).

**Scaffold**:
The structural `resume.tex` and `coverletter.tex` that `/create-application` starts every generated document from. Lives alongside the class files in `src/scaffold/`.
_Avoid_: template (ambiguous).

**Role Template**:
A user's own pre-tailored resume for a job family (e.g. PyDev, MLOps), kept with the user's own data (location decided by the map "Connecting the tool repo and user data"). Belongs to the user, not to this repo. Whether Role Templates take part in the application workflow at all is decided by the map "Workflow model".
_Avoid_: template on its own.
