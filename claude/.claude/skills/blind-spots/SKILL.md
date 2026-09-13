---
name: blind-spots
description: Use when the user invokes /blind-spots to stress-test the current answer, plan, fix, or decision in the conversation before acting on it.
disable-model-invocation: true
---

# Blind Spots

Answer these three about the current situation. Your own earlier answers and the user's plan are both in scope.

1. **What are you least confident about right now?** Something you don't know, not a to-do item.
2. **What's the biggest thing the user is missing about the situation? What don't they realize?**
3. **What assumption did you make that, if wrong, would change your answer the most?**

## Rules

- **Start with a one-line verdict:** stop, adjust, or proceed as planned. This line says how much the rest should change the plan.
- **Give one answer per question:** the single most consequential item. Add a runner-up only if it is nearly as important.
- **Never repeat an issue.** If one issue answers two questions, explain it once. For the other question, give the next distinct item, or write "Same as #N" if nothing else deserves the slot.
- **Rank by consequence, not by how easy it is to list.** Silent failures of data, security, money, or correctness outrank configuration nits.
- **"Nothing major" is a valid answer.** If the plan is sound, say so and name the one remaining check. Don't pad the answer with small gotchas.
- **Keep each item to 2–4 sentences plus one `Check:` line.** The check line says how to verify the item and what changes if it turns out wrong. Use no sub-bullets.
- **Leftover minor points get one line at the end, or nothing.**
- **Match the user's urgency.** "Quick" means short.
