module Secrets
  def self.session_secret = ENV.fetch('SESSION_SECRET')
  def self.db_hostaddress = ENV.fetch('DB_HOST')
  def self.db_name        = ENV.fetch('DB_NAME')
  def self.db_username    = ENV.fetch('DB_USER')
  def self.db_password    = ENV.fetch('DB_PASSWORD')
  def self.redis_password = ENV.fetch('REDIS_PASSWORD')
end
