require "./lib/gitlab-irc.rb"

set :run, false
set :raise_errors, true

run Sinatra::Application
