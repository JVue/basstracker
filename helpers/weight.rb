require_relative 'db'

class Weight
  def initialize(angler, event, weight, bass_type)
    @db = DB.new
    @datetime = Time.now.strftime("%m/%d/%Y,%I:%M %p").split(',')
    @angler_name = angler
    @event = event
    @weight = weight
    @bass_type = bass_type
  end

  def submit
    # verify inputs
    validate_angler
    validate_event
    validate_weight
    validate_bass_type

    # add angler entry
    submit_angler_entry

    # verify entry submitted successfully
    verify_submission

    # make sure we close db connection to avoid lots of open connections
    @db.close_db_connection

    # return success
    'success'
  rescue StandardError => err
    err.message
  end

  def validate_angler
    raise "ERROR: Angler name is invalid or missing." if @angler_name.nil? || @angler_name.empty?
    @angler_name = @angler_name.downcase
    true
  end

  def validate_event
    raise 'ERROR: Event name is invalid or missing.' if @event.nil? || @event.empty?
    @event = @event.downcase
    true
  end

  def validate_weight
    raise 'ERROR: Weight entry is invalid or missing.' if @weight.nil? || @weight.empty?
    raise 'ERROR: Weight format is incorrect. Needs to be in the "lbs-oz" format (eg: 2-14).' unless @weight.match(/^\d{1,2}-\d{1,2}$/)
    raise 'ERROR: Weight -> lbs section exceeds 25lbs. You are full of shit bitch.' if @weight.scan(/^\d{1,}-/)[0].delete('-').to_i > 25
    raise 'ERROR: Weight -> oz section exceeds 15oz (needs to be below 16). You are fucking dumb!' if @weight.scan(/-\d{1,}$/)[0].delete('-').to_i > 15
    true
  end

  def validate_bass_type
    raise "Error: Bass species (largemouth/smallmouth) not selected. Please select a species and try again." if @bass_type.nil? || @bass_type.empty?
    raise "Error: Bass species type is invalid." unless @bass_type.include?('largemouth') || @bass_type.include?('smallmouth')
    true
  end

  def decimal
    arr = @weight.split('-')
    (((arr[0].to_f * 16) + arr[1].to_f) / 16).to_f
  end

  def ounces
    arr = @weight.split('-')
    (arr[0].to_i * 16) + arr[1].to_i
  end

  def submit_angler_entry
    response = @db.add_entry(@datetime[0], @datetime[1], @angler_name, @event, @weight, decimal, ounces, @bass_type)
    raise 'ERROR: Submission failed.' if response == false
    true
  end

  def verify_submission
    response = @db.get_entry(@datetime[0], @datetime[1], @angler_name, @event, @weight, @bass_type)
    raise 'ERROR: Submission validation failed.' if response == false
    true
  end
end
