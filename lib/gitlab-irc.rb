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
    $config['IRC_CHANNELS'].each do |channel|
        $bot.Channel(channel).send msg
    end
end

post '/commit' do
    json = JSON.parse(request.env["rack.input"].read)
    json['commits'].each do |commit|
        say "[#{json['repository']['name'].capitalize}] #{commit['author']['name']} | #{commit['message']}"
        say "           View Commit: #{commit['url']}"
    end
end
