--[[
RGBKrocK, a clock that shows the time like RGB devices would.
Copyright (C) 2025 The KrocK

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
]]

-- Window size.
local window_width = 1200
local window_height = 600

-- Tables that represent each number. Each index of each table is defined as follows:
-- 		0: Top-left vertical line.
-- 		1: Top horizontal line.
-- 		2: Top-right vertical line.
-- 		3: Middle horizontal line.
-- 		4: Bottom-left vertical line.
-- 		5: Bottom horizontal line.
-- 		6: Bottom-right vertical line.
local zero = {true, true, true, false, true, true, true}
local one = {false, false, true, false, false, false, true}
local two = {false, true, true, true, true, true, false}
local three = {false, true, true, true, false, true, true}
local four = {true, false, true, true, false, false, true}
local five = {true, true, false, true, false, true, true}
local six = {true, true, false, true, true, true, true}
local seven = {false, true, true, false, false, false, true}
local eight = {true, true, true, true, true, true, true}
local nine = {true, true, true, true, false, true, true}

-- Text variables.
local font = nil
local font_size = 36

-- Current time variables.
local is_random_time_real = false
local is_random_time_all = false
local numbers = {"", "", "", ""}
local time_timer = 2
local time_show_duration = 2 -- Second.

-- Colon variables.
local colon_timer = 1
local show_colon = true
local colon_show_duration = 1 -- Second.
local colon_dot_size = 30 -- Pixels.

-- Color variables.
local stage = 1
local r = 1.0
local g = 0.0
local b = 0.0
local change_color = true
local color_timer = 0
local color_duration = 0.1
local line_width = 35

-- When the program is loaded.
function love.load()
	-- If the word "random" is passed as second argument (after the script name)
	-- then random number will be shown instead of the current time of the day.
	is_random_time_real = false
	is_random_time_all = false
	if arg[2] ~= nil then
		local lowercase_arg = string.lower(arg[2])
		if lowercase_arg == "random_real" then
			-- Random time, but only value that are possible on a real clock.
			is_random_time_real = true
		elseif lowercase_arg == "random_all" then
			-- Random time, any values, even if they don't exist.
			is_random_time_all = true
		else
			-- The current time from the computer's clock.
			is_random_time = false
			is_random_time_all = false
		end
	end
	
	love.window.setMode(window_width, window_height, {})
	love.window.setTitle("RGB KlocK")
	love.graphics.setBackgroundColor(0, 0, 0)
	love.graphics.setColor(1, 1, 1)
	love.graphics.setLineStyle("rough")
	font = love.graphics.setNewFont(font_size)
end

-- Updated each frame.
-- dt: Delta time (Time elapsed since the last frame).
function love.update(dt)
	time_timer = time_timer + dt
	if time_timer >= time_show_duration then
		time_timer = 0
		if is_random_time_real then
			numbers[1] = get_random_number(0, 2)
			-- Can't go higher than 23 hours.
			if numbers[1] == 2 then
				numbers[2] = get_random_number(0, 3)
			else
				numbers[2] = get_random_number(0, 9)
			end
			numbers[3] = get_random_number(0, 5)
			numbers[4] = get_random_number(0, 9)
		elseif is_random_time_all then
			numbers[1] = get_random_number(0, 9)
			numbers[2] = get_random_number(0, 9)
			numbers[3] = get_random_number(0, 9)
			numbers[4] = get_random_number(0, 9)
		else
			numbers = get_time_numbers()
		end
	end
	
	colon_timer = colon_timer + dt
	if colon_timer >= colon_show_duration then
		colon_timer = 0
		show_colon = not show_colon
	end
	
	if color_timer == 0 then
		update_color()
	end
	color_timer = color_timer + dt
	if color_timer >= color_duration then
		color_timer = 0
	end
end

-- Drawn each frame.
function love.draw()
	draw_time()
	if show_colon then
		draw_colon()
	end
end

-- Returns as random number between 0 and 9.
-- p_min: The minimum number allowed.
-- p_max: The maximum number allowed.
function get_random_number(p_min, p_max)
	return love.math.random(p_min, p_max)
end

-- Returns the current decomposed unto single digits for proper printing on screen.
function get_time_numbers()
	local time_data = {"", "", "", ""}
	local current_time = {year="", month="", day="", hour="", min="", sec="", isdst=""}
	current_time = os.date("*t", os.time())
	
	if current_time.hour < 10 then
		time_data[1] = 0
		time_data[2] = current_time.hour
	else
		time_data[1] = (current_time.hour - (current_time.hour % 10)) / 10
		time_data[2] = current_time.hour % 10
	end
	if current_time.min < 10 then
		time_data[3] = 0
		time_data[4] = current_time.min
	else
		time_data[3] = (current_time.min - (current_time.min % 10)) / 10
		time_data[4] = current_time.min % 10
	end
	
	return time_data
