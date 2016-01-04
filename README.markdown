Super simple IRC bot for announcing commits pushed to a git repository.

* `gitbot.rb` is a simple IRC bot that echoes everything written to a
  fifo.

* `post-receive` is a git hook that will write info about one or more pushed
  commits to a fifo.

Pushing two commits will be announced in the following manner:

    01:23 < gitbot> 2 commit(s) pushed to foo.git on branch 'master':
    01:23 < gitbot> 544208a by Bob: Fixed bug 16
    01:23 < gitbot> 025578a by Alice: Optimized Foo::Bar

By copying the post-receive hook into `/your/git/repo/.git/hooks` and
configuring both `gitbot.rb` and `post-receive` to use the same fifo (default is
`/tmp/gitbotfifo`), the bot will announce new commits that are pushed to the
repo(s) which use the post-receive hook. You probably want to run the bot inside
tmux, GNU screen or similar.
`gitbot.rb` will attempt to create the fifo if it does not exist.

The IRC code is based on a bot by Kevin Glowacz:
<http://kevin.glowacz.info/2009/03/simple-irc-bot-in-ruby.html>.
