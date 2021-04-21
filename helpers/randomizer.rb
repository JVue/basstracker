require 'redis'
require_relative '../secrets'

class Randomizer
  def initialize(passphrase = nil, entry = nil)
    @redis = Redis.new(host: '192.168.1.12', port: 6379, password: Secrets.redis_password)
    raise 'Redis connection failed' if @redis.ping != 'PONG'
    @configs = {'passphrase' => "passphrase_#{passphrase.to_s.downcase.gsub(' ', '')}", 'entry' => entry.to_s.downcase}
  end

  def close_redis_connection
    @redis.close
  end

  def store
    response = @redis.lpush(@configs['passphrase'], @configs['entry'])
    raise "Failed to store entry: #{@configs['entry']} under passphrase: #{passphrase_friendly_name(@configs['passphrase'])}" unless response.is_a?(Integer)
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
    return "No entries found for Passphrase: #{passphrase_friendly_name(@configs['passphrase'])}" if results.nil? || results.empty? || results.length.zero?
    results
  end

  def select_sample(array)
    array.sample
  end

  def remove_item(item)
    @redis.lrem(@configs['passphrase'], ('-' + @redis.llen(@configs['passphrase']).to_s).to_i, item)
  end

  def draw
    passphrase_list = list
    return passphrase_list if passphrase_list.is_a?(String)

    sample = select_sample(passphrase_list.shuffle) # select random element from array
    remove_item(sample) # remove the element from redis list
    old_count = passphrase_list.length
    new_count = list.is_a?(String) ? 0 : list.length
    number_of_sample_removed = old_count - new_count

    {
      'sample' => sample,
      'old_count'  => old_count,
      'new_count' => new_count,
      'number_of_sample_removed' => number_of_sample_removed
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
