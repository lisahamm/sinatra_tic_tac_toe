require 'sinatra'
enable :sessions

get '/' do
  session.clear
  erb :index
end

post '/' do
  erb :game
end

post '/make_move' do
  erb :game
end