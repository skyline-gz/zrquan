require 'singleton'

class VerifyCodeCache
  include Singleton
  @verify_code_cache = nil

  def initialize
    min = Settings.cache.verify_code_experied_minute
    @verify_code_cache = ActiveSupport::Cache::MemoryStore.new(expires_in: min.minutes)
  end

  def write(key, val)
    @verify_code_cache.write(key, val);
  end

  def read(key)
    @verify_code_cache.read(key);
  end
end