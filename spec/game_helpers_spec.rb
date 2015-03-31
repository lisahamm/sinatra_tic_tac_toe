require 'spec_helper'
require 'game_helpers'

describe 'GameHelpers' do
  include GameHelpers

  it "executes computer's move if it is the computer's turn" do
    options = {player_marks: ["X", "O"], current_player_mark: "O", ai_mark: "O"}
    game = TicTacToe::Game.new(options)
    check_for_computer_turn(game)
    expect(game.board.empty?).to eq false
  end

  it "does not update the board if it is not the computer's turn" do
    options = {player_marks: ["X", "O"], current_player_mark: "X", ai_mark: "O"}
    game = TicTacToe::Game.new(options)
    check_for_computer_turn(game)
    expect(game.board.empty?).to eq true
  end
end