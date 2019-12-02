alias console="rlwrap iex -S mix"
alias ocean="ssh deploy@104.248.93.78"
alias deploy="mix edeliver build release production --verbose"
alias deploy_branch="mix edeliver build release production --verbose --branch=$(git rev-parse --abbrev-ref HEAD)"

