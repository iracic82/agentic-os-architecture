# The self-maintenance loop

Most "second brain" setups rot because capture is easy and curation is manual. Agentic OS pushes curation
onto a schedule, with a human only where judgment is required.

| When | Job | What it does | Human? |
|---|---|---|---|
| Daily | **recall canary** | asks the memory a known question and checks the answer is still right, catches a broken or drifted store before you rely on it | no |
| Weekly | **maintenance / lint** | scans the knowledge base for staleness, duplication, and orphaned links; writes a report | no |
| Weekly | **promotion drafts** | proposes new notes (one draft per candidate) into `inbox/`, `status: draft` | no |
| On demand | **promote the inbox** | a human says "promote"; the assistant verifies each draft, merges/moves it, fixes links, updates the index, runs a health check, and syncs | **yes** |
| Continuous | **contradiction hook** | flags two notes that assert conflicting things, so knowledge stays consistent | no |
| Periodic | **evolution proposer** | proposes improvements to the brain's *own* design, new structure, new cadence, retired cruft | review |
| Periodic | **backup** | snapshots the vector store (the canonical markdown is already in git) | no |

The design principle: **the machine drafts, the human approves.** Nothing enters the canonical layer
without a person saying yes, which is what prevents slow drift and memory poisoning, but the machine
does all the tedious scanning, drafting, and link-fixing.
