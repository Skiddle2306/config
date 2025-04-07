vim.g.mapleader = " "

local keymap = vim.keymap --for conciseness

keymap.set("i","jk","<ESC>",{desc = "Exit inset mode with jk"})
