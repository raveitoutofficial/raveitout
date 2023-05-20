local stage = GAMESTATE:GetCurrentStage();

if GAMESTATE:IsCourseMode() then
	song = GAMESTATE:GetCurrentCourse(); -- Get current Course xD
	songdir = song:GetCourseDir();--Get current course directory xD
else
	song = GAMESTATE:GetCurrentSong(); 	--Get current song lel
	songdir = song:GetSongDir();--Get current song directory lel
end
local IsP1On =		GAMESTATE:IsPlayerEnabled(PLAYER_1)	--Is player 1 present? BRETTY OBIOS :DDDD
local IsP2On =		GAMESTATE:IsPlayerEnabled(PLAYER_2)	--Is player 2 present? BRETTY OBIOS :DDDD

local notefxp1 =	THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX")	--Note field X position P1
local notefxp2 =	THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX")	--Note field X position P2
if CenterGameplayWidgets() then
	notefxp1 = SCREEN_CENTER_X
	notefxp2 = SCREEN_CENTER_X
end

local profil1 = 	PROFILEMAN:GetProfile(PLAYER_1);	--short for prfnam1
local prfnam1 = 	profil1:GetDisplayName();			--Profile Display Name in player 1 slot
local profil2 = 	PROFILEMAN:GetProfile(PLAYER_2);	--short for prfnam2
local prfnam2 = 	profil2:GetDisplayName();			--Profile Display Name in player 2 slot
local GTS = 		SCREENMAN:GetTopScreen();			--short
local GPS1 =		GAMESTATE:GetPlayerState(PLAYER_1);
local GPS2 =		GAMESTATE:GetPlayerState(PLAYER_2);
local PSS1 =		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1)	--
local PSS2 =		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2)	--
local PSSMaster =	STATSMAN:GetCurStageStats():GetPlayerStageStats(GAMESTATE:GetMasterPlayerNumber())	--
local lfbpsy =	175 --life bar position Y			--local lfbpsy =	200			--life bar position Y
local spawid =		320			--spacebar graphic width

--Cortes usual dumb shit lol
local cfsepx = 35		--cortes fix screen edge separation

function GetOpositePlayer(pn)	--Obtiene el jugador "opuesto" by ROAD24
	if pn == PLAYER_1 then
		return PLAYER_2;
	else
		return PLAYER_1;
	end;
end;

function GetBreakCombo()		-- by ROAD24 and NeobeatIKK
	-- El combo en el que haremos break, la idea de aqui es poder variarlo
	-- aun durante la ejecucion del programa, pero por el momento es fijo
	-- Corre a cargo del thememaker cuando y por que valor se actualiza
	local Combo = getenv("BreakCombo");
	if Combo == nil then
		Combo = THEME:GetMetric("CustomRIO","MissToBreak");
		setenv("BreakCombo",Combo);
	end;
	return tonumber(Combo);
end;

-- Cambios -- ROAD24
local iOldCombo = 0;
-- Aqui se pueden tomar varias decisiones referentes al comportamiento del gameplay
-- si agregamos misiones este es el mejor lugar para poner ciertos requisitos
function SetupScreen()
	--TODO: This isn't implemented yet
	--[[-- LimitBreak finetuning system by NeobeatIKK and ROAD24
	local p1meter = GAMESTATE:GetCurrentSteps(PLAYER_1):GetMeter()
	local p2meter = GAMESTATE:GetCurrentSteps(PLAYER_2):GetMeter()
	local meterhighest = math.max(p1meter,p2meter)
	
	
	-- StepsType_Dance_Couple --> Dance_Couple --> ["Dance","Couple"]
	local sttype = split("_",ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStepsType()))
	local gamemode = sttype[1]
	local style = sttype[2]
	
	--SCREENMAN:SystemMessage(gamemode.." "..style)
	if style == "Halfdouble"	then cstyle = "H"
	elseif	style == "Double"		then cstyle = "D"
	elseif	sttype == "Routine"		then cstyle = "R"
	else cstyle = "S"
	end;
	
	local filepath = songdir..cstyle..meterhighest..".txt"
	local missvalue = ""

	if FILEMAN:DoesFileExist(filepath) then
		missvalue = File.Read(filepath);
		setenv("BreakCombo",missvalue);
	end;]]

	
	iOldCombo = getenv("BreakCombo"); -- Guardo el misscombo
