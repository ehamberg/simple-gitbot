#!/usr/bin/env ruby
# vi: set sw=2 ts=2 et :
#
# Simple IRC bot that echoes everything written to $fifo to
# $irc_channel on $server
# Based on code from Kevin Glowacz:
# http://kevin.glowacz.info/2009/03/simple-irc-bot-in-ruby.html

require 'socket'

#####################################################################
# Configuration                                                     #
#####################################################################
$server      = "chat.freenode.net"
$irc_port    = 6667
$irc_channel = "gitbot"
$irc_nick    = "gitbot#{rand(100000)}"
$fifo        = "/tmp/gitbotfifo"
#####################################################################

class SimpleIrcBot

  def initialize()
    @socket = TCPSocket.open($server, $irc_port)
    say "NICK #{$irc_nick}"
    say "USER gitbot 0 * https://github.com/ehamberg/simple-gitbot"
    say "JOIN ##{$irc_channel}"
  end

  def say(msg)
    puts msg
    @socket.puts msg
  end

  def run
    Thread.new($fifo) do |fifoname|
      while true
        File.open(fifoname, "r+") do |fi|
          while line = fi.gets
            say "PRIVMSG ##{$irc_channel} :#{line}"
          end
        end
      end
    end
    until @socket.eof? do
      msg = @socket.gets
      puts msg

      if msg.match(/^PING :(.*)$/)
        say "PONG #{$~[1]}"
        next
      end
    end
  end

  def quit
    say 'QUIT'
  end
end

if File.exist?($fifo)
  abort "#{$fifo} exists but is not a fifo" if File.ftype($fifo) != "fifo"
else
  system("mkfifo #{$fifo}")
end

bot = SimpleIrcBot.new
trap("INT"){ bot.quit }
bot.run
