require 'sequel'

module DatabaseHelpers

  def connect_to_database(path)
    Sequel.connect(path)
  end

  def all_games_in_database(database)
    database[:games]
  end

  def save_game(games, args={})
    games.insert(:player1_mark => args[:player1_mark],
                 :player2_mark => args[:player2_mark],
                 :computer_player_mark => args[:computer_player_mark],
                 :moves => args[:moves],
                 :time => Time.now)
  end

  def moves_to_string(moves_array)
    moves = moves_array.map {|move| move == nil ? "nil" : move}
    moves.reduce("") {|string, move| string << (move + " ")}.strip
  end
end