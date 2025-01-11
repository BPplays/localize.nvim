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
helpers are optional parts added to the source words inside <> 'normal\<mode\>' would mean normal as in normal mode but the localized string should reflect the shortening without the helper,  <br>
for example 'normal\<mode\>' should not be localized to the language equal of 'normal mode' instead it should be just 'normal', the same kind of 'normal' you would use in saying 'normal mode'

# usage
start by using
```
local localize = require('localize')
```

### banks
you start by making a bank
```
local mybank = {}

mybank.ja_JP = {
	['normal<mode>']      = 'ノーマル',
	['insert<mode>']      = '挿入',
}

mybank = {
	['_version'] = 1
	['ja_JP'] = mybank.ja_JP
}
```
then you can add your bank by using `localize.set_bank('mybankname', mybank)`
you should also use '_version' to specify what bank version to use, the only version currently is 1


### getting localized strings
you can use `localize.get_string(string, lang, bank_or_banks, search_lower)` to get a string or nil if it can't find anything
- string is the string source
- the language to use - defaults to the users language
- bank or banks to use - can be one bank name or multiple
- search_lower whether or not to also search a lowercase version of the source string

`localize.get_string_orig(string, lang, bank_or_banks, search_lower)` will return the original string without the helper if it doesn't find anything

