require("luasnip.session.snippet_collection").clear_snippets("lua")

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("lua", {
	s("req", fmt("local {} = require('{}')", { i(1), i(2) })),
})
