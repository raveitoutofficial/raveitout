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

--Take a wild guess as to what this does
--Asks for numSongsPlayed instead of profile because of ScreenSelectProfile complexity...
function calcPlayerLevel(numSongsPlayed)
	local uplevelfactor = THEME:GetMetric("CustomRIO","NumSongsToLevelUp");
	local maxlevelnum = THEME:GetMetric("CustomRIO","MaxLevel");
	if numSongsPlayed > maxlevelnum*uplevelfactor then
		return maxlevelnum;
	else
		return math.ceil(numSongsPlayed/uplevelfactor)
	end;
end

--Called from ScreenSelectPlayMode to pick a random group and the GroupWheel to show available groups
function getAvailableGroups()
	local groups = SONGMAN:GetSongGroupNames();

	if not DoDebug then
		--Remove easy and special folder from the group select
		for k,v in pairs(groups) do
			if v == RIO_FOLDER_NAMES["EasyFolder"] then
				table.remove(groups, k)
			elseif v == RIO_FOLDER_NAMES["SpecialFolder"] then
				table.remove(groups, k)
			--Never display the internal group folder
			elseif v == "Internal" then
				table.remove(groups, k)
			--TODO: This should be done on startup.
			elseif (#SONGMAN:GetSongsInGroup(v))-1 < 1 then
				table.remove(groups, k)
			end;
		end
	end;
	return groups;
end;

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end


--NO IT DOESN'T FUCKING WORK GO FUCK YOURSELF
--[[function Actor:ScaleToHeight(height)
	if height >= self:GetHeight() then
		self:SetWidth(self:GetWidth()*(height/self:GetHeight()))
	else
		self:SetWidth(self:GetWidth()*(self:GetHeight()/height))
	end;
	self:SetHeight(height)
end;

function Actor:ScaleToWidth(width)
	if width/self:GetWidth() > 1 then
		self:SetHeight(self:GetHeight()*(width/self:GetWidth()))
	else
		self:SetHeight(self:GetHeight()*(self:GetWidth()/width))
	end;
	self:SetWidth(width)
end;

function testScaleToHeight(origWidth, origHeight, height)
	if height/origHeight > origHeight/height then
		return origWidth*(height/origHeight)
	else
		return origWidth*(origHeight/height)
	end;

end;

function testScaleToWidth(origWidth, origHeight, width)
	if width > origWidth then
		return origHeight*(width/origWidth)
	else
		return origHeight*(origWidth/width)
	end;

end;]]

function returnLastElement(arr)
	return arr[#arr]
end

function ListActorChildren(frame)
	if frame:GetNumChildren() == 0 then
		return "No children in frame.";
	end
	local list = frame:GetNumChildren().." children: ";
	local children = frame:GetChildren()
	for key,value in pairs(children) do
		list = list..key..", ";
	end
	return list;
end

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

--GetChartStyle support Requested by someone on Facebook
function StepsTypeToString(steps)
	local meter = steps:GetMeter();
	--If the steps has a custom style name, use it.
	local style = steps:GetChartName();
	--If not, get the regular name.
	if style == "" then
		local sttype = split("_",ToEnumShortString(steps:GetStepsType()))
		--local gamemode = sttype[1]
		style = string.upper(sttype[2]) --Ex. Single, Double, Halfdouble, etc.
		
		if style == "HALFDOUBLE" then style = "HALF DOUBLE" end;
		if meter >= 99 then
			return style.." Lv.??";
		else
			return style..string.format(" Lv.%02d",meter)
		end;
	end;
	
	return style;
end;

function getCorrectStepsTypeForGame(style)
	return "StepsType"..firstToUpper(GAMESTATE:GetCurrentGame():GetName())..style
end;

--OVERRIDES

GameColor.PlayerColors = {
	PLAYER_1 = color("#ed0972"),
	PLAYER_2 = color("#33B5E5")
};

-- Someone might be too lazy to update their fallback, so it's copied and pasted here
local OptionsListKeys = {
	PrevItem = {
		pump="MenuLeft",
		default="MenuUp"
	},
	NextItem = {
		pump="MenuRight",
		default="MenuDown"
	}
};

function GetOptionsListMapping(name)
	local sGame = string.lower(GAMESTATE:GetCurrentGame():GetName())
	local map = OptionsListKeys[name]
	return map[sGame] or map["default"]
end

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
		--[[
		TODO: Remove GetBackgroundPath() because this function needs to support
		StepF2 where backgrounds without -wide at the end are used instead.
		]]
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

--Because it's useful
function Actor:Cover()
	self:scaletocover(0,0,SCREEN_RIGHT,SCREEN_BOTTOM);
end;

--Like ScaleToFit except not stupid
--Thx to Jousway for this
function Resize(width,height,setwidth,sethight)
    if height >= sethight and width >= setwidth then
        if height*(setwidth/sethight) >= width then
            return sethight/height
        else
            return setwidth/width
        end
    elseif height >= sethight then
        return sethight/height
    elseif width >= setwidth then
        return setwidth/width
    else 
        return 1
    end
end

--Same as above except you can do cmd(Resize,width,height;) on a Def.Sprite{} now
function Sprite:Resize(setwidth,sethight)
	--local width = self:GetTexture():GetTextureWidth();
	--local height = self:GetTexture():GetTextureHeight();
	local width = self:GetWidth();
	local height = self:GetHeight();
    if height >= sethight and width >= setwidth then
        if height*(setwidth/sethight) >= width then
            return self:zoom(sethight/height);
        else
            return self:zoom(setwidth/width);
        end
    elseif height >= sethight then
        return self:zoom(sethight/height);
    elseif width >= setwidth then
        return self:zoom(setwidth/width);
    else 
        return 1
    end
end
