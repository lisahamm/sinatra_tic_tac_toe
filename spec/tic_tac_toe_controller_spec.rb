ENV['RACK_ENV'] = 'test'


require './tic_tac_toe_controller'
require 'rspec'
require 'rack/test'

describe 'The TicTacToe App' do
  include Rack::Test::Methods

  let(:setup_data) {{player_mark: "X", computer_opponent: "no", player_order: "first"}}
  let(:incomplete_setup_data) {{computer_opponent: "no", player_order: "first"}}


  def app
    TicTacToeController
  end

  it "gets the setup page" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.status).to eq 200
    expect(last_response.body).to include "Select your mark"
  end

  describe "POST '/setup'" do
    it "redirects to /game if setup is complete" do
      post '/setup', {:player_mark => "X", :computer_opponent => "no", :player_order => "first"}
      expect(last_response.redirect?).to eq true
      follow_redirect!
      expect(last_request.path).to eq '/game'
    end

    context "setup param missing" do
      it "returns setup page with error message" do
        post '/setup', {:computer_opponent => "no", :player_order => "first"}
        expect(last_response.body).to include "Please select a mark to continue"
        expect(last_response.status).to eq 200
      end
    end
  end

  describe "GET /game" do
    it "loads the game" do
      get '/game', {}, {'rack.session' => {"computer_opponent" => "O",
                                       "player1_mark" => "X",
                                       "player2_mark" => "O",
                                       "current_player_mark" => "X",
                                       "moves" => [nil, nil, nil, nil, nil, nil, nil, nil, nil]}}
      expect(last_response).to be_ok
    end
  end
  # it "starts the game" do
  #   post "/setup", player_mark: "X", computer_opponent: "yes"
  #   expect(last_response).to be_redirect

    #expect(session[:mark]).to eq "O"
  # end
end