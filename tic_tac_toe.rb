require 'sinatra'
require './lib/board.rb'
enable :sessions

get '/' do
  session.clear
  erb :index
end

post '/mark' do
  session[:mark] = params[:player_mark]
  redirect to('/game')
end

get '/game' do
  @player_mark = session[:mark]
  @board = TicTacToe::Board.new(cells: session[:moves])
  session[:moves] = @board.to_array
  erb :board
end

post '/make_move' do
  p params
  p session[:moves]
  move = params[:move].to_i
  board = TicTacToe::Board.new(cells: session[:moves])
  board.set_cell(move, session[:mark])
  session[:moves] = board.to_array
  redirect to('/game')
end
