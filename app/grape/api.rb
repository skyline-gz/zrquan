require "entities"

module Zrquan
  class API < Grape::API
    prefix "api"
    version "v1"
    format :json

    # Get all User Id
    # params
    # Example
    #   /api/v1/user.json
    resource :users do
      get do
        present User.all, with: APIEntities::User
      end
    end
  end
end