local player = ...;
--fuck barely
--local p1w5 =		css1:GetTapNoteScores("TapNoteScore_W5")				--BARELY
--local p2w5 =		css2:GetTapNoteScores("TapNoteScore_W5")				--BARELY
local t =			Def.ActorFrame {};
local css1 =		STATSMAN:GetCurStageStats():GetPlayerStageStats(player);

--scoring
local stagemaxscore = 100000000*GAMESTATE:GetNumStagesForCurrentSongAndStepsOrCourse()





-- players stage data
local p1holdstr	=	css1:GetTapNoteScores("TapNoteScore_CheckpointHit")		--AMAZING (HOLD STREAM)
local p1w1 =		css1:GetTapNoteScores("TapNoteScore_W1")				--AMAZING
local p1nomine =	css1:GetTapNoteScores("TapNoteScore_AvoidMine")			--Avoided Mines
local p1w2 =		css1:GetTapNoteScores("TapNoteScore_W2")				--RAVIN'
local p1w3 =		css1:GetTapNoteScores("TapNoteScore_W3")				--COOL
local p1w4 =		css1:GetTapNoteScores("TapNoteScore_W4")				--OKAY
local p1misses =		css1:GetTapNoteScores("TapNoteScore_Miss")				--MISS
local p1holdmiss =	css1:GetTapNoteScores("TapNoteScore_CheckpointMiss")	--MISS (HOLD STREAM)
local p1minest =	css1:GetTapNoteScores("TapNoteScore_HitMine")			--MISS (MINE HIT)
local maxcp1 =		css1:MaxCombo()											--Max Combo for this stage

--workaround for new scoring system
--TODO: getScores is returning nil
--css1:SetScore(getScores()[player]);

local p1score =		css1:GetScore()			--score :v
--local p1accuracy =	tonumber(string.format("%.02f",(p1score/stagemaxscore)*100))	--Player 1 accuracy formatted number	--"%.3f" thanks CH32, se cambia el numero para mas decimales
--local p2accuracy =	tonumber(string.format("%.02f",(p2score/stagemaxscore)*100))	--Player 2 accuracy formatted number

--TODO: Why are you declaring a variable and then assigning it on the next line wtf
local p1accuracy = getenv(pname(player).."_accuracy") or 0;


local p1ravins =	p1holdstr+p1w1
local p1kcal = tonumber(string.format("%.1f",css1:GetCaloriesBurned()))

if THEME:GetMetric("Gameplay","AvoidMineIncrementsCombo") then
	p1ravins =		p1holdstr+p1w1+p1nomine
end;

if THEME:GetMetric("Gameplay","MineHitIncrementsMissCombo") then
	p1misses =		p1misses+p1holdmiss+p1minest
end;

local p1none =		css1:GetTapNoteScores("TapNoteScore_None")				--No step (DDR1st Hard mode)
--

--Sorry
function gs(s)
	return THEME:GetString("JudgmentLine",s)
end

local datalabelslist = {gs("W1"),gs("W2"),gs("W3"),gs("W4"),gs("Miss"),gs("MaxCombo"),"TOTAL SCORE","PRECISION","CALORIE (KCAL)"};
local p1datalist =	{p1ravins,string.format("%03d",p1w2),string.format("%03d",p1w3),string.format("%03d",p1w4),string.format("%03d",p1misses),maxcp1,p1score,p1accuracy.."%",p1kcal};

