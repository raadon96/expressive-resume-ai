# My resume data

This folder is your **Data Repo**: your profile and applications for [expressive-resume-ai](../README.md). It's a separate git repo inside the tool folder, and the tool's `.gitignore` keeps it out of the tool's own history.

```
data/
├── index.md          # Application Index: one row per application, newest first
├── profile/          # your profile, which Claude reads when tailoring documents
├── templates/        # optional Role Templates: your reviewed resume per job family
└── applications/     # one folder per application, created by /review-job
```

`./setup.sh` ran `git init` here but made no commit. Everything starts untracked, so you can see what you still have to replace.

The tool's [README](../README.md) covers what to do next: replace the example profile (Setup, step 4), back this repo up (step 5), and use it on another machine (Setup on another machine).

> [!WARNING]
> `git clean -ffdx` in the tool folder **deletes `data/`**, including its git history. Keep this repo pushed to a remote so you can recover it.
