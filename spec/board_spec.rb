require "spec_helper"

module TicTacToe
  describe Board do
    let(:board) {Board.new}

    let(:won_board) do
      cells = ['X', 'X', 'O',
               'O', 'X', 'X',
               'X', 'O', 'X']
      Board.new(cells: cells)
    end

    let(:tie_board) do
      cells = ['X', 'X', 'O',
               'O', 'O', 'X',
               'X', 'O', 'X']
      Board.new(cells: cells)
    end

    describe "cell accessors" do
      it "can set and get a cell value" do
        board.set_cell(1, 'X')
        expect(board.get_cell(1)).to eq 'X'
      end
    end

    describe "#empty_cell?" do
      it "is true when cell is empty" do
        expect(board.empty_cell?(1)).to eq true
      end

      it "is false when cell is full" do
        board.set_cell(1, 'X')
        expect(board.empty_cell?(1)).to eq false
      end
    end

    describe "#empty_cells" do
      it "returns the empty cell numbers" do
        expect(board.empty_cells).to eq [0, 1, 2, 3, 4, 5, 6, 7, 8]
      end
    end

    describe "#get_winning_mark" do
      it "returns the winner's mark when won" do
        expect(won_board.get_winning_mark).to eq 'X'
      end

      it "is nil when there is no winner" do
        expect(board.get_winning_mark).to eq nil
      end
    end

    describe "#winner?" do
      it "is true when won" do
        expect(won_board.winner?).to eq true
      end

      it "is false when tied" do
        expect(tie_board.winner?).to eq false
      end

      it "is false when all cells are empty" do
        expect(board.winner?).to eq false
      end
    end

    describe "#empty?" do
      it "is true when all cells are empty" do
        expect(board.empty?).to eq true
      end

      it "is false when not all cells are empty" do
        board.set_cell(1, 'X')
        expect(board.empty?).to eq false
      end
    end

    describe "#tie_game?" do
      it "is true when tied" do
        expect(tie_board.tie_game?).to eq true
      end

      it "is false when won" do
        expect(won_board.tie_game?).to eq false
      end

      it "is false when all cells are empty" do
        expect(board.tie_game?).to eq false
      end
    end

    describe "#over?" do
      it "is true when tied" do
        expect(tie_board.over?).to eq true
      end

      it "is true when won" do
        expect(won_board.over?). to eq true
      end

      it "is false when all cells are empty" do
        expect(board.over?).to eq false
      end
    end
  end
end