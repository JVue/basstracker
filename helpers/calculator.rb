class Calculator
  def initialize(weights_str)
    @weights_str = weights_str
  end

  def create_arrays
    sanitize_input_string(@weights_str)
    @weights_input_array = convert_string_to_array(@weights_str)
    @weights_input_array_in_oz = convert_to_oz_array(@weights_input_array)
  end

  def sanitize_input_string(weights_str)
    raise 'Input string contains a letter character.' if weights_str.match(/[a-z]{1,}/)
    weights_str.downcase
  end

  def convert_string_to_array(weights_str)
    remove_spaces_from_array(weights_str.split(','))
  end

  def remove_spaces_from_array(array)
    new_array = []
    array.each do |element|
      raise "Value: #{weight} is invalid." if (element.include?('-') && element.include?('.'))
      new_array << element.gsub(' ', '')
    end
    new_array
  end

  def convert_to_oz_array(array)
    arr = []
    array.each do |weight|
      if weight.include?('-')
        arr << convert_lbs_oz_to_oz(weight)
      elsif weight.include?('.')
        arr << convert_decimal_to_oz(weight)
      else
        arr << convert_decimal_to_oz(weight)
      end
    end
    arr
  end

  def convert_array_to_string(array)
    array.to_s.gsub("\"", '').gsub(' ','').gsub('[', '').gsub(']', '').gsub(',', ' + ')
  end

  def total_weight
    create_arrays
    {
      'input_weights' => convert_array_to_string(@weights_input_array),
      'input_weights_in_oz' => convert_array_to_string(@weights_input_array_in_oz),
      'total_lbs_oz'  => lbs_oz_total(@weights_input_array_in_oz.inject(:+)),
      'total_decimal' => decimal_total(@weights_input_array_in_oz.inject(:+))
    }
  rescue StandardError => err
    err.message
  end

  def lbs_oz_total(total_oz)
    arr = (total_oz.to_f / 16).to_s.split('.')
    "#{arr[0]}".to_s + '-' + (".#{arr[1]}".to_f * 16).to_i.to_s
  end

  def decimal_total(total_oz)
    (total_oz.to_f / 16).to_s
  end

  def convert_decimal_to_oz(decimal_weight)
    arr = decimal_weight.to_s.split('.')
    (arr[0].to_i * 16).to_i + (".#{arr[1]}".to_f * 16).to_i
  end

  def convert_lbs_oz_to_oz(lbs_oz_weight)
    arr = lbs_oz_weight.to_s.split('-')
    (arr[0].to_i * 16) + (arr[1].to_i)
  end
end
