# gitlab-irc

## Summary
A lightweight gitlab irc bot that announces gitlab project notifications via webhooks.

## Supports
* Connecting to an IRC server over SSL
* Authing with Nickserv
* Support for announcing Commits, Merge Requests, Tags, and Issues. 

## Requirements
* Tested on Ruby 2.2.3
* Tested with Gitlab CE 8.1.4

## Configuration

The following parameters can be set either in the config.yml file or via environment variables.

| Option            | Example Value    | Description                                       | Required? | Default        |
|-------------------|------------------|---------------------------------------------------|-----------|----------------|
| IRC_HOST          | irc.freenode.com | IRC Server Hostname                               | Yes       |                |
| IRC_PORT          | 6667             | IRC Server Port                                   |           | 6667           |
| IRC_PASSWORD      | sample_password  | Server Password                                   |           |                |
| SSL               | true             | if true, allows connection to irc server over ssl |           | false          |
| IRC_CHANNELS      | ['#dev','#all']    | Array of channels to join                         | Yes       | ['#gitlab-irc'] |
| IRC_NICK          | GitLab           | Bot Name                                          |           | GitLab         |
| IRC_REALNAME      | GitLabBot        | Real Name                                         |           | GitLabBot      |
| IRC_USER_NAME     | gitlab-irc       | Username for authing with nickserv                |           |                |
| IRC_USER_PASSWORD | user_password    | Password for authing with nickserv                |           |                |
| DEBUG             | true             |                                                   |           | false          |

## Installation
### Docker (Recommended)

Start the gitlab-irc server with at least IRC_HOST and IRC_CHANNELS environment variables set:

```bash
docker run -e IRC_HOST=irc.freenode.com -e "IRC_CHANNELS=['gitlab-irc']" -d -p 5000:5000 --restart=always --name gitlab-irc chkelly/gitlab-irc:v1.0.4 
```
### Manual
This assumes you have installed Ruby 2.2.3

#### Checkout the code
```bash
git clone https://github.com/chkelly/gitlab-irc.git;
cd gitlab-irc;
mv config/config.yml.example config/config.yml;
```

#### Edit the config file
```bash
vim config/config.yml
```

You can use the config.yml.example file that is provided to configure your connection.

#### Start it up
Once completed, you can start the server using the following commands
```bash
cd gitlab-irc;
bundle exec unicorn -c config/unicorn.conf -D
```
### Configure Projects within Gitlab

Within Gitlab CE, select a project, then go to Settings -> Hooks, and enter in the below. Check all the boxes. Adjust the below host and port to point to the ip:port that the gitlab-irc service is running on.

```bash
http://localhost:5000
```

## Troubleshooting

1. If you encounter the following error and installed ruby with RVM:

```
Gem::Ext::BuildError: ERROR: Failed to build gem native extension.

    /home/ckelly/.rvm/rubies/ruby-2.2.3/bin/ruby -r ./siteconf20151116-6706-1j2d19j.rb extconf.rb
    checking for CLOCK_MONOTONIC in time.h... *** extconf.rb failed ***
    Could not create Makefile due to some reason, probably lack of necessary
    libraries and/or headers.  Check the mkmf.log file for more details.  You may
    need configuration options.
```
reinstall your version of ruby with:
`rvm reinstall ruby-2.2.3 --disable-binary`


