require_relative 'db'

# db reference:
# table name: basstracker_anglers
# field: angler

# manage basstracker anglers
class Angler
  def initialize(angler)
    @db = DB.new
    @angler = angler
    @anglers = anglers
  end

  def add_angler
    validate_name
    insert_new_angler
    'success'
  rescue StandardError => err
    err.message
  end

  def remove_angler
    angler_exists?
    delete_angler
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
    raise "Error: Angler field is blank/empty or angler #{@angler} does not exists." unless @anglers.include?(@angler)

    true
  end

  def anglers
    list = @db.get_db_field_values('basstracker_anglers', 'angler')
    @db.close_db_connection
    list
  end

  def insert_new_angler
    @db.add_db_value('basstracker_anglers', 'angler', @angler)
    @db.close_db_connection
  end

  def delete_angler
    @db.delete_db_value('basstracker_anglers', 'angler', @angler)
    @db.close_db_connection
  end
end
