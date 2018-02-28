require_relative "board"
require_relative "player"
require_relative "piece"
require_relative "errors"





=begin

Chess
runs the game
responsible for getting properly formatted input
keeps track of turns?, players


could keep track of timer



Game
validates moves sent from Chess



Board
holds all pieces (and taken pieces)

executes moves
looks for check, checkmate, stalemate
	needs to simulate moves to see if
		1. moving a player's piece would put that player's king in check
		2. moving a king put that king in check

Piece
has a team color
knows what move deltas are valid




types of invalid moves:
	
	-off the board / invalid coordinates ("H9", "Z5")
	-moving other players piece/ empty squares
	-invalid move for particular piece (rook moving diagonally)
	
	-moving through any piece (doesnt apply to knight)
	-moving onto own teams pieces
	-moves that put own king in check 



king  	diagonal and perpendicular, distance=1
queen		diagonal and perpendicular
rook		perpendicular
bishop	diagonal
knight	distance = 3 and not perpendicular
pawn		forward 2, no on in way and on first turn
			forward 1, no one in way
	 		diagonal 1, only if enemy on destination
	 		or if pawn "en passant"



NEED TO IMPLEMENT

check
checkmate
stalemate

pawn en passant (vulnerable after first forwarddistance 2 move)
# Another unusual rule is the en passant capture. It can occur after a pawn advances two squares using its initial two-step move option, and the square passed over is attacked by an enemy pawn. The enemy pawn is entitled to capture the moved pawn "in passing"—as if it had advanced only one square. The capturing pawn moves to the square over which the moved pawn passed (see diagram), and the moved pawn is removed from the board. The option to capture en passant must be exercised on the move immediately following the double-step pawn advance, or it is lost for the remainder of the game.
The capturing pawn must be on its fifth rank.
The opponent must move a pawn two squares, landing the pawn directly alongside the capturing pawn on the fifth rank.
You must make the capture immediately; you only get one chance to capture en passant.



castling:









pawn promotion


=end




class Chess 

	def initialize
		@board = Board.new
		@players = [Player.new("white"), Player.new("black")]
		@turn = 1
	end


	def translate(human_coord)
		column_index = ("A".."H").to_a.index(human_coord[0].upcase)
		row_index = human_coord[1].to_i - 1
		[column_index, row_index]
	end


	def get_coordinates
		
		begin
			coords = gets.chomp
				
			valid_move = validate_input(coords)
		rescue FormattingError
			puts "Incorrect formatting. Should look like 'a1:c5'"
			retry
		rescue RangeError
			puts "Number or letter out of range"
			retry
		rescue ExistenceError
			puts "You don't have a piece to move at that square"
			retry
		rescue NonMovementError
			puts "Invalid move. Destination is same as origin"
			retry
		rescue MovementError
			puts "That piece cannot move like that"
			retry
		rescue ObstacleError
			puts "There are pieces in the way"
			retry
		rescue CivilWarError
			puts "You cannot attack your own piece"
			retry
		rescue CheckError
			puts "You cannot put your king in check"
			retry
		else
			valid_move 
		end

	end

	def choose_promotion_piece(team)
		name  = gets.chomp.downcase
		piece_names = ["queen", "rook", "bishop", "knight", "pawn"]

		new_piece = Object.const_get(name.capitalize).new


	end

	def validate_input(coord)	
		coord.downcase!

		raise FormattingError unless coord.length == 5 and (("a".."z").include?(coord[0]) and ("a".."z").include?(coord[3]) and (0..9).include?(coord[1].to_i) and (0..9).include?(coord[4].to_i) and coord[2] == ":")

		raise RangeError unless ("a".."h").include?(coord[0]) and ("a".."h").include?(coord[3]) and (1..8).include?(coord[1].to_i) and (1..8).include?(coord[4].to_i)
			

		origin = translate(coord[0..1])
		destination = translate(coord[3..4])
		@board.validate_move(origin, destination, @players[(@turn+1)%2].team)
		
		[origin, destination]
	end

	def play
		@board.new_game
		print @board
		loop do
			player_index = (@turn+1)%2
			player = @players[player_index]
			other_team = player.team == "white" ? "black" : "white"
			puts "#{player.name}, enter your move:"
			move = get_coordinates
			@board.execute_move(move)

			if @board.check(other_team)
				print "CHECK"

				if @board.checkmate(other_team)

					print "CHECKMATE" 
					break
				end

			elsif @board.stalemate(other_team)
				print 'stalemate'
				break
				
			end
			print @board
			@turn += 1
		end

		print "GAME OVER"
	end
end


