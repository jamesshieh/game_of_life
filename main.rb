require './life'
require 'chingu'

board = Environment.new
while true
  board.print_board
  sleep 0.3
  board.step
end
