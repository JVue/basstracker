require_relative 'db'

class HTML
  def initialize
    @db = DB.new
    @anglers = anglers
    @events = events
    @lakes = lakes
  end

  def anglers
    list = @db.get_db_field_values('basstracker_anglers', 'angler')
    #@db.close_db_connection
    list
  end

  def angler_list
    list = []
    @anglers.each do |angler|
      list << "<option value=\"#{angler}\">#{angler}</option>"
    end

    list.join(',').gsub(',', "\n")
  end

  def persist_angler(angler_selected)
    list = []
    @anglers.each do |angler|
      if angler_selected == angler
        list << "<option value=\"#{angler}\" selected>#{angler}</option>"
        next
      end
      list << "<option value=\"#{angler}\">#{angler}</option>"
    end

    list.join(',').gsub(',', "\n")
  end

  def events
    list = @db.get_db_field_values('basstracker_events', 'event')
    #@db.close_db_connection
    list
  end

  def event_list
    list = []
    @events.each do |event|
      list << "<option value=\"#{event}\">#{event}</option>"
    end

    list.join(',').gsub(',', "\n")
  end

  def persist_event(event_selected)
    list = []
    @events.each do |event|
      if event_selected == event
        list << "<option value=\"#{event}\" selected>#{event}</option>"
        next
      end
      list << "<option value=\"#{event}\">#{event}</option>"
    end

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
    list = @db.get_db_field_values('basstracker_lakes', 'lake')
    #@db.close_db_connection
    list
  end

  def lake_list
    list = []
    @lakes.each do |lake|
      list << "<option value=\"#{lake}\">#{lake}</option>"
    end

    list.join(',').gsub(',', "\n")
  end

  def persist_lake(lake_selected)
    list = []
    @lakes.each do |lake|
      if lake_selected == lake
        list << "<option value=\"#{lake}\" selected>#{lake}</option>"
        next
      end
      list << "<option value=\"#{lake}\">#{lake}</option>"
    end

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

  def randomizer_input(input_result)
    <<~HTML
    <p align="center">
      #{input_result}
    </p>
    HTML
  end

  def randomizer_passphrases(list)
    <<~HTML
    <p align="center">
      Existing Passphrases:
      <br>
      #{list.to_s.gsub("\"", '').gsub('[', '').gsub(']', '')}
    </p>
    HTML
  end

  def randomizer_draw_no_result(draw_result)
    <<~HTML
    <p align="center">
      #{draw_result}
    </p>
    HTML
  end

  def randomizer_draw(passphrase, list, count, sample)
    value_list = list.to_s.gsub("\"", '').gsub('[', '').gsub(']', '')
    <<~HTML
    <p align="center">
      Random draw: <h1><i>#{sample}</i></h1>
      Passphrase: #{passphrase}
      <br>
      Entry count: #{count}
      <br>
      <br>
      Entries:
      <br>
      #{value_list}
    </p>
    HTML
  end

  def randomizer_delete(delete_result)
    <<~HTML
    <p align="center">
      #{delete_result}
    </p>
    HTML
  end

  def state_list
    list = []
    states.each do |state|
      list << "<option value=\"#{state}\">#{state}</option>"
    end

    list.join(',').gsub(',', "\n")
  end

  def states
    %w[
      alabama
      alaska
      american samoa
      arizona
      arkansas
      california
      colorado
      connecticut
      delaware
      district of columbia
      florida
      georgia
      guam
      hawaii
      idaho
      illinois
      indiana
      iowa
      kansas
      kentucky
      louisiana
      maine
      maryland
      massachusetts
      michigan
      minnesota
      minor outlying islands
      mississippi
      missouri
      montana
      nebraska
      nevada
      new hampshire
      new jersey
      new mexico
      new york
      north carolina
      north dakota
      northern mariana islands
      ohio
      oklahoma
      oregon
      pennsylvania
      puerto rico
      rhode island
      south carolina
      south dakota
      tennessee
      texas
      u.s. virgin islands
      utah
      vermont
      virginia
      washington
      west virginia
      wisconsin
      wyoming
    ]
  end
end
