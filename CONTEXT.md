# Expressive Resume AI

An AI-assisted LaTeX resume and cover-letter generator, driven by Claude Code slash-commands, meant to be cloned/forked and used for a real job search.

## Language

**Application**:
A single job application's working directory in the user's Data Repo, `applications/YY.MM.DD_<role>@<company>/`, holding that application's job posting, fit analysis, generated resume, cover letter, and notes.
_Avoid_: "the application" for the software/repo itself — always say "this repo" or "expressive-resume-ai" instead; job, posting, submission.

**Profile**:
The user's canonical personal/career source data (`profile/`), kept once and drawn on by every Application. Not itself an Application, and not a generated document.
_Avoid_: resume data, master resume.

**Application Index**:
The list of a user's Applications in their Data Repo, one row per Application (date, company, role, link to its directory), newest first. Records that an Application was created, not whether it was sent or how it is going.
_Avoid_: tracker, applications list, status board.

**Tool Repo**:
expressive-resume-ai, the public, generic code (document classes, Scaffold, slash-commands, scripts), kept free of personal data. Also any user's fork or clone of it; say "upstream Tool Repo" when the original specifically is meant.
_Avoid_: Public Template Repo, the template, the base repo, upstream (on its own).

**Data Repo**:
A user's own private repo holding their Profile, Applications and Role Templates, kept inside their Tool Repo folder but never part of it.
_Avoid_: personal repo, private copy, fork (a fork is a Tool Repo).

**Scaffold**:
The files in the Tool Repo copied to start something new: the `resume.tex` and `coverletter.tex` every Application starts from, and the starting files of a new user's Data Repo. Lives in `src/scaffold/`.
_Avoid_: template (ambiguous), skeleton.

**Role Template**:
A user's own pre-tailored resume for a job family (e.g. PyDev, MLOps), kept in the user's Data Repo. Belongs to the user, not to this repo. Whether Role Templates take part in the application workflow at all is decided by the map "Workflow model".
_Avoid_: template on its own.
