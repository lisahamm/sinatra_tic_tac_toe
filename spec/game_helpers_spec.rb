require 'spec_helper'
require 'game_helpers'

describe 'GameHelpers' do
  include GameHelpers
  let(:params) {{player_mark: "X", computer_opponent: "no", player_order: "first"}}

  xdescribe '#create_game' do
    it "configures the game based on the params" do
      game = create_game(params)
      expect(game.player1.mark).to eq "X"
    end
  end

  describe '#player_settings' do
    it "creates settings for the first and second player" do
      player_settings = player_settings(params)
      expect(player_settings[0].fetch(:mark)).to eq "X"
      expect(player_settings[1].fetch(:mark)).to eq "O"
    end
  end

  describe '#opponent_mark' do
    it "returns the opponent's mark" do
      expect(opponent_mark("X")).to eq "O"
    end
  end

  describe '#computer_opponent' do
    it "provides the player number of the computer_opponent if elected in the game setup" do
      expect(computer_opponent(params)).to eq nil
    end
  end

end