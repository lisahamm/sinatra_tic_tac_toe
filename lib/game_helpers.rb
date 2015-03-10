module GameHelpers
  def create_game(params)
    TicTacToe::Game.new(player_settings(params))
  end

  def player_settings(params)
    player_settings = []
    ai = computer_opponent(params) != nil
    if params[:player_order] = 'first'
      player_settings[0] = {mark: params[:player_mark], ai: false}
      player_settings[1] = {mark: opponent_mark(params[:player_mark]), ai: ai}
    else
      player_settings[0] = {mark: opponent_mark(params[:player_mark]), ai: ai}
      player_settings[1] = {mark: params[:player_mark], ai: false}
    end
    player_settings
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