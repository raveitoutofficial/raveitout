function boolToString(b)
	return b and "true" or "false";
end;

function strleft(str, lenght)
	return string.sub(str, 1, lenght)
end

function strright(str, lenght)
	return string.sub(str, -(tonumber(lenght)))
end

function strmiddle(str, start, final)
	return string.sub(str, start, final)
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function trimStr(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

--gsub ignore case
function gisub(s, pat, repl, n)
    pat = string.gsub(pat, '(%a)', 
               function (v) return '['..string.upper(v)..string.lower(v)..']' end)
    if n then
        return string.gsub(s, pat, repl, n)
    else
        return string.gsub(s, pat, repl)
    end
end

function strArrayToString(a)
	local s = "";
	for i = 1, #a do
		if type(a[i]) == "string" then
			s = s..a[i]..",";
		else
			s = s.."ERROR,";
		end;
	end
	return s;
end


--https://stackoverflow.com/a/27028488
function dumpTable(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


--Because GetCurrentGame returns lowercase, but StepsType wants uppercase.
function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end
