require_relative 'db'

# db reference:
# table name: basstracker_events
# field: event

# manage basstracker events
class Event
  def initialize(event)
    @db = DB.new
    @event = event
    @events = events
  end

  def add_event
    validate_name
    insert_new_event(@event)
    'success'
  rescue StandardError => err
    err.message
  end

  def remove_event
    event_exists?
    delete_event(@event)
    'success'
  rescue StandardError => err
    err.message
  end

  def validate_name
    raise 'Error: New event name is blank/missing.' if @event.nil? || @event.empty?

    @event = @event.downcase
    raise "Error: Event #{@event} already exists." if event_exists?

    true
  end

  def event_exists?
    raise "Error: Event field is blank/empty or event #{@event} does not exists." unless @events.include?(@event)

    true
  end

  def events
    list = @db.get_db_field_values('basstracker_events', 'event')
    @db.close_db_connection
    list
  end

  def insert_new_event(event)
    @db.add_db_value('basstracker_events', 'event', event)
    @db.close_db_connection
  end

  def delete_event(event)
    @db.delete_db_value('basstracker_events', 'event', event)
    @db.close_db_connection
  end
end
