require 'yaml'
require_relative 'board'

class Game
    def initialize(size)
        @board = Board.new(size)
    end

    def play
        until @board.won? or @board.lost?
            puts @board.render
            move = get_move
            action = move[0]
            pos = move[1]
            perform_move(action, pos)
        end

        if @board.won?
            puts "Congratulations, you win!"
        elsif @board.lost?
            puts "BOOM! You lose."
            puts @board.reveal
        end
    end

    private

    def get_move
        move = gets.chomp.split(",")
        [move[0], [move[1].to_i, move[2].to_i]]
    end

    def perform_move(action_type, pos)
        tile = @board[pos]

        if action_type == "f"
            tile.toggle_flag
        elsif action_type == "e"
            tile.explore
        elsif action_type == "s"
            save
        end
    end

    def save
        puts "Enter filename to save as:"
        filename = gets.chomp
        File.write(filename, YAML.dump(self))
    end
end

if $PROGRAM_NAME == __FILE__
    if ARGV.count == 0
        Game.new(9).play
    elsif ARGV.count == 1
        YAML.load_file(ARGV.shift).play
    end
end