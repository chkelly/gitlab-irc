FROM ruby:2.2.3-onbuild
CMD bundle exec unicorn -p 5000
