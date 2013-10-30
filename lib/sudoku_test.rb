require_relative 'sudoku'
require_relative 'cell'

class CellHider

  attr_reader :board

  def initialize
    @board = random_sudoku
  end
  
  def random_sudoku
    seed = (1..9).to_a.shuffle + Array.new(81-9, 0)
    sudoku = Sudoku.new(seed.join)
    sudoku.solve!
    sudoku.to_s.chars
  end

  def indexes
    pos_indexes = (0..80).to_a
    indexes = []
    50.times do 
      num = pos_indexes.sample
      indexes << num
      pos_indexes.delete(num)
    end
    indexes
  end
  
  def hide_cells
    indexes.each do |num|
      board[num] = 0
    end
  end
  
end