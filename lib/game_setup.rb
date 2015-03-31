require 'tic_tac_toe'

class GameSetup
  attr_accessor :user_input, :rules, :options

  def initialize(params)
    @user_input = params
    @rules = TicTacToe::Rules.new
  end

  def configure_specifications!
    @options = {}
    options[:player_marks] = setup_player_marks(user_input[:player_order], user_input[:player_mark])
    options[:current_player_mark] = options[:player_marks].first
    options[:ai_mark] = setup_computer_opponent(user_input, options[:player_marks])
  end

  def create_game!
    configure_specifications!
    TicTacToe::Game.new(options)
  end

  private

  def setup_player_marks(player_order, player_mark)
    if player_order == 'first'
      [player_mark, opponent_mark(player_mark)]
    else
      [opponent_mark(player_mark), player_mark]
    end
  end

  def valid_player_marks
    rules.player_marks
  end

  def opponent_mark(player_mark)
    valid_player_marks.select {|valid_mark| valid_mark != player_mark}.first
  end

  def setup_computer_opponent(user_input, player_marks)
    if user_input[:computer_opponent] == "yes"
      user_input[:player_order] == "first" ? player_marks[1] : player_marks[0]
    end
  end

end