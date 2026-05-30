function gwa --description "Create an isolated Git worktree tracking sibling directory mapping"
    if test (count $argv) -lt 1
        echo (set_color red)"Error: Branch parameter mapping target required."(set_color normal)
        echo "Usage: gwa <branch-name>"
        return 1
    end
    set -l branch_name $argv[1]
    set -l target_path "../$branch_name"
    if test -d $target_path
        echo (set_color yellow)"Error: Directory path target '$target_path' is already occupied."(set_color normal)
        return 1
    end
    echo (set_color cyan)"Constructing git isolated path target: $target_path"(set_color normal)
    git worktree add $target_path -b $branch_name
end
