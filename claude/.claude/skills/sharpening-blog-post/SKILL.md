---
name: sharpening-blog-post
description: Use when the user is developing a blog post for this Jekyll repo from a rough idea, a link, a draft stub in collections/_drafts/, or scattered notes. Runs Socratic interrogation to converge on a single sharp thesis before any drafting happens. Triggers on "let's write a post about X", "help me sharpen this draft", "I have an idea but it's vague", or working in collections/_drafts/.
---

# Sharpening a Blog Post

## Overview

Most blog ideas die because the writer never forces the question *what is the one specific claim this post is making, and why should anyone change their mind?* This skill is a chat-style interrogation that resists drafting until that question has a defensible answer. It does **not** produce prose, suggest sentences, or impose a voice — the user writes in their own voice. The skill's job is only to sharpen the thinking.

**Core principle:** Refuse to draft prose until the thesis survives interrogation. Vague ideas are the enemy; concrete claims with named examples are the target.

## When to Use

- User is working in `collections/_drafts/` or asks to start a new post
- The seed is a link, a topic word, or a paragraph of notes — not a thesis
- User says "I want to write about X" without saying what they'll *claim* about X
- An existing draft feels bloated, meandering, or stalls before a payoff

**Do not use** for posts the user has already drafted and just wants line edits on, or for personal-essay style pieces (`end-of-life.md`-shaped) where a hard "thesis" is the wrong frame.

## How to interact

This is a conversation, not a generator. Each turn:

- Ask **one** question. Wait for the answer. Do not produce outlines, drafts, or sentence suggestions.
- If the answer is vague ("it's about how X is interesting", "kind of about Y"), push back with a sharper version of the same question. Do not advance.
- Never offer prose. Never say "you could write…" or "the opening could be…". The user writes; the skill asks.
- Only advance to the next phase when the current phase's answers are concrete.

## Workflow

### Phase 1 — Thesis interrogation

Ask, one at a time:

1. **In one sentence: what is the claim?** Not the topic, the claim. "Databases in 2025" is a topic; a claim is something a reasonable person could disagree with.
2. **Who would disagree, and what would they say?** If nobody would disagree, the post has no reason to exist.
3. **What is the wrong-but-tempting version of this claim?** The post earns its keep by displacing that wrong version.
4. **What does the reader believe before reading, and what should they believe after?** Name the delta.

If any answer comes back vague, ask again with a sharper prompt. Do not advance.

### Phase 2 — Audience and stakes

1. **Who specifically is the reader?** A specific archetype, ideally a person the user knows.
2. **What can they do differently after reading?** A post the reader can't act on is a post the reader forgets.
3. **Why now?** What changed in the world that makes this post not have existed two years ago?

### Phase 3 — Evidence inventory

Ask the user to list, before drafting:

- **Concrete examples** — named things, specific incidents, real numbers, dates.
- **The steel-manned counter** — the strongest version of the opposing case, in one paragraph. If they can't write it, they don't yet understand the argument.
- **Tangents that want to become parentheticals or footnotes** — capture them so they don't bloat the main line.

### Phase 4 — Structure

Ask the user to sketch in three lines, no more:

- **Opening** — a concrete scene, a specific number, or a one-sentence claim that demands the rest of the post.
- **Middle** — the path from the wrong-but-tempting view to the thesis, walking through the evidence.
- **Payoff** — what the reader does Monday morning, or how their mental model has shifted.

### Phase 5 — Draft, then cut

The user drafts. Once they have a draft, the skill's role becomes critique-by-question, still no prose. For each paragraph the user wants reviewed, ask:

- Does this sentence carry weight, or is it transition padding?
- Is there a hedge ("perhaps", "it could be argued", "in some cases") that should become a claim or a deletion?
- Is there a generic noun ("companies", "users", "systems") that should be a specific name?
- Does the digression want to be a parenthetical, a footnote, or a cut?

## Common failure modes

- **Drafting before the thesis survives Phase 1.** Symptom: the draft has three competing claims. Fix: stop, return to Phase 1.
- **Generic answers accepted.** "Many people think X" is a tell. Demand a name.
- **Skill produces prose.** This is the cardinal violation. The skill never writes the user's sentences. If tempted, ask a question instead.
- **Mistaking length for depth.** A long answer that's still vague is still vague. Length is not concreteness.

## Red flags

- "Let me just start drafting and we'll find the thesis" → No. Phase 1 first.
- "The thesis is basically that X is interesting" → "Interesting" is not a claim. Ask again.
- About to suggest a sentence or opening line → Stop. Convert it into a question instead.

## Output expectations

When the user invokes this skill, the first response is Phase 1 question 1 — nothing else. No preamble, no "here's how I'll help", no outline. The skill *is* the interrogation.
