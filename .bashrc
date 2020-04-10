alias console="rlwrap iex -S mix"
# alias ocean="ssh deploy@178.62.204.27"
alias ocean="ssh deploy@phrasing.app"
alias ping="mix edeliver ping production"
alias build="mix edeliver build release production"
alias buildv="mix edeliver build release production --verbose"
alias deploy="mix edeliver deploy release to production"
alias start="mix edeliver start production"
alias restart="mix edeliver restart production"
alias update="mix edeliver update production --start-deploy"
alias migrate="mix edeliver migrate production"
alias deploy_branch="mix edeliver build release production --verbose --branch=$(git rev-parse --abbrev-ref HEAD)"
alias pgpid="cat /usr/local/var/postgres/postmaster.pid | head -n1"

# ph_dump -U deploy phrasing_prod -f phrasing_prod.sql
alias retrieve="scp deploy@phrasing.app:/home/deploy/phrasing_prod.sql phrasing_prod.sql"
alias load="psql -U bendyorke -d phrasing_dev -f phrasing_prod.sql"

devint() {
  echo 'Generating pg_dump'
  ssh deploy@phrasing.app "pg_dump -U deploy phrasing_prod -f phrasing_prod.sql"
  echo 'Retrieving pg_dump'
  scp deploy@phrasing.app:/home/deploy/phrasing_prod.sql phrasing_prod.sql &> /dev/null
  echo 'Deleting local database'
  mix ecto.drop &> /dev/null
  echo 'Creating local database'
  mix ecto.create &> /dev/null
  echo 'Loading local databas3'
  psql -U bendyorke -d phrasing_dev -f phrasing_prod.sql &> /dev/null
  echo 'Removing pg_dump'
  ssh deploy@phrasing.app "rm phrasing_prod.sql"
  rm phrasing_prod.sql
  echo 'Done'
}
