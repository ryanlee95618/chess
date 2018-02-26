class Player
	attr_accessor :name, :team
	def initialize(team)
		@team = team
		@number = @team == "white" ? 1 : 2
		@name = "Player #{@number}"
	end
end