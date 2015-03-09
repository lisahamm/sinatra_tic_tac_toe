require 'sinatra/base'
require 'rack-flash'
require 'tic_tac_toe'
require './lib/game_setup'
require './lib/game_helpers'


class TicTacToeController < Sinatra::Base
  enable :sessions
  use Rack::Flash
  include GameHelpers

  get '/' do
    session.clear
    erb :index
  end

  post '/setup' do
    @setup = GameSetup.new(params)
    if @setup.invalid?
      flash[:errors] = @setup.errors
      erb :index
    else
      session[:game] = create_game(params)
      session[:computer_opponent] = params[:computer_opponent]
      redirect to('/game')
    end
  end

  get '/game' do
    @board = TicTacToe::Board.new(cells: session[:moves])
    session[:moves] = @board.to_array
    erb :board
  end

  post '/make_move' do
    move = params[:move].to_i
    game = session[:game]
    game.take_turn(move)
    game.switch_turn
    session[:game] = game
    session[:moves] = game.board.to_array
    redirect to('/game_over') if !game.in_progress?
    # if session[:computer_opponent] == 'yes'
    #   @computer_player = TicTacToe::AI.new(player_mark)
    #   @computer_player.take_turn(board)
    #   session[:moves] = board.to_array
    #   player_mark = session[:mark] == 'X' ? 'O' : 'X'
    #   session[:mark] = player_mark
    # end
    redirect to('/game')
  end

  get '/game_over' do
    @board = TicTacToe::Board.new(cells: session[:moves])
    erb :game_over
  end

  run! if app_file == $0
end