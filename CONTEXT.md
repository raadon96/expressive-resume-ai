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
