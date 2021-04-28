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
    @db.close_db_connection
    'success'
  # rescue StandardError => err
  #   err.message
  end

  def remove_event
    raise "Error: Event field is blank/empty or event #{@event} does not exists." unless event_exists?

    delete_event(@event)
    @db.close_db_connection
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
    @events.include?(@event)
  end

  def events
    @db.get_db_field_values('basstracker_events', 'event')
  end

  def insert_new_event(event)
    @db.add_db_value('basstracker_events', 'event', event)
  end

  def delete_event(event)
    @db.delete_db_value('basstracker_events', 'event', event)
  end
end
