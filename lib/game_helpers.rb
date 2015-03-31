require 'tic_tac_toe'

module GameHelpers
  def check_for_computer_turn(game)
    if game.current_player_mark == game.ai_mark
      game.take_turn(game.generate_ai_move)
    end
  end

  def array_to_board(array)
    TicTacToe::Board.new(cells: array)
  end

  def moves_to_string(moves_array)
    moves = moves_array.map {|move| move == nil ? "nil" : move}
    moves.reduce("") {|string, move| string << (move + " ")}.strip
  end
end