end

-- Draws each horizontal and vertical lines necessary to draw the number received as argument.
-- p_number: The number to draw.
-- p_x: The X value of the top-left coordinates to draw the number at.
-- p_y: The Y value of the top-left coordinates to draw the number at.
-- p_width: The width of the drawn number.
-- p_height: The height of the drawn number.
function draw_number(p_number, p_x, p_y, p_width, p_height)
	local tab = {}
	
	if p_number == 0 then
		tab = zero
	elseif p_number == 1 then
		tab = one
	elseif p_number == 2 then
		tab = two
	elseif p_number == 3 then
		tab = three
	elseif p_number == 4 then
		tab = four
	elseif p_number == 5 then
		tab = five
	elseif p_number == 6 then
		tab = six
	elseif p_number == 7 then
		tab = seven
	elseif p_number == 8 then
		tab = eight
	elseif p_number == 9 then
		tab = nine
	else
		-- Do nothing.
	end
	
	for i = 1, 7 do
		if tab[i] then
			draw_line(i, p_x, p_y, p_width, p_height)
		end
	end
end

-- Draws a single line.
-- p_line_number: The position of the line to draw in the table.
-- p_x: The X value of the top-left coordinates to draw the line at.
-- p_y: The Y value of the top-left coordinates to draw the line at.
-- p_width: The width of the drawn line.
-- p_height: The height of the drawn line.
function draw_line(p_line_number, p_x, p_y, p_width, p_height)
	love.graphics.setColor(r, g, b)
	love.graphics.setLineWidth(line_width)
	-- These values assume that the height is always 2X the width.
	local x_buffer = p_width / 10
	local y_buffer = p_height / 20
	local end_length = line_width / 2
	if p_line_number == 1 then
		love.graphics.line(x_buffer + p_x, 2 * y_buffer + p_y, x_buffer + p_x, (p_height / 2) - y_buffer + p_y) -- Line 1.
		draw_triangle(x_buffer + p_x, 2 * y_buffer + p_y, line_width, end_length, "up")
		draw_triangle(x_buffer + p_x, (p_height / 2) - y_buffer + p_y, line_width, end_length, "down")
	elseif p_line_number == 2 then
		love.graphics.line(x_buffer * 2 + p_x, y_buffer + p_y, p_width - (2 * x_buffer) + p_x, y_buffer + p_y) -- Line 2.
		draw_triangle(x_buffer * 2 + p_x, y_buffer + p_y, line_width, end_length, "left")
		draw_triangle(p_width - (2 * x_buffer) + p_x, y_buffer + p_y, line_width, end_length, "right")
	elseif p_line_number == 3 then
		love.graphics.line(p_width - x_buffer + p_x, 2 * y_buffer + p_y, p_width - x_buffer + p_x, (p_height / 2) - y_buffer + p_y) -- Line 3.
		draw_triangle(p_width - x_buffer + p_x, 2 * y_buffer + p_y, line_width, end_length, "up")
		draw_triangle(p_width - x_buffer + p_x, (p_height / 2) - y_buffer + p_y, line_width, end_length, "down")
	elseif p_line_number == 4 then
		love.graphics.line(2 * x_buffer + p_x, p_height / 2 + p_y, p_width - (2 * x_buffer) + p_x, p_height / 2 + p_y) -- Line 4.
		draw_triangle(2 * x_buffer + p_x, p_height / 2 + p_y, line_width, end_length, "left")
		draw_triangle(p_width - (2 * x_buffer) + p_x, p_height / 2 + p_y, line_width, end_length, "right")
	elseif p_line_number == 5 then
		love.graphics.line(x_buffer + p_x, (p_height / 2) + y_buffer + p_y, x_buffer + p_x, p_height - (2 * y_buffer) + p_y) -- Line 5.
		draw_triangle(x_buffer + p_x, (p_height / 2) + y_buffer + p_y, line_width, end_length, "up")
		draw_triangle(x_buffer + p_x, p_height - (2 * y_buffer) + p_y, line_width, end_length, "down")
	elseif p_line_number == 6 then
		love.graphics.line(2 * x_buffer + p_x, p_height - y_buffer + p_y, p_width - (2 * x_buffer) + p_x, p_height - y_buffer + p_y) -- Line 6.
		draw_triangle(2 * x_buffer + p_x, p_height - y_buffer + p_y, line_width, end_length, "left")
		draw_triangle(p_width - (2 * x_buffer) + p_x, p_height - y_buffer + p_y, line_width, end_length, "right")
	elseif p_line_number == 7 then
		love.graphics.line(p_width - x_buffer + p_x, (p_height / 2) + y_buffer + p_y, p_width - x_buffer + p_x, p_height - (2 * y_buffer) + p_y) -- Line 7.
		draw_triangle(p_width - x_buffer + p_x, (p_height / 2) + y_buffer + p_y, line_width, end_length, "up")
		draw_triangle(p_width - x_buffer + p_x, p_height - (2 * y_buffer) + p_y, line_width, end_length, "down")
	else
		-- Do nothing.
	end
