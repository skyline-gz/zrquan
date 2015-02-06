module ReturnCode

  # GENERAL
  S_OK = 'S_OK'             #操作成功
  S_INACTIVE_OK = 'S_INACTIVE_OK' #特指未激活用户登陆成功
  FA_UNKNOWN_ERROR = 'FA_UNKNOWN_ERROR'   #未知错误
  FA_INVALID_PARAMETERS = 'FA_INVALID_PARAMETERS' #请求参数非法，一般指某必须参数为空或取值非法
  FA_NOT_SUPPORTED_PARAMETERS = 'FA_NOT_SUPPORTED_PARAMETERS' #请求参数不支持，一般指某参数取值合法，但不支持取该值
  FA_INNER_NET_CONNECT_ERROR = 'FA_INNER_NET_CONNECT_ERROR' #内部网络连接错误，可能是sunspot:solr等服务器未启动
  FA_WRITING_TO_DATABASE_ERROR = 'FA_WRITING_TO_DATABASE_ERROR' #写入数据库出错，一般是create,save,update等activerecord操作返回false

  # RESTFUL相关
  FA_RESOURCE_ALREADY_EXIST = 'FA_RESOURCE_ALREADY_EXIST' #资源已经存在，一般指【增操作】时，相同内容或目的的资源已被存在
  FA_RESOURCE_NOT_EXIST = 'FA_RESOURCE_NOT_EXIST' #资源不存在，一般指【删查改】等操作所需要的资源不存在

  # 用户相关
  FA_INVALID_MOBILE_FORMAT = 'FA_INVALID_MOBILE_FORMAT'          #非法的电话号码格式
  FA_USER_ALREADY_EXIT = 'FA_USER_ALREADY_EXIT'                  #注册时，用户已经存在
  FA_USER_NOT_EXIT = 'FA_USER_NOT_EXIT'                          #登录，或重置密码时，用户(账号)不存在
  FA_NEED_VERIFY_CODE = 'FA_NEED_VERIFY_CODE'                    #注册或找回密码时，没有短信验证码
  FA_INVALID_VERIFY_CODE = 'FA_INVALID_VERIFY_CODE'              #注册或找回密码时，短信验证码不正确
  FA_VERIFY_CODE_EXPIRED = 'FA_VERIFY_CODE_EXPIRED'              #验证码过期了，应重新请求生成新的验证码
  FA_INVALID_USER_NAME_FORMAT = 'FA_INVALID_USER_NAME_FORMAT'    #非法的用户名格式
  FA_INVALID_PASSWORD_FORMAT = 'FA_INVALID_PASSWORD_FORMAT'      #非法的密码格式
  FA_PASSWORD_ERROR = 'FA_PASSWORD_ERROR'                        #登录时或修改密码时，当前密码错误
  FA_ACCESS_TOKEN_NOT_EXIT = 'FA_ACCESS_TOKEN_NOT_EXIT'          #校验用户JWT时，不存在JWT
  FA_JWT_SIGNATURE_ERROR = 'FA_JWT_SIGNATURE_ERROR'              #校验用户JWT时，签名错误
  FA_SIGN_IN_TIME_INCONSISTENT = 'FA_SIGN_IN_TIME_INCONSISTENT'  #校验用户JWT时，用户最后登陆时间不一致
  FA_SIGN_IN_TIME_EXPIRED = 'FA_SIGN_IN_TIME_EXPIRED'            #校验用户JWT时，用户最后登陆时间失效
  FA_UNAUTHORIZED = 'FA_UNAUTHORIZED'  #用户权限不足

  # 关注
  FA_SELF_RELATIONSHIP_ERROR = 'FA_SELF_RELATIONSHIP_ERROR' #自己关注自己
  FA_RELATIONSHIP_ALREADY_EXIT = 'FA_RELATIONSHIP_ALREADY_EXIT' #指关注某人时，关系已存在
  FA_RELATIONSHIP_NOT_EXIT = 'FA_RELATIONSHIP_NOT_EXIT' #指取消关注某人时，关系不存在

  #问答存草稿
  FA_QUESTION_ALREADY_ANSWERED = 'FA_QUESTION_ALREADY_ANSWERED' #问题已经被该用户回答，所以无法存草稿

end