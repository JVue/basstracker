require_relative 'db'

class HTML
  def initialize
    @db = DB.new
  end

  def anglers
    list = []
    @db.get_anglers.each do |angler|
      list << "<option value=\"#{angler}\">#{angler}</option>"
    end
    @db.close_db_connection
    list.join(',').gsub(',', "\n")
  end

  def persist_angler(angler_selected)
    list = []
    @db.get_anglers.each do |angler|
      if angler_selected == angler
        list << "<option value=\"#{angler}\" selected>#{angler}</option>"
        next
      end
      list << "<option value=\"#{angler}\">#{angler}</option>"
    end
    @db.close_db_connection
    list.join(',').gsub(',', "\n")
  end

  def events
    list = []
    @db.get_events.each do |event|
      list << "<option value=\"#{event}\">#{event}</option>"
    end
    @db.close_db_connection
    list.join(',').gsub(',', "\n")
  end

  def persist_event(event_selected)
    list = []
    @db.get_events.each do |event|
      if event_selected == event
        list << "<option value=\"#{event}\" selected>#{event}</option>"
        next
      end
      list << "<option value=\"#{event}\">#{event}</option>"
    end
    @db.close_db_connection
    list.join(',').gsub(',', "\n")
  end
end
