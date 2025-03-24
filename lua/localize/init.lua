local localize = {}
localize.langmap = {}
localize.langmap.builtin = {}

local current_version



local Lang = {}
Lang.__index = Lang

function Lang.new(name, spec)
    return setmetatable({ name = name or "", spec = spec or "" }, Lang)
end

---@param str string
---@param sep string
---@return table
local function str_split(str, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for split_str in string.gmatch(str, "([^"..sep.."]+)") do
    table.insert(t, split_str)
  end
  return t
end

---@param lang string
---@return table
local function parse_lang(lang)
	local spl = str_split(lang, ".")
	return Lang.new(spl[1], spl[2])

end


---@type table
localize.options = {
  language = parse_lang(vim.fn.getenv("LANG"))
}

---@type table
localize.langmap.builtin.ja_JP = {
	['normal<vim mode>']      = 'ノーマル',
	['insert<vim mode>']      = '挿入',
	['visual<vim mode>']      = 'ビジュアル',
	['v-line<vim mode>']      = 'ビジュアル行',
	['select<vim mode>']      = 'セレクト',
	['s-line<vim mode>']      = '行指向選択',
	['s-block<vim mode>']      = '矩形選択',
	['replace<vim mode>']      = '置換',
	['v-replace<vim mode>']      = '仮想置換',
	['command<vim mode>']      = 'コマンド',
	['shell<vim mode>']      = '端末',
}

---@type table
localize.langmap.builtin = {
	['ja_JP']      = localize.langmap.builtin.ja_JP,
}

---@type table
localize.bankmap = {
	['builtin'] = localize.langmap.builtin,
	['internal'] = localize.langmap.builtin,
}

---@type table
localize.protected = {
	['global'] = true,
	['builtin'] = true,
	['internal'] = true,
}

---Sets a bank to a value
---*Throws* if bank is protected, or no '_version' is set
---@param bank string
---@param bank_value table
function localize.set_bank(bank, bank_value)
	if localize.protected[bank] then
		error("can't change protected bank")
	end

	if bank_value['_version'] == nil then
		error("bank has no version")
	end
	if type(bank_value['_version']) ~= "number" then
		error("bank version wrong type")
	end

	localize.bankmap[bank] = bank_value
end

---Removes a bank
---*Throws* if bank is protected
---@param bank string
function localize.remove_bank(bank)
	if localize.protected[bank] then
		error("can't remove protected bank")
	end
	localize.bankmap[bank] = nil
	return nil
end

---gets a string based on language
---@param string string
---@param bank_or_banks string | table can be one or multiple banks
---@param lang string
---@param search_lower boolean
---@return string | nil
function localize.get_string(string, bank_or_banks,  lang, search_lower)
	bank_or_banks = bank_or_banks or 'global'
	lang = lang or localize.options.language.name
	local banks = {}

	local search_lower_table = { false }
	if search_lower then
		search_lower_table = {
			false,
			true,
		}
	end

	if type(bank_or_banks) == "string" then
		banks = { bank_or_banks }
	else
		banks = bank_or_banks
	end

	for _, bank in ipairs(banks) do
		if bank == 'global' then
			for _, search_lower_current in ipairs(search_lower_table) do
				for _, bank_map in pairs(localize.bankmap) do
					local lang_map = bank_map[lang]
					if lang_map ~= nil then
						local mapped = lang_map[string]
						if search_lower_current then
							mapped = lang_map[string.lower(string)]
						end
						if mapped ~= nil then
							return mapped
						end
					end
				end
			end

		else
			local bank_map = localize.bankmap[bank]
			local lang_map = bank_map[lang]

			for _, search_lower_current in ipairs(search_lower_table) do
				if lang_map ~= nil then

					local mapped = lang_map[string]
					if search_lower_current then
						mapped = lang_map[string.lower(string)]
					end
					if mapped ~= nil then
						return mapped
					end
				end
			end
		end
	end
	return nil

end

---retruns base string without helper
---@param str string
---@return string
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


---gets a string based on language or returns input string without helper
---@param string string
---@param bank_or_banks string | table can be one or multiple banks
---@param lang string
---@param search_lower boolean
---@return string
function localize.get_string_orig(string, bank_or_banks, lang, search_lower)
	local retstr = localize.get_string(string, bank_or_banks, lang, search_lower)
	if type(retstr) == "string" then
		return retstr
	elseif retstr == nil then
		return get_no_helper_str(string)
	end
	return ''
end


localize.get_string_or_orig_no_helper = localize.get_string_orig

function localize.setup(opts)
	localize.options = vim.tbl_deep_extend("force", localize.options, opts or {})
end

return localize

