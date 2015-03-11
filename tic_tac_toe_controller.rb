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
      game = create_game(params)

      if computer_opponent(params) == "player1"
        game.take_turn(game.generate_ai_move)
        game.switch_turn
      end

      session[:computer_opponent] = computer_opponent(params)
      session[:player_settings] = player_settings(params)
      session[:current_player_mark] = game.current_player_mark
      session[:player1] = game.player1
      session[:player2] = game.player2
      session[:moves] = game.board_to_array
      redirect to('/game')
    end
  end

  get '/game' do
    @board = TicTacToe::Board.new(cells: session[:moves])
    erb :board
  end

  post '/make_move' do
    board = array_to_board(session[:moves])
    game = TicTacToe::Game.new(board, session[:player_settings], session[:current_player_mark])

    move = params[:move].to_i
    game.take_turn(move)
    game.switch_turn

    if !game.in_progress?
      session[:moves] = game.board_to_array
      redirect to('/game_over')
    end

    if session[:computer_opponent] != nil
      game.take_turn(game.generate_ai_move)
      game.switch_turn
    end

    session[:moves] = game.board_to_array
    session[:current_player_mark] = game.current_player_mark
    redirect to('/game_over') if !game.in_progress?
    redirect to('/game')
  end

  get '/game_over' do
    @board = TicTacToe::Board.new(cells: session[:moves])
    erb :game_over
  end

  run! if app_file == $0
end