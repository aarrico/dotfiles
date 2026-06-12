---
name: git-control-preference
description: User handles all git operations themselves; do not commit or push
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 68e90e2a-cca9-4873-a664-ad3ef37ab83b
---

The user controls all git operations (commit, push, branch, etc.) themselves. Write/edit files as needed, but do not run `git commit` or `git push` on their behalf.

**Why:** Stated directly during the dotfiles migration work ("i'll control the git stuff").
**How to apply:** Make file changes, then let the user review and commit. Surface what changed so they can stage/commit, but never run git mutating commands unless explicitly asked in the moment.
