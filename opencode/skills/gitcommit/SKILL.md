---
name: gitcommit
description: Create well-structured git commits following conventional commits standards
---

# Git Commit Skill

This skill guides you through creating well-structured git commits following conventional commits standards.

## When to Use

Use this skill when:
- You need to commit ALREADY STAGED changes to a git repository
- You want to create meaningful commit messages for staged changes
- You want to prevent bad commits

**IMPORTANT RULES:**
- This skill only commits files already staged with `git add`. It will NOT stage any files for you.
- **NEVER PUSH CHANGES - This skill is for creating commits only.**
- **DO NOT RESOLVE MERGE CONFLICTS** - If conflicts exist, STOP and inform the user.

## Pre-Commit Safety Checks

### 1. Check Repository Status

Always start by checking the repository state:

```bash
# Check current status
git status

# Check for merge conflicts
git diff --check
git diff --name-only --diff-filter=U
```

**STOP if you see merge conflicts!** Do NOT attempt to resolve them. Inform the user that conflicts exist and they must resolve them manually.

### 2. Verify No Merge Conflicts

If you see files marked as "Unmerged" or "both modified":

```bash
# List conflicted files
git diff --name-only --diff-filter=U
```

**STOP immediately and inform the user:**
"There are merge conflicts that need to be resolved. Please resolve them manually before committing. I cannot resolve merge conflicts or create a commit while conflicts exist."

**DO NOT provide conflict resolution steps. DO NOT commit while conflicts exist.**

## Commit Workflow

**IMPORTANT: This workflow only commits ALREADY STAGED changes. Do NOT add any files using `git add`. NEVER PUSH CHANGES.**

### Step 1: Check Repository Status

```bash
# See what files are staged for commit
git status

# See changes already staged
git diff --cached
```

**STOP conditions:**
- If there are no staged changes: Ask the user to stage files first.
- If there are merge conflicts: Inform the user and stop.

### Step 2: Verify Staged Changes

```bash
# Review what will be committed
git diff --cached
```

Check for:
- [ ] Files are already staged (not just modified)
- [ ] No console.log or debug statements
- [ ] No secrets, passwords, or API keys
- [ ] No merge conflict markers
- [ ] Only intended files are staged

**DO NOT run `git add` or modify staging. Only commit what's already staged.**

### Step 3: Create Conventional Commit

Format: `<type>(<scope>): <description>`

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style (formatting, semicolons, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Build process, dependencies, etc.
- `ci`: CI/CD changes
- `revert`: Reverting a previous commit

**Examples:**
```
feat(auth): add OAuth2 login with Google
fix(api): resolve null pointer in user controller
docs(readme): update installation instructions
refactor(utils): extract validation logic to separate module
style(components): fix indentation in Button.tsx
test(api): add unit tests for user service
chore(deps): update lodash to v4.17.21
perf(queries): optimize database query with index
```

**Breaking Changes:**
Add `BREAKING CHANGE:` in the footer:
```
feat(api): change response format for consistency

BREAKING CHANGE: response now returns object instead of array
```

**Referencing Issues:**
```
fix(auth): resolve login timeout issue

Fixes #123
Closes #456
```

**Execute the Commit:**

After crafting the message, commit the staged changes:

```bash
# Commit staged changes with the message
git commit -m "feat(auth): add OAuth2 login with Google"

# For multi-line messages, use:
git commit -m "feat(api): change response format" -m "BREAKING CHANGE: response now returns object"
```

**IMPORTANT:**
- Only staged changes are committed
- This command does NOT add new files
- **NEVER run `git push` - this skill is for creating commits only**

### Step 4: Verify Commit

```bash
# Show last commit details
git log -1 --stat

# Show commit with patch
git log -1 -p
```

## Best Practices

1. **NEVER PUSH**: This skill creates commits only, never pushes them
2. **Only Staged Changes**: Never add files automatically - only commit what's already staged
3. **No Conflict Resolution**: Do not attempt to resolve merge conflicts - inform the user instead
4. **Commit Size**: Make small, focused commits (one logical change per commit)
5. **Commit Messages**: Explain WHY, not just WHAT
6. **Separate Concerns**: Don't mix refactoring with feature additions
7. **Review**: Double-check staged files match your intention

## Handling Special Cases

### Amending Commits

**IMPORTANT: Before amending, you MUST ask the user:**

> "Would you like to amend the last commit (modify it), or would you prefer to create a new commit?"

**Options:**
1. **Amend last commit** (modifies existing commit)
   ```bash
   # Fix last commit message
   git commit --amend -m "new message"

   # Or amend with additional staged changes
   git commit --amend --no-edit
   ```

   **⚠️ Warning**: Never amend commits that have been pushed to a remote!

2. **Create new commit** (keeps history intact)
   ```bash
   git commit -m "new message"
   ```

**ALWAYS ask the user which option they prefer. Do NOT assume they want to amend.**

## Safety Checklist

**CRITICAL: This skill ONLY creates commit messages and commits ALREADY STAGED changes. It NEVER adds files and NEVER pushes.**

Before every commit:
- [ ] Changes are already staged (run `git status` to verify)
- [ ] No merge conflicts exist
- [ ] DO NOT use `git add` commands - user must stage files themselves
- [ ] DO NOT resolve merge conflicts - inform user instead
- [ ] No secrets/credentials in code
- [ ] No debug statements (console.log, debugger, etc.)
- [ ] Commit message follows conventional format
- [ ] Only intended files are staged
- [ ] **NEVER push changes**

## Emergency Procedures

### Undo Last Commit (keep changes)
```bash
git reset --soft HEAD~1
```

### Undo Last Commit (discard changes)
```bash
git reset --hard HEAD~1
```

### Stash Changes (emergency save)
```bash
git stash push -m "WIP: description"
```

## Questions to Ask Before Committing

1. Are these changes already staged?
2. Are there any merge conflicts?
3. Does this commit solve a specific problem?
4. Would this change make sense to someone in 6 months?
5. Is the commit message clear and descriptive?
