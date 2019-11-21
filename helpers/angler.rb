require_relative 'db'

class Angler
  def initialize(angler)
    @db = DB.new
    @angler = angler
  end

  def add_angler
    validate_name
    @db.add_angler(@angler)
    @db.close_db_connection
    'success'
  rescue StandardError => err
    err.message
  end

  def remove_angler
    angler_exists?
    @db.remove_angler(@angler)
    @db.close_db_connection
    'success'
  rescue StandardError => err
    err.message
  end

  def validate_name
    raise 'Error: New angler name is blank/missing.' if @angler.nil? || @angler.empty?
    @angler = @angler.downcase
    raise "Error: Angler #{@angler} already exists." if @db.get_anglers.include?(@angler)
    true
  end

  def angler_exists?
    raise "Error: Angler field is blank/empty or angler does not exists." unless @db.get_anglers.include?(@angler)
    true
  end
end
