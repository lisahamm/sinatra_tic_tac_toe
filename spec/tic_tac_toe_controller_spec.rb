ENV['RACK_ENV'] = 'test'


require 'tic_tac_toe_controller'
require 'rspec'
require 'rack/test'

describe 'The HelloWorld App' do
  include Rack::Test::Methods

  def app
    TicTacToeController
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.status).to eq 200
    expect(last_response.body).to include "Player 1, select your mark"
  end

  it "starts the game" do
    post "/setup", player_mark: "X", opponent: "yes"
    expect(last_response).to be_redirect

    #expect(session[:mark]).to eq "O"
  end
end