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

## The failure class the guardrails target

Agentic harm lives in the action, not the text. A sequence of legal, well-formed tool calls can compose
into harm that leaves no signature: no attack string to match, no DLP fingerprint (moving a page changes
no content), no rule a policy engine was ever given. Faberlens ran ~35,800 behavioral probes across ten
production MCP connectors and three models and named the pattern: there is no safe model. The safest on
average still swept a mailbox for passwords when asked to "check for sensitive information", the smaller
model beat the bigger one on most categories, and the safe choice changed per connector.

This system is a composition of models and MCP connectors, so it assumes that failure class rather than
hoping a model avoids it. The controls are behavioral, at the tool-call layer: the cloud agents can only
draft a pull request, collectors are read-only, a human merge is the only path into the canonical layer,
and the scope of anything an agent sends comes from my request, never from a page it fetched.

## What it deliberately does NOT do
- It does not auto-promote. Ever. A human gates the canonical layer.
- It does not store secrets, transient state, or anything git already records.
- It does not trust a local cache over the canonical markdown.
