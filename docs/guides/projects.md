# Project Descriptions

A Project is a distinct piece of work you can describe on its own, from an employer, a thesis or on the side. It may or may not appear in your work history. Each one gets a Project Description: one file in `data/profile/projects/`.

Claude reads these files whenever it reviews a job posting or writes a resume, and **anything in them outside a comment can reach a resume** (see [Hide text from Claude](#hide-text-from-claude)). Keep them short and factual, and only write claims you'd defend. Aim for about 60 lines per project, in plain sentences that follow [the copyedit rules](../../.claude/skills/copyedit/rules.md).

When Claude writes a resume, it decides from these files which projects to add or remove for each job posting. You don't tag projects as relevant for anything: it judges that from the content.

## Template

Copy this into `data/profile/projects/<project>.md`. `Links:` is optional; everything else here is required.

```markdown
# <Project name>
Context: <employer / thesis / side project> · <dates> · <role if relevant>
Links: <repo, demo or paper>

## Summary
<What it is, in 2–3 sentences.>

## What I Did
- <Your own work, not the team's.>

## Skills & Technologies
- Concepts: <e.g. object detection, idempotent pipelines>
- Tools: <e.g. YOLO, Airflow>
```

[`example/profile/projects/`](../../example/profile/projects/) has two fictional projects in this format.

## Optional sections

Add these where they have something to say, or use headings of your own:

- `Why I Built It`
- `Problem & Stakeholders`
- `How It Works`
- `Key Decisions`
- `Results`
- `Current Status`
- `Resume Framing`

## Writing them well

- **List both concepts and tools** under `Skills & Technologies`. Job postings use both ("object detection" and "YOLO").
- **Keep a metric's caveat next to the number**, e.g. "17% faster, measured in simulation only". A caveat further down the file can get left behind when the number goes into a resume.
- **Leave out what a resume doesn't need**, such as long diagrams and notes for yourself. Claude reads every line outside a comment on every run, so length costs money and time.

## Hide text from Claude

To keep part of a Profile file out of your applications, such as a `## Results` section or one tool in a list, wrap it in an HTML comment, on one line or across several:

```markdown
- Tools: YOLO, Airflow<!-- , Kafka -->

<!--
## Results
- 17% faster, measured in simulation only
-->
```

A script removes the comments before Claude reads the file for a Fit Analysis, resume or cover letter, so hidden text is treated as absent. Your files stay unchanged. Always close a comment with `-->`: an unclosed `<!--` isn't handled.

This also hides any caveat or skill inside the comment, so make sure the visible text stays true on its own. If you hide "measured in simulation only" and leave "17% faster", the number can reach a resume without its caveat.

`/copyedit` and `/translate` do see the comments of a Profile file you run them on, and keep them unchanged, untranslated.

## How they relate to the rest of your profile

`experience.md` decides titles, dates and employers. The Project Description decides what can be claimed for that project.

Write each Project Description once, in your profile's language. Claude translates what it uses.
