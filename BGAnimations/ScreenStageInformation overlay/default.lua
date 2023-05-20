local t =			Def.ActorFrame {};

--Todo: WHAT IS THIS GARBAGE
if not GAMESTATE:IsCourseMode() then
	local IsP1On =		GAMESTATE:IsPlayerEnabled(PLAYER_1)	--Is player 1 present? BRETTY OBIOS :DDDD
	local IsP2On =		GAMESTATE:IsPlayerEnabled(PLAYER_2)	--Is player 2 present? BRETTY OBIOS :DDDD

	local song = GAMESTATE:GetCurrentSong(); 	--Get current song lel
	local anim;
	local songdir = song:GetSongDir();--Get current song directory lel

	--secret chart for certain song.
	--[[if song:GetMainTitle() == "Show Time Under Leaden Skies" then
		--SCREENMAN:SystemMessage("True!");
		if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerOneSide" or GAMESTATE:GetCurrentStyle():GetStyleType() == 'StyleType_TwoPlayersTwoSides' then
			local stepsArray = song:GetStepsByStepsType('StepsType_Pump_Single');
			local res = stepsArray[ math.random( #stepsArray ) ]
			--SCREENMAN:SystemMessage("Selected "..ToEnumShortString(res:GetDifficulty()));
			GAMESTATE:SetCurrentSteps(PLAYER_1,res);
		end;
	end;]]

	-- again sanity checks !!!
	local p1CurrentSteps = GAMESTATE:GetCurrentSteps(PLAYER_1);
	local p2CurrentSteps = GAMESTATE:GetCurrentSteps(PLAYER_2);

	local p1meter =	p1CurrentSteps and p1CurrentSteps:GetMeter() or 0;
	local p2meter = p2CurrentSteps and p2CurrentSteps:GetMeter() or 0;
	local meterhighest = math.max(p1meter,p2meter)

	local sttype =		GAMESTATE:GetCurrentStyle():GetStepsType()
	local cstyle;
	if 		sttype == "StepsType_Pump_Single" 		then cstyle = "S"
	elseif	sttype == "StepsType_Pump_Halfdouble"	then cstyle = "H"
	elseif	sttype == "StepsType_Pump_Double"		then cstyle = "D"
	elseif	sttyle == "StepsType_Pump_Routine"		then cstyle = "R"
	else
		cstyle = "S" --Fallback
	end;
	local chartspecificanimationpath =	songdir.."_customanimation_"..cstyle..meterhighest..".lua"
	local customanimationpath =			songdir.."_customanimation.lua"
	local haschartspecificanimation = 	FILEMAN:DoesFileExist(chartspecificanimationpath)
	local hascustomanimation =			FILEMAN:DoesFileExist(customanimationpath)
	if haschartspecificanimation then
		anim = chartspecificanimationpath
	elseif hascustomanimation then
		anim = customanimationpath
	else
		anim = "msg.lua"
	end;
	local itemy = 13	--item list y separation

	t[#t+1] = LoadActor(anim);

	if DoDebug then
		if haschartspecificanimation then
			haschartspecificanimationtext = "true"
		else
			haschartspecificanimationtext = "false"
		end;
		if hascustomanimation then
			hascustomanimationtext = "true"
		else
			hascustomanimationtext = "false"
		end;
		--arrays
		local texts = {"Songpath: ","p1meter: ","p2meter: ","meterhighest: ","sttype: ","chartspecificanimationpath: ","customanimationpath: ","haschartspecificanimation: ","hascustomanimation: ","anim: ",};
		local locvl = {songdir,p1meter,p2meter,meterhighest,sttype,chartspecificanimationpath,customanimationpath,haschartspecificanimationtext,hascustomanimationtext,anim,};
		t[#t+1] = LoadFont(DebugFont)..{		--DEBUG: SET Timing Window Scale value
			InitCommand=cmd(xy,SCREEN_LEFT+5,itemy*1;horizalign,left;zoom,0.5);
			OnCommand=function(self)
				local winval = THEME:GetMetric("CustomRIO","ForcedTimingScale")
				self:settext("Setting TimingWindowScale value: "..winval);
				PREFSMAN:SetPreference("TimingWindowScale",winval);
			end;
		};
		for i = 1,#locvl,1 do
			t[#t+1] = LoadFont(DebugFont)..{
				InitCommand=cmd(xy,SCREEN_LEFT+5,itemy*(i+1);horizalign,left;zoom,0.5;settext,texts[i]..locvl[i]);
			};
		end;
	end;
else
	t[#t+1] = LoadActor("msg.lua");
end;


return t
