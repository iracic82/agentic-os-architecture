# Design decisions & threat model

The non-obvious choices, and why each is the way it is. This is the part that separates a weekend
hack from something you can trust with two years of your working knowledge.

## Decisions

**Markdown is canonical; the vector DB is a cache.**
Databases are where knowledge goes to get trapped. Plain markdown in git is diff-able, reviewable,
greppable, and portable. The embedding index is derived data, if it corrupts or the vendor changes,
you re-index from the markdown and lose nothing.

**Two tools, not a framework.**
Assistants integrate through exactly `search_memory` and `add_memory` over MCP. No SDK, no lock-in,
no per-assistant plumbing. A new coding agent or chat tool joins the brain by being told two rules.

**Recall is a *read* habit, enforced in the system prompt.**
The value isn't writing memories, it's reading them *before acting*. That has to be an instruction
every assistant follows, or the brain becomes write-only and useless.

**Curation is scheduled; approval is human.**
The machine does the tedious 90%: scanning for stale/duplicate/orphaned notes, drafting candidates,
fixing links. The human does the 10% that needs judgment: saying "yes, this is canonical."

**Cheap work runs on a local model.**
Classification, routing, and summarization are constant and privacy-sensitive, so they go to a local
LLM. Frontier tokens are spent only on real synthesis.

## Threat model

| Risk | Mitigation |
|---|---|
| **Memory poisoning** (a bad fact becomes "truth") | Human-approved promotion gate + contradiction hook that flags conflicts before they spread |
| **Secret leakage** into memory | Hard rule: never store secrets or anything already in code/git; memories are facts and decisions, not credentials |
| **Drift / staleness** | Daily recall canary (is the store still right?) + weekly lint + dates on time-sensitive notes, converted to absolute dates on write |
| **Vendor lock-in / data loss** | Canonical markdown in git; the DB is rebuildable; backups snapshot the cache |
| **Contradiction / incoherence** | A hook compares new assertions against existing notes and flags disagreement |
| **Over-capture (junk drawer)** | The ingestion agent classifies and can *drop* noise; not everything becomes a memory |

## What it deliberately does NOT do
- It does not auto-promote. Ever. A human gates the canonical layer.
- It does not store secrets, transient state, or anything git already records.
- It does not trust a local cache over the canonical markdown.
