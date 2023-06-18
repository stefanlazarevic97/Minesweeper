class Tile
    $move_diffs = [[-1, 0], [-1, -1], [-1, 1], [0, 1], [0, -1], [1, 1], [1, 0], [1, -1]]

    attr_reader :pos

    def initialize(board, pos)
        @board = board
        @pos = pos
        @bombed = false
        @explored = false
        @flagged = false
    end

    def bombed?
        @bombed
    end

    def explored
        @explored
    end

    def flagged
        @flagged
    end

    def adjacent_bomb_count
        neighbors.select { |neighbor| neighbor.bombed? }.length
    end

    def explored
        return self if flagged? || explored?
        @explored = true
        neighbors.each { |neighbor| neighbor.explore } if !bombed? && adjacent_bomb_count == 0
        self
    end

    def inspect
        { pos: pos, bombed: bombed?, flagged: flagged?, explored: explored? }.inspect
    end

    def neighbors
        adjacent = []

        $move_diffs.each do |diff|
            new_row = pos.first + diff.first
            new_col = pos.last + diff.last

            new_pos = [new_row, new_col]
            adjacent << new_pos
        end

        adjacent.select do |new_pos|
            (0...@board.grid_size).include?(new_pos.first) && (0...@board.grid_size).include?(new_pos.last)
        end
    end
        
    def plant_bomb
        @bombed = true
    end

    def render
        if flagged?
            "F"
        elsif explored?
            adjacent_bomb_count == 0 ? "_" : adjacent_bomb_count.to_s
        else
            "*"
        end
    end

    def reveal
        if flagged?
            bombed? ? "F" : "f"
        elsif bombed?
            explored? ? "X" : "B"
        else
            adjacent_bomb_count == 0 ? "_" : adjacent_bomb_count.to_s
        end
    end

    def toggle_flag
        @flagged = !@flagged unless @explored
    end
end