end

-- Draws a triangle at the given coordinates pointing at the given direction.
-- p_x: The X value of the coordinates of the base side of the triangle.
-- p_y: The Y value of the coordinates of the base side of the triangle.
-- p_side: The length of the base side of the triangle.
-- p_length: The length from the center of the base to the end of the point.
-- p_direction: The direction toward which the point will point to.
-- 		This value can be any of these 4 values: "up", "down", "left" or "right".
function draw_triangle(p_x, p_y, p_side, p_length, p_direction)
	love.graphics.setColor(r, g, b)
	if p_direction == "up" then
		love.graphics.polygon("fill", p_x - (p_side / 2), p_y, p_x + (p_side / 2), p_y, p_x, p_y - p_length)
	elseif p_direction == "down" then
		love.graphics.polygon("fill", p_x - (p_side / 2), p_y, p_x + (p_side / 2), p_y, p_x, p_y + p_length)
	elseif p_direction == "left" then
		love.graphics.polygon("fill", p_x, p_y - (p_side / 2), p_x, p_y + (p_side / 2), p_x - p_length, p_y)
	elseif p_direction == "right" then
		love.graphics.polygon("fill", p_x, p_y - (p_side / 2), p_x, p_y + (p_side / 2), p_x + p_length, p_y)
	end
end

-- Draws all 4 numbers composing the time on the screen.
function draw_time()
	local x, y, width, height = 0, 0, window_width / 5, window_height
	for k, v in pairs(numbers) do
		--print(k .. ":" .. v)
		draw_number(v, x, y, width, height)
		x = x + (window_width / 5)
		-- After the second number, skip one column for the colon.
		if k == 2 then
			x = x + (window_width / 5)
		end
	end
end

-- Draws the colon at the center of the window.
function draw_colon(p_x, p_y, p_width, p_height)
	love.graphics.rectangle("fill", (window_width / 2) - (colon_dot_size / 2), (window_height / 3) - (colon_dot_size / 2), colon_dot_size, colon_dot_size)
	love.graphics.rectangle("fill", (window_width / 2) - (colon_dot_size / 2), ((window_height / 3) * 2) - (colon_dot_size / 2), colon_dot_size, colon_dot_size)
end

-- Updates the color of the time shown on screen.
-- It creates a color morphing effect that looks similar to RGB lights and PC hardware and accessories.
-- Here is the logic:
-- 		Stage 1: Red is set to 1, Green is incremented until it reaches 1.
-- 		Stage 2: Green is set to 1, Red is decremented until it reaches 0.
-- 		Stage 3: Green is set to 1, Blue is incremented until it reaches 1.
-- 		Stage 4: Blue is set to 1, Green is decremented until it reaches 0.
-- 		Stage 5: Blue is set to 1, Red is incremented until it reaches 1.
-- 		Stage 6: Red is set to 1, Blue is decremented until it reaches 0.
--		Return to Stage 1.
function update_color()
	if stage == 1 then
		if g < 1 then
			g = g + 0.01
		else
			stage = stage + 1
		end
	elseif stage == 2 then
		if r > 0 then
			r = r - 0.01
		else
			stage = stage + 1
		end
	elseif stage == 3 then
		if b < 1 then
			b = b + 0.01
		else
			stage = stage + 1
		end
	elseif stage == 4 then
		if g > 0 then
			g = g - 0.01
		else
			stage = stage + 1
		end
	elseif stage == 5 then
		if r < 1 then
			r = r + 0.01
		else
			stage = stage + 1
		end
	elseif stage == 6 then
		if b > 0 then
			b = b - 0.01
		else
			stage = 1
		end
	end
end
