require 'sinatra/base'
require 'rack-flash'
require 'tic_tac_toe'
require './lib/game_setup'
require './lib/game_helpers'
require 'sequel'

class TicTacToeController < Sinatra::Base
  configure do
    enable :sessions
    set :session_secret, ENV['SESSION_SECRET'] || 'session secret'
  end

  use Rack::Flash
  include GameHelpers
  include DatabaseHelpers

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
      session[:computer_opponent] = computer_opponent(params, game)
      check_for_computer_turn(game, session[:computer_opponent])
      session[:player1_mark] = player_marks(params)[0]
      session[:player2_mark] = player_marks(params)[1]
      session[:current_player_mark] = game.current_player_mark
      session[:moves] = game.board_to_array
      redirect to('/game')
    end
  end

  get '/game' do
    @board = array_to_board(session[:moves])
    erb :board
  end

  post '/make_move' do
    board = array_to_board(session[:moves])
    game = TicTacToe::Game.new(session[:player1_mark], session[:player2_mark], session[:current_player_mark], board)

    move = params[:move].to_i
    game.take_turn(move)

    if game.over?
      session[:moves] = game.board_to_array
      redirect to('/game_over')
    end

    check_for_computer_turn(game, session[:computer_opponent])

    session[:moves] = game.board_to_array
    session[:current_player_mark] = game.current_player_mark
    redirect to('/game_over') if game.over?
    redirect to('/game')
  end

  get '/game_over' do

    DB = Sequel.connect('postgres://localhost/tictactoe')
    moves = session[:moves].map do |move|
              if move == nil
                "nil"
              else
                move
              end
            end

    moves_string = ""
    moves.each {|move| moves_string << move + " "}
    moves_string = moves_string.strip

    games = DB[:games]
    games.insert(:player1_mark => session[:player1_mark],
                 :player2_mark => session[:player2_mark],
                 :computer_player_mark => session[:computer_opponent],
                 :moves => moves_string)
    games.each do |row|
      row[:id] row[:player1_mark] + row[:player2_mark] + row[:computer_player_mark] + row[:moves]
    end

    @board = array_to_board(session[:moves])
    erb :game_over
  end

  run! if app_file == $0
end