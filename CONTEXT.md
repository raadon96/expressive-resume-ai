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

**Private Fork**:
A fork of the Public Template Repo that a user makes private and populates with their own Profile and Applications, as the durable remote store for their personal job search.
_Avoid_: personal repo, the fork (on its own, ambiguous which one), sibling repo — the pre-existing `../expressive-resume` repo used as a research source is a separate, unrelated repo predating this project, not an instance of a Private Fork.

**Personal Path**:
A directory whose contents belong to one user's own job search — `profile/`, `applications/`, `templates/`. Empty (a `.gitkeep` only) in the Public Template Repo; populated only in a Private Fork, and never flowing back through sync.
_Avoid_: private files, user data, personal folder.

**Shared Path**:
Any path that is not a Personal Path. Belongs to the Public Template Repo and flows in both directions between it and every Private Fork.
_Avoid_: source, code, the rest.

**Examples**:
The fictional Profile and Application shipped under `examples/` to show the expected shape of Personal Path contents; the only personal-*shaped* content the Public Template Repo carries.
_Avoid_: sample data, demo, placeholder (that is the Scaffold).

**Scaffold**:
The structural `resume.tex` and `coverletter.tex` that `/create-application` starts every generated document from. Shared, lives alongside the class files in `src/`.
_Avoid_: template (ambiguous), placeholder on its own.

**Role Template**:
A user's own pre-tailored resume for a job family (e.g. PyDev, MLOps), kept under `templates/` in a Private Fork. Personal. Whether Role Templates take part in the application workflow at all is decided by the companion map "Workflow model".
_Avoid_: template on its own.
