require_relative 'tile'

class Board
    attr_reader :grid_size, :num_bombs

    def initialize(grid_size)
        @grid_size = grid_size
        @num_bombs = @grid_size ** 2 / 8
        populate
    end

    def [](pos)
        row, col = pos
        @grid[row][col]
    end

    def lost?
        @grid.flatten.any? { |tile| tile.bombed? and tile.explored? }
    end

    def won?
        @grid.flatten.all? { |tile| tile.bombed? != tile.explored? }
    end

    def render(reveal = false)
        @grid.map do |row|
            row.map { |tile| reveal ? tile.reveal : tile.render }.join("")
        end.join("\n")
    end

    def reveal
        render(true)
    end

    def populate
        @grid = Array.new(@grid_size) do |row|
            Array.new(@grid_size) { |col| Tile.new(self, [row, col]) }
        end

        plant_bombs
    end

    def plant_bombs
        planted_bombs = 0

        until planted_bombs == @num_bombs
            rand_pos = Array.new(2) { rand(@grid_size) }
            tile = self[rand_pos]

            if tile.bombed?
                tile.plant_bomb
                total_bombs += 1
            end
        end

        nil
    end
end