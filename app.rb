require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/namespace'
require_relative 'secrets'
require_relative 'helpers/html.rb'
require_relative 'helpers/weight.rb'
require_relative 'helpers/angler.rb'
require_relative 'helpers/event.rb'
require_relative 'helpers/lake.rb'
require_relative 'helpers/calculator.rb'
require_relative 'helpers/randomizer.rb'

# set port and binding
set :bind, '0.0.0.0'
set :port, 8081

# enable sessions
use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => Secrets.session_secret

# presets - load classes
before do
  @HTML = HTML.new
end

###########
# methods #
###########

def submit_session_info
  # persist options for existing session
  @angler_list = @HTML.persist_angler(session[:angler]) if session[:angler]
  @event_list = @HTML.persist_event(session[:event]) if session[:event]
  @state_list = @HTML.persist_state(session[:state]) if session[:state]
  @bass_type = @HTML.persist_bass_type(session[:bass_type]) if session[:bass_type]
  @lake_list = @HTML.persist_lake(session[:lake]) if session[:lake]

  # new lists if no session found
  @angler_list = @HTML.angler_list if session[:angler].nil?
  @event_list = @HTML.event_list if session[:event].nil?
  @state_list = @HTML.state_list if session[:state].nil?
  @bass_type = @HTML.bass_type if session[:bass_type].nil?
  @lake_list = @HTML.lake_list if session[:lake].nil?
end

def options_session_info
  # for angler/event/lake options
  @angler_list_options = @HTML.angler_list
  @event_list_options = @HTML.event_list
  @lake_list_options = @HTML.lake_list
end

#############
# Endpoints #
#############

# main page for submission
get '/basstracker/submit' do
  session_info
  @submit_message = session[:successful_submit]
  erb :main
end

# options
get '/basstracker/options' do
  options_session_info
  @submit_angler_option_message = session[:angler_option_successful_submit]
  #@submit_remove_angler_message = session[:remove_angler_successful_submit]
  @submit_event_option_message = session[:event_option_successful_submit]
  #@submit_remove_event_message = session[:remove_event_successful_submit]
  @submit_lake_option_message = session[:lake_option_successful_submit]
  #@submit_remove_lake_message = session[:remove_lake_successful_submit]
  erb :options
end

# weight submission
post '/basstracker/submit_weight' do
  # set session vars
  session[:angler] = params['angler']
  session[:event] = params['event']
  session[:state] = params['state']
  session[:bass_type] = params['bass_type']
  session[:lake] = params['lake']

  # submit weight
  response = Weight.new(params['angler'], params['event'], params['weight'], params['bass_type'], params['state'], params['lake']).submit
  if response != 'success'
    session[:err_message] = response
    redirect '/basstracker/error'
  end

  session[:successful_submit] = "Submitted #{params['weight']} lbs by #{params['angler']} successfully!"
  redirect back
end

# new angler submission
post '/basstracker/submit_new_angler' do
  response = Angler.new(params['new_angler']).add_angler
  if response != 'success'
    session[:err_message] = response
    redirect '/basstracker/error'
  end

  session[:angler_option_successful_submit] = "Added #{params['new_angler']} successfully!"
  redirect back
end

# remove angler submission
post '/basstracker/submit_remove_angler' do
  response = Angler.new(params['remove_angler']).remove_angler
  if response != 'success'
    session[:err_message] = response
    redirect '/basstracker/error'
  end

  session[:angler_option_successful_submit] = "Removed #{params['remove_angler']} successfully!"
  redirect back
end

# new event submission
post '/basstracker/submit_new_event' do
  response = Event.new(params['new_event']).add_event
  if response != 'success'
    session[:err_message] = response
    redirect '/basstracker/error'
  end

  session[:event_option_successful_submit] = "Added #{params['new_event']} successfully!"
  redirect back
end

# remove event submission
post '/basstracker/submit_remove_event' do
  response = Event.new(params['remove_event']).remove_event
  puts "response is => #{response}"
  if response != 'success'
    session[:err_message] = response
    redirect '/basstracker/error'
  end

  session[:event_option_successful_submit] = "Removed #{params['remove_event']} successfully!"
  redirect back
end

