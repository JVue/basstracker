require 'redis'
require_relative '../secrets'

class Randomizer
  def initialize(passphrase, value = nil)
    @redis = Redis.new(host: '192.168.1.12', port: 6379, password: Secrets.redis_password)
    raise 'Redis connection failed' if @redis.ping != 'PONG'
    @configs = {'passphrase' => passphrase.to_s.downcase, 'value' => value.to_s.downcase}
  end

  def store
    response = @redis.lpush(@configs['passphrase'], @configs['value'])
    raise "Failed to store value: #{@configs['value']} under passphrase: #{@configs['passphrase']}" unless response.is_a?(Integer)
    true
  rescue StandardError => err
    err.message
  end

  def list
    results = @redis.lrange(@configs['passphrase'], 0, @redis.llen(@configs['passphrase']))
    return "No value(s) found for passphrase: #{@configs['passphrase']}" if results.nil? || results.empty? || results.length.zero?
    results
  end

  def output
    passphrase_list = list
    return passphrase_list if passphrase_list.is_a?(String)
    {
        'list'   => passphrase_list.sort,
        'count'  => passphrase_list.length,
        'sample' => passphrase_list.sample
    }
  end

  def count
    list.length
  end

  def remove
    @redis.ltrim(@configs['passphrase'], 1000, -1)
  end
end
