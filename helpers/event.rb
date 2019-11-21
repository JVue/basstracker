require_relative 'db'

class Event
  def initialize(event)
    @db = DB.new
    @event = event
  end

  def add_event
    validate_name
    @db.add_event(@event)
    @db.close_db_connection
    'success'
  rescue StandardError => err
    err.message
  end

  def remove_event
    event_exists?
    @db.remove_event(@event)
    @db.close_db_connection
    'success'
  rescue StandardError => err
    err.message
  end

  def validate_name
    raise 'Error: New event name is blank/missing.' if @event.nil? || @event.empty?
    @event = @event.downcase
    raise "Error: Event #{@event} already exists." if @db.get_events.include?(@event)
    true
  end

  def event_exists?
    raise "Error: Event #{@event} does not exists." unless @db.get_events.include?(@event)
    true
  end
end
