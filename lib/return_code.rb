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
  FA_UNAUTHORIZED = 'FA_UNAUTHORIZED'  #用户权限不足
  FA_USER_ALREADY_EXIT = 'FA_USER_ALREADY_EXIT'              #注册时，用户已经存在
  FA_USER_NOT_EXIT = 'FA_USER_NOT_EXIT'   #登录时，用户(账号)不存在
  FA_PASSWORD_ERROR = 'FA_PASSWORD_ERROR' #登陆时或修改时，当前密码错误
  FA_PASSWORD_INCONSISTENT = 'FA_PASSWORD_INCONSISTENT' #新密码与确认密码不一致
  FA_SESSION_HAS_BEEN_CREATED = 'FA_SESSION_HAS_BEEN_CREATED'  #SESSION已被创建，可能是同一客户端重复登陆
  FA_SMTP_AUTHENTICATION_ERROR = 'FA_SMTP_AUTHENTICATION_ERROR'    #Devise　SMTP登陆认证失败


  # 关注
  FA_SELF_RELATIONSHIP_ERROR = 'FA_SELF_RELATIONSHIP_ERROR' #自己关注自己
  FA_RELATIONSHIP_ALREADY_EXIT = 'FA_RELATIONSHIP_ALREADY_EXIT' #指关注某人时，关系已存在
  FA_RELATIONSHIP_NOT_EXIT = 'FA_RELATIONSHIP_NOT_EXIT' #指取消关注某人时，关系不存在

  #问答存草稿
  FA_QUESTION_ALREADY_ANSWERED = 'FA_QUESTION_ALREADY_ANSWERED' #问题已经被该用户回答，所以无法存草稿

end