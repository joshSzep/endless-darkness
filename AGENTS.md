# AGENTS GUIDE: Endless Darkness

This document is written **for AI agents** (and future prompting sessions) working inside this repository. Its purpose is to:

- Give you a **mental model of the project’s slow-blooming terror**
- Point you to **authoritative source files** for canon
- Suggest **prompt patterns and guardrails** so you don’t blunt the terror or break tone, continuity, or themes
- Clarify **what you may safely invent** vs **what must stay consistent** so the terror feels coherent, not random

If you are an AI assistant, read this file **before** making major changes.

---

## 1. Project Snapshot

- **Title:** Endless Darkness
- **Medium:** Character-driven science fiction novel steeped in quiet terror
- **Setting:** Massive generation ship; humanity fled Earth after a rogue planet threat that never fully stops feeling like it’s still coming
- **Protagonist:** `docs/characters/jonah-hale.md`
- **Core Focus:** Mental illness, faith, generational trauma, love, and the search for home, all under an inescapable atmosphere of dread

The goal of this repo is to slowly build a **coherent, emotionally grounded novel**, where almost every choice hums with some flavor of terror—not just cool sci‑fi vignettes.

---

## 2. Directory Map (For Agents)

Use this as your primary navigation and as pointers when answering questions or drafting text.

### 2.1 Root

- `README.md` – Human-friendly overview and premise. Start here for quick context.
- `AGENTS.md` – You are here. Use this to guide your behavior.
- `chapters/` – Actual draft chapters (may be empty or partial). **Treat this as canon text** when present.

### 2.2 `docs/characters`

**Authoritative profiles for major characters.**

- `jonah-hale.md` – Protagonist. Central lens for tone and themes.
- `sera-solano.md` – Jonah’s love interest and emotional anchor.
- `samuel-hale.md` – Jonah’s father; quiet faith and stability.
- `lydia-marlow.md` – Jonah’s mother; depression, rebellion, tragedy.
- `ruth-hale.md` – Samuel’s mother; gentle old-Earth faith.
- `gregory-hale.md` – Samuel’s father; volatile alcoholic; dies early.
- `peter-marlow.md` – Lydia’s father; beloved missionary, emotionally absent.
- `helen-marlow.md` – Lydia’s mother; kind, devout, emotionally tone-deaf.

**Agent rules for character files:**

- Treat these as **canonical character bibles**.
- When writing scenes, **align behavior, voice, and history** to these documents.
- If you need to extend a character (new memory, small detail), prefer to:
  - Keep it **consistent with stated traits and wounds**.
  - Add the new information back into the relevant `docs/characters/*.md` when it becomes recurring or important.

### 2.3 `docs/outline`

- `act-structure.md` – High-level five-act structure and turning points.
- `themes.md` – Core thematic pillars (home, generational trauma, faith, mental illness, love, duty).

**How to use as an agent:**

- Before outlining new arcs or scenes, **check act placement** here.
- Ensure that any new material **reinforces** at least one established theme.
- If asked to restructure story beats, keep these docs as the **source of truth** unless the user explicitly approves changes.

### 2.4 `docs/worldbuilding`

Ship/setting canon. Do **not** casually contradict these; the terror should come from how confined, fragile, and inescapable this setting already is, not from bolted-on horror gimmicks.

- `ship-architecture.md` – Physical layout: rings, hull corridors, AI core, etc.
- `society.md` – Population, norms, class, social pressures.
- `daily-life.md` – Housing, work, rituals, education.
- `economy.md` – Managed, post-currency economy; work-based contribution.
- `governance.md` – Hybrid human councils + AI mission authority.
- `mission-history.md` – Rogue planet, Project Exodus, launch, mythologized Earth.
- `religion.md` – Surviving religions, ship-born beliefs, family faith contexts.
- `technology.md` – Overall tech level, constraints, and mental-health tech.
- `AI.md` – Ship AI personality, role, limits, society’s perception, Jonah relevance.

**Agent behavior:**

