return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"rcarriga/nvim-dap-ui",
		"leoluz/nvim-dap-go",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup({})

		require("dap-go").setup({})
		dap.adapters.codelldb = {
			type = "server",
			host = "127.0.0.1",
			port = "${port}",
			executable = {
				command = "$HOME/.local/share/nvim/mason/bin/codelldb",
				args = { "--port", "${port}" },
			},
		}
		dap.adapters.lldb = {
			type = "executable",
			command = "/opt/homebrew/opt/llvm/bin/lldb-vscode",
			name = "lldb",
		}
		dap.configurations.cpp = {
			{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
			},
		}
		dap.configurations.c = dap.configurations.cpp
		dap.configurations.rust = {
			{
				name = "Launch",
				type = "lldb",
				request = "launch",
				program = function()
					local bin_name = vim.fn.input("Binary name to debug: ")
					vim.fn.system("cargo build --target-dir .build --bin " .. bin_name)
					return vim.fn.getcwd() .. "/.build/debug/" .. bin_name
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
				initCommands = function()
					-- Find out where to look for the pretty printer Python module
					local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

					local script_import = 'command script import "'
						.. rustc_sysroot
						.. '/lib/rustlib/etc/lldb_lookup.py"'
					local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

					local commands = {}
					local file = io.open(commands_file, "r")
					if file then
						for line in file:lines() do
							table.insert(commands, line)
						end
						file:close()
					end
					table.insert(commands, 1, script_import)

					return commands
				end,
			},
		}

		vim.keymap.set("n", "<F5>", dap.continue, {})
		vim.keymap.set("n", "<F10>", dap.step_over, {})
		vim.keymap.set("n", "<F11>", dap.step_into, {})
		vim.keymap.set("n", "<F12>", dap.step_out, {})
		vim.keymap.set("n", "<Leader>tb", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<Leader>B", dap.set_breakpoint, {})
		vim.keymap.set("n", "<Leader>lp", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end)
		vim.keymap.set("n", "<Leader>dr", dap.repl.open, {})
		vim.keymap.set("n", "<Leader>dl", dap.run_last, {})

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		local dap_wgt = require("dap.ui.widgets")
		vim.keymap.set({ "n", "v" }, "<Leader>dh", dap_wgt.hover, {})
		vim.keymap.set({ "n", "v" }, "<Leader>dp", dap_wgt.preview, {})
		vim.keymap.set("n", "<Leader>df", function()
			dap_wgt.centered_float(dap_wgt.frames)
		end)
		vim.keymap.set("n", "<Leader>ds", function()
			dap_wgt.centered_float(dap_wgt.scopes)
		end)
	end,
}
