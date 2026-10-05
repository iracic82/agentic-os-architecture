# Why it's built this way

Everyone who works with AI daily eventually tries to give it a memory. Most attempts rot, leak, or
lock you in. The combination here avoids all three, and the combination is the point, because none of
the ingredients is new on its own.

## What's actually new

The source-of-truth inversion. Almost every AI-memory product treats the database as canonical, and
your knowledge is stuck there the day the vendor changes their API or their pricing. I keep the
canonical copy as markdown in git and treat the embedding store as a cache I can throw away. That one
decision buys portability, an audit trail (`git blame` on a decision), and an easy exit.

It curates itself on a schedule. A daily recall canary checks the memory still answers a known
question. A weekly job lints the knowledge base and drafts new notes. A contradiction check flags
notes that disagree with each other. Second brains die from capture with no curation; this one puts
the curation on cron and keeps a human only at the promotion gate.

Nothing becomes canonical without me saying so. Drafts sit in an inbox that nothing trusts. The cloud
agents can open a pull request and nothing more. The merge is the only way knowledge crosses into the
canonical layer, which is also the guardrail against a poisoned note spreading.

## How it compares

| | Built-in model memory | RAG over docs | Vector memory alone | Obsidian alone | This |
|---|---|---|---|---|---|
| Works across every assistant | per-vendor | partial | yes | no | yes, over MCP |
| Source of truth you own and can diff | no | the docs | no | yes | markdown in git |
| Curates itself | no | no | partial | no | scheduled |
| Catches contradictions | no | no | no | no | yes |
| Human gate before canonical | no | n/a | no | you write it | promotion gate |
| Rebuildable, no lock-in | no | yes | no | yes | DB is a cache |

The row that matters is the last four together. I haven't found another setup that is owned,
self-curating, cross-assistant, and recall-first at once.

## Why it's worth the effort

Context stops evaporating. I don't re-explain last week to Claude every Monday, and a decision from
one account turns up when I'm on the next. The knowledge compounds instead of leaking away, which is
the single biggest tax on working with these tools.

It survives tool churn. Vendors and frameworks come and go; the knowledge is markdown in git, so it
moves with me. When I swapped parts of the stack, nothing in the brain had to change.

## Where it applies beyond me

Anyone who carries context across many accounts or projects and leans on AI: an SE prepping a
discovery call, a TME who has to remember every lab's traps, a consultant moving between clients. The
design is domain-agnostic. This repo is the blueprint to rebuild it for your own work.
