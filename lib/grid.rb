require_relative 'cell'

class Grid

  attr_reader :box

  def initialize puzzle
    @puzzle = string_to_integer_arrays puzzle
  end

  def puzzle
    @puzzle
  end

  def string_to_integer_arrays puzzle
    puzzle = puzzle.scan(/./)
    puzzle = puzzle.map { |number| number.to_i }
    puzzle = puzzle.each_slice(9).to_a
    @puzzle = puzzle
    cell_creator
  end

  def cell_creator
    @puzzle = @puzzle.map do |array|
      array.map { |number| Cell.new number }
    end
  end

  def row number
    number -= 1
    @puzzle[number]
  end

  def row_values number
    row(number).map { |cell| cell.value }
  end

  def column number
    number -= 1
    column_array = []
    @puzzle.each { |array| column_array << array[number] }
    column_array
  end

  def column_values number
    column(number).map { |cell| cell.value }
  end

  def columns
    columns_array = []
    (1..9).each { |num| columns_array << column(num) }
    columns_array
  end

  def check_box number
    box_rows number
    @box
  end

  def box_values number
    check_box(number).map { |cell| cell.value }
  end

  def box_rows number
    if number < 4
      box_rows_array = @puzzle[0, 3]
      box_columns box_rows_array, number
    elsif number > 3 && number < 7
      box_rows_array = @puzzle[3, 3]
      box_columns box_rows_array, number
    elsif number > 6 && number <= 9
      box_rows_array = @puzzle[6, 3]
      box_columns box_rows_array, number
    end
    box_rows_array
  end

  def box_columns rows, number
    if [1, 4, 7].include? number
      box_sorter rows, 0
    elsif [2, 5, 8].include? number
      box_sorter rows, 3
    elsif [3, 6, 9].include? number
      box_sorter rows, 6
    end
  end

  def box_sorter rows, number
    box_array = rows[0][number, 3] + rows[1][number, 3] + rows[2][number, 3]
    @box = box_array
  end

  def boxes
    boxes_array = []
    (1..9).each { |num| boxes_array << check_box(num) }
    boxes_array
  end

end