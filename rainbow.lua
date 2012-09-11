#!/usr/bin/env lua

--------------------------------------------------------------
-- @Description: Pedagogical Lua script to color code your text using arbitrary "rainbow" BBCode
-- @Author: Forget Me Not (The Unintelligible)
-- @Contact: xxprotozoid@live.com

-- @Version: v0.1

-- @Remarks: Primarily intended for Windows use. However, due to the fact that it's distributed free,
--           as in freedom, you are able to safely modify and re-distribute this script free of charge
--           as long as it abides by the GPLv3 terms.

-- @Dependencies: clipboard DLL module - http://files.luaforge.net/releases/jaslatrix/clipboard/1.0.0/clipboard-1.0.0-Lua51.zip

-- @License: GNU General Public License v3 (GPLv3) - http://www.gnu.org/copyleft/gpl.html
--------------------------------------------------------------

require "clipboard"

----------------------------------------------
--- Internal methods
----------------------------------------------

--- Returns Lua table from tokenized string
-- @param s Lua string to pass as input
-- @usage tokenize("I am a string")
local function tokenize(s)
	local t = {}

	for i = 1, #s do
		t[i] = s:sub(i, i)
	end

	return t
end

--- Returns string color coded in rainbow BBCode and corresponding size
-- @param s Lua string to pass as input
-- @param size Lua number for the size of the text to output
-- @usage color_code("Lorem ipsum dolor sit amet, consectetur, adipisci velit.")
local function color_code(s, size)
	local bool, err = assert(type(s) == "string", "Invalid data supplied.")  -- If given data not string, throw an exception & terminate our function

	if not bool then return end

	local char_array = tokenize(s)
	local buff = ""

	for i = 1, #char_array do
		-- Create a matrix of hues of the different colors of the rainbow
		-- Each row is as follows: Red, Orange, Yellow, Green, Blue, Purple
		local color_matrix = {
			"#C11B17", "#F87A17", "#FFFF00", "#00FF00", "#2B60DE","#893BFF",
			"#F63817", "#E78E17", "#FFFC17", "#5EFB6E", "#1531EC", "#8E35EF"
		}

		local ran_num = math.random(1, #color_matrix) -- Create a pseudo-random number ranging from 1 to the size of the color matrix
		local color = color_matrix[ran_num]

		if string.find(char_array[i], ' ') then whitespace = true end

		if not whitespace then -- For resource conservation, we won't enclose whitespace in BBCode
			bbcode_str = "[color=" .. color .. "]" .. char_array[i] .. "[/color]"
		end


		if whitespace then -- If whitespace is in our token we'll simply leave it as is. Else we wrap it up with BBCode
			buff = buff .. char_array[i]
		else
			buff = buff .. bbcode_str
		end

		whitespace = false
	end

	if not size then size = 3 end -- If no size parameter passed, defaults to 3

	buff = "[size=" .. tostring(size) .. "]".. buff .. "[/size]" -- Finalize process by prepending and appending size tags to our string

	return buff, #buff
end

----------------------------------------------
--- Main program
----------------------------------------------

local function main()
	io.write("Enter your text to be color-coded: ") -- Prompt user to feed input to program for our process
	input_text = io.read() -- Wait for input from the STDIN/STDOUT stream

	-- Rinse, repeat
	io.write("Now enter your size attribute for the text: ")
	input_size = io.read()

	print("Now initializing the process...\n") -- Print out user-friendly message while the process unfolds under the hood

	result = color_code(input_text, input_size)

	clipboard.settext(result)

	print("Done! Your legendary rainbow text has been copied to your clipboard.\n\nPress enter to exit.\n") -- Done!
	io.read() -- Idle
end

main()
