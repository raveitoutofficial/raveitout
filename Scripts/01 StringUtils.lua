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

--From https://stackoverflow.com/a/19263313
--This does not work with periods for some mysterious reason
--Usage: "something here":split(",")
function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end

function split( delimiter, text )
	local list = {}
	local pos = 1
	while 1 do
		local first,last = string.find( text, delimiter, pos )
		if first then
			table.insert( list, string.sub(text, pos, first-1) )
			pos = last+1
		else
			table.insert( list, string.sub(text, pos) )
			break
		end
	end
	return list
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
		s = s..a[i]..",";
	end
	return s;
end
