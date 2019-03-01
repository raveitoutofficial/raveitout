--Unlock functions
function GetUnlockIndex( sEntryID )		--GetUnlockIndex	 by ROAD24 (Jose Jesus)		--HUGE thanks to him -NeobeatIKK
local iNumLocks = UNLOCKMAN:GetNumUnlocks();
lua.Trace("ROAD24 GetUnlockIndex: iNumLocks = " .. iNumLocks);
	for idx = 0, iNumLocks-1 do
			local sIDtoCompare = UNLOCKMAN:GetUnlockEntry(idx):GetCode();
			lua.Trace("ROAD24 GetUnlockIndex: idx = " .. idx .. " sIDtoCompare = " .. sIDtoCompare );
			if sIDtoCompare == sEntryID then
				lua.Trace("ROAD24 GetUnlockIndex: se encontro el code, index = " .. idx);
				return idx;
			end;
	end;
	lua.Trace("ROAD24 GetUnlockIndex: No se encontro regresando -1");	-- Si no lo encuentra ;
	return -1;
end;
function IsEntryIDLocked( sEntryID )	--IsEntryIDLocked	 by ROAD24
	if sEntryID then
		lua.Trace("ROAD24 IsEntryIDLocked: Intentando obtener index de " .. sEntryID);
		lua.Trace("ROAD24 IsEntryIDLocked: Invocando GetUnlockIndex");
		local iEntryIndex = GetUnlockIndex( sEntryID );
		lua.Trace("ROAD24 IsEntryIDLocked: GetUnlockIndex regreso " .. iEntryIndex );
		if iEntryIndex >= 0 then
     		local tUnlockEntry = UNLOCKMAN:GetUnlockEntry( iEntryIndex );
			if tUnlockEntry then
				local IsLocked = tUnlockEntry:IsLocked();
				if IsLocked ~= nil then
					lua.Trace("ROAD24 IsEntryIDLocked: regresa true");
					return IsLocked;
				else
					lua.Trace("ROAD24 IsEntryIDLocked: IsLocked regreso nil");
					return -1;
				end;
			end;
		else
			lua.Trace("ROAD24 IsEntryIDLocked: No se encontro index para " .. sEntryID);
		end;
	end;
		lua.Trace("ROAD24 IsEntryIDLocked: Se esperaba un string pero se recibio nil");
	return -1;
end;

function UnlockStatusToString(num)
	if num == 0 then
		return "UNLOCKED: This song is unlocked.";
	elseif num == 1 then
		return "LOCKED_ROULETTE: Only available in roulette.";
	elseif num == 4 then
		return "LOCKED_SELECTABLE: Locked due to #SELECTABLE tag.";
	elseif num == 8 then
		return "LOCKED_DISABELD: Disabled by operator.";
	else
		return "Unknown Status.";
	end;
end;


--[[
Tentative, implementation is not finished.
Since some stuff is kind of absurd to code, it might be better to add a ForceUnlock()
function for things that can't be managed by the unlock system.
]]
--[[UNLOCKABLE_TITLES = {
	--Name, unlock type, requirement, parameters
	["SANGVIS FERRI","ChartAuthor", 10, "Accelerator"],
	["Team 404", "ChartAuthor", 20, "Accelerator"],
	["Dance Beginner", "Level", 5],
	["Dance Trainee", "Level", 10],
	["Dance Pro", "Level", 20],
	["Dance Master","Level",50],
	["Dance Legend", "Level", 75],
	["Ultimate Rave Legend", "Level", 100],
	--["Snap Crackle Rave", "Artist", 7, "District 78"], --This is too complicated just forget it
	["Nice", "SongsPlayed", 69],
	["Song name?", "SongRank", 1, "Sandstorm"], --This is tentative but I think 1 = W1 or something
	["RadiOut", "SongsPlayedInGroup", 10, "Pop"],
	["Straight Gangsta", "RanksInGroup", 5, "Hip-Hop"],
	["Dale!", "Artist", 3, "Pitbull"],
	["Smooth Criminal", "Artist", 999, "Michael Jackson"], --Replace with however many Michael Jackson songs we have I guess
	["RIO Needs More K-Pop", "SongsPlayedInGroup", 3, "K-Pop"],
	["Thank You For Playing!", "SongRank", 1, "World Go Boom (USoP 2011)"],
	["It's the MF'n D.O.Double-G", "SongsPlayed", 420],
	["What the fuck?", "SongRank", 2, "Loca People"],
	["AAAAYYYY SEXY LADY", "SongRank", 2, "Gangnam Style"]
}]]
--[[
SANGVIS FERRI - Play 10 charts by Accelerator
Team 404 - Play 20 charts by Accelerator
Dance Beginner - Become lv5
Dance Trainee - Become lv10
Dance Pro - Become lv20
Dance Master - Become lv50
Dance Legend - Become lv75
Ultimate Rave Legend - Become lv100
Snap Crackle Rave - Play 7 Snap Tracks by District 78
Nice - Play 69 songs
Song name? - Get an S on Sandstorm.
RadiOut - Play 10 songs in the Pop setlist
Straight Gangsta - Earn 5 S ranks in the hip-hop setlist
Dale! - Play 3 songs by Pitbull.
Smooth Criminal - Play all Michael Jackson songs.
RIO Needs More K-Pop - Play all songs in the K-Pop setlist. All 3 of them.
Thank you for playing! - Earn an S on the Encore Extra Stage "World Go Boom" (USoP 2011).
Big Fat Ass Bitch - Earn an S on Anaconda
It's the MF'n D.O.Double-G - Play 420 charts.
What the fuck? - Earn an A on Loca People
AAAAYYYY SEXY LADY - Earn an A on Gangnam Style
]]