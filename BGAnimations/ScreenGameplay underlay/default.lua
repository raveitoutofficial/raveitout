	local curstage = GAMESTATE:GetCurrentStage();

	local gfxNames = {
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

	local stage = gfxNames[curstage];

if GAMESTATE:IsCourseMode() then
	song = GAMESTATE:GetCurrentCourse(); -- Get current Course xD
	songdir = song:GetCourseDir();--Get current course directory xD
else
	song = GAMESTATE:GetCurrentSong(); 	--Get current song lel
	songdir = song:GetSongDir();--Get current song directory lel
end
local IsP1On =		GAMESTATE:IsPlayerEnabled(PLAYER_1)	--Is player 1 present? BRETTY OBIOS :DDDD
local IsP2On =		GAMESTATE:IsPlayerEnabled(PLAYER_2)	--Is player 2 present? BRETTY OBIOS :DDDD
--tip controls
local th =			4			--tip height
local tw =			52/2		--tip width
--note: for animation time we use local vittim
--diffusecolor,tc1,tc2,tc3;fadeleft,tfl;faderight,tfr
local tc1 =			1			--tip color param 1 (R)
local tc2 =			1			--tip color param 2 (G)
local tc3 =			1			--tip color param 3 (B)
local tfl =			0.25		--tip fade  left ratio 0..1
local tfr =			0.25		--tip face right ratio 0..1
--bar controls
local barin =		0.05		--bar in animation time
local barstay =		3			--bar stay (sleep) time
local baroff =		0.25		--bar off animation time
local barout =		60			--bar distance out screen from edge
local bzom = 		1			--bar zoom
local lfwide =		360+16+10	--life bar   wide screen position X, distance from center value
local lfnorm =		302			--life bar normal screen position X, distance from center value
local lfbpsy =		175*bzom	--life bar position Y			--local lfbpsy =	200			--life bar position Y
local vittim =		0.2			--vitality (life) change/variation animation time
local spawid =		320			--spacebar graphic width
local andiff =		0			--animation effect magnitude, also difference
local debgz1 =		0.75		--debug zoom category 1 value (Player name)
local bralph =		0.25		--life bar alpha diffuse value
local maxwid =		spawid*0.5	--Player name maxwidth (1/2 of the graphic width)	--varies depeding on font used
local namesp =		10			--additional name spacing
local BarsPosY =	_screen.cy+lfbpsy	--Standard Bar Y axis positioning (both players)
local notefxp1 =	THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX")	--Note field X position P1
local notefxp2 =	THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX")	--Note field X position P2
if IsP1On then

	if GAMESTATE:IsCourseMode() then
		stepsp1 = GAMESTATE:GetCurrentCourse():GetAllTrails()[1]:GetStepsType();
	else
		stepsp1 = GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType();
	end

	if stepsp1 ~= "StepsType_Pump_Single" then		--"if not single mode"
		notefxp1 = SCREEN_CENTER_X		--HALFDOUBLE/DOUBLE/ROUTINE--Note field X position P1
	end
end
if IsP2On then

	if GAMESTATE:IsCourseMode() then
		stepsp2 = GAMESTATE:GetCurrentCourse():GetAllTrails()[1]:GetStepsType();
	else
		stepsp2 = GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType();
	end

	if stepsp2 ~= "StepsType_Pump_Single" then		--"if not single mode"
		notefxp2 = SCREEN_CENTER_X		--HALFDOUBLE/DOUBLE/ROUTINE--Note field X position P2
	end
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
--ScreenFilter mod
local filterp1 =	GetUserPref("ScreenFilterP1")	--shortcut
local filterp2 =	GetUserPref("ScreenFilterP2")	--shortcut
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
function IsBreakOn()			--Is StageBreak On? by ROAD24
	if getenv("StageBreak") == nil then
		lua.Warn("No se asigno valor para el break usando valor por defecto");
		setenv("StageBreak",true);
		return true;
	end
	return getenv("StageBreak");
end;
-- Cambios -- ROAD24
local iOldCombo = 0;
-- Aqui se pueden tomar varias decisiones referentes al comportamiento del gameplay
-- si agregamos misiones este es el mejor lugar para poner ciertos requisitos
function SetupScreen()
	-- LimitBreak finetuning system by NeobeatIKK and ROAD24
	local p1meter = GAMESTATE:GetCurrentSteps(PLAYER_1):GetMeter()
	local p2meter = GAMESTATE:GetCurrentSteps(PLAYER_2):GetMeter()
	local meterhighest = math.max(p1meter,p2meter)
	local sttype = GAMESTATE:GetCurrentStyle():GetStepsType()
	if 		sttype == "StepsType_Pump_Single" 		then cstyle = "S"
	elseif	sttype == "StepsType_Pump_Halfdouble"	then cstyle = "H"
	elseif	sttype == "StepsType_Pump_Double"		then cstyle = "D"
	elseif	sttyle == "StepsType_Pump_Routine"		then cstyle = "R"
	end;
	local filepath = songdir..cstyle..meterhighest..".txt"
	local missvalue = ""

	if FILEMAN:DoesFileExist(filepath) then
		missvalue = File.Read(filepath);
		setenv("BreakCombo",missvalue);
	end;

	
	iOldCombo = getenv("BreakCombo"); -- Guardo el misscombo
--	SCREENMAN:SystemMessage("iOldCombo "..iOldCombo);
end;
function EndScreen()
--	SCREENMAN:SystemMessage("Restoring Combo from "..GetBreakCombo().." to "..iOldCombo);
	setenv("BreakCombo",51);
end;
	--P1BarPosX, P2BarPosX variables + CortesWideScreen Fix
if IsUsingWideScreen() then	
	P1BarPosX = SCREEN_LEFT+cfsepx+30;
	P2BarPosX = SCREEN_RIGHT-cfsepx-30;
else
	P1BarPosX = SCREEN_LEFT+cfsepx;
	P2BarPosX = SCREEN_RIGHT-cfsepx;
end

setenv("P1BarPosX",P1BarPosX);
setenv("P2BarPosX",P2BarPosX);

return Def.ActorFrame{
	
	Def.ActorFrame{		-- Wow este codigo es enorme que te parece si lo hacemos un poco mas modular --ROAD24
		-- Iniciamos algunas cosas en la screen
		OnCommand=SetupScreen;
		OffCommand=EndScreen;
	};
	--///// VISUAL STUFF /////
	Def.ActorFrame{	-- PLAYER 1		LIFE BAR STUFF
		InitCommand=cmd(x,-80);
		OnCommand=cmd(sleep,2;accelerate,0.25;x,barin-10);
		LifeChangedMessageCommand=function(self)
			if stage == "ScreenGameplay stage Demo" then
				self:visible(true);
			end;
		end;
		
		LoadActor("spacebar")..{			--back meter graphic
			InitCommand=cmd(visible,IsP1On;x,P1BarPosX;y,BarsPosY+2;horizalign,left;rotationz,-90;zoomx,bzom+0.01;zoomy,bzom+0.2);
		};
		
		LoadActor("spacebar")..{		--lifebar mask
			InitCommand=cmd(visible,IsP1On;x,P1BarPosX;y,BarsPosY-spawid-andiff;MaskSource;horizalign,right;rotationz,-90;zoom,bzom;);
			OnCommand=cmd(bounce;effectmagnitude,0,andiff,0;effectclock,"bgm";effecttiming,1,0,0,0;);
			LifeChangedMessageCommand=function(self)
				self:stoptweening();
				self:bounceend(vittim);
				if ((PSS1:GetCurrentMissCombo()/GetBreakCombo())-1) >= 0 then
					self:cropleft(0);
				else
					self:cropleft(math.abs((PSS1:GetCurrentMissCombo()/GetBreakCombo())-1));
				end;
			end;
		};
		LoadActor("p1_lifebar")..{			--meter graphic
			InitCommand=cmd(visible,IsP1On;x,P1BarPosX;y,BarsPosY;MaskDest;horizalign,left;rotationz,-90;zoom,bzom;);};
		--Def.Quad{						--meter tip indicator
		LoadActor("tip")..{
			--We IIDX now
			InitCommand=cmd(visible,IsP1On;x,P1BarPosX-25;y,BarsPosY-10;horizalign,left;zoomx,1.3;glowshift;effectclock,"beat";diffuseramp;effectcolor1,color(".8,.8,.8,1");effectcolor2,color("1,1,1,1"));
			LifeChangedMessageCommand=function(self)
				self:stoptweening();
				self:bounceend(vittim);
				if ((PSS1:GetCurrentMissCombo()/GetBreakCombo())-1) >= 0 then
					self:y(BarsPosY);
				else
					self:y(_screen.cy-lfbpsy+(spawid*(PSS1:GetCurrentMissCombo()/GetBreakCombo())+(64/2)));
				end;
			end;
		};
		LoadFont("Common normal")..{	--Player name
			InitCommand=function(self)
				(cmd(visible,IsP1On;x,P1BarPosX;y,BarsPosY-namesp;horizalign,left;rotationz,-90;zoom,debgz1;maxwidth,maxwid;))(self)		--notice, has no "zoom,bzom;"
				if prfnam1 == "" then self:settext("PLAYER 1");
				else self:settext(prfnam1);
				end;
			end;
		};
	};
	
	Def.ActorFrame{	-- PLAYER 2		LIFE BAR STUFF
		InitCommand=cmd(x,barout+80);
		OnCommand=cmd(sleep,2;accelerate,0.25;x,barin+10);
		LifeChangedMessageCommand=function(self)
			if stage == "ScreenGameplay stage Demo" then
				self:visible(true);
			end;
		end;
		
		LoadActor("spacebar")..{			--back meter graphic
			InitCommand=cmd(visible,IsP2On;x,P2BarPosX;y,BarsPosY+2;horizalign,left;rotationz,-90;zoomx,bzom+0.01;zoomy,bzom+0.2);
		};
		
		LoadActor("spacebar")..{		--lifebar mask
			InitCommand=cmd(visible,IsP2On;x,P2BarPosX;y,BarsPosY-spawid-andiff;MaskSource;horizalign,right;rotationz,-90;zoom,bzom;);
			OnCommand=cmd(bounce;effectmagnitude,0,andiff,0;effectclock,"bgm";effecttiming,1,0,0,0;);
			LifeChangedMessageCommand=function(self)
				self:stoptweening();
				self:linear(vittim);
				if ((PSS2:GetCurrentMissCombo()/GetBreakCombo())-1) >= 0 then
					self:cropleft(0);
				else
					self:cropleft(math.abs((PSS2:GetCurrentMissCombo()/GetBreakCombo())-1));
				end;
			end;
		};
		LoadActor("p2_lifebar")..{			--meter graphic
			InitCommand=cmd(visible,IsP2On;x,P2BarPosX;y,BarsPosY;MaskDest;horizalign,left;rotationz,-90;zoom,bzom;);};
		--Def.Quad{						--meter tip indicator
		LoadActor("tip")..{
			InitCommand=cmd(visible,IsP2On;x,P2BarPosX-25;y,BarsPosY-10;horizalign,left;zoomx,1.3;glowshift;effectclock,"beat";diffuseramp;effectcolor1,color(".8,.8,.8,1");effectcolor2,color("1,1,1,1"));
			LifeChangedMessageCommand=function(self)
				self:stoptweening();
				self:bounceend(vittim);
				if ((PSS2:GetCurrentMissCombo()/GetBreakCombo())-1) >= 0 then
					self:y(BarsPosY);
				else
					self:y(_screen.cy-lfbpsy+(spawid*(PSS2:GetCurrentMissCombo()/GetBreakCombo())+32));
				end;
			end;
		};
		LoadFont("Common normal")..{	--Player name
			InitCommand=function(self)
				(cmd(visible,IsP2On;x,P2BarPosX;y,BarsPosY-namesp;horizalign,left;rotationz,-90;zoom,debgz1;maxwidth,maxwid;))(self)		--notice, has no "zoom,bzom;"
				if prfnam2 == "" then self:settext("PLAYER 2");
				else self:settext(prfnam2);
				end;
			end;
		};
	};

	Def.ActorFrame{		--ScreenFilters
			OnCommand=function(self)
				if stage == "ScreenGameplay stage Demo" then self:visible(true); end
			end;

		Def.Quad{		--Player 1 Filter
			InitCommand=cmd(draworder,3;visible,IsP1On;x,notefxp1;vertalign,top;zoomto,257,SCREEN_HEIGHT;diffuse,0,0,0,(filterp1*0.01);playcommand,"Refresh";);
			RefreshCommand=function(self)
				if IsP1On then
					if GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType() == "StepsType_Pump_Halfdouble" then
						self:zoomto(310,SCREEN_HEIGHT);
						self:x(_screen.cx);
					elseif GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType() ~= "StepsType_Pump_Single" then
						self:zoomto(505,SCREEN_HEIGHT);
						self:x(_screen.cx);
					elseif PREFSMAN:GetPreference("Center1Player") and GAMESTATE:GetNumSidesJoined() == 1 then
							self:x(_screen.cx);
					end
				end;
			end;
		};
		Def.Quad{		--Player 2 Filter
			InitCommand=cmd(draworder,3;visible,IsP2On;x,notefxp2;vertalign,top;zoomto,257,SCREEN_HEIGHT;diffuse,0,0,0,(filterp2*0.01);playcommand,"Refresh";);
			RefreshCommand=function(self)
				if GAMESTATE:IsPlayerEnabled(PLAYER_2) then
					if GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType() == "StepsType_Pump_Halfdouble" then
						self:zoomto(310,SCREEN_HEIGHT);
						self:x(_screen.cx);
					elseif GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType() ~= "StepsType_Pump_Single" then
						self:zoomto(505,SCREEN_HEIGHT);
						self:x(_screen.cx);
					elseif PREFSMAN:GetPreference("Center1Player") and GAMESTATE:GetNumSidesJoined() == 1 then
						self:x(_screen.cx);
					end
				end;
			end;
		};
	};

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	Def.ActorFrame{		--Limit break by ROAD24 and NeobeatIKK
		--el modo "Perfectionist" hace que el jugador instantaneamente falle si obtiene algo igual o menor a un W3 (un Good) -NeobeatIKK
		ComboChangedMessageCommand=function(self,params)
			local css1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
			local css2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
			local p1w1 = css1:GetTapNoteScores("TapNoteScore_W1");local p1w2 = css1:GetTapNoteScores("TapNoteScore_W2");local p1w3 = css1:GetTapNoteScores("TapNoteScore_W3");local p1w4 = css1:GetTapNoteScores("TapNoteScore_W4");local p1w5 = css1:GetTapNoteScores("TapNoteScore_W5");local p1ms = css1:GetTapNoteScores("TapNoteScore_Miss");local p1cm = css1:GetTapNoteScores("TapNoteScore_CheckpointMiss");local p1hm = css1:GetTapNoteScores("TapNoteScore_HitMine");
			local p2w1 = css2:GetTapNoteScores("TapNoteScore_W1");local p2w2 = css2:GetTapNoteScores("TapNoteScore_W2");local p2w3 = css2:GetTapNoteScores("TapNoteScore_W3");local p2w4 = css2:GetTapNoteScores("TapNoteScore_W4");local p2w5 = css2:GetTapNoteScores("TapNoteScore_W5");local p2ms = css2:GetTapNoteScores("TapNoteScore_Miss");local p2cm = css2:GetTapNoteScores("TapNoteScore_CheckpointMiss");local p2hm = css2:GetTapNoteScores("TapNoteScore_HitMine");
			local GTS = SCREENMAN:GetTopScreen();
			local PlayerStageStats = params.PlayerStageStats;
			local bFailed = PlayerStageStats:GetCurrentMissCombo() >= GetBreakCombo();
			local OpositePlayer = GetOpositePlayer(params.Player);
			local OpositeStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(OpositePlayer);
			local bOpositePlayerFailed = OpositeStats:GetCurrentMissCombo() >= GetBreakCombo();
			if GetUserPref("PerfectionistMode") == "true" then
				if p1w3 >= 1 or p1w4 >= 1 or p1w5 >= 1 or p1ms >= 1 or p1cm >= 1 or p2w3 >= 1 or p2w4 >= 1 or p2w5 >= 1 or p2ms >= 1 or p2cm >= 1 then								-- Only W1s (AKA RAVINs / Marvelouses)
					GTS:PostScreenMessage("SM_BeginFailed",0);
					if GAMESTATE:GetCurrentStage() == "Stage_1st" and Enjoy1stStagePMode == true then
						return nil
					else
						PSS1:FailPlayer();
						PSS2:FailPlayer();
						setenv("StageFailed",true);
					end;
				end;
			elseif GetUserPref("PerfectionistMode") == "false" then
				if IsBreakOn() then			-- Si no esta activado el break no tiene caso revisar todo lo demas
				if THEME:GetMetric("CustomRIO","GamePlayMenu") == false then
					if GAMESTATE:IsPlayerEnabled( OpositePlayer ) then
						bFailed = bFailed and bOpositePlayerFailed;
					end;
					if bFailed then
						GTS:PostScreenMessage("SM_BeginFailed",0);
						if GAMESTATE:GetCurrentStage() == "Stage_1st" and Enjoy1stStage == true then
							return nil
						else				-- No creo que haya problema en forzar el fail de ambos players, ya que el break requiere que ambos deben alcanzar el combo miss -NeobeatIKK
							PSS1:FailPlayer();
							PSS2:FailPlayer();
							setenv("StageFailed",true);
						end;
					end;
				end;
				end;
			end;
		end;
		JudgmentMessageCommand=function(self,params)
		--if not IsComoSeLlameModeEnabled then	--activar cuando este el modo listo
			if 	params.TapNoteScore == 'TapNoteScore_HitMine' then
					local Combo = getenv("BreakCombo");
					-- Disminuyo el combo
					setenv("BreakCombo",Combo-1);
					--SCREENMAN:SystemMessage("BreakCombo: "..GetBreakCombo());
			end;
		--end;
		end;
		LoadFont("Common Normal")..{	--Stage break + value, message
			InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-30;zoom,0.5);
			OnCommand=function(self)
				if GetUserPref("PerfectionistMode") == "true" then		--don't do shit if Perfectionist Mode is activated
					return false
				end;
				-- TODO: Add a GetBreakCombo
				self:settext("Limit Break: "..GetBreakCombo());
				if stage == "ScreenGameplay stage Demo" then self:settext(""); else self:settext("Limit Break: "..GetBreakCombo()); end;
				p1stype = GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType();
				p2stype = GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType();
				if p1stype ~= "StepsType_Pump_Single" or p2stype ~= "StepsType_Pump_Single" or PREFSMAN:GetPreference("Center1Player") then
					self:y(SCREEN_BOTTOM-60);
				end;
			end;
		--[[	JudgmentMessageCommand=function(self,params)
				if	params.TapNoteScore == 'TapNoteScore_HitMine' then
					self:playcommand("On");
				end;
			end;--]]
			LifeChangedMessageCommand=function(self)	--ya que las effortbar reaccionan tan bien al limit break entonces pensé "porqué no actualizarlas de igual forma?" xD -NeobeatIKK
				self:playcommand("On");
			end;--]]
		};		--]]
	};

	Def.ActorFrame{		-- Write data to PlayerProfile/RIO_SongData
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
		Def.Actor{		-- Write SpeedMod to Profile (PLAYER_2) by NeobeatIKK
			OnCommand=function(self)
				if IsP2On then
					if prfnam2 ~= "" then
						local GPS2 = GAMESTATE:GetPlayerState(PLAYER_2);
						if GPS2:GetCurrentPlayerOptions():XMod() ~= nil then		--si XMod no da nil
							speedmod = GPS2:GetCurrentPlayerOptions():XMod().."X"
							modtype = "X"
						end;
						if GPS2:GetCurrentPlayerOptions():CMod() ~= nil then		--si CMod no da nil
							speedmod = "C"..GPS2:GetCurrentPlayerOptions():CMod()
							modtype = "C"
						end;
						if GPS2:GetCurrentPlayerOptions():MMod() ~= nil then		--si Mmod no da nil
							speedmod = "M"..GPS2:GetCurrentPlayerOptions():MMod()
							modtype = "M"
						end;
						local profilep = PROFILEMAN:GetProfileDir("ProfileSlot_Player2")
						local songpath = GAMESTATE:GetCurrentSong():GetSongDir()
					--	local usescard = PROFILEMAN:ProfileWasLoadedFromMemoryCard(PLAYER_1) --bool --breaks on load
					--	File.Write(profilep.."/RIO_SongData/"..songpath.."LastSpeedModUsed.txt","SpeedMod="..speedmod..";\nSModType="..modtype..";");	--works
					--	File.Write(profilep.."/RIO_SongData/"..songpath.."LastSpeedModTypeUsed.txt",modtype);	--Write SpeedModType				--works
						File.Write(profilep.."/RIO_SongData/"..songpath.."LastSpeedModUsed.txt",speedmod);		--Write SpeedMod				--works
					end;
				end;
			end;
		};
	};

	
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	Def.ActorFrame{		-- DEBUG STUFF
		OnCommand=cmd(visible,DoDebug);
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
		LoadFont(DebugFont)..{		-- CORTES FIX MSG
			InitCommand=cmd(xy,_screen.cx,SCREEN_TOP+10;zoom,0.5);
			OnCommand=cmd(visible,CortesWideFix;settext,"\[Using Cortes Widescreen patch\]");
		};
		LoadFont(DebugFont)..{		-- PerfectionistMode status
			InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-60;zoom,0.5);
		--	OnCommand=cmd(settext,"PerfectionistMode Status: "..GetUserPref("PerfectionistMode"));	--works
			OnCommand=function(self)
				if GetUserPref("PerfectionistMode") == "true" then
					temptex = "On.\nGet fucking rekt"
				elseif GetUserPref("PerfectionistMode") == "false" then
					temptex = "Off.\nYou'll never know true pain, fucking pussy bitch"
				end;
				self:settext("PerfectionistMode Status: "..temptex);	--works OK
			end;
		};
		LoadFont(DebugFont)..{		-- ScreenFilter status P1
			InitCommand=cmd(visible,IsP1On;xy,notefxp1,_screen.cy-100;zoom,0.5;);
			OnCommand=cmd(settext,"ScreenFilter P1: "..filterp1);
		};
		LoadFont(DebugFont)..{		-- ScreenFilter status P2
			InitCommand=cmd(visible,IsP2On;xy,notefxp2,_screen.cy-100;zoom,0.5;);
			OnCommand=cmd(settext,"ScreenFilter P2: "..filterp2);
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
		LoadFont(DebugFont)..{		-- MODs "rio" P1
			InitCommand=cmd(visible,IsP1On;xy,SCREEN_LEFT+5,_screen.cy;zoom,0.5;horizalign,left);
			--OnCommand=cmd(settext,GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptionsString("Stage"));			--works
			--OnCommand=cmd(settext,GAMESTATE:GetPlayerState(PLAYER_1):GetPlayerOptionsString("ModsLevel_Stage"));	--works
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
			end;	--]]
			--[[
				OnCommand=function(self)
			--	self:settext(string.find("FUCKING RIO SUCKS BALLS YO","RIO"));		--returns "9"
				self:settext(string.match("FUCKINGRIOSUCKSBALLSYO","RIO"));			--returns "RIO"
			end;	--]]
		};
		LoadFont(DebugFont)..{		-- MODs "rio" P2
			InitCommand=cmd(visible,IsP2On;xy,SCREEN_RIGHT-5,_screen.cy;zoom,0.5;horizalign,right);
			--OnCommand=cmd(settext,GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptionsString("Stage"));			--works
			--OnCommand=cmd(settext,GAMESTATE:GetPlayerState(PLAYER_2):GetPlayerOptionsString("ModsLevel_Stage"));	--works
			OnCommand=function(self)
				local GPS = GAMESTATE:GetPlayerState(PLAYER_2)
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
			end;	--]]
			--[[
				OnCommand=function(self)
			--	self:settext(string.find("FUCKING RIO SUCKS BALLS YO","RIO"));		--returns "9"
				self:settext(string.match("FUCKINGRIOSUCKSBALLSYO","RIO"));			--returns "RIO"
			end;	--]]
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
};
