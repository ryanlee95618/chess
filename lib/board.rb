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
		@board[0][4] = King.new("black")
		@board[7][4] = King.new("white")

		#queens
		@board[0][3] = Queen.new("black")
		@board[7][3] = Queen.new("white")

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
	def castling_scenario
		@board = ([[]]*8).map {|row| [false]*8}

		#place kings
		@board[0][4] = King.new("black")
		@board[7][4] = King.new("white")


		#rooks
		@board[0][0] = Rook.new("black")
		@board[1][4] = Rook.new("black")
		@board[7][0] = Rook.new("white")
		@board[7][7] = Rook.new("white")

		#bishops
		@board[3][4] = Bishop.new("white")
	end
	def stalemate_scenario
		@board = ([[]]*8).map {|row| [false]*8}

		@board[0][7] = King.new("black")
		@board[7][4] = King.new("white")

		@board[2][5] = Knight.new("white")

		@board[7][6] = Rook.new("white")

		@board[6][3] = Pawn.new("white")
		@board[4][3] = Pawn.new("black")
	end
	def pawn_promo_scenario
		@board = ([[]]*8).map {|row| [false]*8}

		@board[0][7] = King.new("black")
		@board[7][4] = King.new("white")

	

		@board[6][2] = Pawn.new("black")
		@board[4][3] = Pawn.new("white")
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

	def other_team(team)
		team == "white" ? "black" : "white"
	end

	def get_delta(origin, destination)
		[destination.first - origin.first, destination.last - origin.last]
	end

	def calculate_destination(origin, delta)
		[origin.first+delta.first, origin.last+delta.last]
	end

	def each_coordinate
		(0..7).each do |x|
			(0..7).each do |y|
				yield [x,y]
			end
		end
	end

	def get_square(coord)
		@board[coord.last][coord.first]
	end

	def set_square(coord, value)
		@board[coord.last][coord.first] = value
	end

	def validate_move(origin, destination, player_team)

		raise RangeError unless (0..7).include?(destination.first) and (0..7).include?(destination.last)

		raise ExistenceError if get_square(origin) == false or get_square(origin).team != player_team
		
		piece = get_square(origin)

		raise NonMovementError if origin == destination
				

		if piece.type == "pawn"
			piece_at_destination = get_square(destination) != false
			raise MovementError unless piece.valid_delta?(get_delta(origin, destination),piece_at_destination)
		elsif piece.type == "king"
			result = piece.valid_delta?(get_delta(origin, destination))
			if [-2, 2].include?(result)
				direction = result.positive? ? "right" : "left"
				raise MovementError unless can_castle?(piece.team, direction)
			else
				raise MovementError unless piece.valid_delta?(get_delta(origin, destination))
			end
			#true, false, +-2

		else
			raise MovementError unless piece.valid_delta?(get_delta(origin, destination))
		end


		raise ObstacleError if (not piece.type == "knight") and pieces_between_exclusive?(origin, destination)

		raise CivilWarError if get_square(destination) and get_square(destination).team == player_team

		raise CheckError if simulate_move_for_check(origin, destination)
	end



	def execute_move(move)
		origin, destination = move
		origin_piece = get_square(origin)

		

		origin_piece.move_history << get_delta(origin, destination)

		destination_piece = get_square(destination)
		@taken_pieces[destination_piece.team] << destination_piece if destination_piece

		set_square(destination, origin_piece) 
		set_square(origin, false)

		
		#castling
		if origin_piece.type == "king" and get_delta(origin, destination).first.abs == 2
			#move knight as well
			direction = get_delta(origin, destination).first.positive? ? "right" : "left" 
			castle_rook(origin_piece.team, direction)

		#pawn promotion
		elsif origin_piece.type == "pawn"
			end_y_coord = origin_piece.team == "white" ? 0 : 7
			if destination.last == end_y_coord
				new_piece = Queen.new(origin_piece.team)
				set_square(destination, new_piece)
				return "promo"
			end	
		end



	end

	def simulate_move_for_check(origin, destination)
		origin_piece = get_square(origin)
		destination_piece = get_square(destination)

		set_square(destination, origin_piece) 
		set_square(origin, false)

		#check
		result = check(origin_piece.team)

		#reset
		set_square(origin, origin_piece)
		set_square(destination, destination_piece) 
		
		result
	end

	def coordinates_between_inclusive(origin, destination)
		x1,y1 = origin
		x2,y2 = destination

		coordinates = []
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
					coordinates << [x,y]
				elsif ld and y-x == ld
					coordinates << [x,y]
				elsif rd and x+y == rd
					coordinates << [x,y]
				end
			end
		end
		coordinates
	end

	def pieces_between_exclusive?(origin, destination)
		pieces = coordinates_between_inclusive(origin,destination).map {|coord| get_square(coord)}[1...-1].select {|piece| piece}
		pieces.count > 0
	end

	def find_piece(type, team)
		each_coordinate do |coord|
			piece = get_square(coord)
			return coord if piece and piece.type == type and piece.team == team
		end
		nil
	end


	def check(team)
		k_coord = find_piece("king", team)
		check_moves = []
		each_coordinate do |coord|
			piece = get_square(coord)
			if piece and piece.team == other_team(team)
				begin
					validate_move(coord, k_coord, other_team(team))
				rescue
					#do nothing
				else
					check_moves << [coord, k_coord]
					
				end
			end
		end

		if check_moves.length > 0
			check_moves
		else
			false
		end
	end


	def king_can_escape(team)
		king_location = find_piece("king", team)
		king = get_square(king_location)
		king.calculate_valid_deltas.each do |delta|
			destination = calculate_destination(king_location, delta)
			begin
				validate_move(king_location, destination, team)
			rescue
				#do nothing
			else
				return true
			end
		end
		false
	end

	def check_can_be_blocked_or_killed(team)
		check_moves = check(team)

		if check_moves.length > 1
			return false
		end
		origin, destination = check_moves[0]
		check_path = coordinates_between_inclusive(origin, destination)

		each_coordinate do |board_coord|
			piece = get_square(board_coord)
			if piece and piece.team == team

				check_path[0...-1].each do |path_coord|

					begin
						validate_move(board_coord, path_coord, team)
					rescue
						#do nothing
					else
						return true
					end
				end
			end
		end
		false
	end

	def tie
		pieces = []
		each_coordinate do |location|
			piece = get_square(location)
			pieces << piece.type if piece
		end

		if pieces.length <= 3
			if pieces.include?("bishop") or pieces.include?("knight")
				return true
			end
		end
		false
	end

	def checkmate(team)
		check(team) and not king_can_escape(team) and not check_can_be_blocked_or_killed(team)
	end


	def stalemate(team)
		#not in check and no valid moves
		each_coordinate do |piece_coord|
			piece = get_square(piece_coord)
			if piece and piece.team == team
				each_coordinate do |destination|
					begin
						validate_move(piece_coord, destination, team)
					rescue
						#do nothing
					else
						return false
					end
				end
			end
		end
		true
	end


	def can_castle?(team, direction)

		# Neither the king nor the rook being used has been moved yet during the game. 
		y = team == "white" ? 7 : 0
		king = @board[y][4]
		return false unless king and king.move_history.empty?

		x = direction == "right" ? 7 : 0
		rook = @board[y][x]
		return false unless rook and rook.move_history.empty?


		#All of the squares between the king and the rook must be empty.
		return false if pieces_between_exclusive?([4,y],[x,y])

		#The king must not be in check
		return false if check(team)

		#nor can castling move the king through a square where it would be in check.
		x_path_coordinates = direction == "right" ? [5,6] : [2,3]
		x_path_coordinates.each do |x|
			return false if simulate_move_for_check([4,y],[x,y])
		end

		true
	end


	def castle_rook(team, direction)
		y = team == "white" ? 7 : 0
		x = direction == "right" ? 7 : 0
		x_delta = direction == "right" ? 1 : -1
		execute_move([[x,y],[4+x_delta ,y]])
	end

	def promote_pawn(location, new_piece_name)
		old_piece = get_square(location)
		new_piece = Object.const_get(new_piece_name.capitalize).new(old_piece.team)

		set_square(location, new_piece)
	end


	def game_status(team)

		if check(team)
			if checkmate(team)
				"checkmate" 
			else
				"check"	
			end
		elsif stalemate(team)
			'stalemate'
		elsif tie
			'tie'
		end

	end
end


b = Board.new
b.new_game
 


 



