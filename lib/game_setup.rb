require 'tic_tac_toe'

class GameSetup
  attr_accessor :user_input, :rules, :options, :player_mark_options

  def initialize(params, player_mark_options=['X','O'])
    @user_input = params
    @player_mark_options = player_mark_options
  end

  def configure_specifications
    options = {}
    options[:player_marks] = setup_player_marks(user_input[:player_order], user_input[:player_mark])
    options[:current_player_mark] = options[:player_marks].first
    options[:ai_mark] = setup_computer_opponent(user_input, options[:player_marks])
    options
  end

  def create_game
    game = TicTacToe::Game.new(configure_specifications)
    check_for_computer_turn(game)
    game
  end

  private

  def setup_player_marks(player_order, player_mark)
    if player_order == 'first'
      [player_mark, opponent_mark(player_mark)]
    else
      [opponent_mark(player_mark), player_mark]
    end
  end

  def opponent_mark(player_mark)
    player_mark_options.select {|valid_mark| valid_mark != player_mark}.first
  end

  def setup_computer_opponent(user_input, player_marks)
    if user_input[:computer_opponent] == "yes"
      user_input[:player_order] == "first" ? player_marks[1] : player_marks[0]
    end
  end

  def check_for_computer_turn(game)
    if game.current_player_mark == game.ai_mark
      game.take_turn(game.generate_ai_move)
    end
  end

end