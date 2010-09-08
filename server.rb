#! /usr/bin/env ruby

require "rubygems"
require "em-websocket-server"


class SocketServer < EM::WebSocket::Server
 
  def on_receive msg 
    EM::popen './exec.sh', TerminalPrinter
    EM::WebSocket::Log.debug "Run requested"
  end
  
  def on_connect
    @sid = Hub.subscribe do |msg|
      send_message msg
    end
    EM::WebSocket::Log.debug "Connected"
  end

end

module TerminalPrinter
  def receive_data data
    puts data
    Hub << "#{data}"
  end
  def unbind
    if get_status.exitstatus != 0
      Hub << "Excited with status #{get_status.exitstatus}"
    end
  end
end



EM.run do
  Hub = EM::Channel.new
    EM.start_server "0.0.0.0", 8080, SocketServer
end

