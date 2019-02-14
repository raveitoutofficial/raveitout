

--DoDebug = THEME:GetMetric("CustomRIO","DevMode")
DoDebug = false;
--[[FIXED FONTS]]
DebugFont =		"Common normal"

--[[ALIASES]]			--
Enjoy1stStage = 		THEME:GetMetric("CustomRIO","Enjoy1stStage")		--
Enjoy1stStagePMode = 	THEME:GetMetric("CustomRIO","Enjoy1stStagePMode")	--
--[[GLOBAL VALUES]]
WallpaperSleepTime =	THEME:GetMetric("CustomRIO","WallpaperSleepTime")	--
FadeInRatio =			THEME:GetMetric("CustomRIO","FadeInRatio")	--
FadeInTween =			THEME:GetMetric("CustomRIO","FadeInTween")	--
FadeOutRatio =			THEME:GetMetric("CustomRIO","FadeOutRatio")	--
FadeOutTween =			THEME:GetMetric("CustomRIO","FadeOutTween")	--

--[[Judgement/Combo animation]]
--Note: Anything involving Combo Numbers also affects "Combo/Miss" label
local zf	= 0.35		--combo zoom finetuning	
local skb	= -0.25		--skewx value, both
local skj	= skb		--skewx judgement value 
local skc	= skb		--skewx combo value
local iab	= 1			--initial alpha both
local iaj	= iab		--initial alpha judgement
local iac	= iab		--initial alpha combo
local izmb	= 1			--initial zoom both
local izmj	= izmb+0.3		--initial zoom judgement
local izmc	= izmj-zf	--initial zoom combo
local ixb	= 0			--initial X (horizontal) position both
local ixj	= ixb		--initial X (horizontal) position judgement
local ixc	= ixb		--initial X (horizontal) position combo
local iyb	= 0			--initial Y (vertical) position both
local iyj	= 0			--initial Y (vertical) position judgement
local iyc	= 5		--initial Y (vertical) position combo
	 --note: in and still/resting time animations must be the always same for both items
local cbin	= 0.15		--combo in time
--
local rxb	= 0			--resting X (horizontal) value, both
local rxj	= rxb		--resting X (horizontal) value, judgement
local rxc	= rxb		--resting X (horizontal) value, combo
local ryb	= 5			--resting Y (vertical) value, both
local ryj	= 0			--resting Y (vertical) value, both
local ryc	= -5		--resting Y (vertical) value, both
local rmzb	= 1.2		--resting zoom value, both
local rzmj	= rmzb+0.4		--resting zoom value, judgement
local rzmc	= rmzb-zf	--resting zoom value, combo
local cbwt	= 0.25		--combo wait time (sleep, if any)
--
local cbot1	= 0.25		--combo out animation time 1
--local xof1b = 0		--X axis value offset from center 1, both items
local xof1j = 30		--X axis value offset from center 1, judgement
local xof1c = -30		--X axis value offset from center 1, combo
local aot1b = 0.5		--Alpha value during out 1 animation, both items
local aot1j = aot1b		--Alpha value during out 1 animation, judgement
local aot1c = aot1b		--Alpha value during out 1 animation, combo
--
local cbot2	= 0.5		--combo out animation time 2
--local xof2b = 0		--X axis value offset from center 1, both items
local xof2j = 75		--X axis value offset from center 1, judgement
local xof2c = -75		--X axis value offset from center 1, combo
local aot2b = 0			--Alpha value during out 2 animation, both items
local aot2j = aot2b		--Alpha value during out 2 animation, judgement
local aot2c = aot2b		--Alpha value during out 2 animation, combo

Comboanijudge = cmd(finishtweening;--[[skewx,skj;]]x,ixj;y,iyj;diffusealpha,iaj;
				   zoom,izmj;decelerate,cbin;x,rxj;y,ryj;zoom,rzmj;sleep,cbwt;
				   decelerate,cbot1;x,xof1j;diffusealpha,aot1j;
				   accelerate,cbot2;x,xof2j;diffusealpha,aot2j);
Comboanicombo = cmd(finishtweening;--[[skewx,skc;]]x,ixc;y,iyc;diffusealpha,iac;
				  zoom,izmc;decelerate,cbin;x,rxc;y,ryc;zoom,rzmc;sleep,cbwt;
				  decelerate,cbot1;x,xof1c;diffusealpha,aot1c;
				  accelerate,cbot2;x,xof2c;diffusealpha,aot2c;);

--Cortes has a weird bug regarding how his setup returns Widescreen values, this is part
--of a workaround for him (and anyone having the same problem) to use. -NeobeatIKK
if FILEMAN:DoesFileExist(THEME:GetCurrentThemeDirectory().."corteswidefix.patch") then
	CortesWideFix = true
else
	CortesWideFix = false
end

--[[FUNCTIONS]]

