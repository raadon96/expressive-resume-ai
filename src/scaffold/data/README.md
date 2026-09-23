# My resume data

This folder is your **Data Repo**: your profile and applications for [expressive-resume-ai](https://github.com/raadon96/expressive-resume-ai). It's a separate git repo inside the tool folder, and the tool's `.gitignore` keeps it out of the tool's own history.

```
data/
├── index.md          # Application Index: one row per application, newest first
├── profile/          # your profile, which Claude reads when tailoring documents
└── applications/     # one folder per application, created by /review-job
```

`./setup.sh` ran `git init` here but made no commit. Everything starts untracked, so you can see what you still have to replace.

## 1. Replace the example profile

`profile/` is a copy of the tool's fictional example. Replace all of it with your own data before you create any applications:

| File | What to put in it |
|------|-------------------|
| `profile/contact.md` | Your name, email, phone, LinkedIn handle, GitHub handle, city, country |
| `profile/experience.md` | Your work history in LinkedIn Experience section format |
| `profile/projects/*.md` | One file per project Claude can reference. **Delete the example projects**, or their fictional content can end up in your real resumes |
| `profile/certificates.md` | Your degrees and certifications |
| `profile/images/qr_code.png` | Your LinkedIn QR code (or a QR code for any URL you want on the resume) |

Then make your first commit:

```bash
cd data
git add .
git commit -m "Add my profile"
```

## 2. Back it up to a private remote (optional, recommended)

With the [GitHub CLI](https://cli.github.com/), from the tool folder:

```bash
gh repo create <name> --private --source=data --push
```

Or create an empty **private** repository in the GitHub UI, then:

```bash
cd data
git remote add origin git@github.com:<you>/<name>.git
git push -u origin HEAD
```

Don't use a fork of the tool for this. A fork of a public repo is always public.

## 3. Restore on another machine

1. Fork or clone the tool (or clone your existing fork).
2. Clone this repo into `data/` **before** running setup:
   ```bash
   git clone <your-data-repo> data
   ```
3. Run `./setup.sh`. It sees the existing `data/` and leaves it alone.

If you run `./setup.sh` first, it creates a seeded `data/` and the clone fails. Delete that `data/` and clone again.

> [!WARNING]
> `git clean -ffdx` (double `f`) in the tool folder **deletes `data/`**, including its git history. Keep this repo pushed to a remote so you can recover it.
