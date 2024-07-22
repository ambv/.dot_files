function pr --wraps='gh pr checkout' --description 'Check out a github PR with a nice branch name'
    if not gh pr checkout $argv[1]
        echo "failed to checkout PR $argv[1], bailing"
        return 1
    end

    git branch -m gh-$argv[1] 
    
    set -l current_branch (git branch --show-current)
    if not set -q current_branch; or not string length -q -- $current_branch
        echo "failed to get current branch name: $current_branch"
        return 2
    end

    set -l pr_details (gh pr view $argv[1] --json url,headRepositoryOwner)
    if not set -q pr_details; or not string length -q -- $pr_details
        echo "failed to get current PR details"
        return 3
    end

    set -l remote_name (echo "$pr_details" | jq -r .headRepositoryOwner.login)
    if not set -q remote_name; or not string length -q -- $remote_name
        echo "failed to get current PR remote name"
        return 4
    end

    set -l remote_url (git config "branch.$current_branch.remote") 
    if not set -q remote_url; or not string length -q -- $remote_url
        echo "failed to get current PR remote URL"
        return 5
    end

    if string match -q -- $remote_name $remote_url
        echo "remote $remote_name already known"
    else if string match -q -- "git@github.com:*" $remote_url
        git config "remote.$remote_name.url" "$remote_url"
        git config "remote.$remote_name.fetch" "+refs/heads/*:refs/remotes/$remote_name/*"
        git config "remote.$remote_name.github-pr-remote" true
        git config "branch.$current_branch.remote" "$remote_name"
    else
        echo "Weird remote URL: $remote_url"
        return 6
    end
    git config --unset "branch.$current_branch.pushRemote"
    git fetch -a "$remote_name"
end
  