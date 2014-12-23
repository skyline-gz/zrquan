class MessagesController < ApplicationController

  def index
    @messages = current_user.messages
  end
end
