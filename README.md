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
banks:  <br>
banks are groups of localizations by usage usually your plugin's name  <br>
for example if you have a plugin `statusline` you might make a bank with name 'statusline'

helpers:  <br>
helpers are optional parts added to the source words inside <> for example 'normal\<mode\>' would mean normal as in normal mode but the localized string should reflect the shortening without the helper,  <br>
for example 'normal\<mode\>' should not be localized to the language equal of 'normal mode' instead it should be just 'normal', the same kind of 'normal' you would use in saying 'normal mode'

# usage
start by using
```
local localize = require('localize')
```

### banks
you start by making a bank
```
mybank = {
	['normal<mode>']      = 'ノーマル',
	['insert<mode>']      = '挿入',
}
```
you can add a bank by using `localize.set_bank('mybankname', mybank)`

