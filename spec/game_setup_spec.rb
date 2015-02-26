require 'spec_helper'
require 'game_setup'

describe 'GameSetup' do
  valid_params = {player_mark: 'X', opponent: 'yes', player_order: 'first'}
  invalid_params = {opponent: 'yes', player_order: 'third'}

  let(:valid_game_setup) {GameSetup.new(valid_params)}
  let(:invalid_game_setup) {GameSetup.new(invalid_params)}

  context 'valid game setup' do
    it 'validates the game configurations' do
      expect(valid_game_setup.valid?).to eq true
    end

    it 'does not produce error messages' do
      expect(valid_game_setup.errors.empty?).to eq true
    end
  end

  context 'invalid_game_setup' do
    it 'validates the game configurations' do
      expect(invalid_game_setup.valid?).to eq false
    end

    it 'does not produce error messages' do
      expect(invalid_game_setup.errors.empty?).to eq false
    end
  end
end