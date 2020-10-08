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

  def bass_type
    <<~HTML
    <input type="radio" name="bass_type" value="largemouth"> largemouth
    <input type="radio" name="bass_type" value="smallmouth"> smallmouth
    HTML
  end

  def persist_bass_type(bass_type_selected)
    case bass_type_selected
    when 'largemouth'
      <<~HTML
      <input type="radio" name="bass_type" value="largemouth" checked="checked"> largemouth
      <input type="radio" name="bass_type" value="smallmouth"> smallmouth
      HTML
    when 'smallmouth'
      <<~HTML
      <input type="radio" name="bass_type" value="largemouth"> largemouth
      <input type="radio" name="bass_type" value="smallmouth" checked="checked"> smallmouth
      HTML
    end
  end

  def lakes
    list = []
    @db.get_lakes.each do |lake|
      list << "<option value=\"#{lake}\">#{lake}</option>"
    end
    @db.close_db_connection
    list.join(',').gsub(',', "\n")
  end

  def persist_lake(lake_selected)
    list = []
    @db.get_lakes.each do |lake|
      if lake_selected == lake
        list << "<option value=\"#{lake}\" selected>#{lake}</option>"
        next
      end
      list << "<option value=\"#{lake}\">#{lake}</option>"
    end
    @db.close_db_connection
    list.join(',').gsub(',', "\n")
  end

  def calculator_result(input_weights, input_weights_in_oz, lbs_oz, decimal)
    <<~HTML
    <p align="left">
      <b>Submitted weights:</b>
      <br>
      Input values:    #{input_weights}
      <br>
      Converted to oz: #{input_weights_in_oz}
      <br>
      <br>
      <b>Total:</b>
      <br>
      lbs-oz:  #{lbs_oz}
      <br>
      decimal: #{decimal}
    </p>
    HTML
  end
end
