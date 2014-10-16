module Zrquan
  module APIHelpers
    def warden
      env['warden']
    end

    def authenticated?
      true if warden.authenticated?
      # 暂时只通过Session检验用户，不支持Token的方式
      # params[:access_token] && @user = User.find_by_authentication_token(params[:access_token])
    end

    def current_user
      warden.user
      # warden.user || @user
    end

    # 提供API 内访问cancan的入口
    def authorize!(*args)
      ::Ability.new(current_user).authorize!(*args)
    end

    def can?(*args)
      ::Ability.new(current_user).can?(*args)
    end
  end
end