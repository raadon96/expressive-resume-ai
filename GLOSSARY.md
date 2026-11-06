# Expressive Resume AI

An AI-assisted LaTeX resume and cover-letter generator, driven by Claude Code skills, meant to be cloned/forked and used for a real job search.

## Language

**Application**:
A single job application's working directory in the user's Data Repo, `applications/YY.MM.DD_<role>@<company>/`, holding that application's job posting, fit analysis, generated resume, cover letter, and notes.
_Avoid_: "the application" for the software/repo itself — always say "this repo" or "expressive-resume-ai" instead; job, posting, submission.

**Job Posting**:
The employer's advertisement for one role, as the user received it; the starting point of an Application.
_Avoid_: job description, JD, job ad.

**Fit Analysis**:
The assessment of a Job Posting against the Profile, kept in its Application: strengths, gaps, how to frame the application, and a verdict on whether to apply.
_Avoid_: job review, match report.

**Profile**:
The user's canonical personal/career source data (`profile/`), kept once and drawn on by every Application. Not itself an Application, and not a generated document.
_Avoid_: resume data, master resume.

**Project**:
A distinct piece of work the user can describe on its own, whether from an employer, a thesis or on the side. It may or may not appear in their work history.
_Avoid_: case study, portfolio item.

**Project Description**:
The Profile's account of one Project: what it is, what the user did, and the skills and technologies involved. Resumes and cover letters draw on it.
_Avoid_: project notes, project summary, description (on its own).

**Application Index**:
The list of a user's Applications in their Data Repo, one row per Application (date, company, role, link to its directory), newest first. Records that an Application's resume and cover letter were created, not whether they were sent or how it is going. An Application that stopped after its fit analysis has no row.
_Avoid_: tracker, applications list, status board.

**Tool Repo**:
expressive-resume-ai, the public, generic code (document classes, Scaffold, skills, scripts), kept free of personal data. Also any user's fork or clone of it; say "upstream Tool Repo" when the original specifically is meant.
_Avoid_: Public Template Repo, the template, the base repo, upstream (on its own).

**Data Repo**:
A user's own private repo holding their Profile and Applications, kept inside their Tool Repo folder but never part of it.
_Avoid_: personal repo, private copy, fork (a fork is a Tool Repo).

**Scaffold**:
The files in the Tool Repo copied to start something new: the `resume.tex` and `coverletter.tex` every Application starts from, and the starting files of a new user's Data Repo. Lives in `src/scaffold/`.
_Avoid_: template (ambiguous), skeleton.

**Source Language**:
The language of the Profile's `experience.md`. An Application's resume and cover letter are written in it first.
_Avoid_: base language, native language.

**Target Language**:
The Job Posting's language. When it differs from the Source Language, the resume and cover letter are translated into it, and both versions are kept.
_Avoid_: output language.
