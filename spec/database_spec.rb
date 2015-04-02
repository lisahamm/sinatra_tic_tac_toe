ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'database'
require 'yaml'
require 'database_cleaner'
require 'sequel'

describe 'Database' do
  RSpec.configure do |config|
    config.before(:suite) do
      DatabaseCleaner[:sequel, {:connection => Sequel.connect('postgres://localhost/tictactoe_test')}]
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end

  before :each do
    database_yaml_file_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'database.yml'))
    config = YAML.load_file(database_yaml_file_path)
    Database.init!(config[ENV['RACK_ENV']])
  end

  describe '#games' do
    it "returns 0 games when there are no games in the database" do
      expect(Database.games.count).to eq 0
    end

    it "returns all games saved in the database" do
      game_hash = {:player1_mark => "X",
                   :player2_mark => "O",
                   :current_player_mark => "X",
                   :computer_player_mark => "O",
                   :moves => "nil nil nil nil nil nil nil nil nil",
                   :time => Time.now}
      Database.save_game(game_hash)
      expect(Database.games.count).to eq 1
    end
  end

  describe '#game_by_id(id)' do
    it "retrieves game data from database for a game with the specified id" do
      game_hash = {:player1_mark => "X",
                   :player2_mark => "O",
                   :current_player_mark => "X",
                   :computer_player_mark => "O",
                   :moves => "nil nil nil nil nil nil nil nil nil",
                   :time => Time.now}
      id = Database.save_game(game_hash)
      game_data = Database.game_by_id(id)
      expect(game_data[:id]).to eq id
      expect(game_data[:player1_mark]).to eq "X"
      expect(game_data[:moves]).to eq "nil nil nil nil nil nil nil nil nil"
    end
  end

  describe '#save_game' do

  end

  describe '#update_game_moves' do

  end

  describe '#update_game_current_player' do

  end


end

