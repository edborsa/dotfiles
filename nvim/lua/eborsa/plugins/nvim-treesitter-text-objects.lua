return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  event = "VeryLazy",
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
      },
      move = {
        set_jumps = true,
      },
    })

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

    local function select_textobject(query, query_group)
      return function()
        select.select_textobject(query, query_group or "textobjects")
      end
    end

    local function goto_next_start(query, query_group)
      return function()
        move.goto_next_start(query, query_group or "textobjects")
      end
    end

    local function goto_next_end(query, query_group)
      return function()
        move.goto_next_end(query, query_group or "textobjects")
      end
    end

    local function goto_previous_start(query, query_group)
      return function()
        move.goto_previous_start(query, query_group or "textobjects")
      end
    end

    local function goto_previous_end(query, query_group)
      return function()
        move.goto_previous_end(query, query_group or "textobjects")
      end
    end

    local function swap_next(query)
      return function()
        swap.swap_next(query)
      end
    end

    local function swap_previous(query)
      return function()
        swap.swap_previous(query)
      end
    end

    vim.keymap.set({ "x", "o" }, "a=", select_textobject("@assignment.outer"), { desc = "Select assignment outer" })
    vim.keymap.set({ "x", "o" }, "i=", select_textobject("@assignment.inner"), { desc = "Select assignment inner" })
    vim.keymap.set({ "x", "o" }, "l=", select_textobject("@assignment.lhs"), { desc = "Select assignment lhs" })
    vim.keymap.set({ "x", "o" }, "r=", select_textobject("@assignment.rhs"), { desc = "Select assignment rhs" })
    vim.keymap.set({ "x", "o" }, "a:", select_textobject("@property.outer"), { desc = "Select property outer" })
    vim.keymap.set({ "x", "o" }, "i:", select_textobject("@property.inner"), { desc = "Select property inner" })
    vim.keymap.set({ "x", "o" }, "l:", select_textobject("@property.lhs"), { desc = "Select property lhs" })
    vim.keymap.set({ "x", "o" }, "r:", select_textobject("@property.rhs"), { desc = "Select property rhs" })
    vim.keymap.set({ "x", "o" }, "aa", select_textobject("@parameter.outer"), { desc = "Select parameter outer" })
    vim.keymap.set({ "x", "o" }, "ia", select_textobject("@parameter.inner"), { desc = "Select parameter inner" })
    vim.keymap.set({ "x", "o" }, "ai", select_textobject("@conditional.outer"), { desc = "Select conditional outer" })
    vim.keymap.set({ "x", "o" }, "ii", select_textobject("@conditional.inner"), { desc = "Select conditional inner" })
    vim.keymap.set({ "x", "o" }, "al", select_textobject("@loop.outer"), { desc = "Select loop outer" })
    vim.keymap.set({ "x", "o" }, "il", select_textobject("@loop.inner"), { desc = "Select loop inner" })
    vim.keymap.set({ "x", "o" }, "af", select_textobject("@call.outer"), { desc = "Select call outer" })
    vim.keymap.set({ "x", "o" }, "if", select_textobject("@call.inner"), { desc = "Select call inner" })
    vim.keymap.set({ "x", "o" }, "am", select_textobject("@function.outer"), { desc = "Select function outer" })
    vim.keymap.set({ "x", "o" }, "im", select_textobject("@function.inner"), { desc = "Select function inner" })
    vim.keymap.set({ "x", "o" }, "ac", select_textobject("@class.outer"), { desc = "Select class outer" })
    vim.keymap.set({ "x", "o" }, "ic", select_textobject("@class.inner"), { desc = "Select class inner" })

    vim.keymap.set("n", "<leader>na", swap_next("@parameter.inner"), { desc = "Swap next parameter" })
    vim.keymap.set("n", "<leader>n:", swap_next("@property.outer"), { desc = "Swap next property" })
    vim.keymap.set("n", "<leader>nm", swap_next("@function.outer"), { desc = "Swap next function" })
    vim.keymap.set("n", "<leader>pa", swap_previous("@parameter.inner"), { desc = "Swap previous parameter" })
    vim.keymap.set("n", "<leader>p:", swap_previous("@property.outer"), { desc = "Swap previous property" })
    vim.keymap.set("n", "<leader>pm", swap_previous("@function.outer"), { desc = "Swap previous function" })

    vim.keymap.set({ "n", "x", "o" }, "]f", goto_next_start("@call.outer"), { desc = "Next function call start" })
    vim.keymap.set({ "n", "x", "o" }, "]m", goto_next_start("@function.outer"), { desc = "Next function start" })
    vim.keymap.set({ "n", "x", "o" }, "]c", goto_next_start("@class.outer"), { desc = "Next class start" })
    vim.keymap.set({ "n", "x", "o" }, "]i", goto_next_start("@conditional.outer"), { desc = "Next conditional start" })
    vim.keymap.set({ "n", "x", "o" }, "]l", goto_next_start("@loop.outer"), { desc = "Next loop start" })
    vim.keymap.set({ "n", "x", "o" }, "]s", goto_next_start("@scope", "locals"), { desc = "Next scope" })
    vim.keymap.set({ "n", "x", "o" }, "]z", goto_next_start("@fold", "folds"), { desc = "Next fold" })
    vim.keymap.set({ "n", "x", "o" }, "]F", goto_next_end("@call.outer"), { desc = "Next function call end" })
    vim.keymap.set({ "n", "x", "o" }, "]M", goto_next_end("@function.outer"), { desc = "Next function end" })
    vim.keymap.set({ "n", "x", "o" }, "]C", goto_next_end("@class.outer"), { desc = "Next class end" })
    vim.keymap.set({ "n", "x", "o" }, "]I", goto_next_end("@conditional.outer"), { desc = "Next conditional end" })
    vim.keymap.set({ "n", "x", "o" }, "]L", goto_next_end("@loop.outer"), { desc = "Next loop end" })
    vim.keymap.set({ "n", "x", "o" }, "[f", goto_previous_start("@call.outer"), { desc = "Previous function call start" })
    vim.keymap.set({ "n", "x", "o" }, "[m", goto_previous_start("@function.outer"), { desc = "Previous function start" })
    vim.keymap.set({ "n", "x", "o" }, "[c", goto_previous_start("@class.outer"), { desc = "Previous class start" })
    vim.keymap.set({ "n", "x", "o" }, "[i", goto_previous_start("@conditional.outer"), { desc = "Previous conditional start" })
    vim.keymap.set({ "n", "x", "o" }, "[l", goto_previous_start("@loop.outer"), { desc = "Previous loop start" })
    vim.keymap.set({ "n", "x", "o" }, "[F", goto_previous_end("@call.outer"), { desc = "Previous function call end" })
    vim.keymap.set({ "n", "x", "o" }, "[M", goto_previous_end("@function.outer"), { desc = "Previous function end" })
    vim.keymap.set({ "n", "x", "o" }, "[C", goto_previous_end("@class.outer"), { desc = "Previous class end" })
    vim.keymap.set({ "n", "x", "o" }, "[I", goto_previous_end("@conditional.outer"), { desc = "Previous conditional end" })
    vim.keymap.set({ "n", "x", "o" }, "[L", goto_previous_end("@loop.outer"), { desc = "Previous loop end" })

    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  end,
}
