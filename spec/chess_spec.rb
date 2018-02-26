require "chess"
require "errors"

describe Chess do

	before do
		@game = Chess.new
	end

	describe "validate_input" do
		context "given !@#!@" do
			it "raises FormattingError" do
				expect(@game.validate_input("!@#!@")).to raise_error(FormattingError)
			end
		end

		context "given A9:B5" do
			it "raises RangeError" do
				expect(@game.validate_input("A9:B5")).to raise_error(RangeError)
			end
		end
	end
end