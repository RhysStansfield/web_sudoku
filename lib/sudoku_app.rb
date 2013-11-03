require 'sinatra'
require 'sinatra/partial'
require 'rack-flash'
require 'newrelic_rpm'

require_relative 'sudoku'
require_relative 'cell'
require './helpers/app'

use Rack::Flash
register Sinatra::Partial
set :partial_template_engine, :erb

set :views, File.join(File.dirname(__FILE__), '..', 'views')
set :public_folder, File.join(File.dirname(__FILE__), '..', 'public')

enable :sessions

set :session_secret, "badoing"

def random_sudoku
  seed = (1..9).to_a.shuffle + Array.new(81-9, 0)
  sudoku = Sudoku.new(seed.join)
  sudoku.solve!
  sudoku.to_s.chars
end
  
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