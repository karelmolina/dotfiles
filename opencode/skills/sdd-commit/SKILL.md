---
name: sdd-commit
description: >
  Create conventional commits for staged git changes with automatic message generation.
  Trigger: When the user wants to commit staged changes, says "commit", or uses the commit command.
license: MIT
metadata:
  author: karel Molina
  version: "1.0"
---

## Purpose

You are a sub-agent responsible for creating conventional commits from staged git changes. You analyze staged files, generate appropriate commit messages following conventional commit standards, and execute commits with user confirmation.

## What You Receive

From the orchestrator:
- `command_args`: Array of `[type, scope, description]` (all optional)
  - `type`: Commit type (feat, fix, docs, style, refactor, perf, test, chore, ci, revert)
  - `scope`: Scope of the change (use "-" to skip, empty for auto-detect)
  - `description`: Short description of the change (optional)
- `flags`: Object with optional flags
  - `breaking`: Boolean indicating if this is a breaking change

From git state:
- Staged files via `git diff --cached`
- Current repository state and branch

## Execution and Persistence Contract

From the orchestrator:
- Artifact store mode (`engram | openspec | none`)

Read and follow `skills/_shared/persistence-contract.md` for mode resolution rules.

- If mode is `engram`: Read and follow `skills/_shared/engram-convention.md`. Artifact type: `archive-report`. Retrieve `verify-report`, `proposal`, `spec`, `design`, and `tasks` as dependencies. Include all artifact observation IDs in the archive report for full traceability.
- If mode is `openspec`: Read and follow `skills/_shared/openspec-convention.md`. Perform merge and archive folder moves.
- If mode is `none`: Return closure summary only. Do not perform archive file operations.

## What to Do

### Step 1: Verify Staged Changes

Check for staged changes using:
```
git diff --cached --stat
git status --short
```

**If no staged changes:**
- Inform user: "No staged changes found. Please stage your changes first with 'git add'."
- Exit without committing

**If staged changes exist:**
- Record the list of files to be committed
- Proceed to Step 2

### Step 2: Analyze Changes

Review the staged diff to understand what changed:
```
git diff --cached
```

Analyze:
- **File extensions** - .py, .js, .md, etc.
- **Directories** - src/auth/, tests/, docs/, etc.
- **Change types** - new files, modifications, deletions
- **Diff keywords** - "fix", "add", "refactor", "test", "docs"

### Step 3: Determine Commit Type

Based on analysis, select from conventional commit types.

**Commit Type Definitions (FR-001, FR-002):**

| Type | Description | When to Use | Indicators |
|------|-------------|-------------|------------|
| **feat** | New feature | Adding new functionality, capabilities, or user-facing changes | New files in src/, new API endpoints, new UI components, new modules |
| **fix** | Bug fix | Correcting errors or unexpected behavior | Error messages in diff, "fix", "resolve", "bug" keywords, test files with "fix" |
| **docs** | Documentation | Documentation changes only (no code changes) | README.md, CHANGELOG.md, .md files, comments, API docs |
| **style** | Code style | Code style changes (no functional changes) | Whitespace, semicolons, quotes, formatting, indentation |
| **refactor** | Refactoring | Code restructuring without changing behavior | Renaming variables, extracting functions, reorganizing code |
| **perf** | Performance | Performance improvements | Optimizations, caching, reducing complexity, "perf", "optimize" keywords |
| **test** | Tests | Adding or updating tests | *.test.js, *.spec.py, test directories, test utilities |
| **chore** | Chores | Build process, dependencies, tooling | package.json, Makefile, .gitignore, dependency updates, tooling config |
| **ci** | Continuous Integration | CI/CD configuration changes | .github/workflows/, .gitlab-ci.yml, Jenkinsfile, CI configs |
| **revert** | Revert | Reverting previous commits | Revert commits, rollback changes, "revert" keyword |

**Message Generation Algorithm (FR-002):**

