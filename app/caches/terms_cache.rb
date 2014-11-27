require 'singleton'

class TermsCache
  include Singleton
  @terms_cache = nil

  def initialize
    min = 60
    @terms_cache = ActiveSupport::Cache::MemoryStore.new(expires_in: min.minutes)
  end

  def write(key, val)
    @terms_cache.write(key, val);
  end

  def read(key)
    @terms_cache.read(key);
  end
end