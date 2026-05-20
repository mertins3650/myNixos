-- helper functions
local app = function(cmd)
	return hl.dsp.exec_cmd("uwsm app -- " .. cmd)
end

local focus = function(dir)
	return hl.dsp.focus({ direction = dir })
end

local move_focus = function(dir)
	return hl.dsp.window.move({ direction = dir })
end

local focus_workspace = function(ws)
	return hl.dsp.focus({ workspace = ws })
end

local move_workspace = function(ws)
	return hl.dsp.window.move({ workspace = ws })
end

local exec = function(cmd)
	return hl.dsp.exec_cmd(cmd)
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
	-- screenshots
	{ "PRINT", exec("cmd-screenshot"), "Screenshot with editing" },
	{ "SHIFT + PRINT", exec("cmd-screenshot smart clipboard"), "Screenshot to clipboard" },
	-- dismiss notifications
	{ "SUPER + COMMA", exec("makoctl dismiss"), "Dismiss last notification" },
	{ "SUPER + SHIFT + COMMA", exec("makoctl dismiss --all"), "Dismiss all notifications" },
	-- audio and brightness
	{ "XF86AudioRaiseVolume", exec("swayosd-client-wrapper --output-volume raise") },
	{ "XF86AudioLowerVolume", exec("swayosd-client-wrapper --output-volume lower") },
	{ "XF86AudioMute", exec("swayosd-client-wrapper --output-volume mute-toggle") },
	{ "XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-brightness-display +5%") },
	{ "XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-brightness-display +5%-") },
}

for _, bind in ipairs(binds) do
	hl.bind(bind[1], bind[2], bind[3] and { description = bind[3] } or nil)
end

hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })

-- focus/move to workspace
for i = 1, 9 do
	hl.bind("SUPER + " .. i, focus_workspace(i))
	hl.bind("SUPER + SHIFT + " .. i, move_workspace(i))
end