```
IF command_args provided:
  - type = command_args[0] OR infer from changes
  - scope = command_args[1] (if "-", omit; if empty, auto-detect)
  - description = command_args[2] OR generate from diff
ELSE:
  Analyze staged changes:
  1. File Analysis:
     - Check file extensions (.py → Python, .js → JavaScript)
     - Check directories (src/auth/ → auth module, tests/ → testing)
     - Check change types (A = added, M = modified, D = deleted, R = renamed)

  2. Diff Analysis:
     - Keywords: "fix", "bug", "resolve" → fix
     - Keywords: "test", "spec" → test
     - Keywords: "doc", "readme", "comment" → docs
     - Keywords: "refactor", "extract", "rename" → refactor
     - Keywords: "perf", "optimize", "cache" → perf
     - New files in src/ with functionality → feat

  3. Determine Type:
     - Priority: explicit type > keyword match > file pattern > default (feat)

  4. Determine Scope:
     - Extract from most common directory name
     - Check for component/module patterns (auth/, api/, ui/)
     - Use filename patterns (*.test.js → test)
     - If scope="-" or empty, omit entirely

  5. Generate Description:
     - Analyze diff content for action verbs
     - Use imperative mood ("add", "fix", "update", "remove")
     - Keep under 72 characters
     - Include file count if > 1 file (e.g., "update 3 config files")
     - Be specific: "add user validation" not "add code"
```

### Step 4: Determine Scope (Optional)

Extract scope from:
- Directory structure (e.g., `src/auth/` → `auth`)
- File patterns (e.g., `*.test.js` → `test`)
- Module/component names in file paths
- If scope is "-" or empty, omit it

### Step 5: Generate Description

Create a concise description (under 72 characters):
- Use imperative mood: "add", "fix", "update", "remove"
- Be specific about what changed
- For multiple files: include file count (e.g., "update 3 config files")
- Base on the actual diff content

### Step 6: Format Commit Message

**Argument Parsing Logic (FR-003, SC-003, SC-004, SC-005, SC-006):**

```
Arguments: [type] [scope] [description] [--breaking]

Case 1 - No arguments:
  commit
  → Auto-detect type, scope, and description from changes
  → Example: "feat: add user authentication"

Case 2 - Type only:
  commit feat
  → Use provided type, auto-detect scope and description
  → Example: "feat: implement login form"

Case 3 - Type + scope:
  commit feat auth
  → Use provided type and scope, auto-detect description
  → Example: "feat(auth): add OAuth2 support"

Case 4 - Type + scope + description:
  commit feat auth "add OAuth2 support"
  → Use all provided arguments
  → Example: "feat(auth): add OAuth2 support"

Special scope handling:
  commit fix - "resolve issue"
  → Scope "-" means omit scope
  → Example: "fix: resolve issue"
```

**Message Formats:**

**With scope:**
```
<type>(<scope>): <description>
```

**Without scope:**
```
<type>: <description>
```

**Breaking Change Handling (FR-004, SC-008):**

Breaking changes are indicated with `!` before the colon.

```
# With scope and breaking flag
<type>(<scope>)!: <description>

# Without scope but with breaking flag
<type>!: <description>
```

**Breaking Change Formatting:**
- **Flag detection**: Check for `breaking: true` in flags object
- **Format**: Insert `!` between scope (if any) and colon
- **With scope**: `feat(api)!: change response format`
- **Without scope**: `feat!: change response format`
- **In body**: If breaking, add `BREAKING CHANGE:` section after description

**Algorithm:**
```
IF flags.breaking == true:
  IF scope provided AND scope != "-":
    format = "<type>(<scope>)!: <description>"
  ELSE:
    format = "<type>!: <description>"
ELSE:
  IF scope provided AND scope != "-":
    format = "<type>(<scope>): <description>"
  ELSE:
    format = "<type>: <description>"
```

### Step 7: Display and Confirm (FR-005, SC-007, SC-009)

**Display Format:**
```
Files to be committed:
  M  src/auth/login.js
  A  src/auth/oauth.js
  M  tests/auth.test.js

Generated commit message:
  feat(auth): add OAuth2 login support

Proceed with commit? (yes/no/edit)
```

**User Confirmation Flow:**

The user can respond with:

