require 'spec_helper'
require 'game_setup'

describe 'GameSetup' do
  params = {:player_mark => "X", :computer_opponent => "yes", :player_order => "first"}

  it "configures the setup options" do
    setup = GameSetup.new(params)
    p setup.user_input
    setup.configure_specifications!
    expect(setup.options[:player_marks]).to eq ["X", "O"]
    expect(setup.options[:current_player_mark]).to eq "X"
    expect(setup.options[:ai_mark]).to eq "O"
  end

  it "initializes the game" do
    setup = GameSetup.new(params)
    setup.configure_specifications!
    game = setup.create_game
    expect(game.nil?).to eq false
    expect(game.ai_mark).to eq "O"
  end
end