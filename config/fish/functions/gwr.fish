function gwr --description "Safely unmount and clean a local git worktree tracking node path"
    if test (count $argv) -lt 1
        echo (set_color red)"Error: Worktree branch reference parameter omitted."(set_color normal)
        echo "Usage: gwr <worktree-name>"
        return 1
    end
    set -l target $argv[1]
    set -l target_path "../$target"
    if not test -d $target_path
        echo (set_color red)"Error: Path location target '$target_path' invalid."(set_color normal)
        return 1
    end
    echo (set_color yellow)"Deconstructing tracking index paths from: $target_path"(set_color normal)
    git worktree remove $target_path
    echo -n "Completely scrap local git reference records for branch '$target'? [y/N]: "
    read -l confirm
    if test "$confirm" = "y" -o "$confirm" = "Y"
        git branch -d $target
        echo (set_color green)"Tracking branch pointer destroyed."(set_color normal)
    else
        echo "Local branch reference records left untouched."
    end
end
