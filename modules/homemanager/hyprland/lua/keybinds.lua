local M = {}

local actions = nil
local function ensure_actions()
	if actions == nil and hl then
		actions = require("actions")
	end
	return actions
end

local A = {}
A.exec = function(c)
	return { exec = c }
end
-- Launch a graphical app via `uwsm app --` so it gets its own scope in
-- app-graphical.slice with a fresh NOTIFY_SOCKET. Required for terminals
-- (and anything that may run sd_notify-emitting children like podman/conmon)
-- to avoid sd_notify MAINPID hijack tearing down the compositor.
-- See uwsm#67.
A.exec_app = function(c)
	return { exec = "uwsm app -- " .. c }
end

A.exec_webapp = function(c)
	return { exec = "launch-webapp " .. c }
end

A.kill = function()
	return {
		dispatch = function()
			return hl.dsp.window.kill()
		end,
	}
end
A.toggle_float = function()
	return {
		dispatch = function()
			return hl.dsp.window.float()
		end,
	}
end
A.fullscreen = function(mode)
	return {
		dispatch = function()
			return hl.dsp.window.fullscreen({ mode = mode })
		end,
	}
end
A.pin = function()
	return {
		dispatch = function()
			return hl.dsp.window.pin()
		end,
	}
end
A.focus_dir = function(d)
	return {
		dispatch = function()
			return hl.dsp.focus({ direction = d })
		end,
	}
end
A.swap_dir = function(d)
	return {
		dispatch = function()
			return hl.dsp.window.swap({ direction = d })
		end,
	}
end
A.move_xy = function(x, y)
	return {
		dispatch = function()
			return hl.dsp.window.move({ x = x, y = y, relative = true })
		end,
	}
end
A.resize_xy = function(x, y)
	return {
		dispatch = function()
			return hl.dsp.window.resize({ x = x, y = y, relative = true })
		end,
	}
end
A.focus_ws = function(n)
	return {
		dispatch = function()
			return hl.dsp.focus({ workspace = n })
		end,
	}
end
A.move_ws_silent = function(n)
	return {
		dispatch = function()
			return hl.dsp.window.move({ workspace = n, follow = false })
		end,
	}
end
A.toggle_special = function(n)
	return {
		dispatch = function()
			return hl.dsp.workspace.toggle_special(n)
		end,
	}
end
A.layout = function(m)
	return {
		dispatch = function()
			return hl.dsp.layout(m)
		end,
	}
end
A.drag = function()
	return {
		dispatch = function()
			return hl.dsp.window.drag()
		end,
	}
end
A.mresize = function()
	return {
		dispatch = function()
			return hl.dsp.window.resize()
		end,
	}
end
A.float_and_pin = function()
	return {
		fn = function()
			hl.dispatch(hl.dsp.window.float())
			hl.dispatch(hl.dsp.window.pin())
		end,
	}
end

-- Native-Lua helpers from actions.lua (replace the old hypr-* shell scripts).
A.reset_splits = function()
	return {
		fn = function()
			ensure_actions().reset_splits()
		end,
	}
end
A.dwindle_resize = function(d)
	return {
		fn = function()
			ensure_actions().dwindle_resize(d)
		end,
	}
end
A.resize_step = function(d)
	return {
		fn = function()
			ensure_actions().resize_step(d)
		end,
	}
end
A.colresize_all = function(d)
	return {
		fn = function()
			ensure_actions().colresize_all(d)
		end,
	}
end
A.toggle_special_move = function(n)
	return {
		fn = function()
			ensure_actions().toggle_special_move(n)
		end,
	}
end

