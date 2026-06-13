-- helper functions
local app = function(cmd)
	return hl.dsp.exec_cmd("uwsm app -- " .. cmd)
end

local wep_app = function(cmd)
	return hl.dsp.exec_cmd('launch-webapp "' .. cmd .. '"')
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

local function has_external_monitor()
	local monitors = hl.get_monitors()

	if #monitors > 1 then
		return true
	end

	if #monitors == 1 and monitors[1].name ~= "eDP-1" then
		return true
	end

	return false
end

local binds = {
	-- apps
	{ "SUPER + RETURN", app("ghostty") },
	{ "SUPER + D", app("rofi -show drun") },
	{ "SUPER + CTRL + F", app("nautilus --new-window") },
	{ "SUPER + SHIFT + F", app("ghostty -e yazi") },
	{ "SUPER + SHIFT + B", app("zen") },
	{ "SUPER + SHIFT + ALT + B", app("zen --private-window") },

	-- webapps
	{ "SUPER + SHIFT + A", wep_app("https://chat.deepseek.com/") },
	{ "SUPER + SHIFT + Y", wep_app("https://youtube.com") },
	{ "SUPER + SHIFT + C", wep_app("https://calendar.proton.me/") },
	{ "SUPER + SHIFT + E", wep_app("https://mail.proton.me/") },
	{ "SUPER + SHIFT + T", wep_app("https://twitch.tv") },
	{ "SUPER + SHIFT + R", wep_app("https://reddit.com") },
	{ "SUPER + CTRL + J", wep_app("http://jellyfin.mertins.net") },

	-- window management
	{ "SUPER + T", hl.dsp.window.float("true") },
	{ "SUPER + P", hl.dsp.window.pseudo("true") },
	{ "SUPER + F", hl.dsp.window.fullscreen("fullscreen") },
	{ "SUPER + Q", hl.dsp.window.close() },
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
	{
		"XF86AudioRaiseVolume",
		exec("swayosd-client-wrapper --output-volume raise"),
		{ locked = true, repeating = true },
	},
	{
		"XF86AudioLowerVolume",
		exec("swayosd-client-wrapper --output-volume lower"),
		{ locked = true, repeating = true },
	},
	{ "XF86AudioMute", exec("swayosd-client-wrapper --output-volume mute-toggle") },
	{ "XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-brightness-display +5%"), { locked = true, repeating = true } },
	{
		"XF86MonBrightnessDown",
		hl.dsp.exec_cmd("swayosd-brightness-display +5%-"),
		{ locked = true, repeating = true },
	},
	-- laptop lid
	{
		"switch:on:Lid Switch",
		function()
			if has_external_monitor() then
				hl.monitor({ output = "eDP-1", disabled = true })
			end
		end,
		{ locked = true },
	},
	{
		"switch:off:Lid Switch",
		function()
			hl.monitor({
				output = "eDP-1",
				mode = "preferred",
				position = "auto",
				scale = 1.25,
				disabled = false,
			})
		end,
		{ locked = true },
	},
}

for _, bind in ipairs(binds) do
	hl.bind(bind[1], bind[2], bind[3] or nil)
end

hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })

-- focus/move to workspace
for i = 1, 9 do
	hl.bind("SUPER + " .. i, focus_workspace(i))
	hl.bind("SUPER + SHIFT + " .. i, move_workspace(i))
end
