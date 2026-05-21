-- ==========================================
-- WINDOW RULES
-- ==========================================

local window_rules = {
	{ match = { class = ".*" }, opacity = "1 0.95" },
	{ match = { class = ".*" }, suppress_event = "maximize" },

	{ match = { workspace = "w[tv1]" }, float = false, border_size = 0, rounding = 0 },
	{ match = { workspace = "f[1]" }, float = false, border_size = 0, rounding = 0 },

	{ match = { tag = "floating-window" }, float = true },
	{ match = { tag = "floating-window" }, center = true },
	{ match = { tag = "floating-window" }, size = { 875, 600 } },

	{
		match = {
			class = "(org.nixy.bluetui|org.nixy.impala|org.nixy.wiremix|org.nixy.btop|org.nixy.terminal|org.nixy.bash|org.gnome.NautilusPreviewer|org.gnome.Evince|com.gabm.satty|nixy|About|TUI.float|imv|mpv)",
		},
		tag = "+floating-window",
	},
	{
		match = {
			class = "(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus)",
			title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)",
		},
		tag = "+floating-window",
	},

	{ match = { class = "org.gnome.Calculator" }, float = true },
	{ match = { class = "hyprland-run" }, float = true, move = "20 monitor_h-120" },

	{ match = { class = "steam" }, float = true },
	{ match = { class = "steam" }, opacity = "1 1" },
	{ match = { class = "steam" }, idle_inhibit = "fullscreen" },
	{ match = { class = "steam", title = "Steam" }, center = true },
	{ match = { class = "steam", title = "Steam" }, size = { 1100, 700 } },
	{ match = { class = "steam", title = "Friends List" }, size = { 460, 800 } },

	{
		match = {
			class = "^$",
			title = "^$",
			xwayland = true,
			workspace = "w[f1]",
		},
		no_focus = true,
	},
}

for _, rule in ipairs(window_rules) do
	hl.window_rule(rule)
end

-- ==========================================
-- WORKSPACE RULES
-- ==========================================

local workspace_rules = {
	{ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 },
	{ workspace = "f[1]", gaps_out = 0, gaps_in = 0 },
}

for _, rule in ipairs(workspace_rules) do
	hl.workspace_rule(rule)
end