| Input | Action | Result |
|-------|--------|--------|
| `yes` or `y` | Execute commit | Run `git commit -m "<message>"` |
| `no` or `n` | Abort commit | Exit with "Commit aborted by user" |
| `edit` or `e` | Edit message | Prompt for new message, then commit |

**If user says "yes":**
1. Execute: `git commit -m "<message>"`
2. On success: Show commit hash
   ```
   Committed successfully: abc1234
   ```
3. On failure: Show git error and abort

**If user says "edit":**
1. Prompt: "Enter new commit message:"
2. Accept user input
3. Execute: `git commit -m "<new-message>"`
4. Show result (success or error)

**If user says "no":**
1. Inform: "Commit aborted by user"
2. Exit without committing
3. Do not modify repository state

### Step 8: Optional Body and Footer (FR-006, SC-010)

After initial commit message confirmation, prompt for additional details:

**Body Prompt:**
```
Add body to commit message? (optional, press Enter to skip)
>
```

**Footer Prompt:**
```
Add footer references? (e.g., Fixes #123, Closes #456, Refs #789)
>
```

**Extended Message Format:**

When body and/or footer are provided, use multi-line commit format:

```bash
git commit -m "<type>(<scope>): <description>

<body>

<footer>"
```

**Example with body and footer:**
```bash
git commit -m "feat(auth): add OAuth2 login support

This implementation adds OAuth2 support for Google and GitHub providers.
The authentication flow uses PKCE for enhanced security.

Closes #123
Co-authored-by: Jane Doe <jane@example.com>"
```

**Body Content Guidelines:**
- Explain **what** changed and **why** (not how)
- Use multiple paragraphs for complex changes
- Keep lines under 72 characters
- Can include bullet points for lists

**Footer Content Guidelines:**
- Reference issues: `Fixes #123`, `Closes #456`, `Refs #789`
- Breaking change notice: `BREAKING CHANGE: description`
- Co-authors: `Co-authored-by: Name <email>`
- Multiple footers separated by newlines

## Scenarios (FR-001 through FR-008)

### SC-001: No staged changes (Error Case)
**Given:** No files are staged
**When:** User runs `commit`
**Then:** Display "No staged changes found. Please stage your changes first with 'git add'." and exit

### SC-002: Full auto-generation - no arguments
**Given:** Staged changes exist, no arguments provided
**When:** User runs `commit`
**Then:** Analyze changes, generate type, scope, and description automatically
**Example:** `"feat(auth): add OAuth2 login support"`

### SC-003: Partial - type only provided
**Given:** Staged changes exist, user provides type only
**When:** User runs `commit feat`
**Then:** Use provided type, auto-generate scope and description
**Example:** `"feat: implement login form"`

### SC-004: Partial - type and scope provided
**Given:** Staged changes exist, user provides type and scope
**When:** User runs `commit feat auth`
**Then:** Use provided type and scope, auto-generate description
**Example:** `"feat(auth): add OAuth2 support"`

### SC-005: Full arguments - all provided
**Given:** Staged changes exist, all arguments provided
**When:** User runs `commit feat auth "add OAuth2 login support"`
**Then:** Use all provided arguments exactly as given
**Example:** `"feat(auth): add OAuth2 login support"`

### SC-006: Explicit no-scope with dash
**Given:** User wants no scope despite detection
**When:** User runs `commit fix - "resolve issue"`
**Then:** Omit scope, format as `"fix: resolve issue"`

### SC-007: User edits message before commit
**Given:** Generated message shown to user
**When:** User responds "edit" and provides new message
**Then:** Use edited message for commit

### SC-008: Breaking change flag
**Given:** User indicates breaking change
**When:** User runs `commit feat api "change response format" --breaking`
**Then:** Format with `!`: `"feat(api)!: change response format"`

### SC-009: User cancels commit
**Given:** Generated message shown to user
**When:** User responds "no"
**Then:** Abort commit, inform user, no changes made

### SC-010: Extended message with body and footer
**Given:** User confirms initial message
**When:** User provides body and footer text
**Then:** Create multi-line commit with body and footer sections

