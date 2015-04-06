require 'tic_tac_toe'

module DatabaseHelpers
  def serialize_game_data(game)
    {:player1_mark => game.player1_mark,
     :player2_mark => game.player2_mark,
     :current_player_mark => game.current_player_mark,
     :computer_player_mark => game.ai_mark,
     :moves => moves_to_string(game.board_to_array),
     :completed => game.over?,
     :time => Time.now}
  end

  def make_move_database_update(game_id, game)
    completed = game.over?
    moves = moves_to_string(game.board_to_array)
    Database.update_after_turn(game_id, moves, game.current_player_mark, completed)
  end

  def move_data_to_board(game_id)
    move_array = unserialize_move_data(game_id)
    array_to_board(move_array)
  end

  private

  def moves_to_string(moves_array)
    moves = moves_array.map {|move| move == nil ? "nil" : move}
    moves.reduce("") {|string, move| string << (move + " ")}.strip
  end

  def unserialize_move_data(game_id)
    game_data = Database.game_by_id(game_id)
    game_data[:moves].split.map {|move| move == "nil" ? nil : move}
  end

end
