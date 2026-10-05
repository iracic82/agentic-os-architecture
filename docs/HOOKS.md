# Hooks & automation, what runs without you

The brain curates itself because a set of scheduled and event-driven hooks do the tedious work. A
human is in the loop at exactly one point: promotion.

```mermaid
flowchart TD
  subgraph Scheduled
    DC[daily: recall canary] --> HL[(health log)]
    WM[weekly: maintenance/lint] --> REP[_consolidation/ report]
    WM --> DR[weekly: promotion drafts] --> INBOX[inbox/ draft notes]
    BK[periodic: memory backup] --> SNAP[(snapshot)]
    EP[periodic: evolution proposer] --> PROP[proposals about the brain itself]
  end
  subgraph Event-driven
    CH[contradiction hook] --> FLAG[flag conflicting notes]
    DW[draft watch] --> INBOX
  end
  subgraph Human
    INBOX -->|"promote the inbox"| VERIFY[verify → merge → fix links → index → health → sync]
    VERIFY --> WIKI[(canonical wiki)]
    PROP -->|review| WIKI
  end
  classDef s fill:#0e1627,stroke:#334155,color:#e2e8f0; class HL,REP,SNAP,WIKI,INBOX s;
```

| Hook | Trigger | Job | Human? |
|---|---|---|---|
| recall canary | daily | ask a known question, assert the answer, catch a broken/drifted store early | no |
| maintenance / lint | weekly | find stale notes, duplicates, orphaned links; write a report | no |
| promotion drafts | weekly | draft candidate notes into `inbox/` (one per candidate) | no |
| contradiction hook | on write | flag two notes that assert conflicting things | no |
| draft watch | on new raw item | funnel it into the pipeline | no |
| evolution proposer | periodic | propose changes to the brain's *own* structure/cadence | review |
| memory backup | periodic | snapshot the vector store (markdown is already in git) | no |
| **promote the inbox** | on human say-so | verify each draft, merge/move, fix `[[links]]`, update index, health-check, sync | **yes** |

Scheduling runs on whatever the host provides, `cron`, macOS `launchd`, or Linux `systemd`, so the
same brain maintains itself on a laptop or a server. See [templates/](../templates/) for skeletons of
the daily and weekly jobs.
