# Engram Artifact Convention (reference documentation)

> **NOTE**: Critical engram calls (`mem_search`, `mem_save`, `mem_get_observation`) are now inlined directly in each skill's SKILL.md file. This document is supplementary reference — sub-agents do NOT need to read it to function correctly.

## Naming Rules

ALL SDD artifacts persisted to Engram MUST follow this deterministic naming:

```
title:     sdd/{change-name}/{artifact-type}
topic_key: sdd/{change-name}/{artifact-type}
type:      architecture
project:   {detected or current project name}
scope:     project
```

### Artifact Types (exact strings)

| Artifact Type | Produced By | Description |
|---------------|-------------|-------------|
| `explore` | sdd-explore | Exploration analysis |
| `proposal` | sdd-propose | Change proposal |
| `spec` | sdd-spec | Delta specifications (all domains concatenated) |
| `design` | sdd-design | Technical design |
| `tasks` | sdd-tasks | Task breakdown |
| `apply-progress` | sdd-apply | Implementation progress (one per batch) |
| `verify-report` | sdd-verify | Verification report |
| `archive-report` | sdd-archive | Archive closure with lineage |
| `state` | orchestrator | DAG state for recovery after compaction |

**Exception**: `sdd-init` uses `sdd-init/{project-name}` as both title and topic_key (it's project-scoped, not change-scoped).

### State Artifact

The orchestrator persists DAG state after each phase transition to enable recovery after context compaction:

```
mem_save(
  title: "sdd/{change-name}/state",
  topic_key: "sdd/{change-name}/state",
  type: "architecture",
  project: "{project}",
  content: "change: {change-name}\nphase: {last-phase}\nartifact_store: engram\nartifacts:\n  proposal: true\n  specs: true\n  design: false\n  tasks: false\ntasks_progress:\n  completed: []\n  pending: []\nlast_updated: {ISO date}"
)
```

Recovery: `mem_search("sdd/{change-name}/state")` → `mem_get_observation(id)` → parse YAML → restore orchestrator state.

### Example

```
mem_save(
  title: "sdd/add-dark-mode/proposal",
  topic_key: "sdd/add-dark-mode/proposal",
  type: "architecture",
  project: "my-app",
  content: "# Proposal: Add Dark Mode\n\n..."
)
```

## Recovery Protocol (2 steps — MANDATORY)

To retrieve an artifact, ALWAYS use this two-step process:

```
Step 1: Search by topic_key pattern
  mem_search(query: "sdd/{change-name}/{artifact-type}", project: "{project}")
  → Returns a truncated preview with an observation ID

Step 2: Get full content (REQUIRED)
  mem_get_observation(id: {observation-id from step 1})
  → Returns complete, untruncated content
```

NEVER use `mem_search` results directly as the full artifact — they are truncated previews.
ALWAYS call `mem_get_observation` to get the complete content.

### Retrieving Multiple Artifacts

When a skill needs multiple artifacts (e.g., sdd-tasks needs proposal + spec + design):

```
1. mem_search(query: "sdd/{change-name}/proposal", project: "{project}") → get ID
2. mem_search(query: "sdd/{change-name}/spec", project: "{project}") → get ID
3. mem_search(query: "sdd/{change-name}/design", project: "{project}") → get ID
4. mem_get_observation(id) for EACH → full content
```

### Loading Project Context

```
mem_search(query: "sdd-init/{project}", project: "{project}") → get ID
mem_get_observation(id) → full project context
```

### Browsing All Artifacts for a Change

```
mem_search(query: "sdd/{change-name}/", project: "{project}")
→ Returns all artifacts for that change
```

## Writing Artifacts

### Standard Write (new artifact)

```
mem_save(
  title: "sdd/{change-name}/{artifact-type}",
  topic_key: "sdd/{change-name}/{artifact-type}",
  type: "architecture",
  project: "{project}",
  content: "{full markdown content}"
)
```

### Update Existing Artifact

When updating an artifact you already retrieved (e.g., marking tasks complete):

```
mem_update(
  id: {observation-id},
  content: "{updated full content}"
)
```

Use `mem_update` when you have the exact observation ID. Use `mem_save` with the same `topic_key` for upserts (Engram deduplicates by topic_key).

## Why This Convention Exists

- **Deterministic titles** → recovery works by exact match, not fuzzy search
- **`topic_key`** → enables upserts (updating same artifact without creating duplicates)
- **`sdd/` prefix** → namespaces all SDD artifacts away from other Engram observations
- **Two-step recovery** → `mem_search` previews are always truncated; `mem_get_observation` is the only way to get full content
- **Lineage** → archive-report includes all observation IDs for complete traceability
