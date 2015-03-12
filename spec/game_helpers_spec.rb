require 'spec_helper'
require 'game_helpers'

describe 'GameHelpers' do
  include GameHelpers
  let(:params) {{player_mark: "X", computer_opponent: "no", player_order: "first"}}
  let(:game) {TicTacToe::Game.new("X", "0", "X", board=nil)}

  describe '#create_game' do
    it "configures the game based on the params" do
      game = create_game(params)
      expect(game.player1).to eq "X"
    end
  end

  describe '#player_marks' do
    it "creates player marks for the first and second player based on the params" do
      player_marks = player_marks(params)
      expect(player_marks[0]).to eq "X"
      expect(player_marks[1]).to eq "O"
    end
  end

  describe '#opponent_mark' do
    it "returns the opponent's mark" do
      expect(opponent_mark("X")).to eq "O"
    end
  end

  describe '#computer_opponent' do
    it "provides the mark of the computer_opponent if elected in the game setup" do
      expect(computer_opponent(params, game)).to eq nil
    end
  end

  it "executes computer's move if it is the computer's turn" do
    computer_opponent = "X"
    check_for_computer_turn(game, computer_opponent)
    expect(game.board.empty?).to eq false
  end

  it "does not update the board if it is not the computer's turn" do
    computer_opponent = "O"
    check_for_computer_turn(game, computer_opponent)
    expect(game.board.empty?).to eq true
  end
end