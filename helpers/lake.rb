require_relative 'db'

class Lake
  def initialize(lake)
    @db = DB.new
    @lake = lake
  end

  def add_lake
    validate_name
    @db.add_lake(@lake)
    @db.close_db_connection
    'success'
  rescue StandardError => err
    err.message
  end

  def remove_lake
    lake_exists?
    @db.remove_lake(@lake)
    @db.close_db_connection
    'success'
  rescue StandardError => err
    err.message
  end

  def validate_name
    raise 'Error: New lake name is blank/missing.' if @lake.nil? || @lake.empty?
    @lake = @lake.downcase
    raise "Error: Lake #{@lake} already exists." if @db.get_lakes.include?(@lake)
    true
  end

  def lake_exists?
    raise "Error: Lake #{@lake} does not exists." unless @db.get_lakes.include?(@lake)
    true
  end
end