--	SCREENMAN:SystemMessage("iOldCombo "..iOldCombo);
end;
function EndScreen()
--	SCREENMAN:SystemMessage("Restoring Combo from "..GetBreakCombo().." to "..iOldCombo);
	setenv("BreakCombo",51);
end;


local t = Def.ActorFrame{
	
	Def.ActorFrame{		-- Wow este codigo es enorme que te parece si lo hacemos un poco mas modular --ROAD24
		-- Iniciamos algunas cosas en la screen
		OnCommand=SetupScreen;
		OffCommand=EndScreen;
	};
}
--[[
yeah this isn't really good code
To be honest I kind of hate this feature -Accelerator
]]
local activeModP1 = ActiveModifiers["P1"]["BGAMode"]
local activeModP2 = ActiveModifiers["P2"]["BGAMode"]
if activeModP1 == "Black" or activeModP2 == "Black" then
	t[#t+1] = Def.Quad{InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,Color("Black");Center)};
--or (ReadPrefFromFile("StreamSafeEnabled") == "true" and has_value(STREAM_UNSAFE_VIDEO, GAMESTATE:GetCurrentSong():GetDisplayFullTitle()))
elseif activeModP1 == "Off" or activeModP2 == "Off" or false then
	local BGAOffcolors = {
		["Special"] = "#F3CE71",
		["Pro"] = "#F3718D",
		["Easy"] = "#86f482",
		["Arcade"] = "#717ff3"
	}
	t[#t+1] = LoadActor(THEME:GetPathG("","_BGMovies/BGAOFF"))..{
		InitCommand=cmd(Cover;Center;)
	}
	--Color BGA
	t[#t+1] = Def.Quad{
			InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;vertalign,top;horizalign,left;diffuse,color(BGAOffcolors[getenv("PlayMode")]);blend,"BlendMode_WeightedMultiply")
	};
	--Left side
	t[#t+1] = LoadActor("scrollingText")..{
		InitCommand=cmd(customtexturerect,0,0,2,1;zoomto,463*2,100;texcoordvelocity,.25,0;vertalign,top;horizalign,right;addx,-10;rotationz,-90;diffuse,color(BGAOffcolors[getenv("PlayMode")]);diffusealpha,.8;);
	};
	t[#t+1] = LoadActor("BGAOFF_"..getenv("PlayMode").."Text")..{
		InitCommand=cmd(customtexturerect,0,0,2,1;zoomto,400*2,27;texcoordvelocity,.2,0;vertalign,top;horizalign,right;addx,90;rotationz,-90;diffuse,color(BGAOffcolors[getenv("PlayMode")]);diffusealpha,.8;);
	
	}
	t[#t+1] = Def.Quad{
		InitCommand=cmd(setsize,15,SCREEN_HEIGHT;vertalign,top;horizalign,left;addx,90+27;diffuse,color(BGAOffcolors[getenv("PlayMode")]);faderight,1;diffusealpha,.8);
	};
	--Right side
	t[#t+1] = LoadActor("scrollingText")..{
		InitCommand=cmd(customtexturerect,0,0,2,1;zoomto,463*2,100;texcoordvelocity,.25,0;vertalign,top;horizalign,left;x,SCREEN_RIGHT+10;rotationz,90;diffuse,color(BGAOffcolors[getenv("PlayMode")]);diffusealpha,.8;);
	};
	t[#t+1] = LoadActor("BGAOFF_"..getenv("PlayMode").."Text")..{
		InitCommand=cmd(customtexturerect,0,0,2,1;zoomto,400*2,27;texcoordvelocity,.2,0;vertalign,top;horizalign,left;x,SCREEN_RIGHT-90;rotationz,90;diffuse,color(BGAOffcolors[getenv("PlayMode")]);diffusealpha,.8;);
	
	}
	t[#t+1] = Def.Quad{
		InitCommand=cmd(setsize,15,SCREEN_HEIGHT;vertalign,top;horizalign,right;x,SCREEN_RIGHT-90-27;diffuse,color(BGAOffcolors[getenv("PlayMode")]);fadeleft,1;diffusealpha,.8);
	};
	--color mixing test
	--[[for i = 1, 10 do
		t[#t+1] = Def.Quad{
			InitCommand=cmd(setsize,SCREEN_WIDTH/10,SCREEN_HEIGHT;vertalign,top;horizalign,left;x,SCREEN_WIDTH/10*i-SCREEN_WIDTH/10;diffuse,color(BGAOffcolors[getenv("PlayMode")]);blend,BlendMode:Reverse()[i])
		};
	end;]]
end;

