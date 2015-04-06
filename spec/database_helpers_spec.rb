require 'spec_helper'
require 'game_helpers'
require 'database_cleaner'
require 'sequel'

describe 'GameHelpers' do
  include GameHelpers
  include DatabaseHelpers

  let(:game) {TicTacToe::Game.new({player_marks: ["X", "O"], current_player_mark: "X", ai_mark: "O"})}

  describe '#serialize_game_data' do
    it "formats data from the Game object to be stored in the database" do
      game_data = serialize_game_data(game)
      expect(game_data[:player1_mark]).to eq "X"
      expect(game_data[:player2_mark]).to eq "O"
      expect(game_data[:current_player_mark]).to eq "X"
      expect(game_data[:computer_player_mark]).to eq "O"
    end
  end

  describe '#move_data_to_board' do
    it "creates a Board object with the string of moves saved in the database" do
      game_data = {:id=>350,
                   :player1_mark=>"X",
                   :player2_mark=>"O",
                   :current_player_mark=>"X",
                   :computer_player_mark=>"O",
                   :moves=>"nil nil nil nil nil nil nil nil nil",
                   :completed=>false,
                   :time=>"2015-04-02 15:58:29 -0500"}

      expect(Database).to receive(:game_by_id).and_return(game_data)
      board = move_data_to_board(350)
      expect(board.empty?).to eq true
    end
  end
end