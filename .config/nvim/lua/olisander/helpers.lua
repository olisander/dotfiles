local function replace_string(str, what, with)
	what = string.gsub(what, "[%(%)%.%+%-%*%?%[%]%^%$%%]", "%%%1") -- escape pattern
	with = string.gsub(with, "[%%]", "%%%%") -- escape replacement
	return string.gsub(str, what, with)
end

return {
	replace_string = replace_string,
}
