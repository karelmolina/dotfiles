# commit

Create a conventional commit for **already staged** changes only.

## Important

This command **does NOT stage files automatically**. It only commits changes that are already staged.

## Usage

```
commit [type] [scope] [description]
```

## Arguments

- `type` - Commit type (optional: feat, fix, docs, style, refactor, perf, test, chore, ci, revert)
- `scope` - Scope of the change (optional, use "-" to skip)
- `description` - Short description of the change (optional)

## Commit Types

| Type | Description |
|------|-------------|
| feat | New feature |
| fix | Bug fix |
| docs | Documentation only changes |
| style | Code style changes (formatting, semicolons, etc.) |
| refactor | Code refactoring without changing functionality |
| perf | Performance improvements |
| test | Adding or updating tests |
| chore | Build process, dependencies, etc. |
| ci | CI/CD changes |
| revert | Reverting a previous commit |

## Workflow

1. **Check what's staged** - I will show you the staged changes for review
2. **Review the diff** - You can see exactly what will be committed
3. **Confirm the commit** - I'll execute the commit with the conventional message

## Implementation

When the user runs this command:

1. Check for staged changes using `git diff --cached`
2. If no staged changes: inform user and exit
3. If staged changes exist:
   - Show the files that will be committed using `git status --staged`
   - Show the diff using `git diff --cached`
   - Parse arguments:
     - If type, scope, and description are provided:
       - Format: `<type>(<scope>): <description>` (scope is optional if "-")
       - Support --breaking flag: `<type>(<scope>)!: <description>`
     - If arguments are NOT provided or incomplete:
       - Analyze the staged changes (files modified, diff content)
       - Determine appropriate commit type based on changes
       - Infer scope from file paths or directory structure
       - Generate a descriptive commit message
       - Present the generated message to user for confirmation or editing
   - Display the commit message
   - Ask user to confirm: "Proceed with commit? (yes/no/edit)"
   - If yes: execute `git commit -m "<message>"`
   - If edit: prompt user to provide/edit the message, then commit
   - If no: abort and inform user

## Examples

```
# With all arguments - creates commit directly
/commit feat auth "add OAuth2 login support"
# Result: git commit -m "feat(auth): add OAuth2 login support"

# Without scope
/commit fix - "resolve button alignment issue"
# Result: git commit -m "fix: resolve button alignment issue"

# With breaking change
/commit feat api "change response format" --breaking
# Result: git commit -m "feat(api)!: change response format"

# No arguments - analyze changes and generate message
/commit
# Analyzes staged files and generates appropriate message
# Example: "feat: add user authentication module"

# Partial arguments - use what provided, generate rest
/commit feat
# Generates: "feat: <generated description based on changes>"

/commit feat auth
# Generates: "feat(auth): <generated description based on changes>"
```

## Message Generation Rules

When generating commit messages automatically:

1. **Analyze file changes**:
   - Look at file extensions and directories
   - Check for new files vs modifications vs deletions
   - Review diff content for keywords

2. **Determine type**:
   - New files → `feat` or `docs`
   - Bug fixes → `fix`
   - Formatting only → `style`
   - Tests → `test`
   - CI/config → `chore` or `ci`
   - Refactoring → `refactor`

3. **Determine scope**:
   - Extract from directory structure (e.g., `src/auth/` → `auth`)
   - Use filename patterns (e.g., `*.test.js` → `test`)
   - Look for module/component names

4. **Generate description**:
   - Use imperative mood ("add", "fix", "update")
   - Keep under 72 characters
   - Be specific about what changed
   - Include file count if multiple files (e.g., "update 3 config files")

## Pre-Commit Checks

The command will:
1. Check `git status --staged` for staged changes
2. If none found: "No staged changes found. Please stage your changes first with 'git add'."
3. If staged changes exist: Show diff and ask for confirmation before executing

## Breaking Changes

To indicate a breaking change when providing arguments:
```
commit feat api "change response format" --breaking
```

Formats as: `<type>(<scope>)!: <description>`

## Body and Footer

For commits requiring additional context, after initial confirmation ask:
- "Add body to commit message? (optional, press Enter to skip)"
- "Add footer references? (e.g., Fixes #123)"

## Related Commands

- `git status --staged` - Check staged changes
- `git diff --cached` - Review what will be committed
- `git log -1` - Verify last commit

## Error Handling

- If no staged changes: Show error and suggest running `git add`
- If commit fails: Show git error message
- If user cancels: Show "Commit aborted by user"
