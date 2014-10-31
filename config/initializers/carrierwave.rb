::CarrierWave.configure do |config|
  config.storage             = :qiniu
  config.qiniu_access_key    = "cC74qHcGrQ369MTrJRosCjocP_pL2dAgsyMsd_R8"
  config.qiniu_secret_key    = 'VIJwpQbkbvFaAEY4it54i-Vgh8ZsaCaEz_2Md--j'
  config.qiniu_bucket        = "zrquan"
  config.qiniu_bucket_domain = "zrquan.qiniudn.com"
  config.qiniu_bucket_private= false #default is false
  config.qiniu_block_size    = 4*1024*1024
  config.qiniu_protocol      = "http"
end