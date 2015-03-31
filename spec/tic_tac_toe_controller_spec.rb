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

  describe "GET '/'" do
    it "loads the setup page with game setup options" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.status).to eq 200
      expect(last_response.body).to include "Select your mark"
    end

    it "clears the session" do
      get '/', {}, {'rack.session' => {:computer_opponent => "O"}}
      expect(rack_mock_session.cookie_jar[:computer_opponent]).to be_nil
    end
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
    it "loads a game without any moves" do
      get '/game', {}, {'rack.session' => {:ai_mark => "O",
                                       :player_marks => ["X", "O"],
                                       :current_player_mark => "X",
                                       :moves => [nil, nil, nil, nil, nil, nil, nil, nil, nil]}}
      expect(last_response).to be_ok
      expect(last_response.status).to eq 200
      expect(last_response.body).to include '<form action="/make_move" method="POST">'
    end


    it "loads the game with a move" do
      get '/game', {}, {'rack.session' => {:ai_mark => "O",
                                       :player_marks => ["X", "O"],
                                       :current_player_mark => "X",
                                       :moves => ["X", nil, nil, nil, nil, nil, nil, nil, nil]}}
      expect(last_response).to be_ok
      expect(last_response.status).to eq 200
      expect(last_response.body).to include 'name="0" value=" X " readonly'
    end
  end


  describe "POST /make_move" do

    it "adds a human player's mark to the board" do
      @mock_game = instance_double("TicTacToe::Game", :board_to_array => [])

      expect(TicTacToe::Game).to receive(:new).and_return(@mock_game)
      expect(@mock_game).to receive(:ai_mark).and_return(nil)
      expect(@mock_game).to receive(:take_turn).with(0)
      expect(@mock_game).to receive(:over?).and_return(false, false)
      expect(@mock_game).to receive(:current_player_mark).and_return("X", "O")

      post '/make_move', {:move => '0'}, {'rack.session' => {
                                     :ai_mark => nil,
                                     :player_marks => ["X", "O"],
                                     :current_player_mark => "X",
                                     :moves => [nil, nil, nil, nil, nil, nil, nil, nil, nil]}}
      expect(last_response.redirect?).to eq true
      expect(last_response.headers["Location"]).to eq ("http://example.org/game")
    end

    it "completes a game" do
      @mock_game = instance_double("TicTacToe::Game", :board_to_array => [])
      expect(TicTacToe::Game).to receive(:new).and_return(@mock_game)
      expect(@mock_game).to receive(:take_turn).with(0)
      expect(@mock_game).to receive(:over?).and_return true

      post '/make_move', {:move => '0'}
      expect(last_response.redirect?).to eq true
      expect(last_response.headers["Location"]).to eq ("http://example.org/game_over")
    end
  end

  describe "GET /game_over" do
    before :each do
      get '/game_over', {}, {'rack.session' => {
                                     :ai_mark => nil,
                                     :player_marks => ["X", "O"],
                                     :current_player_mark => "X",
                                     :winning_player => "X",
                                     :moves => ["X", "X", "X", "O", "O", nil, nil, nil, nil]}}
    end

    it "loads the game over message" do
      expect(last_response).to be_ok
      expect(last_response.status).to eq 200
      expect(last_response.body).to include "Result: Player X wins"
    end

    it "displays all completed games" do
      expect(last_response.body).to include "<td>"
    end
  end
end
