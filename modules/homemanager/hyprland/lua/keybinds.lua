-- helper functions
local app = function(cmd)
	return hl.dsp.exec_cmd("uwsm app -- " .. cmd)
end

local focus = function(cmd)
	return hl.dsp.focus({ direction = cmd })
end

local move_focus = function(cmd)
	return hl.dsp.window.move({ direction = cmd })
end

local focus_workspace = function(cmd)
	return hl.dsp.focus({ workspace = cmd })
end

local move_workspace = function(cmd)
	return hl.dsp.window.move({ workspace = cmd })
end

local binds = {
	{ "SUPER + RETURN", app("ghostty") },
	{ "SUPER + D", app("rofi -show drun") },
	{ "SUPER + Q", hl.dsp.window.kill() },
	-- focus window
	{ "SUPER + H", focus("left") },
	{ "SUPER + J", focus("down") },
	{ "SUPER + K", focus("up") },
	{ "SUPER + L", focus("right") },
	-- move window
	{ "SUPER + SHIFT + H", move_focus("left") },
	{ "SUPER + SHIFT + J", move_focus("down") },
	{ "SUPER + SHIFT + K", move_focus("up") },
	{ "SUPER + SHIFT + L", move_focus("right") },
}

for _, bind in ipairs(binds) do
	hl.bind(bind[1], bind[2])
end
-- move focus to workspace
for i = 1, 9 do
	hl.bind("SUPER + " .. i, focus_workspace(i))
end

-- move window to workspace
for i = 1, 9 do
	hl.bind("SUPER + SHIFT + " .. i, move_workspace(i))
end
