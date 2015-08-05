class HumanPlayer
  attr_reader :board, :color

  def initialize(board, color)
    @board, @color = board, color
  end

  def play_turn
    puts "Your turn, #{color.to_s.capitalize}. \nPlease use the format a1 b2."

    begin
      start_pos, end_pos = parse(gets.chomp)
      move(start_pos, end_pos)
    rescue InvalidMove, BadInput, NoPiece, WrongColor => e
      puts e.message
      puts "Try again"
      retry
    end
  end

  private

  def move(start_pos, end_pos)
    if !board.piece_at?(start_pos)
      raise NoPiece.new("There's no piece there!")
    elsif board.color_at(start_pos) != color
      raise WrongColor.new("Wrong color! You can't move your opponent's piece.")
    end
    board.move(start_pos, end_pos)
  end

  def parse(string_input)
    string_input.split.map { |pos| translate(pos) }
  end

  def translate(pos_input)
    col_string, row_string = pos_input.split("")
    pos = [(row_string.to_i - 1), col_string.downcase.ord - "a".ord]

    unless pos.all? { |coord| coord.between?(0, board.class::BOARD_SIZE - 1) }
      raise BadInput.new "Invalid input!"
    end

    pos
  end
end

class BadInput < StandardError
end

class NoPiece < StandardError
end

class WrongColor < StandardError
end