--This is honestly only ever called in ScreenOptionsCustomizeProfile so it's kind of useless
function getProfileIcons()
	--This junk is copypasted from Delta NEX Rebirth (which was copypasted from Simply Love), so it still uses the backgrounds variable
    local fullPath = THEME:GetPathG("","USB_stuff/avatars")
    local files = FILEMAN:GetDirListing(fullPath.."/")
    local backgrounds = {}
    --local backgroundsLength=0 --Fucking lua

    for k,filename in ipairs(files) do
        backgrounds[#backgrounds+1] = filename--:sub(1, -5)
        --backgroundsLength = backgroundsLength+1;
    end
    return backgrounds;
end;

--If this is called at the same frame, it's not truly random... So use the playernumber to randomize it a bit
function getRandomProfileIcon(pn)
	if pn == PLAYER_2 then
		math.randomseed(Hour()*3600+Second());
	end;
	--return THEME:GetPathG("","USB_stuff/avatars/"..string.format("%03i",tostring(math.random(40))));
	
	--This junk is copypasted from Delta NEX Rebirth (which was copypasted from Simply Love), so it still uses the backgrounds variable
    local fullPath = THEME:GetPathG("","USB_stuff/avatars")
    local files = FILEMAN:GetDirListing(fullPath.."/")
    local backgrounds = {}
    local backgroundsLength=0 --Fucking lua

    for k,filename in ipairs(files) do
        backgrounds[#backgrounds+1] = filename--:sub(1, -5)
        backgroundsLength = backgroundsLength+1;
    end
    
   
	if backgroundsLength > 0 then
		local bg = backgrounds[math.random(backgroundsLength)]
		return THEME:GetPathG("","USB_stuff/avatars/"..bg);
	end;
	
	assert("No backgrounds found!");
	return nil
end;

--DO NOT CALL THIS FUNCTION!!! Use getenv("profile_icon_PX") (where X is the player number).
--SL-CustomProfiles will set the env var "profile_icon_PX" when you load a profile.
function getLocalProfileIcon(profileDir)
	--local profileDir = PROFILEMAN:GetProfileDir(ProfileSlot[PlayerNumber:Reverse()[pn]+1]);
	if (FILEMAN:DoesFileExist(profileDir.."avatar.png")) then
		return profileDir.."avatar.png";
	elseif (FILEMAN:DoesFileExist(profileDir.."avatar.jpg")) then
		return profileDir.."avatar.jpg";
	elseif (FILEMAN:DoesFileExist(profileDir.."avatar.bmp")) then
		return profileDir.."avatar.bmp";
	elseif (FILEMAN:DoesFileExist(profileDir.."avatar.gif")) then
		return profileDir.."avatar.gif";
	else
		return nil
	end
end;

--Get available choices for ScreenSelectPlayMode
--TODO: Is ReadPrefFromFile slow? Need to check
function getPlayModeChoices()
	if ReadPrefFromFile("MixtapeModeEnabled") == "true" and ReadPrefFromFile("SpecialModeEnabled") == "true" then
		return "Easy,Arcade,Pro,Mixtapes,Special";
	elseif ReadPrefFromFile("MixtapeModeEnabled") == "true" then
		return "Easy,Arcade,Pro,Mixtapes"
	elseif ReadPrefFromFile("SpecialModeEnabled") == "true" then
		return "Easy,Arcade,Pro,Special"
	else
		return "Easy,Arcade,Pro";
	end;
end;

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

function getNumberOfElements(t)
	local count = 0;
	if t then
		for index in pairs(t) do
			count = count + 1;
		end;
	end;
	return count;
end

function setScores(PlayerScores)
	setenv("PlayerScores",PlayerScores);
end;

function getScores()
	return getenv("PlayerScores");
end;

function soundext(filename)
	if FILEMAN:DoesFileExist(filename..".wav") then
		file_path = filename..".wav";
	elseif FILEMAN:DoesFileExist(filename..".mp3") then
		file_path = filename..".mp3";
	elseif FILEMAN:DoesFileExist(filename..".ogg") then
		file_path = filename..".ogg";
	else
		file_path = THEME:GetPathS("","nosound.ogg");
	end
	
	return file_path
end


--Override the function to support RIO's SongBackgrounds folder.
function GetSongBackground(return_nil_on_fail)
	local song = GAMESTATE:GetCurrentSong();
	if not song then
		local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
		local e = trail:GetTrailEntries()
		if #e > 0 then
			song = e[1]:GetSong()
		end
	end
	if song then
		local path = split("/",GAMESTATE:GetCurrentSong():GetSongDir())
		path = path[#path-1];
		--SCREENMAN:SystemMessage(song:GetSongDir())
		if IsUsingWideScreen() then
			path = "/SongBackgrounds/HD/"..path.."-bg.png";
			if FILEMAN:DoesFileExist(path) then
				return path
			end;
		else
			path = "/SongBackgrounds/SD/"..path.." (SD)-bg.png";
			if FILEMAN:DoesFileExist(path) then
				return path;
			end;
		end;
		path = song:GetBackgroundPath()
		if path then
			return path;
		end;
	end;
	return return_nil_on_fail and nil or THEME:GetPathG("Common","fallback background")
end
--Override the function to use above function.
function Sprite:LoadFromCurrentSongBackground()
	self:Load(GetSongBackground());
	return self;
end;


function getLargeJacket()
	local songdir  = GAMESTATE:GetCurrentSong():GetSongDir()
	local path = split("/",songdir)
	path = "/SongJacketsLarge/"..path[#path-1];
	--SCREENMAN:SystemMessage(path)
	if FILEMAN:DoesFileExist(path..".png") then
		return path..".png"
	elseif FILEMAN:DoesFileExist(path..".jpg") then
		return path..".jpg"
	elseif FILEMAN:DoesFileExist(path..".jpeg") then
		return path..".jpeg"
	elseif FILEMAN:DoesFileExist(songdir.."largejk.png") then
		return songdir.."largejk.png"
	elseif GAMESTATE:GetCurrentSong():HasJacket() then
		return GAMESTATE:GetCurrentSong():GetJacketPath()
	else
		--self:LoadFromSongBanner(GAMESTATE:GetCurrentSong())
		return song:GetBannerPath()
	end;
end;
