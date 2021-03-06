get '/cat' do
  prepare_to_check_solution
  generate_new_puzzle_if_necessary
  @current_solution = session[:current_solution] || session[:puzzle]
  @solution = session[:solution]
  @puzzle = session[:puzzle]
  erb :cat
end

get '/cat/solution' do
  @current_solution = session[:solution]
  @solution = @current_solution
  @puzzle = session[:puzzle]
  erb :cat
end

post '/cat' do
  cells = box_order_to_row_order(params["cell"])
  session[:current_solution] = cells.map { |value| value.to_i }.join
  session[:check_solution] = true
  redirect to("/cat")
end

post '/cat/reset' do
  session[:current_solution] = session[:puzzle]
  redirect to("/cat")
end

post '/cat/save' do
  cells = box_order_to_row_order(params["cell"])
  session[:current_solution] = cells.map { |value| value.to_i }.join
  redirect to("/cat")
end

get '/cat/new_game' do
  new_game 50
  redirect to("/cat")
end

get '/cat/easy' do
  new_game 30
  redirect to("/cat")
end

get '/cat/hard' do
  new_game 65
  redirect to("/cat")
end
