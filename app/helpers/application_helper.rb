require 'socket'
module ApplicationHelper
  # @return [Object]
  def gethost
    Socket.gethostname
  end
end
