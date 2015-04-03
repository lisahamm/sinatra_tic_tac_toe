ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'database'
require 'yaml'
require 'database_cleaner'
require 'sequel'

describe 'Database' do
  let(:game_hash) {{:player1_mark => "X",
                :player2_mark => "O",
                :current_player_mark => "X",
                :computer_player_mark => "O",
                :moves => "nil nil nil nil nil nil nil nil nil",
                :completed => false,
                :time => Time.now}}

  describe '#init!' do
    it "connects to the database" do
      database_yaml_file_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'database.yml'))
      config = YAML.load_file(database_yaml_file_path)
      expect(Database.init!(config[ENV['RACK_ENV']]).class).to eq Sequel::Postgres::Database
    end
  end

  describe '#games' do
    it "returns 0 games when there are no games in the database" do
      expect(Database.games.count).to eq 0
    end

    it "returns all games saved in the database" do
      Database.save_game(game_hash)
      expect(Database.games.count).to eq 1
    end
  end

  describe '#completed_games' do
    it "returns 0 game records when there are no completed games saved in the database" do
      Database.save_game(game_hash)
      expect(Database.completed_games.count).to eq 0
    end

    it "returns 1 game record when there is 1 completed game saved in the database" do
      completed_game_hash = {:player1_mark => "X",
                             :player2_mark => "O",
                             :current_player_mark => "X",
                             :computer_player_mark => "O",
                             :moves => "X X X O O nil nil nil nil",
                             :completed => true,
                             :time => Time.now}
      Database.save_game(completed_game_hash)
      expect(Database.completed_games.count).to eq 1
    end
  end

  describe '#save_game' do
    it "stores game data in the database's game table" do
      Database.save_game(game_hash)
      Database.save_game(game_hash)
      expect(Database.games.count).to eq 2
    end
  end

  describe '#game_by_id(id)' do
    it "retrieves game data from database for a game with the specified id" do
      id = Database.save_game(game_hash)
      game_data = Database.game_by_id(id)
      expect(game_data[:id]).to eq id
      expect(game_data[:player1_mark]).to eq "X"
      expect(game_data[:moves]).to eq "nil nil nil nil nil nil nil nil nil"
    end
  end

  describe '#update_after_turn' do
    before :each do
      @id = Database.save_game(game_hash)
      @game_data = Database.game_by_id(@id)
    end

    it "updates moves, current player, and completed status for game record in database with specified id" do
      expect(@game_data[:moves]).to eq game_hash[:moves]
      expect(@game_data[:current_player_mark]).to eq game_hash[:current_player_mark]
      expect(@game_data[:completed]).to eq game_hash[:completed]
      Database.update_after_turn(@id, "X X X O O nil nil nil nil", "O", true)
      updated_game_data = Database.game_by_id(@id)
      expect(updated_game_data[:moves]).to eq "X X X O O nil nil nil nil"
      expect(updated_game_data[:current_player_mark]).to eq "O"
      expect(updated_game_data[:completed]).to eq true
    end
  end
end