--Hide elements if we're on the OMES
if not getenv("IsOMES_RIO") then
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		
		if pn == "PlayerNumber_P3" or pn == "PlayerNumber_P4" then
			break
		end;
		
		local negativeOffset = (pn == PLAYER_1) and -1 or 1;
		local barposX = (pn == PLAYER_1) and 25*PREFSMAN:GetPreference("DisplayAspectRatio") or SCREEN_RIGHT-(25*PREFSMAN:GetPreference("DisplayAspectRatio"));
		--setenv("BarPosX",barposX);
		t[#t+1] = LoadActor("lifebar", pn)..{
			InitCommand=cmd(xy,barposX+(negativeOffset*100),SCREEN_CENTER_Y;rotationz,-90;);
			OnCommand=cmd(sleep,1.5;accelerate,0.25;x,barposX);
		};
		t[#t+1] = LoadActor("avatars", pn)..{
			InitCommand=cmd(xy,barposX+negativeOffset*100,50);
			OnCommand=cmd(sleep,1.5;accelerate,0.25;x,barposX);
		};
		if ActiveModifiers[pname(pn)]["TargetScore"] then
			t[#t+1] = LoadActor("TargetScoreV2",pn);
		end;
		
	end;
end;
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
t[#t+1] = Def.ActorFrame{		--Limit break by ROAD24 and NeobeatIKK
	--el modo "Perfectionist" hace que el jugador instantaneamente falle si obtiene algo igual o menor a un W3 (un Good) -NeobeatIKK
	ComboChangedMessageCommand=function(self,params)
		local GTS = SCREENMAN:GetTopScreen();
		local pss = params.PlayerStageStats;
		
		local bFailed = pss:GetFailed(); --True if forced failed or the lifebar is empty.
		if pss:GetCurrentMissCombo() >= GetBreakCombo() then
			pss:FailPlayer();
			bFailed = true;
		end;
		
		local OpositePlayer = GetOpositePlayer(params.Player);
		local OpositeStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(OpositePlayer);
		local bOpositePlayerFailed = OpositeStats:GetFailed();
		--Shit code
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			if PerfectionistMode[pn] then
				local OppositePlayer = GetOpositePlayer(pn);
				local css = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
				--[[local w1 = css:GetTapNoteScores("TapNoteScore_W1");
				local w2 = css:GetTapNoteScores("TapNoteScore_W2");]]
				local w3 = css:GetTapNoteScores("TapNoteScore_W3");
				local w4 = css:GetTapNoteScores("TapNoteScore_W4");
				local w5 = css:GetTapNoteScores("TapNoteScore_W5");
				local ms = css:GetTapNoteScores("TapNoteScore_Miss");
				local cm = css:GetTapNoteScores("TapNoteScore_CheckpointMiss");
				local hm = css:GetTapNoteScores("TapNoteScore_HitMine");
				if w3 >= 1 or w4 >= 1 or w5 >= 1 or ms >= 1 or cm >= 1 then -- Only W1s (AKA RAVINs / Marvelouses)
					--SCREENMAN:SystemMessage("Player "..pn.." failed");
					css:FailPlayer();
					if GAMESTATE:IsSideJoined(OppositePlayer) and bOpositePlayerFailed then
						setenv("StageFailed",true);
						GTS:PostScreenMessage("SM_BeginFailed",0);
					elseif not GAMESTATE:IsSideJoined(OppositePlayer) then

						setenv("StageFailed",true);
						GTS:PostScreenMessage("SM_BeginFailed",0);
					end;
				end;
			end;
		end;
		
		if GAMESTATE:IsPlayerEnabled( OpositePlayer ) then
			bFailed = bFailed and bOpositePlayerFailed;
		end;
		--If both players failed.
		if bFailed then
			GTS:PostScreenMessage("SM_BeginFailed",0);
			setenv("StageFailed",true);
		end;
	end;
	LoadFont("Common Normal")..{	--Stage break + value, message
		InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-30;zoom,0.5);
		OnCommand=function(self)
			--don't do shit if Perfectionist Mode is activated, don't show if it's the demo stage.
			if (PerfectionistMode[PLAYER_1] and PerfectionistMode[PLAYER_2]) or stage == "Stage_Demo" then
				self:visible(false)
				return
			end;
			self:settext("Limit Break: "..GetBreakCombo());
			--[[local p1stype;
			local p2stype;
			if GAMESTATE:GetPlayMode() == 'PlayMode_Regular' then
				p1stype = GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType();
				p2stype = GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType();
			else
				p1stype = GAMESTATE:GetCurrentTrail(PLAYER_1):GetStepsType();
				p2stype = GAMESTATE:GetCurrentTrail(PLAYER_2):GetStepsType();
			end;
			if p1stype ~= "StepsType_Pump_Single" or p2stype ~= "StepsType_Pump_Single" or PREFSMAN:GetPreference("Center1Player") then
				self:y(SCREEN_BOTTOM-60);
			end;]]
			if CenterGameplayWidgets() then
				self:y(SCREEN_BOTTOM-60);
			end;
		end;
		--[[LifeChangedMessageCommand=function(self)	--ya que las effortbar reaccionan tan bien al limit break entonces pensé "porqué no actualizarlas de igual forma?" xD -NeobeatIKK
			self:settext("Limit Break: "..GetBreakCombo());
		end;]]
		JudgmentMessageCommand=function(self,params)
			--if not IsComoSeLlameModeEnabled then	--activar cuando este el modo listo
			if params.TapNoteScore == 'TapNoteScore_HitMine' then
				local Combo = getenv("BreakCombo");
				-- Disminuyo el combo
				setenv("BreakCombo",Combo-1);
				--SCREENMAN:SystemMessage("BreakCombo: "..GetBreakCombo());
				self:settext("Limit Break: "..Combo);
			end;
		--end;
		end;
		
	};
};

