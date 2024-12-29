Localize = {}
Localize.langmap = {}
Localize.langmap.builtin = {}
Localize.current_lang = "en_US"

Localize.langmap.builtin.ja_JP = {
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

Localize.langmap.builtin = {
	['ja_JP']      = Localize.langmap.builtin.ja_JP,
	['ja_JP.utf8']      = Localize.langmap.builtin.ja_JP,
}
Localize.bankmap = {
	['builtin'] = Localize.langmap.builtin,
	['internal'] = Localize.langmap.builtin
}
Localize.protected = {
	['global'] = true,
	['builtin'] = true,
	['internal'] = true,
}

function Localize.set_bank(bank, bank_value)
	if Localize.protected[bank] then
		return false
	end
	Localize.bankmap[bank] = bank_value
	return true
end

function Localize.remove_bank(bank)
	if Localize.protected[bank] then
		return false
	end
	Localize.bankmap[bank] = nil
	return true
end

function Localize.get_string(string, lang, bank)
	bank = bank or 'global'
	lang = lang or Localize.current_lang


	if bank == 'global' then
		for _, bank_map in pairs(Localize.bankmap) do
			local lang_map = bank_map[lang]
			if lang_map ~= nil then
				if lang_map[string] ~= nil then
					return lang_map[string]
				end

			end

		end
	else
		local bank_map = Localize.bankmap[bank]
		local lang_map = bank_map[lang]
		if lang_map ~= nil then
			if lang_map[string] ~= nil then
				return lang_map[string]

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

function Localize.get_string_or_orig_no_helper(string, lang, bank)
	local retstr = Localize.get_string(string, lang, bank)
	if type(retstr) == "string" then
		return retstr
		-- return retstr.gsub(retstr, '([^\\])([<>])', '%1[substituted]')
	elseif retstr == nil then
		-- return retstr.gsub(retstr, "<.->", "")
		return get_no_helper_str(string)
	end
	return nil
end
