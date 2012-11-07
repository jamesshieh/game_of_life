require 'colorize'

class Environment
  attr_accessor :board, :next_gen

  # Initialize a grid of size x * y

  def initialize(x=40, y=40)
    @x, @y= x, y
    @board = self.create_blank_board
    @next_gen = self.create_blank_board
    @board[14][16] = 1
    @board[16][17] = 1
    @board[15][15] = 1
    @board[15][16] = 1
    @board[15][17] = 1
  end

  def step
    @board.each_with_index do |_, i|
      @board.each_with_index do |_, j|
        @next_gen[i][j] = 1 if life?(i, j)
      end
    end
    @board = @next_gen
    @next_gen = self.create_blank_board
  end

  def create_blank_board
    board = []
    for i in(0..@y-1)
      board << [0] * @x
    end
    return board
  end

  def alive?(x, y)
    return @board[x][y] == 1
  end

  def life?(x, y)
    if x > 0 and x < @x-1 and y > 0 and y < @y-1
      neighbors = self.find_neighbors(x,y)
      if self.alive?(x,y)
        return (neighbors == 2 or neighbors == 3)
      else
        return neighbors == 3
      end
    else
      return false
    end
  end

  def find_neighbors(x, y)
    neighbors = 0
    for i in (x-1..x+1)
      for j in (y-1..y+1)
        if !@board[i][j].nil?
          neighbors += (@board[i][j])
        end
      end
    end
    neighbors -= @board[x][y]
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


