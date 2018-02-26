# king_white = "\u2654".encode("utf-8")
# queen_white = "\u2655".encode("utf-8")
# rook_white = "\u2656".encode("utf-8")
# bishop_white = "\u2657".encode("utf-8")
# knight_white = "\u2658".encode("utf-8")
# pawn_white  = "\u2659".encode("utf-8")

# king_black = "\u265A".encode("utf-8")
# queen_black = "\u265B".encode("utf-8")
# rook_black = "\u265C".encode("utf-8")
# bishop_black = "\u265D".encode("utf-8")
# knight_black = "\u265E".encode("utf-8")
# pawn_black = "\u265F".encode("utf-8")


class Piece
	attr_accessor :team
	def initialize(team)
		@team = team
		@move_history = []
	end


	def diagonal?(delta)
		delta.first.abs == delta.last.abs
	end

	def perpendiculer?(delta)
		(delta.first == 0) ^ (delta.last == 0)
	end

	def distance(delta)
		delta.first.abs + delta.last.abs
	end

end




class King < Piece

	def to_s
		code = @team == 1 ? "\u2654" : "\u265A"
		code.encode("utf-8")
	end

	def valid_delta?(delta)
		(diagonal?(delta) and distance(delta) == 2) or (perpendiculer?(delta) and distance(delta) == 1)
	end
end

class Queen < Piece
	def to_s
		code = @team == 1 ? "\u2655" : "\u265B"
		code.encode("utf-8")
	end

	def valid_delta?(delta)
		diagonal?(delta) or perpendiculer?(delta)
	end
end

class Rook < Piece
	def to_s
		code = @team == 1 ? "\u2656" : "\u265C"
		code.encode("utf-8")
	end

	def valid_delta?(delta)
		perpendiculer?(delta)
	end
end

class Bishop < Piece
	def to_s
		code = @team == 1 ? "\u2657" : "\u265D"
		code.encode("utf-8")
	end
	def valid_delta?(delta)
		diagonal?(delta)
	end
end

class Knight < Piece
	def to_s
		code = @team == 1 ? "\u2658" : "\u265E"
		code.encode("utf-8")
	end

	def valid_delta?(delta)
		distance(delta) == 3 and not perpendiculer?(delta)
	end

end

class Pawn < Piece
	def to_s
		code = @team == 1 ? "\u2659" : "\u265F"
		code.encode("utf-8")
	end

	def valid_delta?(delta)

		#must move forward
		if @team == 1
			return false unless delta.last > 0
		else
			return false unless delta.last < 0
		end

		#can move forward 2 on first move
		if delta.first == 0 and distance(delta) == 2
			return @move_history.empty?
		elsif delta.first == 0 and distance(delta) == 1
			return true
		elsif perpendiculer?(delta) and distance(delta) == 2
			return true
		end






	end

end

# Another unusual rule is the en passant capture. It can occur after a pawn advances two squares using its initial two-step move option, and the square passed over is attacked by an enemy pawn. The enemy pawn is entitled to capture the moved pawn "in passing"—as if it had advanced only one square. The capturing pawn moves to the square over which the moved pawn passed (see diagram), and the moved pawn is removed from the board. The option to capture en passant must be exercised on the move immediately following the double-step pawn advance, or it is lost for the remainder of the game.