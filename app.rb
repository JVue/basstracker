require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/namespace'
require_relative 'secrets'
require_relative 'helpers/html.rb'
require_relative 'helpers/weight.rb'
require_relative 'helpers/angler.rb'
require_relative 'helpers/event.rb'

# set port and binding
set :bind, '0.0.0.0'
set :port, 8081

# enable sessions
use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => Secrets.session_secret

# presets - load classes
before do
end

#############
# Endpoints #
#############

# main page for submission
get '/basstracker/submit' do
  @angler_list = HTML.new.persist_angler(session[:angler]) if session[:angler]
  @event_list = HTML.new.persist_event(session[:event]) if session[:event]
  @bass_type = HTML.new.persist_bass_type(session[:bass_type]) if session[:bass_type]
  @angler_list = HTML.new.anglers if session[:angler].nil?
  @event_list = HTML.new.events if session[:event].nil?
  @bass_type = HTML.new.bass_type if session[:bass_type].nil?
  @angler_list_options = HTML.new.anglers
  @event_list_options = HTML.new.events
  erb :main
end

# weight submission
post '/basstracker/submit_weight' do
  session[:angler] = params['angler']
  session[:event] = params['event']
  session[:bass_type] = params['bass_type']
  response = Weight.new(params['angler'], params['event'], params['weight'], params['bass_type']).submit
  if response != 'success'
    session[:err_message] = response
    redirect '/basstracker/error'
  end
  redirect back
end

# new angler submission
post '/basstracker/submit_new_angler' do
  response = Angler.new(params['new_angler']).add_angler
  if response != 'success'
    session[:err_message] = response
    redirect '/basstracker/error'
  end
  redirect back
end

# remove angler submission
post '/basstracker/submit_remove_angler' do
  response = Angler.new(params['remove_angler']).remove_angler
  if response != 'success'
    session[:err_message] = response
    redirect '/basstracker/error'
  end
  redirect back
end

# new event submission
post '/basstracker/submit_new_event' do
  response = Event.new(params['new_event']).add_event
  if response != 'success'
    session[:err_message] = response
    redirect '/basstracker/error'
  end
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
  redirect back
end

################
# error routes #
################

get '/basstracker/error' do
  @error_message = session[:err_message]
  erb :error
end
