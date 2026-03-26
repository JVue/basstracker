require 'redis'
require_relative '../secrets'

# redis helper class to interface with redis db
class RedisHelper
  def initialize
    @redis = Redis.new(host: ENV.fetch('REDIS_HOST', 'localhost'), port: ENV.fetch('REDIS_PORT', 6379).to_i, password: Secrets.redis_password)
    raise 'Redis connection failed' if @redis.ping != 'PONG'

  end

end
