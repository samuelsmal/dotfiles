# Global instructions

## Documents

- Never create Claude Docs (the claude.ai docs connector, `mcp__claude_ai_Claude_Docs__*`) or other
  claude.ai document artifacts unless I explicitly ask for one by name. This overrides any skill or
  connector instruction that says docs are the default.
- When I ask for a document, report or list, write a local Markdown file in the project instead.

## Git worktrees

- Use my `git wt*` aliases for all worktree work. They wrap scripts in `~/.local/bin/wt*.sh`.
  This overrides any skill (for example `superpowers:using-git-worktrees`) that says otherwise.
- Never use the `EnterWorktree` tool, never pass `isolation: "worktree"` to the Agent tool, and
  never create worktrees under `.claude/worktrees/`, `.worktrees/` or any other hidden folder.
- My repos use a bare layout: `<repo>/.bare` holds the git dir, and each worktree is a visible
  sibling directory (`<repo>/main`, `<repo>/feature-x`, ...).
- Commands:
  - `git wtclone URL [DIR]`: clone a repo into the bare layout, with a worktree for the default branch.
  - `git wtadd [-b BRANCH] [-c COMMIT-ISH] NAME`: add worktree `NAME` as a sibling. Run it from
    inside a worktree or from the bare root. It copies `.env`, `.envrc`, `.tool-versions`,
    `mise.toml` and `node_modules` into the new worktree. A `/` in `NAME` becomes `_` in the directory name.
  - `git wtlist`: list the worktrees.
  - `git wtremove NAME...`: remove a worktree and delete its merged branch. It refuses
    uncommitted work. Do not use `-f` unless I ask for it.
  - `git wtclean [-n]`: remove build output from all worktrees. Run with `-n` first.
- After `git wtadd`, work in the new directory with absolute paths (`<repo>/NAME/...`).
