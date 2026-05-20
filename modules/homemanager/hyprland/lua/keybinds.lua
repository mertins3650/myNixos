local app = function(cmd)
	return hl.dsp.exec_cmd("uwsm app -- " .. cmd)
end

local binds = {
	{ "SUPER + RETURN", app("ghostty") },
	{ "SUPER + D", app("rofi -show drun") },
	{ "SUPER + Q", hl.dsp.window.kill() },
}

for _, bind in ipairs(binds) do
	hl.bind(bind[1], bind[2])
end