# new lake submission
post '/basstracker/submit_new_lake' do
  response = Lake.new(params['new_lake']).add_lake
  if response != 'success'
    session[:err_message] = response
    redirect '/basstracker/error'
  end

  session[:lake_option_successful_submit] = "Added #{params['new_lake']} successfully!"
  redirect back
end

# remove lake submission
post '/basstracker/submit_remove_lake' do
  response = Lake.new(params['remove_lake']).remove_lake
  puts "response is => #{response}"
  if response != 'success'
    session[:err_message] = response
    redirect '/basstracker/error'
  end

  session[:lake_option_successful_submit] = "Removed #{params['remove_lake']} successfully!"
  redirect back
end

##############
# calculator #
##############

# calculator page
get '/basstracker/calculator' do
  if session[:total_weight_lbs_oz] && session[:total_weight_decimal]
    @result = @HTML.calculator_result( \
      session[:input_weights], \
      session[:input_weights_in_oz], \
      session[:total_weight_lbs_oz], \
      session[:total_weight_decimal] \
    )
    session[:input_weights], session[:input_weights_in_oz], session[:total_weight_lbs_oz], session[:total_weight_decimal] = nil
  end
  erb :calc
end

# calculate weights
post '/basstracker/calculate_weights' do
  response = Calculator.new(params['weights']).total_weight
  if response.class != Hash
    session[:err_message] = response
    redirect '/basstracker/error'
  end
  session[:input_weights] = response['input_weights']
  session[:input_weights_in_oz] = response['input_weights_in_oz']
  session[:total_weight_lbs_oz] = response['total_lbs_oz']
  session[:total_weight_decimal] = response['total_decimal']
  redirect back
end

##############
# randomizer #
##############

# main page
get '/basstracker/randomizer' do
  if session[:input_result]
    @input_result = @HTML.randomizer_input(session[:input_result])
    session[:input_result] = nil
  elsif session[:passphrase_list]
    @passphrase_list = @HTML.randomizer_passphrases(session[:passphrase_list])
    session[:passphrase_list] = nil
  elsif session[:draw_result]
    @draw_result = @HTML.randomizer_draw_no_result(session[:draw_result])
    session[:draw_result] = nil
  elsif session[:sample] && session[:old_count] && session[:new_count] && session[:number_of_sample_removed]
    @draw_result = @HTML.randomizer_draw( \
      session[:passphrase], \
      session[:sample], \
      session[:old_count], \
      session[:new_count], \
      session[:number_of_sample_removed]
    )
    session[:passphrase], session[:count], session[:sample] = nil
  elsif session[:delete_result]
    @delete_result = @HTML.randomizer_delete(session[:delete_result])
    session[:delete_result] = nil
  end

  erb :randomizer
end

# randomizer input
post '/basstracker/randomizer_input' do
  response = Randomizer.new(params['passphrase'], params['entry']).store
  if response != true
    session[:err_message] = response
    redirect '/basstracker/error'
  end
  session[:input_result] = "#{params['entry']} added to Passphrase: #{params['passphrase'].downcase.gsub(' ', '')} successfully!"
  redirect back
end

# randomizer show passphrases
post '/basstracker/randomizer_passphrases' do
  response = Randomizer.new.passphrase_list
  unless response.is_a?(Array)
    session[:err_message] = response
    redirect '/basstracker/error'
  end

  session[:passphrase_list] = response

  redirect back
end

# randomizer draw
post '/basstracker/randomizer_draw' do
  response = Randomizer.new(params['passphrase']).draw

  if response.is_a?(Hash)
    session[:passphrase] = params['passphrase']
    session[:sample] = response['sample']
    session[:old_count] = response['old_count']
    session[:new_count] = response['new_count']
    session[:number_of_sample_removed] = response['number_of_sample_removed']
  elsif response.is_a?(String)
    session[:draw_result] = response
  end

  redirect back
end

# randomizer delete
post '/basstracker/randomizer_delete' do
  response = Randomizer.new(params['passphrase']).delete
  unless response.include?('successfully') || response.include?('not found')
    session[:err_message] = response
    redirect '/basstracker/error'
  end

  session[:delete_result] = response

  redirect back
end

################
# error routes #
################

get '/basstracker/error' do
  @error_message = session[:err_message]
  erb :error
end
