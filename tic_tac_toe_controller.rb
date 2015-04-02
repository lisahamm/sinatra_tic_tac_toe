require 'sinatra/base'
require 'rack-flash'
require 'tic_tac_toe'
require './lib/user_setup_validation'
require './lib/game_setup'
require './lib/game_helpers'
require './lib/database'
require './lib/database_helpers'
require 'sequel'
require 'yaml'

ENV['RACK_ENV'] ||= 'development'

class TicTacToeController < Sinatra::Base
  use Rack::Flash
  include GameHelpers
  include DatabaseHelpers

  configure do
    enable :sessions
    set :session_secret, ENV['SESSION_SECRET'] || 'session secret'
    database_yaml_file_path = File.expand_path(File.join(File.dirname(__FILE__), 'config', 'database.yml'))
    config = YAML.load_file(database_yaml_file_path)
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
      game = GameSetup.new(params).create_game
      session[:game_id] = Database.save_game(serialize_game_data(game))
      redirect to('/game')
    end
  end

  get '/game' do
    @board = move_data_to_board(session[:game_id])
    erb :board
  end

  post '/make_move' do
    game = recreate_game(session[:game_id])
    game.take_turn(params[:move].to_i)
    make_move_database_update(session[:game_id], game)
    if game.over?
      session[:winning_player] = game.get_winning_player
      redirect to('/game_over')
    end
    redirect to('/game')
  end

  get '/game_over' do
    @games = Database.games
    @winning_player = session[:winning_player]
    erb :game_over
  end

  run! if app_file == $0
end