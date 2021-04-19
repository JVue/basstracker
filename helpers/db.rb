require 'pg'
require_relative '../secrets'

# class to manage generic db functions
class DB
  def initialize
    @pg = PG.connect :hostaddr => Secrets.db_hostaddress, :dbname => Secrets.db_name, :user => Secrets.db_username, :password => Secrets.db_password
  end

  def add_weight_entry(date, time, angler, event, weight, weight_decimal, weight_oz, bass_type, state, lake = nil)
    response = @pg.exec "INSERT INTO basstracker (date, time, angler, event, weight, weight_decimal, weight_oz, bass_type, state, lake) VALUES(\'#{date}\', \'#{time}\', \'#{angler}\', \'#{event}\', \'#{weight}\', \'#{weight_decimal}\', \'#{weight_oz}\', \'#{bass_type}\', \'#{state}\', \'#{lake}\')"
    return false if response.result_status != 1

    true
  end

  def get_weight_entry(time, date, angler, event, weight, bass_type, state, lake)
    response = @pg.exec "SELECT * FROM basstracker WHERE date=\'#{date}\' AND time=\'#{time}\' AND angler=\'#{angler}\' AND event=\'#{event}\' AND weight=\'#{weight}\' AND bass_type=\'#{bass_type}\' AND state=\'#{state}\' AND lake=\'#{lake}\'"
    return false if response.result_status == 0

    true
  end

  def get_db_field_values(table_name, field)
    response = @pg.exec "SELECT #{field} FROM #{table_name}"
    list = []
    response.values.each do |i|
      list << i[0]
    end
    list.sort
  end

  def add_db_value(table_name, field, value)
    response = @pg.exec "INSERT INTO #{table_name} (#{field}) VALUES(\'#{value}\')"
    return false if response.result_status != 1

    true
  end

  def delete_db_value(table_name, field, value)
    response = @pg.exec "DELETE FROM #{table_name} WHERE #{field}=\'#{value}\'"
    return false if response.result_status != 1

    true
  end

  def close_db_connection
    @pg.close
  end
end
