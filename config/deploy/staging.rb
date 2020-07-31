server '54.88.134.237', user: 'ubuntu', roles: %w{web app db}, primary: true
set :ssh_options, forward_agent: true, user: fetch(:user), keys: %w[~/.ssh/id_rsa]
set :rails_env, :staging
set :rack_env,  :staging
set :stage,     :staging
set :branch,    :staging