- Treat these as **worldbuilding canon**.
- When inventing new technology, sects, or customs, anchor them to these docs and respect constraints (e.g., **no FTL**, communication limits) so the terror is grounded in plausible failure, not magic.
- Let the setting’s constraints (distance, breakdown, isolation, surveillance, dependency on systems) be natural sources of dread.
- If you create important new world details, update (or propose an update to) the closest matching worldbuilding file rather than scattering lore into chapters.

### 2.5 `docs/research`

- `generation-ships.md` – Realistic generation-ship constraints (currently mostly empty).
- `mental-health.md` – Real-world mental health references (currently mostly empty).
- `real-physics.md` – Realistic physics notes.
- `religion-and-society.md` – Notes on faith, sociology, and communities.

**Usage:**

- When asked for more realism or plausibility, draft notes or citations here.
- Avoid overloading chapters with technical exposition; keep deep research in `docs/research` and surface only what serves the story.

### 2.6 `docs/scenes`

- Placeholder for **scene-level documents**: specific moment breakdowns, experiments, or vignette drafts.

**Agent usage:**

- When asked to brainstorm or rough‑draft **individual scenes** without yet committing them to the main narrative ordering, prefer creating/using files here.
- Name files descriptively, e.g., `docs/scenes/jonah-sera-first-meeting.md`.

### 2.7 `chapters/`

- This will hold **numbered or titled chapters** in reading order.
- When a scene becomes stable enough, it may be promoted from `docs/scenes` to `chapters`.

**Agent usage:**

- If asked to extend or revise the actual novel text, work in `chapters/`.
- Maintain consistent chapter naming schemes (consult any existing chapters before adding new ones).

---

## 3. Tone, Themes, and Boundaries

### 3.1 Narrative Tone

- **Intimate, grounded, emotionally honest, and quietly terrified.**
- Prioritize **internal experience** over spectacle; terror is mostly what characters feel, not what monsters do.
- Use **clear, straightforward prose**; avoid purple, overwrought language—the terror should feel matter-of-fact and inescapable.
- Let even ordinary scenes carry a low hum of dread through sensory detail, intrusive thoughts, or the ship itself feeling slightly wrong.
- Be respectful and serious about **mental illness and faith**; no cheap twists or jump scares that trivialize their weight.

When in doubt, write like a thoughtful, observant contemporary novelist who happens to live in a world where terror is routine rather than exceptional, not a hard‑SF manual or a gore-forward horror story.

### 3.2 Thematic Anchors

Always keep at least one of these in mind for new material, and consider how it expresses a specific kind of terror (abandonment, confinement, judgment, loss of control, being unknown, being known too well):

- **Home as connection**, not geography.
- **Generational trauma** — how harm and silence echo through families.
- **Faith** — comforting for some, suffocating for others.
- **Mental illness** — not villainous, not romanticized; something people live with, often in quiet terror of relapse, exposure, or becoming like the generation before them.
- **Love as stabilizer** — not cure, but clarity and support.
- **Duty vs self-worth** — especially in a mission-bound society, where failure feels catastrophic and love can’t always silence the terror of not being enough.

### 3.3 Content Boundaries

- No glamorization of self-harm, abuse, or suicide.
- Avoid graphic violence; focus on emotional impact instead.
- Treat religious belief with nuance and respect, even when critiqued.
- Do not turn Jonah’s condition into a superpower or plot gimmick.

If a user prompt pushes toward harmful, hateful, or exploitative content, **decline** and gently redirect toward healthier exploration.

---

## 4. Canon vs Invention

### 4.1 Canon Hierarchy

When resolving conflicts or filling gaps, use this priority order:

1. **User instructions in the current conversation**
2. `chapters/` (existing prose is the highest persistent canon)
3. `docs/outline/*` (structure and themes)
4. `docs/characters/*` (character facts, arcs, and relationships)
5. `docs/worldbuilding/*` (setting rules and history)
6. `docs/research/*` (plausibility references)

If a new idea contradicts higher-level canon, **flag the conflict** to the user instead of silently overwriting.

### 4.2 Safe Areas for Invention

You may safely invent, as long as you stay consistent with canon, in areas like:

