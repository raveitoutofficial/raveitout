function getcurstage()
	gfxNames = {
		Stage_Extra1=	"ScreenGameplay stage extra1";
		Stage_Extra2=	"ScreenGameplay stage extra1";
		Stage_Demo=	"ScreenGameplay stage Demo";
		Stage_Event="ScreenGameplay stage event";
		Stage_1st=	"ScreenGameplay stage 1";
		Stage_2nd=	"ScreenGameplay stage 2";
		Stage_3rd=	"ScreenGameplay stage 3";
		Stage_4th=	"ScreenGameplay stage 4";
		Stage_5th=	"ScreenGameplay stage 5";
		Stage_6th=	"ScreenGameplay stage 6";
		StageFinal=	"ScreenGameplay stage final";
	};

	return gfxNames[GAMESTATE:GetCurrentStage()]
end

function GetBGAPreviewPath(tag)
local song = GAMESTATE:GetCurrentSong();
if song then
local sscfile = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetFilename();
if FILEMAN:DoesFileExist(sscfile) then
	local sscpath = sscfile
	local file = File.Read( sscpath )
		if not file then return "" end
	local fnd = string.find(file , "#"..tag..":")
		if not fnd then return "" end
	local last = string.find(file , ";" , fnd)
	local previewvid = string.sub(file,fnd,last)
		previewvid = string.gsub(previewvid, "\r", "")
		previewvid = string.gsub(previewvid, "\n", "")
		previewvid = string.gsub(previewvid, "#"..tag..":", "")
		previewvid = string.gsub(previewvid, ";", "")
		
		total_random_vid = FILEMAN:GetDirListing("/RandomMovies/");
		
		if previewvid ~= "" then
			if FILEMAN:DoesFileExist(song:GetSongDir().."/"..previewvid) then
				return song:GetSongDir().."/"..previewvid
			elseif FILEMAN:DoesFileExist("/SongPreviews/"..previewvid) then
				return "/SongPreviews/"..previewvid
			else
				return "/Backgrounds/bgaoff.avi" --temporarily using this because loading RandomMovies in ScreenSelectMusic causes lag due to large file size -Gio
			end;
		else
			return "/Backgrounds/bgaoff.avi"
			--return "/RandomMovies/"..total_random_vid[math.random(#total_random_vid)] --original code for future use
		end;
else
	return ""
end
end
end;

function IsRoutineMasterPlayer(p)
	--[[ ROAD: check if not nil
	if not p then return false end;
	if GAMESTATE:IsHumanPlayer(p) and GAMESTATE:IsSideJoined(p) then
		-- Also adding some checks
		local CurSteps = GAMESTATE:GetCurrentSteps(p);
		if not CurSteps then return false end;
		if CurSteps:GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() == p then
			return true
		elseif CurSteps:GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() ~= p then
			return false
		elseif CurSteps:GetStepsType() ~= "StepsType_Pump_Routine" then
			return true
		end
	else
		return false
	end
	--]]
	return true
end

function GetCourseDescription(file,tag)
if FILEMAN:DoesFileExist(file) then
	local readfile = File.Read( file )
		if not readfile then return "" end
	local fnd = string.find(readfile , "#"..tag..":")
		if not fnd then return "" end
	local last = string.find(readfile , ";" , fnd)
	local found = string.sub(readfile,fnd,last)
		found = string.gsub(found, "\r", "")
		found = string.gsub(found, "\n", "")
		found = string.gsub(found,  "#"..tag..":", "")
		found = string.gsub(found, ";", "")
	return found
else
	return ""
end
end;

function EasyOrArcade()
	return getenv("LockHardSteps")
end;


function DevMode()
return THEME:GetMetric("CustomRIO","DevMode")
end;

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

function ResetPreferences()
	PREFSMAN:SetPreference("AllowW1",'AllowW1_Never');
	WriteGamePrefToFile("DefaultFail","Off");
	GAMESTATE:ApplyGameCommand( "mod,3x,rio,FailOff;", PLAYER_1 );
	GAMESTATE:ApplyGameCommand( "mod,3x,rio,FailOff;", PLAYER_2 );
	--SCREENMAN:SystemMessage("Preferences setted to default values.");
end

function GetNumlifeLeft()
	local life = GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer();
	return life;
end;

function GetMaxLife()
	return PREFSMAN:GetPreference("SongsPerPlay");
end;

function ResetLife()
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		while GAMESTATE:GetNumStagesLeft(pn) < GetMaxLife() do
			GAMESTATE:AddStageToPlayer(pn);
		end
	end
end

function strleft(str, lenght)
	return string.sub(str, 1, lenght)
end

function strright(str, lenght)
	return string.sub(str, -(tonumber(lenght)))
end

function strmiddle(str, start, final)
	return string.sub(str, start, final)
end


function SetTagValue(file,tag)
local song = GAMESTATE:GetCurrentSong();
--if GAMESTATE:IsCourseMode() then return "" end
if FILEMAN:DoesFileExist(file) then
        local writefile = File.Read( file )
        if not writefile then return "" end
        local firstsecond = song:GetFirstSecond();
        local lastsecond = song:GetLastSecond();
        teste = split("#"..tag..":",writefile);
        --File.Write(song:GetSongDir().."/newssc.txt" ,teste[1].."#FIRSTSECOND:"..firstsecond..";".."\n".."#LASTSECOND:"..lastsecond..";".."\n".."#"..tag..":"..teste[2])
        File.Write(file..".a2",teste[1].."#FIRSTSECOND:"..firstsecond..";".."\n".."#LASTSECOND:"..lastsecond..";".."\n".."#"..tag..":"..teste[2])
end
end;


function GetTagValue(file,tag)
if FILEMAN:DoesFileExist(file) then
	local readfile = File.Read( file )
		if not readfile then return "" end
	local fnd = string.find(readfile , "#"..tag..":")
		if not fnd then return "" end
	local last = string.find(readfile , ";" , fnd)
	local found = string.sub(readfile,fnd,last)
		found = string.gsub(found, "\r", "")
		found = string.gsub(found, "\n", "")
		found = string.gsub(found,  "#"..tag..":", "")
		found = string.gsub(found, ";", "")
	return found
else
	return ""
end
end;

--[[
function ConvertDescription2Credits(file)
local song = GAMESTATE:GetCurrentSong();
if song then
local sscfile = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetFilename();
if FILEMAN:DoesFileExist(file) then
        local writefile = File.Read( file )
        if not writefile then return "" end
        teste = split("#CREDITS:",writefile);
        --File.Write(song:GetSongDir().."/newssc.txt" ,teste[1].."#FIRSTSECOND:"..firstsecond..";".."\n".."#LASTSECOND:"..lastsecond..";".."\n".."#"..tag..":"..teste[2])
        if song:GetGroupName() == "TESTE"
        	File.Write(song:GetSongDir().."/"..sscfile..".a2",teste[1].."\n".."#CREDITS:"..teste[2])
end
end;
--]]

function SpeedMods()
	local t = {
		Name = "UserPrefSpeedMods";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = false;
		ExportOnChange = true;
		Choices = { "+0.25", "+0.5","+0.75"};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefSpeedMods") == nil then
				list[1] = true;
				WritePrefToFile("UserPrefSpeedMods","+0.25");
			else

				if GetUserPref("UserPrefSpeedMods") == "+0.25" then
					list[1] = true;
				end

				if GetUserPref("UserPrefSpeedMods") == "+0.5" then
					list[2] = true;
				end

				if GetUserPref("UserPrefSpeedMods") == "+0.75" then
					list[3] = true;

				end

			end;
		end;
		SaveSelections = function(self, list, pn)
				if list[1] then
					WritePrefToFile("UserPrefSpeedMods","+0.25");
					local speed = (math.ceil(GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():GetXMod()*100)/100)+0.25;
					GAMESTATE:ApplyGameCommand("mod,"..speed.."x",pn);
				end

				if list[2] then
					WritePrefToFile("UserPrefSpeedMods","+0.5");
					local speed = (math.ceil(GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():GetXMod()*100)/100)+0.5;
					GAMESTATE:ApplyGameCommand("mod,"..speed.."x",pn);
				end

				if list[3] then
					WritePrefToFile("UserPrefSpeedMods","+0.75");
					local speed = (math.ceil(GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():GetXMod()*100)/100)+0.75;
					GAMESTATE:ApplyGameCommand("mod,"..speed.."x",pn);
				end
				MESSAGEMAN:Broadcast("SpeedModChange");
		end
	};
	setmetatable( t, t );
	return t;
end
