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


Boards
holds all pieces (and taken pieces)
validates moves sent from Chess
execults moves
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
	 		diagonal 1, only if enemy 


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
			puts "Incorrect formatting"
			retry
		rescue RangeError
			puts "Number or letter out of range"
			retry
		rescue ExistenceError
			puts "You don't have a piece to move at that origin"
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
			puts "#{player.name}, enter your move: (a1:c5)"
			move = get_coordinates
			@board.execute_move(move)
			print @board
			@turn += 1
		end
	end
end

game = Chess.new
game.play
# game.validate_input("A9:B5")