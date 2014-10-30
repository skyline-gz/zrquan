require "entities"
require 'helpers'

module Zrquan
  class API < Grape::API
    prefix "api"
    version "v1"
    format :json

    helpers APIHelpers

    # Get all User Id
    # params
    # Example
    #   /api/v1/user.json
    resource :users do
      get do
        present User.all, with: APIEntities::User
      end
    end

    # Return User's Status
    # params
    # Example
    #   /api/v1/authenticated.json
    resource :authenticated do
      get do

        userexit = true if authenticated?
        usermentor = true if current_user.verified_user?
        useractivated = true if current_user.activated?
        followuser = true if can? :follow, User
        editall = true if can? :edit, :all

        results = {
            :userexit => userexit,
            :usermentor => usermentor,
            :useractivated => useractivated,
            :followUser => followuser,
            :editall => editall
        }
        present results
      end
    end
  end
end