local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

local function copy(args)
	return args[1]
end

local same = function(index)
	return f(function(arg)
		return arg[1]
	end, {index})
end

local M = {
	s("className", fmt([[
      className={{{}}}
		]], {i(0)})),
	s("next_api_function", fmt([[
    const {} = (req, res) => {{
      {}
      return res.json({{message: "hi"}});
    }};
    export default {};
  ]], {i(1), i(0), same(1)})),
	s("cslog", fmt([[console.log({})]], {i(0)})),
	s("pre", fmt([[<pre>{{JSON.stringify({}, null, 2)}}</pre>]], {i(0)})),
	s("it", fmt([[
        it("{}", async function () {{
          {}
        }})
      ]], {i(1), i(0)})),
	s("describe", fmt([[
        describe("{}", function () {{
          {}
        }});
      ]], {i(1), i(0)}))
}

return M

-- s("it", fmt([[
--    it({}, async function () {{
--    }});
--  ]]), {i(0)})
