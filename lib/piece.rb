class Piece
	attr_accessor :team, :move_history
	def initialize(team)
		@team = team
		@move_history = []
		@valid_deltas = calculate_valid_deltas
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

	def calculate_valid_deltas
		output = []
		(-7..7).each do |x|
			(-7..7).each do |y|
				delta = [x,y]
				
				if type == "pawn"
					if valid_delta?(delta, true)
						output << delta
					end
					if valid_delta?(delta, false)
						output << delta
					end
				else

					if valid_delta?(delta)
						output << delta
					end
				end
			end
		end
		output
	end


end




class King < Piece

	def to_s
		code = @team == "white" ? "\u2654" : "\u265A"
		code.encode("utf-8")
	end

	def valid_delta?(delta)

		if distance(delta) == 2 and delta.last == 0
			delta.first
		else
			(diagonal?(delta) and distance(delta) == 2) or (perpendiculer?(delta) and distance(delta) == 1)
		end
	end

	def calculate_valid_deltas
		output = []
		(-7..7).each do |x|
			(-7..7).each do |y|
				delta = [x,y]
				output << delta if valid_delta?(delta)				
			end
		end
		output
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



	def valid_delta?(delta, piece_at_destination, en_passant = false)

		#must move forward
		if @team == "white"
			return false unless delta.last.negative?
		else
			return false unless delta.last.positive?
		end

		return false if distance(delta) > 2


		if delta.first == 0 #forward only			
			if distance(delta) == 1
				return (not piece_at_destination)
			elsif distance(delta) == 2
				return (@move_history.empty? and (not piece_at_destination))
			end
		else #must be diagonal
			if piece_at_destination
				return true
			else
				en_passant
			end
		end
	end

end


