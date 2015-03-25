require 'sequel'

module DatabaseHelpers

  def connect_to_database(path)
    Sequel.connect(path)
  end

  def games(DB)
    DB["SELECT * FROM games"]
  end

  def save_game(args={})
    games.insert(:player1_mark => args[:player1_mark],
                 :player2_mark => args[:player2_mark],
                 :computer_player_mark => args[:computer_opponent],
                 :moves => moves_to_string(args[:moves]))
  end

  def moves_to_string(moves_array)
    moves = moves_array.map {|move| move == nil ? "nil" : move}
    moves.reduce("") {|string, move| string << (move + " ")}.strip
  end
end