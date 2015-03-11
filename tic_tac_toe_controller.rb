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
      if computer_opponent(params) == 'player1'
        game.take_turn(generate_ai_move)
        switch_turn
      end
      session[:game] = game
      redirect to('/game')
    end
  end

  get '/game' do
    game = session[:game]
    @board = game.board
    erb :board
  end

  post '/make_move' do
    game = session[:game]
    move = params[:move].to_i
    game.take_turn(move)
    game.switch_turn
    redirect to('/game_over') if !game.in_progress?
    game.take_turn(game.generate_ai_move)
    game.switch_turn
    redirect to('/game_over') if !game.in_progress?
    session[:game] = game
    session[:moves] = game.board.to_array
    redirect to('/game')
  end

  get '/game_over' do
    @board = session[:game].board
    erb :game_over
  end

  run! if app_file == $0
end