local noFantastics = (PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never") --Used in two places
if noFantastics then
	datalabelslist = {gs("W2"),gs("W3"),gs("W4"),gs("Miss"),gs("MaxCombo"),"PRECISION","TOTAL SCORE","CALORIE (KCAL)"};
	p1datalist =	{p1ravins+p1w2,string.format("%03d",p1w3),string.format("%03d",p1w4),string.format("%03d",p1misses),maxcp1,p1accuracy.."%",p1score,p1kcal};
end;
	
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(y,SCREEN_TOP+37;zoom,0;rotationz,0;);
	OnCommand=cmd(sleep,2;bounceend,0.5;zoom,1;rotationz,0);

	LoadFont("monsterrat/_montserrat semi bold 60px")..{
	InitCommand=cmd(zoomx,0.25;zoomy,0.225;skewx,-0.2;uppercase,true;horizalign,center;vertalign,top;);
	OnCommand=function(self)
		local steps = GAMESTATE:GetCurrentSteps(player);
		if ToEnumShortString(steps:GetStepsType()) == "Pump_Routine" then
			self:visible(player == GAMESTATE:GetMasterPlayerNumber());
		end;
		self:settext(StepsTypeToString(steps));
		
		if player == PLAYER_1 then
			if IsUsingWideScreen() then self:x(SCREEN_CENTER_X-290); self:maxwidth(350); else self:x(SCREEN_CENTER_X-217); end;
			self:horizalign(center);
		elseif player == PLAYER_2 then
			if IsUsingWideScreen() then self:x(SCREEN_CENTER_X+290); self:maxwidth(350); else self:x(SCREEN_CENTER_X+217); end;
			self:horizalign(center);
		end
		
	end;
	
	OffCommand=cmd(linear,0.3;diffusealpha,0);
	};
	
	LoadFont("monsterrat/_montserrat light 60px")..{
	InitCommand=cmd(y,13;zoom,0.235;skewx,-0.2;uppercase,true;horizalign,center;vertalign,top;maxwidth,220);
	OnCommand=function(self)

		if GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() then
			author = GAMESTATE:GetCurrentCourse():GetScripter();
			if author == "" then
				author = "Not available"
			end
		else
			author = GAMESTATE:GetCurrentSteps(player):GetAuthorCredit();		--Cortes got lazy and opt to use Description tag lol
			if author == "" then
				author = "Not available"
			end;
		end;
		
		local steps = GAMESTATE:GetCurrentSteps(player);
		local stepstype = ToEnumShortString(steps:GetStepsType());
		if stepstype == "Pump_Routine" then self:visible(player == GAMESTATE:GetMasterPlayerNumber()); end;
		
		if player == PLAYER_1 then
			if IsUsingWideScreen() then self:x(SCREEN_CENTER_X-290); self:maxwidth(350); else self:x(SCREEN_CENTER_X-217); end;
			self:horizalign(center);
		elseif player == PLAYER_2 then
			if IsUsingWideScreen() then self:x(SCREEN_CENTER_X+290); self:maxwidth(350); else self:x(SCREEN_CENTER_X+217); end;
			self:horizalign(center);
		end
		
		self:settext(author);
	end;
	};
};

--TODO: These should probably be metrics
local sepx =		100					--horizontal spacing from labels
local sepy =		25					--vertical spacing factor starting from 1st item
local iniy =		SCREEN_TOP+100		--vertical starting point for evaluation data
local initzoom = 	5
local datazoom = 	0.55
local intw =		0.1					--"in tween" animation
local fx =			1.8-intw			--sound effect sleep time
local inc =			0.15				--increment time between items

--Positioning of the numbers, depending on if you're playing Player 1 or Player 2.
local xPosition = (player == PLAYER_1) and SCREEN_LEFT+20 or SCREEN_RIGHT-20;
--See above.
local alignment = (player == PLAYER_1) and left or right;
for i = 1,#datalabelslist,1 do

	
	local initsleeps = {}
    for n=0,#datalabelslist do
      initsleeps[n] = fx+(inc*n)
    end
	
	--[[t[#t+1] = Def.Quad {
		InitCommand=cmd(xy,_screen.cx,iniy+(i*sepy)+2;diffuse,0,0,0,0;);
		OnCommand=cmd(sleep,initsleeps[i];accelerate,intw;diffuse,0,0,0,0.55;zoomto,SCREEN_WIDTH,22;);
	};]]
	--Ternary abuse: If noFantastics is true then it will do (i >= 5), if it's false it will do (i >= 6).
	if i >= (noFantastics and 5 or 6) then
		t[#t+1] = LoadActor("gfx/judge_back")..{
			InitCommand=cmd(xy,_screen.cx,iniy+(i*sepy)+2;zoom,initzoom;diffusealpha,0);
			OnCommand=cmd(sleep,initsleeps[i];accelerate,intw;;diffusealpha,1;x,_screen.cx;y,iniy+(i*sepy)+2;zoomto,175,22;);
		};
	end;
	t[#t+1] = LoadFont("monsterrat/_montserrat semi bold 60px")..{		--JUDGEMENT LABELS
		InitCommand=cmd(xy,_screen.cx,iniy+(i*sepy);zoom,initzoom;settext,datalabelslist[i];diffusealpha,0);
		OnCommand=cmd(sleep,initsleeps[i];accelerate,intw;diffusealpha,1;zoom,datazoom-0.25;addy,1);
	};
	
	--TODO:Fix later
	--[[if GAMESTATE:IsCourseMode() then
		visp1 = IsP1On;
	elseif GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() == PLAYER_1 then
		visp1 = IsP1On;
	elseif GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then
		visp1 = false;
	else
		visp1 = IsP1On;
	end;]]
	
	t[#t+1] = LoadFont("monsterrat/_montserrat light 60px")..{		--stats p1
		InitCommand=cmd(xy,xPosition,iniy+(i*sepy);zoom,initzoom;horizalign,alignment;settext,p1datalist[i];diffusealpha,0);
		OnCommand=cmd(sleep,initsleeps[i];accelerate,intw;diffusealpha,1;zoom,datazoom-0.15;);
	};
	
