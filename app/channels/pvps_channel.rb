class PvpsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "PvpsChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