### SC-011: Multiple file types detection
**Given:** Staged changes include multiple file types (src/, tests/, docs/)
**When:** Auto-generating commit message
**Then:** Analyze all files, determine primary change type, include file count
**Example:** `"feat(auth): add OAuth2 support with tests and docs"`

## Examples

### Full arguments provided (SC-005)
```
commit feat auth "add OAuth2 login support"
# Executes: git commit -m "feat(auth): add OAuth2 login support"
```

### No scope (SC-006)
```
commit fix - "resolve button alignment issue"
# Executes: git commit -m "fix: resolve button alignment issue"
```

### Breaking change (SC-008)
```
commit feat api "change response format" --breaking
# Executes: git commit -m "feat(api)!: change response format"
```

### No arguments - analyze and generate (SC-002)
```
commit
# Analyzes staged files and generates appropriate message
# Example output: "feat: add user authentication module"
```

### Partial arguments (SC-003, SC-004)
```
commit feat
# Generates: "feat: <generated description based on changes>"

commit feat auth
# Generates: "feat(auth): <generated description based on changes>"
```

### User edits message (SC-007)
```
commit
# Generated: "feat: add login"
# User says: "edit"
# User enters: "feat(auth): implement secure login with validation"
# Executes: git commit -m "feat(auth): implement secure login with validation"
```

### Extended commit with body and footer (SC-010)
```
commit feat api "add rate limiting"
# User confirms: yes
# Add body? "Implement rate limiting using token bucket algorithm
# with configurable limits per endpoint."
# Add footer? "Closes #456"
# Executes: git commit with multi-line message
```

## Rules

### Core Principles (FR-001, FR-005)
- **ALWAYS** check for staged changes first - never assume files are staged
- **NEVER** stage files automatically - this command only commits what's already staged
- Show the diff so users know exactly what will be committed
- Ask for user confirmation before executing the commit

### Message Generation Rules (FR-002)
- Use provided arguments when given, generate missing parts based on diff analysis
- Keep descriptions under 72 characters
- Use imperative mood in descriptions ("add", not "added" or "adding")
- Include file count if multiple files affected (e.g., "update 3 config files")
- Base description on actual diff content, not just filenames

### Formatting Rules (FR-003, FR-004)
- Follow conventional commit format: `<type>(<scope>): <description>`
- Omit scope entirely if not provided or if scope is "-"
- Add `!` before colon for breaking changes: `<type>!: <description>`
- Use lowercase for type and scope

### User Interaction Rules (FR-005, FR-006)
- Display files to be committed before asking for confirmation
- Accept "yes", "y", "no", "n", "edit", "e" as valid responses
- Allow users to edit the generated message before committing
- Support optional body and footer for extended commits

### Safety Rules (FR-007, FR-008)
- Validate commit type against allowed list
- Handle git errors gracefully with informative messages
- Never execute commit without explicit user confirmation
- Return structured envelope with implementation status

## Error Handling (FR-007, FR-008, SC-001)

| Error Scenario | Response | Action |
|----------------|----------|--------|
| **No staged changes** (SC-001) | "No staged changes found. Please stage your changes first with 'git add'." | Exit without committing |
| **Git commit fails** | Show git error message: "Error: <git-error>" | Abort, do not retry |
| **User cancels** (SC-009) | "Commit aborted by user" | Exit without changes |
| **Invalid commit type** | "Invalid type '<type>'. Valid types: feat, fix, docs, style, refactor, perf, test, chore, ci, revert" | Suggest valid types or default to "feat" |
| **Empty description** | "Description cannot be empty. Please provide a description or allow auto-generation." | Re-prompt or use default |
| **Git not initialized** | "Not a git repository. Please initialize with 'git init'." | Exit |
| **Permission denied** | "Permission denied. Check file permissions and try again." | Exit |

**Validation Rules:**
- Type must be one of: feat, fix, docs, style, refactor, perf, test, chore, ci, revert
- Description must be non-empty and under 72 characters
- Scope is optional but if provided, should be lowercase alphanumeric with hyphens
- Breaking flag must be boolean true/false
