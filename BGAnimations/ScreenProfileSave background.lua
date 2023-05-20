-- Timerseconds for this screen is controlled by:
-- NextStageSleepTime+WallpaperSleepTime values in ScreenProfileSaveOverlay
-- Wallpaper transition system by ROAD24 and NeobeatIKK
-- and modified by Accelerator!

local t =							Def.ActorFrame{};
local SongsPlayed =					STATSMAN:GetAccumPlayedStageStats():GetPlayedSongs();
local LastSong =					SongsPlayed[#SongsPlayed]
--Show logo if using weaboo theme, since wallpapers don't have logo
--SCREENMAN:SystemMessage(THEME:GetCurThemeName())
local ShowRIOLogo =					(THEME:GetCurThemeName()=="rio4weebs")

-- TODO: this values should be defaulted and reseted between games to avoid issues like this
local LastStageAccuracyP1 =			tonumber(getenv("LastStageAccuracyP1")) or 0;
local LastStageAccuracyP2 =			tonumber(getenv("LastStageAccuracyP2")) or 0;
local LastStageAccuracyHighest =	math.max(LastStageAccuracyP1,LastStageAccuracyP2);
local LastStageGradeP1 =			tonumber(getenv("LastStageGradeP1")) or 0;
local LastStageGradeP2 =			tonumber(getenv("LastStageGradeP2")) or 0;
local LastStageGradeHighest =		math.max(LastStageGradeP1,LastStageGradeP2);


local function getRandomWall()
-- Cortes quiere random wallpaper, este script cargara de forma aleatoria
--  una imagen dentro del folder _RandomWalls en BGAnimations
	local sImagesPath = THEME:GetPathG("","_LoadingWallpapers/RandomWalls");
	local sRandomWalls = FILEMAN:GetDirListing(sImagesPath.."/",false,true);
	-- El random seed
	 math.randomseed(Hour()*3600+Second());
	return sRandomWalls[math.random(#sRandomWalls)];
end;

local function getSpecialRandom(path)
	local sImagesPath = THEME:GetPathG("","_LoadingWallpapers/Special/"..path);
	local sRandomWalls = FILEMAN:GetDirListing(sImagesPath.."/",false,true);
	math.randomseed(Hour()*3600+Second());
	return sRandomWalls[math.random(#sRandomWalls)];
end;

--//set conditions
local SpecialTransition = nil;
if LastSongPlayedArtist == "Kanye West" and LastStageAccuracyHighest >= 90 then
	SpecialTransition = getSpecialRandom("ArtistKanyeWest")
elseif LastSongPlayedArtist == "Ariana Grande" and LastStageAccuracyHighest >= 90 then
	SpecialTransition = getSpecialRandom("ArtistArianaGrande")
--	ShowRIOLogo = false
elseif LastSongPlayedArtist == "Logic feat. Alessia Cara & Khalid" then
	SpecialTransition = getSpecialRandom("SuicidePrevention")
end;

local bonusSongBG = nil;
--Always show bonus BG if there is a custom song or it's a per-song BG
if FILEMAN:DoesFileExist(LastSong:GetSongDir().."/specialBG.png") then
	bonusSongBG = LastSong:GetSongDir().."/specialBG.png"
	ShowRIOLogo = true;
elseif FILEMAN:DoesFileExist(LastSong:GetSongDir().."/specialBG.jpg") then
	bonusSongBG = LastSong:GetSongDir().."/specialBG.jpg"
	ShowRIOLogo = true;
end;

if SpecialTransition then		--load wallpaper or special transition
	t[#t+1] = Def.ActorFrame{
		LoadActor(SpecialTransition)..{
			InitCommand=cmd(Cover);
		};
	};
elseif bonusSongBG then
	t[#t+1] = Def.ActorFrame{
		LoadActor(bonusSongBG)..{
			InitCommand=cmd(Cover);
		};
	};
else
	t[#t+1] = Def.ActorFrame{
		LoadActor(getRandomWall())..{
			InitCommand=cmd(Cover);
		};
	};

end;
if ShowRIOLogo then	--load rio logo in bottom right corner
	t[#t+1] = LoadActor(THEME:GetPathG("","logo"))..{
		InitCommand=cmd(horizalign,right;vertalign,bottom;xy,SCREEN_RIGHT,SCREEN_BOTTOM-25;zoom,.25);
	};
end;



return t
