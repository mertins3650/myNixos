local active_border_color = { colors = { "rgb(ebbcba)", "rgb(ebbcba)", "rgb(eb6f92)", "rgb(c4a7e7)" }, angle = 90 }
local inactive_border_color = "rgba(595959aa)"
hl.config({
	xwayland = {
		force_zero_scaling = true,
	},

	ecosystem = {
		no_update_news = true,
	},

	animations = {
		enabled = false,
	},

	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		col = {
			active_border = active_border_color,
			inactive_border = inactive_border_color,
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 0,

		shadow = {
			enabled = true,
			range = 2,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			size = 2,
			passes = 2,
			special = true,
			brightness = 0.60,
			contrast = 0.75,
		},
	},

	dwindle = {
		preserve_split = true,
		force_split = 2,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		disable_scale_notification = true,
		focus_on_activate = true,
		anr_missed_pings = 3,
		on_focus_under_fullscreen = 1,
	},

	cursor = {
		hide_on_key_press = true,
		warp_on_change_workspace = 1,
	},
})
