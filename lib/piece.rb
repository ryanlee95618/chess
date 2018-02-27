class Piece
	attr_accessor :team, :move_history
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

	def type
		self.class.to_s.downcase
	end
end




class King < Piece

	def to_s
		code = @team == "white" ? "\u2654" : "\u265A"
		code.encode("utf-8")
	end

	def valid_delta?(delta)
		(diagonal?(delta) and distance(delta) == 2) or (perpendiculer?(delta) and distance(delta) == 1)
	end
end

class Queen < Piece
	def to_s
		code = @team == "white" ? "\u2655" : "\u265B"
		code.encode("utf-8")
	end

	def valid_delta?(delta)
		diagonal?(delta) or perpendiculer?(delta)
	end
end

class Rook < Piece
	def to_s
		code = @team == "white" ? "\u2656" : "\u265C"
		code.encode("utf-8")
	end

	def valid_delta?(delta)
		perpendiculer?(delta)
	end
end

class Bishop < Piece
	def to_s
		code = @team == "white" ? "\u2657" : "\u265D"
		code.encode("utf-8")
	end
	def valid_delta?(delta)
		diagonal?(delta)
	end
end

class Knight < Piece
	def to_s
		code = @team == "white" ? "\u2658" : "\u265E"
		code.encode("utf-8")
	end

	def valid_delta?(delta)
		distance(delta) == 3 and not perpendiculer?(delta)
	end

end

class Pawn < Piece

	# attr_accessor :vulnerable
	# def initialize
	# 	super()
	# 	@vulnerable = false
	# end
	def to_s
		code = @team == "white" ? "\u2659" : "\u265F"
		code.encode("utf-8")
	end



	def valid_delta?(delta, piece_at_destination)

		#must move forward
		if @team == "white"
			return false unless delta.last.negative?
		else
			return false unless delta.last.positive?
		end


		return false if distance(delta) > 2

		#can move forward and not sideways if no piece at destination
		if delta.first == 0
			if piece_at_destination
				return false
			else
				if distance(delta) == 1
					return true
				elsif distance(delta) == 2
					return @move_history.empty?
				end
			end
		end
		

		#can move diagonally if there is a piece at destination (we already know destance is 2)
		return piece_at_destination if diagonal?(delta)

		false

		# Another unusual rule is the en passant capture. It can occur after a pawn advances two squares using its initial two-step move option, and the square passed over is attacked by an enemy pawn. The enemy pawn is entitled to capture the moved pawn "in passing"—as if it had advanced only one square. The capturing pawn moves to the square over which the moved pawn passed (see diagram), and the moved pawn is removed from the board. The option to capture en passant must be exercised on the move immediately following the double-step pawn advance, or it is lost for the remainder of the game.

	end

end


