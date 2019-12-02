alias console="rlwrap iex -S mix"
alias ocean="ssh deploy@104.248.93.78"
alias build="mix edeliver build release production --verbose"
alias deploy="mix edeliver deploy release to production"
alias start="mix edeliver start production"
alias update="mix edeliver update production --start-deploy"
alias migrate="mix edeliver migrate production"
alias deploy_branch="mix edeliver build release production --verbose --branch=$(git rev-parse --abbrev-ref HEAD)"

