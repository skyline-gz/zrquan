module Zrquan
  module ReturnCode
    S_OK = "S_OK"             #操作成功
    S_INACTIVE_OK = "S_INACTIVE_OK" #特指未激活用户登陆成功
    FA_INVALID_PARAMETERS = "FA_INVALID_PARAMETERS" #请求参数非法
    FA_UNKNOWN_ERROR = "FA_UNKNOWN_ERROR"   #未知错误
    FA_USER_NOT_EXIT = "FA_USER_NOT_EXIT"   #用户(账号)不存在
    FA_PASSWORD_ERROR = "FA_PASSWORD_ERROR" #密码错误
    FA_SESSION_HAS_BEEN_CREATED = "FA_SESSION_HAS_BEEN_CREATED"  #SESSION已被创建，可能是同一客户端重复登陆
  end
end