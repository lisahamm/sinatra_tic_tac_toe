require 'spec_helper'
require 'game_helpers'
require 'database_cleaner'
require 'sequel'

describe 'GameHelpers' do
  include GameHelpers
  include DatabaseHelpers

  describe '#recreate_game' do
    it "creates a Game from the data saved in the database" do
      game_data = {:id=>350,
                   :player1_mark=>"X",
                   :player2_mark=>"O",
                   :current_player_mark=>"X",
                   :computer_player_mark=>"O",
                   :moves=>"nil nil nil nil nil nil nil nil nil",
                   :time=>"2015-04-02 15:58:29 -0500"}
      expect(Database).to receive(:game_by_id).and_return(game_data).exactly(2).times
      game = recreate_game(game_data[:id])
      expect(game.player_marks).to eq ["X", "O"]
      expect(game.current_player_mark).to eq "X"
      expect(game.ai_mark).to eq "O"
    end
  end

  describe '#array_to_board' do
    it "creates a Board object from an array" do
      board = array_to_board(["X", "X", "O", nil, nil, nil, nil, nil, nil])
      expect(board.class).to eq TicTacToe::Board
      expect(board.cells.length).to eq 9
    end
  end
end