require 'sudoku_test'

describe SudokuBuggery do

let(:board) { CellHider.new }

  it 'is created with a board' do
    expect(board.board).to be_a_kind_of Array
  end

  it 'has 81 spaces on the board' do
    expect(board.board.count).to eq 81
  end

  it 'has a value for every cell' do
    expect(board.board.first).to be_a_kind_of String
  end

  it 'can generate a random sequence of indexes to hide numbers' do
    expect(board.indexes).to be_a_kind_of Array
  end

  it 'has a value for each index it selects' do
    expect(board.indexes.first).to be_a_kind_of Fixnum
  end

  it 'creates 50 random indexes' do
    expect(board.indexes.count).to eq 50
  end

  it 'creates 50 unique indexes' do
    a = board.indexes.uniq
    expect(a.count).to eq 50
  end

  it 'can use the unique indexes to hide elements in the grid' do
    board.hide_cells
    expect(board.board).to include(0)
  end

end