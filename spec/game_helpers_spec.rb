require 'spec_helper'
require 'game_helpers'

describe 'GameHelpers' do
  include GameHelpers
  let(:params) {{player_mark: "X", computer_opponent: "no", player_order: "first"}}

  describe '#create_game' do
    it "configures the game based on the params" do
      game = create_game(params)
      expect(game.player1.mark).to eq 'X'
    end
  end

  describe '#configure_players' do
    it "sets marks for the first and second player" do
      player_marks = configure_players(params)
      expect(player_marks[:player1]).to eq "X"
      expect(player_marks[:player2]).to eq "O"
    end
  end

  describe '#opponent_mark' do
    it "returns the opponent's mark" do
      expect(opponent_mark('X')).to eq 'O'
    end
  end

  describe '#computer_opponent' do
    it "provides the player number of the computer_opponent if elected in the game setup" do
      expect(computer_opponent(params)).to eq nil
    end
  end

end