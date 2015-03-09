module GameHelpers
  def create_game(params)
    player_marks = configure_players(params)
    TicTacToe::Game.new(TicTacToe::Board.new, player_marks[:player1], player_marks[:player2])
  end

  def configure_players(params)
    player_marks = {}
    if params[:player_order] = 'first'
      player_marks[:player1] = params[:player_mark]
      player_marks[:player2] = opponent_mark(player_marks[:player1])
    else
      player_marks[:player2] = params[:player_mark]
      player_marks[:player1] = opponent_mark(player_marks[:player2])
    end
    player_marks
  end

  def opponent_mark(mark)
    mark == 'X' ? 'O' : 'X'
  end

  def computer_opponent(params)
    if params[:computer_opponent] == 'yes'
      params[:player_order] == 'first' ? 'player2' : 'player1'
    end
  end


end