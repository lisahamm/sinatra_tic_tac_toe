require 'tic_tac_toe'

module GameHelpers
  def check_for_computer_turn(game)
    if game.current_player_mark == game.ai_mark
      game.take_turn(game.generate_ai_move)
    end
  end

  def serialize_game_data(game, time)
    {:player1_mark => game.player1_mark,
     :player2_mark => game.player2_mark,
     :computer_player_mark => game.ai_mark ,
     :moves => moves_to_string(game.board_to_array),
     :time => time}
  end

  def array_to_board(array)
    TicTacToe::Board.new(cells: array)
  end

  def moves_to_string(moves_array)
    moves = moves_array.map {|move| move == nil ? "nil" : move}
    moves.reduce("") {|string, move| string << (move + " ")}.strip
  end
end