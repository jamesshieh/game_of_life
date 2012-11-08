#!/usr/bin/env ruby

require './life'
require 'chingu'
include Gosu
  
CELL_SIZE = 5

class Game < Chingu::Window
  def initialize
    super(1280, 720, false)
    $universe = Environment.new($window.width/CELL_SIZE, $window.height/CELL_SIZE)
    push_game_state(Menu)
  end

end

class Master < Chingu::GameState

  def initialize
    super
  end
 
  def draw_grid
    $universe.board.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        if cell == 1
          draw_rect(x, y)
        end
      end
    end
  end

  def draw_rect(x, y)
    $window.fill_rect([x*CELL_SIZE, y*CELL_SIZE, CELL_SIZE, CELL_SIZE], Color::WHITE, 0)
  end
end

# Starting Menu

class Menu < Chingu::GameState
  def initialize(options = {})
    super
    @title = Chingu::Text.create(:text => "Welcome to the Game Of Life!", :x => 300, :y => 300, :size => 30)
    @prompt = Chingu::Text.create(:text => "Press space to begin.", :x => 800, :y => 300, :size => 30)
    self.input = { :space => Draw }
  end
end

# Free Edit Drawing Mode

class Draw < Master
  def initialize
    super
    @prompt = Chingu::Text.create(:text => "Press Space to simulate", :x => 0, :y => 670, :size => 30)
    self.input =  {   :escape => :exit,
                      :space => Sim,
                      :left_mouse_button => :add_rect,
                      :right_mouse_button => :remove_rect                    
                  }
  end

  def add_rect
    $universe.alive!($window.mouse_x/CELL_SIZE,$window.mouse_y/CELL_SIZE) 
  end

  def remove_rect
    $universe.dead!($window.mouse_x/CELL_SIZE,$window.mouse_y/CELL_SIZE)
  end
  
  def draw_cursor
    $window.fill_rect([$window.mouse_x, $window.mouse_y, CELL_SIZE, CELL_SIZE], Color::RED, 0)
  end

  def draw
    super
    draw_grid
    draw_cursor
  end

  def update
    super
  end

end

# Simulation Mode

class Sim < Master
  def initialize
    super
    @prompt = Chingu::Text.create(:text => "Press Space to return to draw mode", :x => 0, :y => 670, :size => 30)
    self.input = { :escape => :exit, :f1 => :debug, :space => Draw }
  end

  def debug
    push_game_state(Chingu::GameStates::Debug.new)
  end

  def draw
    super
    draw_grid
  end
  
  def update
    super
    $universe.step
    $window.caption =  "FPS: #{$window.fps}, Game_Objects: #{$window.game_objects}"
  end
end

Game.new.show
