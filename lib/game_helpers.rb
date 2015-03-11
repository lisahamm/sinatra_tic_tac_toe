module GameHelpers
  def create_game(params)
    player_settings = player_settings(params)
    TicTacToe::Game.new(player_settings, player_settings[0][:mark])
  end

  def player_settings(params)
    player_settings = []
    ai = computer_opponent(params) != nil
    if params[:player_order] == 'first'
      player_settings[0] = {mark: params[:player_mark], ai: false}
      player_settings[1] = {mark: opponent_mark(params[:player_mark]), ai: ai}
    else
      player_settings[0] = {mark: opponent_mark(params[:player_mark]), ai: ai}
      player_settings[1] = {mark: params[:player_mark], ai: false}
    end
    player_settings
  end

  def opponent_mark(mark)
    mark == "X" ? "O" : "X"
  end

  def computer_opponent(params)
    player_order = params[:player_order]
    if params[:computer_opponent] == "yes"
      if player_order == "first"
        return "player2"
      else
        return "player1"
      end
    end
    nil
  end

  def array_to_board(array)
    TicTacToe::Board.new(cells: array)
  end
end