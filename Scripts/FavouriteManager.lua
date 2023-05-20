-- SM5 Favorites manager by leadbman & modified for RIO by Rhythm Lunatic

-- Inhibit Regular Expression magic characters ^$()%.[]*+-?)
local function strPlainText(strText)
	-- Prefix every non-alphanumeric character (%W) with a % escape character, 
	-- where %% is the % escape, and %1 is original character
	return strText:gsub("(%W)","%%%1")
end


function addOrRemoveFavorite(player)
	local profileName = PROFILEMAN:GetPlayerName(player)
	local path = PROFILEMAN:GetProfileDir(ProfileSlot[PlayerNumber:Reverse()[player]+1]).."RIO_FavoriteSongs.txt"
	local sDir = GAMESTATE:GetCurrentSong():GetSongDir()
	local sTitle = GAMESTATE:GetCurrentSong():GetDisplayFullTitle();
	local arr = split("/",sDir);
	local favoritesString = lua.ReadFile(path) or "";
	if favoritesString then
		--If song found in the player's favorites
		local checksong = string.match(favoritesString, strPlainText(arr[3].."/"..arr[4]))

		--If no favorites exist yet, create a group title first.
		--Well, we would, but we don't need to do this anyway since the generateFavoritesForMusicWheel function handles it...
		--[[if string.len(favoritesString) == 0 then
			favoritesString = "---"..profileName.."'s Favorites".."\r\n";
		end;]]
		
		--Song found
		if checksong then
			favoritesString= string.gsub(favoritesString, strPlainText(arr[3].."/"..arr[4]).."\n", "");
			SCREENMAN:SystemMessage(sTitle.." removed from "..profileName.."'s Favorites.");
		else
			favoritesString= favoritesString..arr[3].."/"..arr[4].."\n";
			SCREENMAN:SystemMessage(sTitle.." added to "..profileName.."'s Favorites.");
		end;
			
	end;

	-- write string
	local file= RageFileUtil.CreateRageFile()
	if not file:Open(path, 2) then
		Warn("Could not open '" .. path .. "' to write current playing info.")
	else
		file:Write(favoritesString)
		file:Close()
		file:destroy()
	end
end;

--[[
This is the only way to use favorites in the stock StepMania songwheel, 
It reads the favorites file and then generates a Preferred Sort formatted file which SM can read.
Call this before ScreenSelectMusic and after addOrRemoveFavorite.

To open the favorties folder, call this from ScreenSelectMusic:
SCREENMAN:GetTopScreen():GetMusicWheel():ChangeSort("SortOrder_Preferred")
SONGMAN:SetPreferredSongs("Favorites");
SCREENMAN:GetTopScreen():GetMusicWheel():SetOpenSection("P1 Favorites");

Rave It Out uses a custom lua GroupWheel so the favorites folders will show alongside your groups.
]]
function generateFavoritesForMusicWheel()
	local strToWrite = ""
	for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
		local path = PROFILEMAN:GetProfileDir(ProfileSlot[PlayerNumber:Reverse()[pn]+1]).."RIO_FavoriteSongs.txt"
		if FILEMAN:DoesFileExist(path) then
			local favs = lua.ReadFile(path)
			if string.len(favs) > 2 then
				setenv(pname(pn).."HasAnyFavorites",true)
				strToWrite=strToWrite.."---"..pname(pn).." Favorites\n"..favs;
			end;
		--else
			--Warn("No favorites found at "..path)
		end;
	end;
	if strToWrite ~= "" then
		--Warn(strToWrite)
		local path = THEME:GetCurrentThemeDirectory().."Other/SongManager Favorites.txt"
		local file= RageFileUtil.CreateRageFile()
		if not file:Open(path, 2) then
			Warn("Could not open '" .. path .. "' to write current playing info.")
		else
			file:Write(strToWrite)
			file:Close()
			file:destroy()
		end
	end;
end;
