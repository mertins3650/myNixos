local M = {}

-- Reset all dwindle split ratios to 50/50 in the current workspace.
-- (was reset-splits.sh)
function M.reset_splits()
	local active = hl.get_active_window()
	if not active then
		return
	end
	local ws = hl.get_active_workspace()
	if not ws then
		return
	end
	for _, w in ipairs(hl.get_workspace_windows(ws.id) or {}) do
		if not w.floating then
			hl.dispatch(hl.dsp.focus({ window = "address:" .. w.address }))
			hl.dispatch(hl.dsp.layout("splitratio 1 exact"))
		end
	end
	hl.dispatch(hl.dsp.focus({ window = "address:" .. active.address }))
end

-- Resize the focused dwindle window in fixed pixel steps.
-- (was dwindle-resize.sh)
function M.dwindle_resize(direction)
	local w = hl.get_active_window()
	if not w or not w.size then
		return
	end
	local win_w, win_h = w.size[1], w.size[2]
	local target_w = direction == "up" and (win_w + 200) or math.max(200, win_w - 200)
	hl.dispatch(hl.dsp.window.resize({ x = target_w, y = win_h, relative = false }))
end

local function is_scrolling()
	local ws = hl.get_active_workspace()
	return ws and ws.tiled_layout == "scrolling"
end

-- Layout-aware breakpoint resize. On scrolling layout, step through colresize
-- breakpoints; on dwindle, fall through to the pixel-step resize above.
-- (was resize-step.sh)
function M.resize_step(direction)
	if is_scrolling() then
		hl.dispatch(hl.dsp.layout(direction == "up" and "colresize +conf" or "colresize -conf"))
	else
		M.dwindle_resize(direction)
	end
end

-- Resize all columns on the active workspace to the same config breakpoint.
-- (was colresize-all.sh) State (the current step index) is held in this
-- upvalue, replacing the old /tmp/hypr-colresize-all-index file. The state
-- resets to mid (0.5) on Hyprland restart, which matches the old behaviour
-- when the file didn't exist yet.
local colresize_breakpoints = { 0.2, 0.25, 0.333, 0.5, 0.667, 1.0 }
local colresize_idx = 4 -- 1-indexed, starts at 0.5
function M.colresize_all(direction)
	if not is_scrolling() then
		hl.exec_cmd('notify-send "err" "Can only resize all in scrolling mode"')
		return
	end
	if direction == "up" then
		colresize_idx = math.min(colresize_idx + 1, #colresize_breakpoints)
	else
		colresize_idx = math.max(colresize_idx - 1, 1)
	end
	hl.dispatch(hl.dsp.layout("colresize all " .. tostring(colresize_breakpoints[colresize_idx])))
end

-- Toggle the focused window between a named special workspace and the
-- current regular workspace. (was toggle-special-move.sh)
function M.toggle_special_move(name)
	local w = hl.get_active_window()
	if not w then
		return
	end
	local special = "special:" .. name
	if w.workspace and w.workspace.name == special then
		local mon = hl.get_active_monitor()
		local target = mon and mon.active_workspace and mon.active_workspace.id
		if not target then
			return
		end
		hl.dispatch(hl.dsp.window.move({
			workspace = target,
			window = "address:" .. w.address,
			follow = false,
		}))
	else
		hl.dispatch(hl.dsp.window.move({
			workspace = special,
			window = "address:" .. w.address,
			follow = false,
		}))
	end
end

return M
