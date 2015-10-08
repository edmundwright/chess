require_relative 'chess_error'
require_relative 'board'
require_relative 'players/human_player'
require_relative 'players/stupid_computer_player'
require_relative 'players/smart_computer_player'

class Game
  attr_reader :board, :current_player, :other_player
  attr_accessor :turns_played
  def initialize(board, player_white, player_black)
    @board = board
    @current_player = player_white
    @other_player = player_black
    @turns_played = 0
  end

  def play
    until winner || draw?
      board.render
      puts "Turns played: #{turns_played}"
      puts "Your turn, #{current_player.color.to_s.capitalize}."
      self.turns_played += 1
      if board.in_check?(current_player.color)
        puts "#{current_player.color.to_s.capitalize} is in check!"
      end
      current_player.play_turn
      switch_players
    end

    board.render
    puts winner ? "#{winner.to_s.capitalize} wins!" : "Draw!"
  end

  private

  def winner
    if board.check_mate?(:black)
      :white
    elsif board.check_mate?(:white)
      :black
    else
      nil
    end
  end

  def draw?
    board.draw?(current_player.color)
  end

  def switch_players
    @current_player, @other_player = other_player, current_player
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.setup_new_board

  players = {}
  [:white, :black].each do |color|
    puts
    puts "Who will play #{color.to_s.upcase}? Enter h for a human player, s for"
    puts "a stupid computer player, and c for a (somewhat) clever"
    puts "computer player."
    player_choice = gets.chomp
    if player_choice.downcase == "h"
      players[color] = HumanPlayer.new(board, color)
    elsif player_choice.downcase == "s"
      players[color] = StupidComputerPlayer.new(board, color)
    else
      puts "How clever should it be? Enter a positive integer. Note"
      puts "that < 2 will still be pretty stupid, and > 3 will take"
      puts "a very long time to choose moves."
      cleverness = gets.chomp.to_i
      players[color] = SmartComputerPlayer.new(board, color, cleverness)
    end
  end

  Game.new(board, players[:white], players[:black]).play
end
