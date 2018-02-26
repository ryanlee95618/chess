require "board"
require "player"
require "piece"





=begin

chess runs the game

gets valid players moves
who determines if a move in invalid piece, or board?
types of invalid moves:
	
	-off the board / invalid coordinates ("H9", "Z5")
	-moving other players piece/ empty squares
	-invalid move for particular piece (rook moving diagonally)
	

	-moving through any piece (doesnt apply to knight)
	-moving onto own teams pieces

	-moves that put own king in check 

king  	diagonal and perpendicular, but only a distance=1
queen		diagonal and perpendicular
rook		perpendicular
bishop	diagonal
knight	abs(xdelta) + abs(ydelta) = 3 and not perpendicular

pawn		forward 2, no on in way and on first turn
			forward 1, no one in way
	 		diagonal 1, only if ememy 




each 

each piece should calculate its valid moves?
should each piece keep track of position?




=end


class Chess 

	def initialize
		@board = Board.new

	end


	def translate(human_coord)
		column_index = ("A".."H").to_a.index(human_coord[0].upcase)
		row_index = human_coord[1].to_i - 1
		[column_index, row_index]


	def get_coordinates
		
		coord = gets.chomp
		len(coord) == 5

		coord[0]

	end



	def move(start, finish)


	end

	def play
		turn = 1
		loop do
			player_index = (turn+1)%2+1

			puts "Player #{player_index}, enter your move: (a1:c5)"

			move_input = gets.chomp
			move(move_input.split(":").first, move_input.split(":").last)
			


			turn += 1
		end



	end
end