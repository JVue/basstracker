require 'redis'
require_relative '../secrets'

# redis helper class to interface with redis db
class RedisHelper
  def initialize
    @redis = Redis.new(host: '192.168.1.12', port: 6379, password: Secrets.redis_password)
    raise 'Redis connection failed' if @redis.ping != 'PONG'

  end

end