end;
--]]

--[
t[#t+1] = Def.ActorFrame{
	Def.Actor{		--set in the env table accuracy values, so they can be get from save profile screen (next screen)
		InitCommand=function(self)
			--don't pass nil values to env
			if p1accuracy == nil then p1accuracy = 0 end
			if p1grade == nil then p1grade = 0 end
			setenv("LastStageAccuracy"..pname(player),p1accuracy);
			setenv("LastStageGrade"..pname(player),p1grade);
		end;
	};
};
--]]

local initzoomp1 = 0.8;
local finalzoomp1 = 0.6;
local p1initx = (player == PLAYER_1) and SCREEN_WIDTH/4.5 or SCREEN_RIGHT-SCREEN_WIDTH/4.5;
local p1inity = SCREEN_CENTER_Y-30;


--P1 RANK CODE
if STATSMAN:GetCurStageStats():GetPlayerStageStats(player):IsDisqualified()==false then

	--TODO: investigate why this exists later
	--[[if GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then
		initzoomp1 = 0
		finalzoomp1 = 0
	end]]

	if getenv("StageFailed") == true then
		gradep1="_failed";
	elseif p1accuracy == 100 then
		gradep1="S_S";
	elseif p1accuracy >= 97 and p1misses == 0 and p1w4 == 0 and p1w3 == 0 then
		if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" then 
			gradep1="S_S";
		else 
			gradep1="S_plus"; 
		end;
	elseif p1accuracy >= 96 and p1misses == 0 and p1w4 == 0 then
		gradep1="S_normal";
	elseif p1accuracy >= 80 then
		gradep1="A";
	elseif p1accuracy >= 70 then
		gradep1="B";
	elseif p1accuracy >= 60 then
		gradep1="C";
	elseif p1accuracy >= 50 then
		gradep1="D";
	elseif p1accuracy < 50 then
		gradep1="F";
	else
		gradep1="blank";
	end;

	t[#t+1] = LoadActor(THEME:GetPathG("","GradeDisplayEval/"..gradep1))..{
		InitCommand=cmd(x,p1initx;y,p1inity;draworder,100;diffusealpha,0;zoom,initzoomp1;sleep,3;linear,.2;diffusealpha,1;zoom,initzoomp1-0.25;linear,.3;zoom,finalzoomp1);
	};

	t[#t+1] = LoadActor("flash")..{
		InitCommand=cmd(blend,Blend.Add;x,p1initx;y,p1inity;draworder,100;diffusealpha,0;zoom,initzoomp1;sleep,3;diffusealpha,1;linear,.5;diffusealpha,0;zoom,finalzoomp1;);
	};

	t[#t+1] = LoadActor(THEME:GetPathG("","GradeDisplayEval/"..gradep1))..{
		InitCommand=cmd(horizalign,center;blend,Blend.Add;x,p1initx;y,p1inity;draworder,101;diffusealpha,0;zoom,initzoomp1;sleep,3;linear,.2;diffusealpha,1;zoom,initzoomp1-0.25;linear,.5;diffusealpha,0;zoom,finalzoomp1;);
	};

	if MonthOfYear() == 11 then
		t[#t+1] = LoadActor("xmas_hat")..{
			InitCommand=cmd(x,p1initx+15;y,p1inity-45;draworder,100;diffusealpha,0;zoom,initzoomp1/1.5;sleep,3;linear,.2;diffusealpha,1;zoom,initzoomp1-0.25;linear,.3;zoom,finalzoomp1/1.5);
		};
	end;
	
	if DoDebug then
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(x,p1initx+15;y,p1inity+100;zoom,.5);
			--Must be OnCommand because hearts have to be subtracted first in default.lua
			LoadFont("Common Normal")..{
				OnCommand=cmd(settext,pname(player).." hearts left: "..NumHeartsLeft[player];);
			};
			LoadFont("Common Normal")..{
				OnCommand=cmd(settext,pname(player).." hearts removed: "..NumHeartsRemoved[player].. "(excluding bonus hearts)";addy,20);
			};
			LoadFont("Common Normal")..{
				OnCommand=cmd(settext,pname(player).." bonus hearts: "..BonusHeartsAdded[player];addy,40);
			};
			LoadFont("Common Normal")..{
				OnCommand=cmd(settext,pname(player).." got bonus heart? "..boolToString(PlayerAchievedBonusHeart(player));addy,60);
			};
		
		};
	end;

	t[#t+1] = LoadActor(THEME:GetPathS("","DanceGrade/male/RANK_"..gradep1))..{
		OnCommand=cmd(sleep,2.75;queuecommand,'Play');
		PlayCommand=cmd(stop;play);
		OffCommand=cmd(stop;)
	};
end;

return t
