require 'redis'
require_relative '../secrets'

class Randomizer
  def initialize(passphrase = nil, value = nil)
    @redis = Redis.new(host: '192.168.1.12', port: 6379, password: Secrets.redis_password)
    raise 'Redis connection failed' if @redis.ping != 'PONG'
    @configs = {'passphrase' => "passphrase_#{passphrase.to_s.downcase.gsub(' ', '')}", 'value' => value.to_s.downcase}
  end

  def close_redis_connection
    @redis.close
  end

  def store
    response = @redis.lpush(@configs['passphrase'], @configs['value'])
    raise "Failed to store value: #{@configs['value']} under passphrase: #{@configs['passphrase']}" unless response.is_a?(Integer)
    true
  rescue StandardError => err
    err.message
  end

  def get_passphrases
    @redis.keys('passphrase_*')
  end

  def passphrase_friendly_name(passphrase)
    passphrase.gsub('passphrase_', '')
  end

  def passphrase_list
    arr = []
    get_passphrases.each { |passphrase| arr << passphrase_friendly_name(passphrase) }
    arr
  end

  def get_list
    @redis.lrange(@configs['passphrase'], 0, @redis.llen(@configs['passphrase']))
  end

  def list
    results = get_list
    return "No entries found for passphrase: #{passphrase_friendly_name(@configs['passphrase'])}" if results.nil? || results.empty? || results.length.zero?
    results
  end

  def draw
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

  def delete
    return "Passphrase: #{passphrase_friendly_name(@configs['passphrase'])} not found." \
    if get_list.nil? \
      || get_list.empty? \
      || get_list.length.zero?

    @redis.ltrim(@configs['passphrase'], 1000, -1)
    raise "Unable to delete passphrase: #{passphrase_friendly_name(@configs['passphrase'])}. Please contact admin." \
    if get_passphrases.include?(@configs['passphrase'])
    "Deleted Passphrase: #{passphrase_friendly_name(@configs['passphrase'])} successfully!"
  end
end
