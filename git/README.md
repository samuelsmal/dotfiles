# Worktree scripts

Vendored from [tomups/worktrees-scripts](https://github.com/tomups/worktrees-scripts) at commit
`d67f11a` (2026-01-11, MIT), which adapts scripts by Bill Mill and Morgan Cugerone. Copied rather
than installed from upstream's `curl | bash` so the working copy is reviewable and travels with
this repo.

The layout they assume, and that `~/proj/50_priv/{takt,Hesindion,ios-template,corpore,brigid}`
already use:

```
project/
├── .bare/      bare repository
├── .git        a file reading `gitdir: ./.bare`
├── main/       worktree for the default branch
└── feature-1/  worktrees as siblings, never nested
```

| Alias | Does |
| --- | --- |
| `git wtclone <url> [dir]` | Clones into that layout, sets the fetch refspec, adds `main/` |
| `git wtadd <name> [-b branch] [-c commit-ish]` | Adds a sibling worktree, copying `.env`, `.envrc`, `.tool-versions`, `mise.toml` and a root `node_modules` |
| `git wtremove <name> [-f]` | Removes a worktree, prunes, deletes its branch |
| `git wtlist` | Lists worktrees with their branches, hiding `.bare` |

A `/` in a worktree name becomes `_` in the directory, so `chore/foo` lives in `chore_foo`.

## Changes against upstream

`wtadd.sh` — upstream's direnv guard, `[ type -t direnv 2>/dev/null && -f ... ]`, is not valid
test syntax; bash reports a missing `]` and then tries to run `-f` as a command. Replaced with
`command -v direnv … && [ -f … ]`.

`wtremove.sh` — rewritten. Upstream ran `rm -rf` on the directory and `git branch -D`, which
bypasses git's refusal to drop a worktree holding uncommitted work and force-deletes the branch
merged or not. The default is now `git worktree remove` and `git branch -d`, which refuse and
explain; `-f` restores the old behaviour. Upstream also rebuilt the branch name from the directory
by turning every `_` back into `/`, so `feat/my_thing` came back as `feat/my/thing`; the branch is
now read from `git worktree list --porcelain`.

`wtclone.sh`, `wtlist.sh` — unchanged.

## Claude Code

Claude Code's built-in `EnterWorktree` tool takes no path and hardcodes
`<repo root>/.claude/worktrees/`. Under this layout the repo root is the bare repo, so worktrees
land in `.bare/.claude/worktrees/` — a dot directory inside a dot directory, invisible beside
`main/`. Make the worktree with `git wtadd`, then hand the path to `EnterWorktree(path: …)`, which
enters an existing worktree and keeps the session's bookkeeping straight.
