<h1 align="center">localize.nvim</h1>
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
for example if you have a plugin `my_cool_statusline` you might make a bank with name 'my_cool_statusline'

helpers:  <br>
helpers are optional parts added to the source words inside <> 'normal\<vim mode\>' would mean normal as in normal mode but the localized string should reflect the shortening without the helper,  <br>
for example 'normal\<vim mode\>' should *not* be localized to the language equal of 'normal mode' instead it should be just 'normal', the same kind of 'normal' you would use in saying 'normal mode'

# usage
start by using
```lua
local localize = require('localize')
```

### banks
you start by making a bank
```lua
local mybank = {}

mybank.ja_JP = {
	['normal<vim mode>']      = 'ノーマル',
	['insert<vim mode>']      = '挿入',
}

mybank = {
	['_version'] = 1,
	['ja_JP'] = mybank.ja_JP,
}
```
then you can add your bank by using
```lua
localize.set_bank('mybankname', mybank)
```
note: this function can throw an error
you must also use '_version' to specify what bank version to use, the only version currently is 1


### getting localized strings
you can use `localize.get_string(string, bank_or_banks, lang, search_lower)` to get a string or nil if it can't find anything  <br>
`localize.get_string_orig(string, bank_or_banks, lang, search_lower)` will return the original string without the helper if it doesn't find anything
- *string* - is the string source
- *bank_or_banks* - bank or banks to use - can be one bank name or multiple
- *lang* - the language to use - defaults to the users language
- *search_lower* - search_lower whether or not to also search a lowercase version of the source string
  <br>

the most basic use case would be:
```
localize.get_string_orig('normal<mode>')
```

but if you want to specify the bank you can do
```
localize.get_string_orig('normal<mode>', 'mybankname')
```
there are also reserved bank names ['global', 'builtin', 'internal']



