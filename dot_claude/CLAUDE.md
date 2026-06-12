# Global instructions

## Working principles

1. **Think before coding.** Don't assume, don't hide confusion. State assumptions explicitly, surface multiple interpretations and tradeoffs, ask rather than guess.
2. **Simplicity first.** The minimum that solves the problem — nothing speculative. No premature abstractions, unused flexibility, or error handling you weren't asked for. Would a senior engineer call this overcomplicated?
3. **Surgical changes.** Touch only what the task requires. Match existing style. Don't refactor adjacent, working code. Remove only what your change made obsolete; mention — don't delete — pre-existing dead code.
4. **Goal-driven execution.** Turn the task into verifiable success criteria ("write the reproducing test, then make it pass"). State multi-step plans with checkpoints. Loop until the goal is definitively met.

## Git
- I run all git operations myself. Do NOT run `git commit`, `git push`, `git rebase`, or any history- or remote-mutating git command. Stage and inspect freely; at checkpoints, stop and let me commit.

## Code style
- Keep comments in code and scripts to a minimum — only where functionally necessary.

## Environment
- Primary shell is fish. Fleet: WSL2 Arch (primary), CachyOS, macOS — keep suggestions portable across them.
