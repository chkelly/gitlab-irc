gitlab-irc
==========

A lightweight gitlab irc bot that announces commit messages and supports the ability to connect to an irc server over ssl.

Installation
------------

```bash
git clone git@github.com:chkelly/gitlab-irc.git;
cd gitlab-irc;
mv config/config.yml.example config/config.yml;
#Edit the config file
vim config/config.yml
```

You can use the config.yml.example file that is provided to configure your connection.

Once completed, you can start the server using the following commands
```bash
cd gitlab-irc;
unicorn -c config/unicorn.conf -D
```

You can then configure your post commit web hooks to
```bash
http://localhost:8080/commit
```

