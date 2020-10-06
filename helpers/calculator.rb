class Calculator
  def initialize(weights_str)
    @weights = weights_str
    @weights = sanitize_input_string
  end

  def sanitize_input_string
    input_str = @weights.downcase
    raise 'Input string contains a letter character.' if input_str.match(/[a-z]/)
    convert_to_oz_array(input_str)
  end

  def convert_to_oz_array(weights_str)
    arr = []
    weights_arr = convert_string_to_array(weights_str)
    weights_arr.each do |weight|
      raise 'A value is empty or contains too many spaces / invalid characters.' unless weight.match(/\d/)
      raise "Value: #{weight} is invalid." if weight.include?('-') && weight.include?('.')
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

  def convert_string_to_array(weights_str)
    return weights_str.split(',') if weights_str.include?(',')
    weights_str.split(' ')
  rescue StandardError => err
    err.message
  end

  def total_weight
    {
      'total_lbs_oz'  => lbs_oz_total(@weights.inject(:+)),
      'total_decimal' => decimal_total(@weights.inject(:+))
    }
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
