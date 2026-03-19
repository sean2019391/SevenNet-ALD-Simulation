# How to Publish This Repository to GitHub

## Recommended Repository Names

- `UNIST-ALD-Research-Internship-Notebook`
- `UNIST-Semiconductor-Process-Research-Notebook`
- `UNIST-ALD-MLFF-Simulation-Notebook`

---

## Step 1: Review Before Publishing

Read these files to make sure everything looks good:
1. `README.md`
2. `RESEARCH_NOTEBOOK.md`
3. `FILE_INDEX.md`

---

## Step 2: Check for Sensitive Information

Make sure the repository does **not** contain:
- Passwords or tokens
- Private server credentials
- Confidential or unpublished data

> **Note:** Some manual files include internal IP addresses and file paths. Review them before making the repository public.

---

## Step 3: Create a GitHub Repository

1. Go to GitHub and click **New repository**
2. Enter the repository name
3. Set visibility to **Public** (for portfolio use)
4. Do **not** initialize with a README (you'll push this folder directly)

---

## Step 4: Initialize Git and Push

```bash
cd ~/Desktop/UNIST_Lab_Note_EN
git init
git add .
git commit -m "Initial commit: UNIST semiconductor process research internship notebook"
```

---

## Step 5: Connect to GitHub and Push

Replace the URL with your own:
```bash
git remote add origin https://github.com/<your-username>/<repo-name>.git
git branch -M main
git push -u origin main
```

---

## Step 6: Verify the Landing Page

After pushing, make sure `README.md` displays correctly as the repository's landing page.

---

## Step 7: Share the Repository

When sharing the link, describe it as:

> A structured research notebook from my UNIST semiconductor process internship, covering LAMMPS, SevenNet, OVITO-based simulation analysis, ML force fields, and ALD-relevant atomistic workflows.

---

## Optional: Clean Up Before Publishing

Remove system files that are not research assets:
```bash
find . -name ".DS_Store" -delete
```
