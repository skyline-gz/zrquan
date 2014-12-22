require 'net/http'
class FayeClient
  def self.send(channel, params)
    params[:token] = Settings.faye_token
    message = {channel: channel, data: params}
    uri = URI.parse(Settings.faye_server)
    Net::HTTP.post_form(uri, message: message.to_json)
  end
end