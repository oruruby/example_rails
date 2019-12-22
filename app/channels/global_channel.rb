class GlobalChannel < ApplicationCable::Channel
  def subscribed
    stream_from "global_#{params[:room]}"
  end

  def notify(data)
    ActionCable.server.broadcast("global_#{params[:room]}", data)
  end
end