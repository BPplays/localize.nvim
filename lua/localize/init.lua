local localize = {}
localize.langmap = {}
localize.langmap.builtin = {}
localize.options = {
  language = "en_US"
}

localize.langmap.builtin.ja_JP = {
	['normal<mode>']      = 'ノーマル',
	['insert<mode>']      = '挿入',
	['visual<mode>']      = 'ビジュアル',
	['v-line<mode>']      = 'ビジュアル行',
	['select<mode>']      = 'セレクト',
	['s-line<mode>']      = '行指向選択',
	['s-block<mode>']      = '矩形選択',
	['replace<mode>']      = '置換',
	['v-replace<mode>']      = '仮想置換',
	['command<mode>']      = 'コマンド',
	['shell<mode>']      = '端末',
}

localize.langmap.builtin = {
	['ja_JP']      = localize.langmap.builtin.ja_JP,
	['ja_JP.utf8']      = localize.langmap.builtin.ja_JP,
}
localize.bankmap = {
	['builtin'] = localize.langmap.builtin,
	['internal'] = localize.langmap.builtin,
}
localize.protected = {
	['global'] = true,
	['builtin'] = true,
	['internal'] = true,
}

function localize.set_bank(bank, bank_value)
	if localize.protected[bank] then
		return false
	end
	localize.bankmap[bank] = bank_value
	return true
end

function localize.remove_bank(bank)
	if localize.protected[bank] then
		return false
	end
	localize.bankmap[bank] = nil
	return true
end

function localize.get_string(string, lang, bank_or_banks)
	bank_or_banks = bank_or_banks or 'global'
	lang = lang or localize.options.language
	local banks = {}

	if type(bank_or_banks) == "string" then
		banks = { bank_or_banks }
	else
		banks = bank_or_banks
	end

	for _, bank in ipairs(banks) do
		if bank == 'global' then
			for _, bank_map in pairs(localize.bankmap) do
				local lang_map = bank_map[lang]
				if lang_map ~= nil then
					if lang_map[string] ~= nil then
						return lang_map[string]
					end

				end

			end
		else
			local bank_map = localize.bankmap[bank]
			local lang_map = bank_map[lang]
			if lang_map ~= nil then
				if lang_map[string] ~= nil then
					return lang_map[string]

				end

			end
		end
	end
	return nil

end

local function get_no_helper_str(str)
    local new_str = ''
    local last_char = ''
    local remove = false
    for i = 1, #str do
        local char = str:sub(i, i)  -- Get the character at position i
        if char == "<" and last_char ~= '\\' then
            remove = true
        elseif char == ">" and last_char ~= '\\' then
            remove = false
            goto continue
        elseif not(char == "\\" and last_char ~= '\\') then
            if not remove then
                new_str = new_str..char
            end
        end
        last_char = char
        ::continue::
    end

    return new_str
end

function localize.get_string_or_orig_no_helper(string, lang, bank_or_banks)
	local retstr = localize.get_string(string, lang, bank_or_banks)
	if type(retstr) == "string" then
		return retstr
		-- return retstr.gsub(retstr, '([^\\])([<>])', '%1[substituted]')
	elseif retstr == nil then
		-- return retstr.gsub(retstr, "<.->", "")
		return get_no_helper_str(string)
	end
	return nil
end

function localize.setup(opts)
	localize.options = vim.tbl_deep_extend("force", localize.options, opts or {})
end

return localize

