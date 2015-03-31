require 'sinatra/base'
require 'rack-flash'
require 'tic_tac_toe'
require './lib/user_setup_validation'
require './lib/game_setup'
require './lib/game_helpers'
require './lib/database'
require 'sequel'
require 'yaml'

ENV['RACK_ENV'] ||= 'development'

class TicTacToeController < Sinatra::Base
  use Rack::Flash
  include GameHelpers

  configure do
    enable :sessions
    set :session_secret, ENV['SESSION_SECRET'] || 'session secret'
    database_yaml_file_path = File.expand_path(File.join(File.dirname(__FILE__), 'config', 'database.yml'))
    config = YAML.load_file(database_yaml_file_path)
    puts ENV['RACK_ENV']
    Database.init!(config[ENV['RACK_ENV']])
  end

  get '/' do
    session.clear
    erb :index
  end

  post '/setup' do
    @user_setup = UserSetupValidation.new(params)
    if @user_setup.invalid?
      flash[:errors] = @user_setup.errors
      erb :index
    else
      game_setup = GameSetup.new(params)
      game = game_setup.create_game!
      check_for_computer_turn(game)
      session[:player_marks] = game_setup.options[:player_marks]
      session[:current_player_mark] = game.current_player_mark
      session[:ai_mark] = game.ai_mark
      session[:moves] = game.board_to_array
      redirect to('/game')
    end
  end

  get '/game' do
    @board = array_to_board(session[:moves])
    erb :board
  end

  post '/make_move' do
    options = {}
    options[:player_marks] = session[:player_marks]
    options[:current_player_mark] = session[:current_player_mark]
    options[:ai_mark] = session[:ai_mark]
    options[:board] = array_to_board(session[:moves])
    game = TicTacToe::Game.new(options)
    move = params[:move].to_i
    game.take_turn(move)

    if game.over?
      session[:moves] = game.board_to_array
      redirect to('/game_over')
    end

    check_for_computer_turn(game)

    session[:moves] = game.board_to_array
    session[:current_player_mark] = game.current_player_mark
    if game.over?
      session[:winning_player] = game.get_winning_player
      redirect to('/game_over')
    end
    redirect to('/game')
  end

  get '/game_over' do

    game_hash = {:player1_mark => session[:player1_mark],
            :player2_mark => session[:player2_mark],
            :computer_player_mark => session[:computer_opponent],
            :moves => moves_to_string(session[:moves]),
            :time => Time.now}

    Database.save_game(game_hash)
    @games = Database.games
    @winning_player = session[:winning_player]
    erb :game_over
  end

  run! if app_file == $0
end