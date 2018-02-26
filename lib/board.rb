require_relative "piece"

class Board
	attr_accessor :dead_white, :dead_black

	def initialize
		@board = ([[]]*8).map {|row| [false]*8}
		@dead_white = []
		@dead_black = [] 

	end

	def new_game
		@board = ([[]]*8).map {|row| [false]*8}

		#place kings
		@board[0][3] = King.new(0)
		@board[7][3] = King.new(1)
		#queens
		@board[0][4] = Queen.new(0)
		@board[7][4] = Queen.new(1)

		#rooks
		@board[0][0] = Rook.new(0)
		@board[0][7] = Rook.new(0)
		@board[7][0] = Rook.new(1)
		@board[7][7] = Rook.new(1)

		#bishops
		@board[0][2] = Bishop.new(0)
		@board[0][5] = Bishop.new(0)
		@board[7][2] = Bishop.new(1)
		@board[7][5] = Bishop.new(1)		

		#knights
		@board[0][1] = Knight.new(0)
		@board[0][6] = Knight.new(0)
		@board[7][1] = Knight.new(1)
		@board[7][6] = Knight.new(1)	

		#pawns
		@board[1].map! {|v| Pawn.new(0) }
		@board[6].map! {|v| Pawn.new(1) }
	end

	def to_s
		print "  " + @dead_black.join("") + "\n"
		print "  " + ("A".."H").to_a.join(" ") + "\n"
		@board.each_with_index do |row, index|
			print "#{index + 1} " + row.map {|v| v ? v : " "}.join("|") + "\n"
		end
		print "  " + dead_white.join("") + "\n"
	end




	def get_delta(origin, destination)
		[destination.first - origin.first, destination.last - origin.last]
	end



	def get_piece(human_coord)
		column_index = ("A".."H").to_a.index(human_coord[0].upcase)
		row_index = human_coord[1].to_i - 1
		@board[row_index][column_index]
	end

	def between(x1,y1, x2, y2)
		output = []
		#same row
		x1 == x2
		min, max = [y1, y2].sort 
		(min..max).each do |y|

			if y != y1
				output << @board[y][x1]
			end
		end


		#same column
		y1 == y2
		min, max = [x1, x2].sort 

		#same diagonal right /
		y2+x2 == y1+x1

		#same diagonal left \
		y2-x2 == y1-x1



	end
end


b = Board.new
b.new_game

b.dead_white << Pawn.new(0)
b.dead_black << Queen.new(1)
b.dead_black << Rook.new(1)
b.dead_black << Pawn.new(1)
b.dead_black << Pawn.new(1)
b.dead_black << Pawn.new(1)
b.to_s

# puts b.get_piece("b1")



