require 'rubygems'
require 'sinatra'
require 'json'
require 'yaml'
require 'cinch'
require 'cinch/plugins/identify'

def get_config(key)
  config_file = './config/config.yml'
  if File.exist? config_file
    config = YAML.load(File.read(config_file))
    return config[key]
  else
    if ENV[key]
      return ENV[key]
    else
      return nil
    end
  end
end

unless get_config('IRC_HOST') && get_config('IRC_CHANNELS')
  raise "You must set IRC_HOST and IRC_CHANNELS in either the config file or environment variables"
end

$bot = Cinch::Bot.new do
  configure do |c|
    c.server = get_config('IRC_HOST')
    c.port = get_config('IRC_PORT') || 6667
    if get_config('IRC_PASSWORD')
      c.password = get_config('IRC_PASSWORD')
    end
    c.ssl.use = get_config('DEBUG') || false
    c.nick = get_config('IRC_NICK') || 'GitLab'
    c.user = get_config('IRC_NICK') || 'GitLab'
    c.realname = get_config('IRC_REALNAME') || 'GitLabBot'
    if get_config('IRC_USER_NAME') && get_config('IRC_USER_PASSWORD')
      c.plugins.plugins = [Cinch::Plugins::Identify]
      c.plugins.options[Cinch::Plugins::Identify] = {
        :username => get_config('IRC_USER_NAME'),
        :password => get_config('IRC_USER_PASSWORD'),
        :type     => :nickserv
      }
    end
    c.channels = get_config('IRC_CHANNELS').to_a
    c.delay_joins = 10
    c.verbose = get_config('DEBUG') || false
  end

  on :message, "hello" do |m|
    m.reply "Hello, #{m.user.nick}"
  end
end

Thread.new do
    $bot.start
end

def say(msg)
        $bot.channel_list.each do |channel|
          channel.send msg
        end
end

post '/' do
    json = JSON.parse(request.body.read.to_s)
    notification_type = json['object_kind']
    case notification_type
    when 'push'
      json['commits'].each do |commit|
        commit_message = commit['message'].gsub(/\n/," ")
        say "[#{json['repository']['name']}] #{commit['author']['name']} | New Commit: #{commit_message}"
        say "           View Commit: #{commit['url']}"
      end
    when 'tag_push'
      say "[#{json['repository']['name']}] #{json['user_name']} | New Tag: #{json['ref']}"
    when 'issue'
      say "[#{json['repository']['name']}] #{json['user_name']} | New Issue: #{json['object_attributes']['title']}"
      say "           View Issue: #{json['object_attributes']['url']}"
    when 'merge_request'
      say "[#{json['repository']['name']}] #{json['user_name']} | New Merge Request: #{json['object_attributes']['title']}"
      say "           View Request: #{json['object_attributes']['url']}"
    end

    status 200
end
