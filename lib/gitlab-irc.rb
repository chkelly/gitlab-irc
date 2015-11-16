require 'rubygems'
require 'sinatra'
require 'json'
require 'yaml'
require 'cinch'

$config = YAML.load(File.read('./config/config.yml'))
$bot = Cinch::Bot.new do
  configure do |c|
    c.server = $config['IRC_HOST']
    c.channels = $config['IRC_CHANNELS']
    c.port = $config['IRC_PORT']
    if $config['SSL'] == true
        c.ssl.use = true
    end
    c.nick = $config['IRC_NICK']
    c.user = $config['IRC_NICK']
    c.realname = $config['IRC_REALNAME']
    c.verbose = $config['DEBUG']
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
        say "[#{json['repository']['name'].capitalize}] #{commit['author']['name']} | New Commit: #{commit_message}"
        say "           View Commit: #{commit['url']}"
      end
    when 'tag_push'
      say "[#{json['repository']['name'].capitalize}] #{json['user_name']} | New Tag: #{json['ref']}"
    when 'issue'
      say "[#{json['repository']['name'].capitalize}] #{json['user_name']} | New Issue: #{json['object_attributes']['title']}"
      say "           View Issue: #{json['object_attributes']['url']}"
    when 'merge_request'
      say "[#{json['repository']['name'].capitalize}] #{json['user_name']} | New Merge Request: #{json['object_attributes']['title']}"
      say "           View Request: #{json['object_attributes']['url']}"
    end

    status 200
end
