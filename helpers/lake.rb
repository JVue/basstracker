require_relative 'db'

# db reference:
# table name: basstracker_lakes
# field: lake

# manage basstracker lakes
class Lake
  def initialize(lake)
    @db = DB.new
    @lake = lake
    @lakes = lakes
  end

  def add_lake
    validate_name
    insert_new_lake
    'success'
  rescue StandardError => err
    err.message
  end

  def remove_lake
    lake_exists?
    delete_lake
    'success'
  rescue StandardError => err
    err.message
  end

  def validate_name
    raise 'Error: New lake name is blank/missing.' if @lake.nil? || @lake.empty?

    @lake = @lake.downcase
    raise "Error: Lake #{@lake} already exists." if lake_exists?

    true
  end

  def lake_exists?
    raise "Error: Lake field is blank/empty or lake #{@lake} does not exists." unless @lakes.include?(@lake)

    true
  end

  def lakes
    list = @db.get_db_field_values('basstracker_lakes', 'lake')
    @db.close_db_connection
    list
  end

  def insert_new_lake
    @db.add_db_value('basstracker_lakes', 'lake', @lake)
    @db.close_db_connection
  end

  def delete_lake
    @db.delete_db_value('basstracker_lakes', 'lake', @lake)
    @db.close_db_connection
  end
end
