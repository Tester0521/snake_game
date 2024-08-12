require 'rubygems'
require 'curses'

Curses.init_screen
Curses.curs_set(0) 
Curses.timeout = 150 

WIDTH = 40
HEIGHT = 20

def spawnA(width, height) 
  width = rand(width - 8)
  height = rand(height - 4) 
  return [width - width % 2 - 1, height - height % 2 - 1] end

snake = [[1, 1], [1, 0]]
direction = :right
food = spawnA(WIDTH, HEIGHT)
score = 0

def draw_game(snake, food, score)
  Curses.clear

  Curses.setpos(0, 0)
  Curses.addstr("Score: #{score}")

  (0..HEIGHT).each do |i|
    Curses.setpos(i, 0)
    Curses.addstr('#')
    Curses.setpos(i, WIDTH)
    Curses.addstr('#')
  end

  (0..WIDTH).each do |i|
    Curses.setpos(0, i)
    Curses.addstr('#')
    Curses.setpos(HEIGHT, i)
    Curses.addstr('#')
  end

  Curses.setpos(food[1], food[0])
  Curses.addstr('@')
  Curses.refresh

  snake.each do |segment|
    Curses.setpos(segment[1], segment[0])
    Curses.addstr('O')
  end
end

loop do
  case Curses.getch
  when 'w'
    direction = :up if direction != :down
  when 's'
    direction = :down if direction != :up
  when 'a'
    direction = :left if direction != :right
  when 'd'
    direction = :right if direction != :left
  when 'q'
    break
  end

  head = snake.first.dup
  case direction
  when :up
    head[1] -= 1
  when :down
    head[1] += 1
  when :left
    head[0] -= 2
  when :right
    head[0] += 2
  end

  if head[0] < 0 || head[0] >= WIDTH || head[1] <= 0 || head[1] >= HEIGHT || snake.include?(head)
    Curses.close_screen
    puts "Game Over! Your score: #{score}"
    break
  end

  snake.unshift(head)

  if head == food
    score += 1
    food = spawnA(WIDTH, HEIGHT)
  else
    snake.pop
  end

  draw_game(snake, food, score)
end

Curses.close_screen
