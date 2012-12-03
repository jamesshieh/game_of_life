require 'colorize'

class Environment
  attr_accessor :board, :next_gen

  # Initialize a grid of size x * y

  def initialize(x=40, y=40)
    @x, @y= x, y
    @board = create_blank_board
    @next_gen = create_blank_board
  end

  def step
    @board.each_with_index do |row, i|
      row.each_with_index do |_, j|
        @next_gen[i][j] = 1 if life?(j, i)
      end
    end
    @board = @next_gen
    @next_gen = create_blank_board
  end

  def create_blank_board
    board = []
    for i in(1..@y)
      board << [0] * @x
    end
    return board
  end

  def dead!(x, y)
    @board[y][x] = 0
  end

  def alive!(x, y)
    @board[y][x] = 1
  end

  def alive?(x, y)
    return @board[y][x] == 1
  end

  def life?(x, y)
    neighbors = find_neighbors(x,y)
    if @board[y][x] == 1
      return (neighbors == 2 or neighbors == 3)
    else
      return neighbors == 3
    end
  end

  def find_neighbors(x, y)
    neighbors = @board[y-1][x-1] + @board[y-1][x] + @board[y-1][(x+1) % @x] + @board[y][x-1] + @board[y][(x+1) % @x] + @board[(y+1) % @y][x-1] + @board[(y+1) % @y][x] + @board[(y+1) % @y][(x+1) % @x]
#    neighbors = 0
#    for i in (x-1..x+1)
#      for j in (y-1..y+1)
#        i = i % @x
#        j = j % @y
#        neighbors += (@board[j][i])
#      end
#    end
#    neighbors -= @board[y][x]
    return neighbors
  end

  def print_board(board = @board)
    board.each do |row|
      row.each do |cell|
        if cell == 1
          print "#{cell}".red
        else
          print "#{cell}".blue
        end
      end
      puts
    end
    puts "---------------------------------"
  end

end