M.binds = {
	-- Window management
	{ keys = "SUPER + Return", desc = "Open terminal", action = A.exec_app("ghostty") },
	{ keys = "SUPER + d", desc = "App launcher", action = A.exec_app("rofi -show drun") },
	{ keys = "SUPER + q", desc = "Kill active window", action = A.kill() },
	{
		keys = "SUPER + ALT + q",
		desc = "Force kill active window",
		action = A.exec("kill -9 $(hyprctl activewindow -j | jq -r '.pid')"),
	},
	{ keys = "SUPER + t", desc = "Toggle floating", action = A.toggle_float() },
	{ keys = "SUPER + f", desc = "Fullscreen", action = A.fullscreen("fullscreen") },
	{ keys = "SUPER + SHIFT + f", desc = "Fake fullscreen", action = A.fullscreen("maximized") },
	{ keys = "SUPER + SHIFT + t", desc = "Pin window", action = A.pin() },
	{ keys = "SUPER + p", desc = "Float and pin window", action = A.float_and_pin() },

	-- Window navigation
	{ keys = "SUPER + h", desc = "Focus window left", action = A.focus_dir("l") },
	{ keys = "SUPER + l", desc = "Focus window right", action = A.focus_dir("r") },
	{ keys = "SUPER + k", desc = "Focus window up", action = A.focus_dir("u") },
	{ keys = "SUPER + j", desc = "Focus window down", action = A.focus_dir("d") },
	{ keys = "SUPER + SHIFT + h", desc = "Swap window left", action = A.swap_dir("l") },
	{ keys = "SUPER + SHIFT + l", desc = "Swap window right", action = A.swap_dir("r") },
	{ keys = "SUPER + SHIFT + k", desc = "Swap window up", action = A.swap_dir("u") },
	{ keys = "SUPER + SHIFT + j", desc = "Swap window down", action = A.swap_dir("d") },

	-- Window resize & move
	{
		keys = "SUPER + left",
		desc = "Move floating window left",
		action = A.move_xy(-20, 0),
		repeating = true,
	},
	{
		keys = "SUPER + right",
		desc = "Move floating window right",
		action = A.move_xy(20, 0),
		repeating = true,
	},
	{
		keys = "SUPER + up",
		desc = "Move floating window up",
		action = A.move_xy(0, -60),
		repeating = true,
	},
	{
		keys = "SUPER + down",
		desc = "Move floating window down",
		action = A.move_xy(0, 60),
		repeating = true,
	},
	{ keys = "SUPER + ALT + h", desc = "Shrink window to previous breakpoint", action = A.resize_step("down") },
	{ keys = "SUPER + ALT + l", desc = "Grow window to next breakpoint", action = A.resize_step("up") },
	{
		keys = "SUPER + ALT + k",
		desc = "Resize window up",
		action = A.resize_xy(0, -20),
		repeating = true,
	},
	{
		keys = "SUPER + ALT + j",
		desc = "Resize window down",
		action = A.resize_xy(0, 20),
		repeating = true,
	},

	-- Workspaces
	{ keys = "SUPER + 1", desc = "Switch to workspace 1", action = A.focus_ws(1) },
	{ keys = "SUPER + 2", desc = "Switch to workspace 2", action = A.focus_ws(2) },
	{ keys = "SUPER + 3", desc = "Switch to workspace 3", action = A.focus_ws(3) },
	{ keys = "SUPER + 4", desc = "Switch to workspace 4", action = A.focus_ws(4) },
	{ keys = "SUPER + 5", desc = "Switch to workspace 5", action = A.focus_ws(5) },
	{ keys = "SUPER + 6", desc = "Switch to workspace 6", action = A.focus_ws(6) },
	{ keys = "SUPER + 7", desc = "Switch to workspace 7", action = A.focus_ws(7) },
	{ keys = "SUPER + 8", desc = "Switch to workspace 8", action = A.focus_ws(8) },
	{ keys = "SUPER + 9", desc = "Switch to workspace 9", action = A.focus_ws(9) },
	{ keys = "SUPER + 0", desc = "Switch to workspace 10", action = A.focus_ws(10) },
	{ keys = "SUPER + SHIFT + 1", desc = "Move to workspace 1", action = A.move_ws_silent(1) },
	{ keys = "SUPER + SHIFT + 2", desc = "Move to workspace 2", action = A.move_ws_silent(2) },
	{ keys = "SUPER + SHIFT + 3", desc = "Move to workspace 3", action = A.move_ws_silent(3) },
	{ keys = "SUPER + SHIFT + 4", desc = "Move to workspace 4", action = A.move_ws_silent(4) },
	{ keys = "SUPER + SHIFT + 5", desc = "Move to workspace 5", action = A.move_ws_silent(5) },
	{ keys = "SUPER + SHIFT + 6", desc = "Move to workspace 6", action = A.move_ws_silent(6) },
	{ keys = "SUPER + SHIFT + 7", desc = "Move to workspace 7", action = A.move_ws_silent(7) },
	{ keys = "SUPER + SHIFT + 8", desc = "Move to workspace 8", action = A.move_ws_silent(8) },
	{ keys = "SUPER + SHIFT + 9", desc = "Move to workspace 9", action = A.move_ws_silent(9) },
	{ keys = "SUPER + SHIFT + 0", desc = "Move to workspace 10", action = A.move_ws_silent(10) },

	-- Special workspaces / scratchpads
	{
		keys = "SUPER + u",
		desc = "Terminal scratchpad",
		action = A.exec_app("pypr-toggle-smart terminal"),
	},
	{
		keys = "SUPER + SHIFT + u",
		desc = "Send window to terminal scratchpad",
		action = A.move_ws_silent("special:scratch_terminal"),
	},
	{
		keys = "SUPER + i",
		desc = "Notes scratchpad",
		action = A.exec_app("pypr-toggle-smart notes"),
	},
	{
		keys = "SUPER + SHIFT + i",
		desc = "Send window to notes scratchpad",
		action = A.move_ws_silent("special:scratch_notes"),
	},
	{
		keys = "SUPER + ALT + i",
		desc = "Lockbook file menu",
		action = A.exec_app("lockbook-menu"),
	},
	{
		keys = "SUPER + o",
		desc = "File manager scratchpad",
		action = A.exec_app("pypr-toggle-smart files"),
	},
	{
		keys = "SUPER + SHIFT + o",
		desc = "Send window to file manager scratchpad",
		action = A.move_ws_silent("special:scratch_files"),
	},
	{
		keys = "SUPER + y",
		desc = "Toggle chat workspace",
		action = A.toggle_special("chat"),
	},
	{
		keys = "SUPER + SHIFT + y",
		desc = "Send window to chat workspace",
		action = A.move_ws_silent("special:chat"),
	},
	{
		keys = "SUPER + SHIFT + semicolon",
		desc = "Toggle scratch workspace",
		action = A.toggle_special("scratch"),
	},
	{
		keys = "SUPER + v",
		desc = "Clipboard history",
		action = A.exec(
			"cliphist list | rofi -dmenu -theme-str 'window { width: 800px; }' | cliphist decode | wl-copy"
		),
	},
	{
		keys = "SUPER + z",
		desc = "Magnify/zoom current window",
		action = A.exec("pypr zoom"),
	},

	-- Layout helpers
	{
		keys = "SUPER + semicolon",
		desc = "Toggle scrolling/dwindle layout",
		action = A.exec("hypr-toggle-layout"),
	},
	{
		keys = "SUPER + ALT + semicolon",
		desc = "Toggle center/fit focus (scrolling)",
		action = A.exec("hypr-toggle-center-focus"),
	},
	{
		keys = "SUPER + SHIFT + apostrophe",
		desc = "Fit all columns on screen",
		action = A.layout("fitsize all"),
	},
	{
		keys = "SUPER + CTRL + h",
		desc = "Shrink all columns one step",
		action = A.colresize_all("down"),
	},
	{
		keys = "SUPER + CTRL + l",
		desc = "Grow all columns one step",
		action = A.colresize_all("up"),
	},
	{
		keys = "SUPER + s",
		desc = "Toggle split direction (dwindle)",
		action = A.layout("togglesplit"),
	},
	{
		keys = "SUPER + x",
		desc = "Swap column right",
		action = A.layout("swapsplit"),
	},
	{
		keys = "SUPER + ALT + m",
		desc = "Move window to root (dwindle)",
		action = A.layout("movetoroot"),
	},
	{ keys = "SUPER + apostrophe", desc = "Reset all splits to 50/50 (dwindle)", action = A.reset_splits() },

	-- Utilities
	{ keys = "SUPER + SHIFT + w", desc = "Wallpaper menu", action = A.exec_app("rofi-wallpaper-menu") },
	{
		keys = "SUPER + SHIFT + b",
		desc = "Randomize waybar gradient",
		action = A.exec("systemctl --user restart waybar-gradient-randomizer"),
	},
	{ keys = "SUPER + n", desc = "VPN menu", action = A.exec_app("rofi-vpn-menu") },
	{ keys = "CTRL + ALT + l", desc = "Lock screen", action = A.exec_app("hyprlock") },
	{ keys = "SUPER + ALT + c", desc = "Color picker", action = A.exec_app("hyprpicker -a") },
	{ keys = "SUPER + ALT + s", desc = "Notify shares", action = A.exec("notify-shares") },
	{ keys = "SUPER + ALT + p", desc = "Screenshot menu", action = A.exec_app("rofi-screenshot-menu") },
	{ keys = "SUPER + SHIFT + p", desc = "Screenshot (region)", action = A.exec("smart-screenshot region") },
	{ keys = "SUPER + r", desc = "Toggle screen recording", action = A.exec("toggle-recording") },

	-- Widgets
	{ keys = "SUPER + b", desc = "Toggle EWW dashboard", action = A.exec_app("eww open --toggle dashboard") },

	-- System
	{ keys = "SUPER + ALT + r", desc = "Reload Hyprland", action = A.exec("hyprctl reload") },
	{ keys = "SUPER + ALT + b", desc = "NixOS Build menu", action = A.exec_app("rofi-nixos-menu") },
	{ keys = "SUPER + ALT + q", desc = "Power menu", action = A.exec_app("rofi-power-menu") },
	{ keys = "SUPER + slash", desc = "Show this keybind menu", action = A.exec_app("rofi-show-keybinds") },

	-- Mouse
	{ keys = "SUPER + mouse:272", desc = "Move window (left click drag)", action = A.drag(), mouse = true },
	{ keys = "SUPER + mouse:273", desc = "Resize window (right click drag)", action = A.mresize(), mouse = true },

	-- Media keys
	{
		keys = "XF86AudioMute",
		desc = "Toggle mute",
		action = A.exec(
			"ponymix toggle && dunstify -r 2593 -u normal \"$(ponymix is-muted && echo '🔇 Muted' || echo '🔊 Volume: '$(ponymix get-volume)'%')\" -h int:value:$(ponymix get-volume)"
		),
		locked = true,
	},
	{
		keys = "XF86AudioLowerVolume",
		desc = "Lower volume",
		action = A.exec(
			"ponymix decrease 2 && dunstify -r 2593 -u normal '🔊 Volume: '$(ponymix get-volume)'%' -h int:value:$(ponymix get-volume)"
		),
		locked = true,
	},
	{
		keys = "XF86AudioRaiseVolume",
		desc = "Raise volume",
		action = A.exec(
			"ponymix increase 2 && dunstify -r 2593 -u normal '🔊 Volume: '$(ponymix get-volume)'%' -h int:value:$(ponymix get-volume)"
		),
		locked = true,
	},
	{
		keys = "XF86MonBrightnessUp",
		desc = "Increase brightness",
		action = A.exec("brightnessctl set +10%"),
		locked = true,
	},
	{
		keys = "XF86MonBrightnessDown",
		desc = "Decrease brightness",
		action = A.exec("brightnessctl set 10%-"),
		locked = true,
	},
}

-- Build a dispatcher (or callback) from an action table.
-- Called lazily so this module can load without `hl` defined.
local function build(action)
	if action.exec then
		return hl.dsp.exec_cmd(action.exec)
	end
	if action.dispatch then
		return action.dispatch()
	end
	if action.fn then
		return action.fn
	end
	error("keybinds: action with no exec/dispatch/fn field")
end

-- Register every bind via hl.bind. Run AFTER device-keybinds has had a chance
-- to mutate or append to M.binds.
function M.register()
	if not hl then
		return
	end
	for _, b in ipairs(M.binds) do
		local flags = { description = b.desc }
		if b.repeating then
			flags.repeating = true
		end
		if b.mouse then
			flags.mouse = true
		end
		if b.locked then
			flags.locked = true
		end
		hl.bind(b.keys, build(b.action), flags)
	end
end

-- Re-export the action helpers so device-keybinds.lua can use them.
M.A = A

return M
