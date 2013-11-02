require 'sinatra'
require 'sinatra/partial'
require 'rack-flash'
require 'newrelic_rpm'
require_relative './lib/sudoku'
require_relative './lib/cell'

use Rack::Flash
register Sinatra::Partial
set :partial_template_engine, :erb

enable :sessions

set :session_secret, "badoing"

def random_sudoku
  seed = (1..9).to_a.shuffle + Array.new(81-9, 0)
  sudoku = Sudoku.new(seed.join)
  sudoku.solve!
  sudoku.to_s.chars
end

# def indexes
#   [*0..80].sample(50)
# end
  
def puzzle sudoku, difficulty
  indexes = [*0..80].sample(difficulty)
  puzzle_board = sudoku.dup
  indexes.each do |num|
    puzzle_board[num] = 0
  end
  puzzle_board
end

def new_game difficulty
  sudoku = random_sudoku
  session[:solution] = sudoku
  session[:puzzle] = puzzle(sudoku, difficulty)
  session[:current_solution] = session[:puzzle]
end

def generate_new_puzzle_if_necessary
  return if session[:current_solution]
  new_game 50
end

def prepare_to_check_solution
  @check_solution = session[:check_solution]
  flash[:notice] = "You guessed wrong if it's yellow, foo!" if @check_solution
  session[:check_solution] = nil
end

helpers do

  def colour_class(solution_to_check, puzzle_value, current_solution_value, solution_value)
    must_be_guessed = puzzle_value == 0
    tried_to_guess = current_solution_value.to_i != 0
    guessed_incorrectly = current_solution_value != solution_value
  
    if solution_to_check && must_be_guessed && tried_to_guess && guessed_incorrectly
      'incorrect'
    elsif !must_be_guessed
      'value-provided'
    end
  end

  def cell_value(value)
    value.to_i == 0 ? '' : value
  end

end

def box_order_to_row_order(cells)
  boxes = cells.each_slice(9).to_a
  (0..8).to_a.inject([]) do |memo, i|
    first_box_index = i / 3 * 3
    three_boxes = boxes[first_box_index, 3]
    three_rows_of_three = three_boxes.map do |box|
      row_number_in_a_box = i % 3
      first_cell_in_the_row_index = row_number_in_a_box * 3
      box[first_cell_in_the_row_index, 3]
    end
    memo += three_rows_of_three.flatten
  end
end


get '/' do
  prepare_to_check_solution
  generate_new_puzzle_if_necessary
  @current_solution = session[:current_solution] || session[:puzzle]
  @solution = session[:solution]
  @puzzle = session[:puzzle]
  erb :index
end

get '/solution' do
  @current_solution = session[:solution]
  @solution = @current_solution
  @puzzle = session[:puzzle]
  erb :index
end

post '/' do
  cells = box_order_to_row_order(params["cell"])
  session[:current_solution] = cells.map { |value| value.to_i }.join
  session[:check_solution] = true
  redirect to("/")
end

get '/new_game' do
  new_game 50
  redirect to("/")
end

get '/easy' do
  new_game 30
  redirect to("/")
end

get '/hard' do
  new_game 65
  redirect to("/")
end