require 'sinatra/base'
require 'tic_tac_toe'

class TicTacToeController < Sinatra::Base
  enable :sessions

  get '/' do
    session.clear
    erb :index
  end

  post '/setup' do
    redirect to('/invalid_setup') if params[:player_mark] == nil || params[:opponent] == nil
    session[:mark] = params[:player_mark]
    session[:opponent] = params[:opponent]
    redirect to('/game')
  end

  get '/invalid_setup' do
    erb :index_with_validation_messages
  end

  get '/game' do
    @board = TicTacToe::Board.new(cells: session[:moves])
    session[:moves] = @board.to_array
    erb :board
  end

  post '/make_move' do
    move = params[:move].to_i
    board = TicTacToe::Board.new(cells: session[:moves])
    board.set_cell(move, session[:mark])
    session[:moves] = board.to_array
    redirect to('/game_over') if board.winner? || board.tie_game?
    player_mark = session[:mark] == 'X' ? 'O' : 'X'
    session[:mark] = player_mark
    if session[:opponent] == 'yes'
      @computer_player = TicTacToe::ComputerPlayer.new(player_mark)
      @computer_player.take_turn(board)
      session[:moves] = board.to_array
      player_mark = session[:mark] == 'X' ? 'O' : 'X'
      session[:mark] = player_mark
    end
    redirect to('/game')
  end

  get '/game_over' do
    @board = TicTacToe::Board.new(cells: session[:moves])
    erb :game_over
  end

  run! if app_file == $0
end