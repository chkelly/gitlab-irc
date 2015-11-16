gitlab-irc
==========

Summary
-------
A lightweight gitlab irc bot that announces gitlab project notifications via webhooks.

Supports
--------
* Connecting to an IRC server over SSL
* Authing with Nickserv
* Support for announcing Commits, Merge Requests, Tags, and Issues. 

Requirements
------------
* Tested on Ruby 2.2.3
* Tested with Gitlab CE 8.1.4


Installation
------------

```bash
git clone https://github.com/chkelly/gitlab-irc.git;
cd gitlab-irc;
mv config/config.yml.example config/config.yml;
#Edit the config file
vim config/config.yml
```

You can use the config.yml.example file that is provided to configure your connection.

Once completed, you can start the server using the following commands
```bash
cd gitlab-irc;
bundle exec unicorn -c config/unicorn.conf -D
```

You can then configure your post commit web hooks to
```bash
http://localhost:5000
```

Troubleshooting
---------------

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

