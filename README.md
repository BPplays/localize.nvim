# localize.nvim
this plugin is a localization library

## install

`lazy.nvim`
```
	{
		"BPplays/localize.nvim",
		name = "localize.nvim",
		config = function()
			require('localize').setup({
				-- language = { name = "ja_JP", spec = "utf8" },
			})
		end,
	},
```

# concepts
banks:
    banks

# usage
start by using
```
local localize = require('localize')
```

### banks
you can add a bank by using `localize.set_bank`
