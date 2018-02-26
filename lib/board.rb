require_relative "piece"
require_relative "errors"

class Board
	attr_accessor 

	def initialize
		@board = ([[]]*8).map {|row| [false]*8}
		@taken_pieces = {"white" => [], "black" => []}
	end

	def new_game
		@board = ([[]]*8).map {|row| [false]*8}

		#place kings
		@board[0][3] = King.new("black")
		@board[7][3] = King.new("white")
		#queens
		@board[0][4] = Queen.new("black")
		@board[7][4] = Queen.new("white")

		#rooks
		@board[0][0] = Rook.new("black")
		@board[0][7] = Rook.new("black")
		@board[7][0] = Rook.new("white")
		@board[7][7] = Rook.new("white")

		#bishops
		@board[0][2] = Bishop.new("black")
		@board[0][5] = Bishop.new("black")
		@board[7][2] = Bishop.new("white")
		@board[7][5] = Bishop.new("white")		

		#knights
		@board[0][1] = Knight.new("black")
		@board[0][6] = Knight.new("black")
		@board[7][1] = Knight.new("white")
		@board[7][6] = Knight.new("white")	

		#pawns
		@board[1].map! {|v| Pawn.new("black") }
		@board[6].map! {|v| Pawn.new("white") }
	end

	def to_s
		print "  " + @taken_pieces["white"].join("") + "\n"
		print "  " + ("A".."H").to_a.join(" ") + "\n"
		@board.each_with_index do |row, index|
			print "#{index + 1} " + row.map {|v| v ? v : " "}.join("|") + " #{index + 1}\n"
		end
		print "  " + ("A".."H").to_a.join(" ") + "\n"
		print "  " + @taken_pieces["black"].join("") + "\n"
	end


	def get_delta(origin, destination)
		[destination.first - origin.first, destination.last - origin.last]
	end

	def get_square(coord)
		@board[coord.last][coord.first]
	end

	def set_square(coord, value)
		@board[coord.last][coord.first] = value
	end

	def validate_move(origin, destination, player_team)



		raise ExistenceError if get_square(origin) == false or get_square(origin).team != player_team
		
		piece = get_square(origin)

		raise NonMovementError if origin == destination
				
		raise MovementError unless piece.valid_delta?(get_delta(origin, destination))

		raise ObstacleError if pieces_between(origin, destination)


		raise CivilWarError if get_square(destination) and get_square(destination).team == player_team

		# raise CheckError if check(player_team)

	end

	def capture
	end

	def execute_move(move)
		origin, destination = move
		origin_piece = get_square(origin)

		origin_piece.move_history << get_delta(origin, destination)

		destination_piece = get_square(destination)
		@taken_pieces[destination_piece.team] << destination_piece if destination_piece

		set_square(destination, origin_piece) 
		set_square(origin, false)
	end

	def simulate_move
		
	end

	def pieces_between(origin, destination)

		if get_square(origin).type == "knight"
			return false
		end

		x1,y1 = origin
		x2,y2 = destination


		list = []
		if x1 == x2 or y1 == y2
			perpindeculer = true
		elsif y2+x2 == y1+x1
			rd = y1+x1
		elsif y2-x2 == y1-x1
			ld = y1-x1
		end

		x1,x2 = [x1,x2].sort
		y1,y2 = [y1,y2].sort
		(x1..x2).each do |x|
			(y1..y2).each do |y|
				if perpindeculer
					list << get_square([x,y])
				elsif ld and y-x == ld
					list << get_square([x,y])
				elsif rd and x+y == rd
					list << get_square([x,y])
				end
			end
		end

		p list
		if list.length <= 2
			return false
		else
			return list[1...-1].select {|piece| piece}.count > 0
		end
	end


	def check
		
	end

	def checkmate
		
	end

	def stalemate
		
	end

end


# b = Board.new
# b.new_game
# b.dead_white << Pawn.new("black")
# b.dead_black << Queen.new("white")
# b.dead_black << Pawn.new("white")
# b.to_s






=begin
		#same row/column

		output = []
		(x1..x2).each do |x|
			(y1..y2).each do |y|
				output << get_square([x,y])
			end
		end

		if x1 == x2
			min, max = [y1, y2].sort 

			list = (min..max).map do |y|
				get_square([x1,y]) 
			end

		#same column
		elsif y1 == y2
			min, max = [x1, x2].sort 
			list = (min..max).map do |x|
				get_square([x,y1]) 
			end

		#same diagonal right /
		elsif y2+x2 == y1+x1

		#same diagonal left \
		elsif y2-x2 == y1-x1
			min_y, max_y = [y1, y2].sort 
			min_x, max_x = [x1, x2].sort 
			change = max_y - min_y
			list = (0..change).map do |c|
				get_square([min_x + c, min_y + c])
			end
		end
=end