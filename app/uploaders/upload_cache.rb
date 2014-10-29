require 'singleton'

class UploadCache
  include Singleton
  @avatars_cache = nil

  def initialize
    @avatars_cache = ActiveSupport::Cache::MemoryStore.new(expires_in: 5.minutes)
  end

  def write(key, val)
    @avatars_cache.write(key, val);
  end

  def read(key)
    @avatars_cache.read(key);
  end
end