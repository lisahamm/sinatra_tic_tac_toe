require 'spec_helper'
require 'game_setup'

describe 'GameSetup' do
  params = {:player_mark => "X", :computer_opponent => "yes", :player_order => "first"}

  it "initializes the game" do
    setup = GameSetup.new(params)
    game = setup.create_game
    expect(game.nil?).to eq false
    expect(game.player_marks).to eq ["X", "O"]
    expect(game.current_player_mark).to eq "X"
    expect(game.ai_mark).to eq "O"
  end
end