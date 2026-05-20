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

-- Binds without flags or unique logic
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

local descriptive_binds = {
	{ "PRINT", hl.dsp.exec_cmd("cmd-screenshot"), "Screenshot with editing" },
	{ "SHIFT + PRINT", hl.dsp.exec_cmd("cmd-screenshot smart clipboard"), "Screenshot to clipboard" },
	{ "SUPER + COMMA", hl.dsp.exec_cmd("makoctl dismiss"), "Dismiss last notification" },
	{ "SUPER + SHIFT + COMMA", hl.dsp.exec_cmd("makoctl dismiss --all"), "Dismiss all notifications" },
}
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client-wrapper --output-volume raise"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client-wrapper --output-volume lower"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client-wrapper --output-volume mute-toggle"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-brightness +5%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-brightness +5%-"))

for _, b in ipairs(descriptive_binds) do
	hl.bind(b[1], b[2], { description = b[3] })
end

hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })

-- move focus to workspace
for i = 1, 9 do
	hl.bind("SUPER + " .. i, focus_workspace(i))
end

-- move window to workspace
for i = 1, 9 do
	hl.bind("SUPER + SHIFT + " .. i, move_workspace(i))
end