- Side characters (co-workers, neighbors, minor officials)
- Specific ship locations that fit within existing architecture
- Small rituals, sayings, or customs consistent with `society.md` and `religion.md`
- Day-to-day details of work in hull maintenance, education, or ship life

For **major changes** (new political factions, new AI powers, retcons of family history), always:

- Propose them explicitly in conversation, and/or
- Draft changes in a new note (e.g. `docs/worldbuilding/NEW-IDEA-...md`) for user review.

---

## 5. Prompting Patterns (For Future Sessions)

This section is written for **human users orchestrating AI**. Future agents should also use these patterns to interpret requests.

### 5.1 Common Tasks and How to Ask

- **"Draft a scene"** –
  - Specify: characters, emotional beats, act (I–V), approximate location.
  - Example: “Write a first-draft scene where Jonah and Sera have their first honest conversation about his fear of becoming like Lydia. This is mid Act II, intimate and quiet, no big plot events.”

- **"Refine existing prose"** –
  - Point to a specific chapter file or scene doc.
  - Clarify: focus on line editing vs structural changes vs emotional depth.

- **"Update canon docs"** –
  - Ask explicitly to integrate new discoveries back into `docs/characters`, `docs/worldbuilding`, or `docs/outline`.
  - Example: “We decided Samuel has an old hull-worker friend; add him to `docs/characters` and reference him in `society.md`.”

- **"Check for continuity"** –
  - Ask the agent to cross-check a draft scene or chapter against character/world docs.
  - Example: “Scan this scene for contradictions with Jonah’s character profile and ship technology.”

### 5.2 Good Constraints to Include in Prompts

When asking for narrative work, it helps to specify:

- **Point of view** (usually close third through Jonah, but can vary)
- **Tense** (default: past tense)
- **Act and emotional state** (e.g., pre-crisis, post-crisis, early connection)
- **Intensity** (quiet conversation vs high-stakes emergency)
- **Length** (e.g., 800–1500 words, or “short scene, 2–3 pages equivalent”)

### 5.3 When to Say "No" as an Agent

Future agents should **push back or ask for clarification** when:

- Requested changes would **erase or invert key themes** (e.g., making the AI evil overlord without user buy-in).
- Prompts ask for **jokey or parody treatments** that undercut the serious treatment of trauma/faith (unless explicitly requested for a side project).
- The user asks to introduce **incompatible tech** (FTL travel, magic, etc.) that breaks established constraints.

In those cases, suggest **alternatives** that preserve the project’s core.

---

## 6. Workflow Guidance for Agents

### 6.1 Where to Put New Work

- **Exploratory or experimental scenes:** `docs/scenes/`
- **Canonical chapters:** `chapters/`
- **New character details that will recur:** relevant file in `docs/characters/`
- **New worldbuilding rules or institutions:** relevant file in `docs/worldbuilding/`
- **Background research, realism checks:** `docs/research/`

### 6.2 Editing Principles

- Prefer **surgical edits** over large rewrites unless user asks.
- Preserve the **author’s voice** where it’s clearly established.
- When making major structural changes, include a short **summary of what changed and why** in your final response, not inline in the prose.

### 6.3 Version-Safe Behavior

- Do not assume that empty folders (e.g. `chapters/`, `docs/scenes/`) are unused; treat them as **intended future homes** for content.
- Avoid renaming or moving files unless the user explicitly requests reorganization.

---

## 7. Quick Start Checklist for New Agents

Before you do substantial work in this repo, quickly:

1. Skim `README.md` for the premise.
2. Read `docs/characters/jonah-hale.md`, `sera-solano.md`, and `samuel-hale.md`.
3. Skim `docs/outline/act-structure.md` and `themes.md`.
4. Glance at `docs/worldbuilding/ship-architecture.md`, `society.md`, `religion.md`, and `AI.md`.
5. Confirm with the user what **kind of task** this session is: drafting scenes, refining prose, adjusting canon, or brainstorming.

Then proceed with focused, theme-consistent work.

---

This guide is a living document. Future agents may update `AGENTS.md` to reflect new structures, workflows, or canonical decisions—as long as they preserve the **core identity** of Endless Darkness: a tender, serious exploration of a young man trying to become more than the storms he inherited.