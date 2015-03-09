require 'spec_helper'
require 'game_setup'

describe 'GameSetup' do
  valid_params = {player_mark: 'X', computer_opponent: 'yes', player_order: 'first'}
  invalid_params = {computer_opponent: 'yes', player_order: 'third'}

  let(:valid_game_setup) {GameSetup.new(valid_params)}
  let(:invalid_game_setup) {GameSetup.new(invalid_params)}

  context 'valid game setup' do
    it 'validates the game configurations' do
      expect(valid_game_setup.valid?).to eq true
    end

    it 'checks if game configurations are invalid' do
      expect(valid_game_setup.invalid?).to eq false
    end

    it 'does not produce error messages' do
      expect(valid_game_setup.errors.empty?).to eq true
    end
  end

  context 'invalid_game_setup' do
    it 'validates the game configurations' do
      expect(invalid_game_setup.valid?).to eq false
    end

    it 'checks if game configurations are invalid' do
      expect(invalid_game_setup.invalid?).to eq true
    end

    it 'retrieves and stores the appropriate error messages for invalid params' do
      invalid_game_setup.valid?
      expect(invalid_game_setup.errors.empty?).to eq false
    end

    it 'stores missing parameter symbol in the errors hash' do
      invalid_game_setup.valid?
      expect(invalid_game_setup.errors.has_key?(:player_mark)).to eq true
    end

    it 'stores error messages in error hash for missing parameter' do
      invalid_game_setup.valid?
      expect(invalid_game_setup.errors[:player_mark].respond_to?(:to_s)).to eq true
    end

  end
end