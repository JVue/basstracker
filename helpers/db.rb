require 'pg'
require_relative '../secrets'

class DB
  def initialize
    @pg = PG.connect :hostaddr => Secrets.db_hostaddress, :dbname => Secrets.db_name, :user => Secrets.db_username, :password => Secrets.db_password
  end

  def add_entry(date, time, angler, event, weight, weight_decimal, weight_oz, bass_type)
    response = @pg.exec "INSERT INTO basstracker (date, time, angler, event, weight, weight_decimal, weight_oz, bass_type) VALUES(\'#{date}\', \'#{time}\', \'#{angler}\', \'#{event}\', \'#{weight}\', \'#{weight_decimal}\', \'#{weight_oz}\', \'#{bass_type}\')"
    return false if response.result_status != 1
    true
  end

  def get_anglers
    response = @pg.exec "SELECT angler FROM basstracker_anglers"
    anglers = []
    response.values.each do |angler|
      anglers << angler[0]
    end
    anglers.sort
  end

  def add_angler(angler)
    response = @pg.exec "INSERT INTO basstracker_anglers (angler) VALUES(\'#{angler}\')"
    return false if response.result_status != 1
    true
  end

  def remove_angler(angler)
    response = @pg.exec "DELETE FROM basstracker_anglers WHERE angler=\'#{angler}\'"
    return false if response.result_status != 1
    true
  end

  def get_events
    response = @pg.exec "SELECT event FROM basstracker_events"
    events = []
    response.values.each do |event|
      events << event[0]
    end
    events.sort
  end

  def add_event(event)
    response = @pg.exec "INSERT INTO basstracker_events (event) VALUES(\'#{event}\')"
    return false if response.result_status != 1
    true
  end

  def remove_event(event)
    response = @pg.exec "DELETE FROM basstracker_events WHERE event=\'#{event}\'"
    return false if response.result_status != 1
    true
  end

  def get_entry(time, date, angler, event, weight, bass_type)
    response = @pg.exec "SELECT * FROM basstracker WHERE date=\'#{date}\' AND time=\'#{time}\' AND angler=\'#{angler}\' AND event=\'#{event}\' AND weight=\'#{weight}\' AND bass_type=\'#{bass_type}\'"
    return false if response.result_status == 0
    true
  end

  def close_db_connection
    @pg.close
  end
end
