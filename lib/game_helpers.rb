module GameHelpers
  def create_game(params)
    player_marks = player_marks(params)
    TicTacToe::Game.new(player_marks[0], player_marks[1], player_marks[0])
  end

  def player_marks(params)
    if params[:player_order] == 'first'
      [params[:player_mark], opponent_mark(params[:player_mark])]
    else
      [opponent_mark(params[:player_mark]), params[:player_mark]]
    end
  end

  def opponent_mark(mark)
    mark == "X" ? "O" : "X"
  end

  def computer_opponent(params, game)
    player_order = params[:player_order]
    if params[:computer_opponent] == "yes"
      return player_order == "first" ? game.player2 : game.player1
    end
    nil
  end

  def check_for_computer_turn(game, computer_opponent)
    if game.current_player_mark == computer_opponent
      game.take_turn(game.generate_ai_move)
    end
  end

  def array_to_board(array)
    TicTacToe::Board.new(cells: array)
  end

end