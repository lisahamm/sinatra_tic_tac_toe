require 'tic_tac_toe'
require 'database_helpers'

module GameHelpers
  include DatabaseHelpers

  def reconfigure_game_specifications(game_id, game_data)
    {
      board: move_data_to_board(game_id),
      player_marks: [game_data[:player1_mark], game_data[:player2_mark]],
      current_player_mark: game_data[:current_player_mark],
      ai_mark: game_data[:computer_player_mark]
    }
  end

  def recreate_game(game_id)
    game_data = Database.game_by_id(game_id)
    options = reconfigure_game_specifications(game_id, game_data)
    TicTacToe::Game.new(options)
  end

  def array_to_board(array)
    TicTacToe::Board.new(cells: array)
  end
end