--[[t[#t+1] = 	Def.ActorFrame{		-- Write data to PlayerProfile/RIO_SongData
		Def.Actor{		-- Write SpeedMod to Profile (PLAYER_1) by NeobeatIKK
			OnCommand=function(self)
				if IsP1On then
					if prfnam1 ~= "" then
						local GPS1 = GAMESTATE:GetPlayerState(PLAYER_1);
						if GPS1:GetCurrentPlayerOptions():XMod() ~= nil then		--si XMod no da nil
							speedmod = GPS1:GetCurrentPlayerOptions():XMod().."X"
							modtype = "X"
						end;
						if GPS1:GetCurrentPlayerOptions():CMod() ~= nil then		--si CMod no da nil
							speedmod = "C"..GPS1:GetCurrentPlayerOptions():CMod()
							modtype = "C"
						end;
						if GPS1:GetCurrentPlayerOptions():MMod() ~= nil then		--si Mmod no da nil
							speedmod = "M"..GPS1:GetCurrentPlayerOptions():MMod()
							modtype = "M"
						end;
						local profilep = PROFILEMAN:GetProfileDir("ProfileSlot_Player1")
						local songpath = GAMESTATE:GetCurrentSong():GetSongDir()
					--	local usescard = PROFILEMAN:ProfileWasLoadedFromMemoryCard(PLAYER_1) --bool --breaks on load
					--	File.Write(profilep.."/RIO_SongData/"..songpath.."LastSpeedModUsed.txt","SpeedMod="..speedmod..";\nSModType="..modtype..";");	--works
					--	File.Write(profilep.."/RIO_SongData/"..songpath.."LastSpeedModTypeUsed.txt",modtype);	--Write SpeedModType				--works
						File.Write(profilep.."/RIO_SongData/"..songpath.."LastSpeedModUsed.txt",speedmod);		--Write SpeedMod				--works
					end;
				end;
			end;
		};

]]

if DoDebug then
	t[#t+1] = 	Def.ActorFrame{		-- DEBUG STUFF
		--[[LoadFont(DebugFont)..{		--Hit Mine button
			InitCommand=cmd(xy,_screen.cx,_screen.cy-20;zoom,0.5;settext,"MINE HIT BUTTON");
			HitMineMessageCommand=cmd(stoptweening;zoom,1;linear,0.25;zoom,0.5;);
		};--]]
		LoadFont(DebugFont)..{		-- Timing window scale GET value
			InitCommand=cmd(xy,_screen.cx,SCREEN_TOP+20;zoom,0.5;vertalign,top);
			OnCommand=cmd(settext,"DEBUG: GET Timing Window Scale value: "..PREFSMAN:GetPreference("TimingWindowScale"));
		};
		LoadFont(DebugFont)..{		-- Current Song Path, for Disabled song dev.
			InitCommand=cmd(xy,_screen.cx,SCREEN_TOP+40;zoom,0.5);
			OnCommand=cmd(settext,"Song path: \""..GAMESTATE:GetCurrentSong():GetSongDir().."\"";);
		};
		LoadFont(DebugFont)..{		-- PerfectionistMode status
			InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-80;zoom,0.5);
		--	OnCommand=cmd(settext,"PerfectionistMode Status: "..GetUserPref("PerfectionistMode"));	--works
			OnCommand=function(self)
				local perfModeP1 = boolToString(PerfectionistMode[PLAYER_1]);
				local perfModeP2 = boolToString(PerfectionistMode[PLAYER_2]);
				self:settext("PerfectionistMode Status: P1="..perfModeP1.." | P2="..perfModeP2);	--works OK
			end;
		};
		LoadFont(DebugFont)..{		-- ScreenFilter status P1
			InitCommand=cmd(visible,IsP1On;xy,notefxp1,_screen.cy-100;zoom,0.5;);
			OnCommand=cmd(settext,"ScreenFilter P1: "..ActiveModifiers["P1"]["ScreenFilter"]);
		};
		LoadFont(DebugFont)..{		-- ScreenFilter status P2
			InitCommand=cmd(visible,IsP2On;xy,notefxp2,_screen.cy-100;zoom,0.5;);
			OnCommand=cmd(settext,"ScreenFilter P2: "..ActiveModifiers["P2"]["ScreenFilter"]);
		};
		LoadFont(DebugFont)..{		-- Miss bar value P1
			InitCommand=cmd(visible,IsP1On;xy,SCREEN_LEFT+5,SCREEN_TOP+10+15;horizalign,left;zoom,0.5;);	--notice, has no "zoom,bzom;"
			LifeChangedMessageCommand=cmd(settext,"Bar pos: ".._screen.cy-lfbpsy+(spawid*(PSS1:GetCurrentMissCombo()/GetBreakCombo())-65));			--this has to be the same calc as the bar tip indicator
		};
		LoadFont(DebugFont)..{		-- Miss bar value P2
			InitCommand=cmd(visible,IsP2On;xy,SCREEN_RIGHT-5,SCREEN_TOP+10+15;horizalign,right;zoom,0.5;);	--notice, has no "zoom,bzom;"
			LifeChangedMessageCommand=cmd(settext,"Bar pos: ".._screen.cy-lfbpsy+(spawid*(PSS2:GetCurrentMissCombo()/GetBreakCombo())-65));			--this has to be the same calc as the bar tip indicator
		};
		LoadFont(DebugFont)..{		-- Miss combo P1
			InitCommand=cmd(visible,IsP1On;xy,SCREEN_LEFT+5,SCREEN_TOP+10;zoom,0.5;horizalign,left;);
			ComboChangedMessageCommand=function(self)
				self:settext("Miss count: "..PSS1:GetCurrentMissCombo());
			end;
		};

		LoadFont(DebugFont)..{		-- Miss combo P2
			InitCommand=cmd(visible,IsP2On;xy,SCREEN_RIGHT-5,SCREEN_TOP+10;zoom,0.5;horizalign,right;);
			ComboChangedMessageCommand=function(self)
				self:settext("Miss count: "..PSS2:GetCurrentMissCombo());
			end;
		};
		--stages
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=cmd(xy,SCREEN_RIGHT-5,SCREEN_TOP+15;zoom,0.5;horizalign,right;);
			OnCommand=function(self) --Current stage value changes if you do InitCommand.
				self:settext("Current Stage: "..GAMESTATE:GetCurrentStage());
			end;
		};
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=cmd(xy,SCREEN_RIGHT-5,SCREEN_TOP+30;zoom,0.5;horizalign,right;);
			Text="Number of stages: "..PREFSMAN:GetPreference("SongsPerPlay");
		};
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=cmd(xy,SCREEN_RIGHT-5,SCREEN_TOP+45;zoom,0.5;horizalign,right;);
			Text="Smallest Num stages: "..GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer();
		};
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=cmd(xy,SCREEN_RIGHT-5,SCREEN_TOP+60;zoom,0.5;horizalign,right;);
			Text="Num stages left P1: "..GAMESTATE:GetNumStagesLeft(PLAYER_1);
		};
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=cmd(xy,SCREEN_RIGHT-5,SCREEN_TOP+75;zoom,0.5;horizalign,right;);
			Text="Num stages left P2: "..GAMESTATE:GetNumStagesLeft(PLAYER_2);
		};
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			InitCommand=cmd(xy,SCREEN_RIGHT-5,SCREEN_TOP+90;zoom,0.5;horizalign,right;);
			Text="Final stage for any player? "..boolToString(GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer()==1);
		};
		
		LoadFont(DebugFont)..{		-- MODs "rio" P1
			InitCommand=cmd(visible,IsP1On;xy,SCREEN_LEFT+5,_screen.cy;zoom,0.5;horizalign,left);
			OnCommand=function(self)
				local GPS = GAMESTATE:GetPlayerState(PLAYER_1)
				local modstage = GPS:GetPlayerOptionsString("Stage")	--String
							--	local modstage = GPS:GetPlayerOptionsArray("Stage")	--array
			--	local srch = ", rio"									--Search
				local srch = "rio"										--Search (safe)
				if string.match(modstage,srch) == srch then
					msg = srch.."\" was found"
				else
					msg = srch.."\" is not here, GTFO"
				end;
				self:settext("Looking for: \""..srch.."\"\nFound it?: \""..msg.."\nCurrent mods: "..modstage);
			end;
		};
		LoadFont(DebugFont)..{		-- finding speedmod P1 by NeobeatIKK
			InitCommand=cmd(visible,IsP1On;xy,SCREEN_LEFT+10,_screen.cy+100;zoom,0.5;horizalign,left);
			OnCommand=function(self)
				local GPS = GAMESTATE:GetPlayerState(PLAYER_1);
				if GPS:GetCurrentPlayerOptions():XMod() ~= nil then		--si XMod no da nil
					speedmod = GPS:GetCurrentPlayerOptions():XMod().."X"
					modtype = "X"
				end;
				if GPS:GetCurrentPlayerOptions():CMod() ~= nil then		--si CMod no da nil
					speedmod = "C"..GPS:GetCurrentPlayerOptions():CMod()
					modtype = "C"
				end;
				if GPS:GetCurrentPlayerOptions():MMod() ~= nil then		--si Mmod no da nil
					speedmod = "M"..GPS:GetCurrentPlayerOptions():MMod()
					modtype = "M"
				end;
				self:settext("Speedmod: "..speedmod.."\nSpeedmod type: "..modtype);
			end;
		};
		LoadFont(DebugFont)..{		-- finding speedmod P2 by NeobeatIKK
			InitCommand=cmd(visible,IsP2On;xy,SCREEN_RIGHT-10,_screen.cy+100;zoom,0.5;horizalign,right);
			OnCommand=function(self)
				local GPS = GAMESTATE:GetPlayerState(PLAYER_2);
				if GPS:GetCurrentPlayerOptions():XMod() ~= nil then		--si XMod no da nil
					speedmod = GPS:GetCurrentPlayerOptions():XMod().."X"
					modtype = "X"
				end;
				if GPS:GetCurrentPlayerOptions():CMod() ~= nil then		--si CMod no da nil
					speedmod = "C"..GPS:GetCurrentPlayerOptions():CMod()
					modtype = "C"
				end;
				if GPS:GetCurrentPlayerOptions():MMod() ~= nil then		--si Mmod no da nil
					speedmod = "M"..GPS:GetCurrentPlayerOptions():MMod()
					modtype = "M"
				end;
				self:settext("Speedmod: "..speedmod.."\nSpeedmod type: "..modtype);
			end;
		};
		LoadFont(DebugFont)..{		-- Profile path debug P1
			InitCommand=cmd(visible,IsP1On;xy,SCREEN_LEFT+10,_screen.cy+140;zoom,0.5;horizalign,left);
			OnCommand=function(self)
				local profilep = PROFILEMAN:GetProfileDir("ProfileSlot_Player1")
						--local usescard = PROFILEMAN:ProfileWasLoadedFromMemoryCard("ProfileSlot_Player1")	--breaks on load
				self:settext("Loaded profile path:\n"..profilep);
			--	File.Write(profilep.."testwashere.txt","Surprise muthafucka!");
			end;
		};--]]
		LoadFont(DebugFont)..{		-- Profile path debug P2
			InitCommand=cmd(visible,IsP2On;xy,SCREEN_RIGHT-10,_screen.cy+140;zoom,0.5;horizalign,right);
			OnCommand=function(self)
				local profilep = PROFILEMAN:GetProfileDir("ProfileSlot_Player2")
						--local usescard = PROFILEMAN:ProfileWasLoadedFromMemoryCard("ProfileSlot_Player2")	--breaks on load
				self:settext("Loaded profile path:\n"..profilep);
			--	File.Write(profilep.."testwashere.txt","Surprise muthafucka!");
			end;
		};--]]
	};
end;
	
return t;
