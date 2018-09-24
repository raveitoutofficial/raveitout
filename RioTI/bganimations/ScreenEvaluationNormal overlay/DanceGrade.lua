--fuck barely
--local p1w5 =		css1:GetTapNoteScores("TapNoteScore_W5")				--BARELY
--local p2w5 =		css2:GetTapNoteScores("TapNoteScore_W5")				--BARELY
local t =			Def.ActorFrame {};
local gradep1="blank";
local IsP1On =		GAMESTATE:IsPlayerEnabled(PLAYER_1)	--Is player 1 present? BRETTY OBIOS :DDDD
local IsP2On =		GAMESTATE:IsPlayerEnabled(PLAYER_2)	--Is player 2 present? BRETTY OBIOS :DDDD
local css1 =		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
local css2 =		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
local visp1 = true;
local visp2 = true;
--songinfo
local cursong =		GAMESTATE:GetCurrentSong()
local song =		cursong:GetDisplayMainTitle()
local artist =		GAMESTATE:GetCurrentSong():GetDisplayArtist()
local function subtitle()	--regresar con parentesis el subtitulo si es que esta presente
	if cursong:GetDisplaySubTitle() == "" then
		return ""
	else
		return cursong:GetDisplaySubTitle()
	end;
end;

--scoring
local stagemaxscore = 100000000*GAMESTATE:GetNumStagesForCurrentSongAndStepsOrCourse()





-- players stage data
local p1holdstr	=	css1:GetTapNoteScores("TapNoteScore_CheckpointHit")		--RAVIN (HOLD STREAM)
local p2holdstr	=	css2:GetTapNoteScores("TapNoteScore_CheckpointHit")		--RAVIN (HOLD STREAM)
local p1w1 =		css1:GetTapNoteScores("TapNoteScore_W1")				--RAVIN
local p2w1 =		css2:GetTapNoteScores("TapNoteScore_W1")				--RAVIN
local p1nomine =	css1:GetTapNoteScores("TapNoteScore_AvoidMine")			--Avoided Mines
local p2nomine =	css2:GetTapNoteScores("TapNoteScore_AvoidMine")			--Avoided Mines
local p1w2 =		css1:GetTapNoteScores("TapNoteScore_W2")				--CRAZY
local p2w2 =		css2:GetTapNoteScores("TapNoteScore_W2")				--CRAZY
local p1w3 =		css1:GetTapNoteScores("TapNoteScore_W3")				--COOL
local p2w3 =		css2:GetTapNoteScores("TapNoteScore_W3")				--COOL
local p1w4 =		css1:GetTapNoteScores("TapNoteScore_W4")				--OKAY
local p2w4 =		css2:GetTapNoteScores("TapNoteScore_W4")				--OKAY
local p1miss =		css1:GetTapNoteScores("TapNoteScore_Miss")				--MISS
local p2miss =		css2:GetTapNoteScores("TapNoteScore_Miss")				--MISS
local p1holdmiss =	css1:GetTapNoteScores("TapNoteScore_CheckpointMiss")	--MISS (HOLD STREAM)
local p2holdmiss =	css2:GetTapNoteScores("TapNoteScore_CheckpointMiss")	--MISS (HOLD STREAM)
local p1minest =	css1:GetTapNoteScores("TapNoteScore_HitMine")			--MISS (MINE HIT)
local p2minest =	css2:GetTapNoteScores("TapNoteScore_HitMine")			--MISS (MINE HIT)
local maxcp1 =		css1:MaxCombo()											--Max Combo for this stage
local maxcp2 =		css2:MaxCombo()											--Max Combo for this stage

--workaround for new scoring system
css1:SetScore(getScores()[PLAYER_1]);
css2:SetScore(getScores()[PLAYER_2]);

local p1score =		css1:GetScore()			--score :v
local p2score =		css2:GetScore()			--score :v
--local p1accuracy =	tonumber(string.format("%.02f",(p1score/stagemaxscore)*100))	--Player 1 accuracy formatted number	--"%.3f" thanks CH32, se cambia el numero para mas decimales
--local p2accuracy =	tonumber(string.format("%.02f",(p2score/stagemaxscore)*100))	--Player 2 accuracy formatted number

local p1accuracy = 0;
local p2accuracy = 0;


p1accuracy = getenv("P1_accuracy") or 0;
p2accuracy = getenv("P2_accuracy") or 0;


local p1ravins =	p1holdstr+p1w1
local p2ravins =	p2holdstr+p2w1
local p1kcal = tonumber(string.format("%.1f",css1:GetCaloriesBurned()))
local p2kcal = tonumber(string.format("%.1f",css2:GetCaloriesBurned()))

if THEME:GetMetric("Gameplay","AvoidMineIncrementsCombo") then
	p1ravins =		p1holdstr+p1w1+p1nomine
	p2ravins =		p2holdstr+p2w1+p2nomine
end;
if THEME:GetMetric("Gameplay","MineHitIncrementsMissCombo") then
	p1misses =		p1miss+p1holdmiss+p1minest
	p2misses =		p2miss+p2holdmiss+p2minest
end;
local p1none =		css1:GetTapNoteScores("TapNoteScore_None")				--No step (DDR1st Hard mode)
local p2none =		css2:GetTapNoteScores("TapNoteScore_None")				--No step (DDR1st Hard mode)
--

local datalabelslist = {"AMAZING","RAVIN","COOL","OKAY","MISS","MAX COMBO","TOTAL SCORE","PRECISION","CALORIE (KCAL)"};
local p1datalist =	{p1ravins,string.format("%03d",p1w2),string.format("%03d",p1w3),string.format("%03d",p1w4),string.format("%03d",p1misses),maxcp1,p1score,p1accuracy.."%",p1kcal};
local p2datalist =	{p2ravins,string.format("%03d",p2w2),string.format("%03d",p2w3),string.format("%03d",p2w4),string.format("%03d",p2misses),maxcp2,p2score,p2accuracy.."%",p2kcal};


if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" then
	datalabelslist = {"RAVIN","COOL","OKAY","MISS","MAX COMBO","PRECISION","TOTAL SCORE","CALORIE (KCAL)"};
	p1datalist =	{p1ravins+p1w2,string.format("%03d",p1w3),string.format("%03d",p1w4),string.format("%03d",p1misses),maxcp1,p1accuracy.."%",p1score,p1kcal};
	p2datalist =	{p2ravins+p2w2,string.format("%03d",p2w3),string.format("%03d",p2w4),string.format("%03d",p2misses),maxcp2,p2accuracy.."%",p2score,p2kcal};
end;

	--BACKGROUND
	t[#t+1] = LoadActor("/Backgrounds/dancegrade")..{
		InitCommand=cmd(diffusealpha,0;x,5;zoomx,1.02;zoomy,0.998;Center;linear,1;diffusealpha,1;);
	};

	t[#t+1] = Def.Sprite {
		OnCommand=cmd(stoptweening;playcommand,"Banner";);
		BannerCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:Load(GAMESTATE:GetCurrentCourse():GetBannerPath());
			else
				self:Load(GAMESTATE:GetCurrentSong():GetBannerPath());
			end;
			(cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0;sleep,1;linear,2;diffusealpha,0.1)) (self)
		end;
	};
	
	--CENTER COLUMN
	t[#t+1] = LoadActor("gfx/midbarlayer")..{
		InitCommand=cmd(zoomto,215,1;xy,SCREEN_CENTER_X,SCREEN_TOP;vertalign,top;horizalign,center;sleep,1;linear,0.75;zoomto,215,SCREEN_HEIGHT;);
	};
	
	--TOP STUFF
	t[#t+1] = LoadActor("gfx/p1_topbar")..{
		InitCommand=cmd(x,SCREEN_LEFT-300;y,SCREEN_TOP+50;zoomto,275,55;horizalign,left;sleep,0.85;linear,0.2;x,SCREEN_LEFT;visible,GAMESTATE:IsSideJoined(PLAYER_1));
		OnCommand=function(self)
			if GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then self:x(SCREEN_RIGHT-268) end;
		end;
	};
	
	t[#t+1] = LoadActor("gfx/p2_topbar")..{
		InitCommand=cmd(x,SCREEN_RIGHT+300;y,SCREEN_TOP+50;horizalign,right;zoomto,275,55;sleep,0.85;linear,0.2;x,SCREEN_RIGHT;visible,GAMESTATE:IsSideJoined(PLAYER_2));
		OnCommand=function(self)
			if GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() == PLAYER_1 then self:x(SCREEN_LEFT+268) end;
		end;
	};
	
	if MonthOfYear() == 5 and DayOfMonth() == 12 then
	t[#t+1] = LoadActor("rainbow")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+42;horizalign,center;zoomx,0;zoomy,0.5;croptop,0.3;cropbottom,0.3;sleep,0.5;linear,0.2;zoomx,1);
	};
	end;
	
	t[#t+1] = LoadActor("gfx/top_title")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+50;horizalign,center;zoomx,0;zoomy,0.365;sleep,0.5;linear,0.2;zoomx,0.365);
	};
	
	
	--TIME LABEL
	t[#t+1] = LoadActor("gfx/time_bar")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP;zoomx,1;zoomy,1.4);
	};	
	
	t[#t+1] = LoadActor("gfx/time_label")..{
		InitCommand=cmd(x,_screen.cx-5;y,SCREEN_TOP+12;zoom,0.5);
	};
	
	t[#t+1] = Def.ActorFrame {
	OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+68;diffusealpha,0;sleep,1.5;linear,0.75;diffusealpha,1;);
	
		LoadFont("monsterrat/_montserrat semi bold 60px")..{	--SONG + (SUBTITLE)
		InitCommand=cmd(uppercase,true;zoom,0.22;addy,1;skewx,-0.2;diffuse,0,0,0,1;horizalign,center;settext,song.." "..subtitle();maxwidth,1250);
		OnCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:settext(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle());
			end;
		end;
	};
	};
	
	
--[MUSIC LEVELS
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(y,SCREEN_TOP+37;zoom,0;rotationz,0;);
	OnCommand=cmd(sleep,2;bounceend,0.5;zoom,1;rotationz,0);

	LoadFont("monsterrat/_montserrat semi bold 60px")..{
	InitCommand=cmd(zoomx,0.25;zoomy,0.225;skewx,-0.2;uppercase,true;horizalign,center;vertalign,top;);
	OnCommand=function(self)
	
	local steps = GAMESTATE:GetCurrentSteps(pn)
	local meter = steps:GetMeter();
	local stepstype = ToEnumShortString(steps:GetStepsType());

		if steps then			
			if stepstype == "Pump_Single" then mode = "SINGLE";
			elseif stepstype == "Pump_Double" then mode = "DOUBLE";
			elseif stepstype == "Pump_Routine" then mode = "ROUTINE"; self:visible(pn == GAMESTATE:GetMasterPlayerNumber());
			elseif stepstype == "Pump_Halfdouble" then mode = "HALF DOUBLE";
			end;

			if meter < 10 then
				self:settext(mode.." Lv.0"..meter);
			elseif meter >= 30 then
				self:settext(mode.." Lv.??");
			else
				self:settext(mode.." Lv."..meter);
			end;
		end;
		
		if pn == PLAYER_1 then
			if IsUsingWideScreen() then self:x(SCREEN_CENTER_X-290); self:maxwidth(350); else self:x(SCREEN_CENTER_X-217); end;
			self:horizalign(center);
		elseif pn == PLAYER_2 then
			if IsUsingWideScreen() then self:x(SCREEN_CENTER_X+290); self:maxwidth(350); else self:x(SCREEN_CENTER_X+217); end;
			self:horizalign(center);
		end
		
	end;
	
	OffCommand=cmd(linear,0.3;diffusealpha,0);
	};
	
	LoadFont("monsterrat/_montserrat light 60px")..{
	InitCommand=cmd(y,13;zoom,0.235;skewx,-0.2;uppercase,true;horizalign,center;vertalign,top;maxwidth,220);
	OnCommand=function(self)

		if GAMESTATE:IsCourseMode() and GetCourseDescription(GAMESTATE:GetCurrentCourse():GetCourseDir(),"DESCRIPTION") ~= "" then
			author = GAMESTATE:GetCurrentCourse():GetScripter();
			if author == "" then
				author = "Not available"
			end
		else
			author = GAMESTATE:GetCurrentSteps(pn):GetAuthorCredit();		--Cortes got lazy and opt to use Description tag lol
			if author == "" then
				author = "Not available"
			end;
		end;
		
		local steps = GAMESTATE:GetCurrentSteps(pn);
		local stepstype = ToEnumShortString(steps:GetStepsType());
		if stepstype == "Pump_Routine" then self:visible(pn == GAMESTATE:GetMasterPlayerNumber()); end;
		
		if pn == PLAYER_1 then
			if IsUsingWideScreen() then self:x(SCREEN_CENTER_X-290); self:maxwidth(350); else self:x(SCREEN_CENTER_X-217); end;
			self:horizalign(center);
		elseif pn == PLAYER_2 then
			if IsUsingWideScreen() then self:x(SCREEN_CENTER_X+290); self:maxwidth(350); else self:x(SCREEN_CENTER_X+217); end;
			self:horizalign(center);
		end
		
		self:settext(author);
	end;
	};
};

end;
--]]

--[			
for i = 1,#datalabelslist,1 do
	local sepx =		100					--horizontal spacing from labels
	local sepy =		25					--vertical spacing factor starting from 1st item
	local iniy =		SCREEN_TOP+100		--vertical starting point for evaluation data
	local initzoom = 	5
	local datazoom = 	0.55
	local intw =		0.1					--"in tween" animation
	local fx =			1.8-intw			--sound effect sleep time
	local inc =			0.15				--increment time between items
	
	local initsleeps = {}
    for n=0,#datalabelslist do
      initsleeps[n] = fx+(inc*n)
    end
	
	t[#t+1] = Def.Quad {
		InitCommand=cmd(xy,_screen.cx,iniy+(i*sepy)+2;diffuse,0,0,0,0;);
		OnCommand=cmd(sleep,initsleeps[i];accelerate,intw;diffuse,0,0,0,0.55;zoomto,SCREEN_WIDTH,22;);
	};
		if i >= 5 then
			t[#t+1] = LoadActor("gfx/judge_back")..{
				InitCommand=cmd(xy,_screen.cx,iniy+(i*sepy)+2;zoom,initzoom;diffusealpha,0);
				OnCommand=cmd(sleep,initsleeps[i];accelerate,intw;;diffusealpha,1;x,_screen.cx;y,iniy+(i*sepy)+2;zoomto,175,22;);
			};
		end;
	t[#t+1] = LoadFont("monsterrat/_montserrat semi bold 60px")..{		--JUDGEMENT LABELS
		InitCommand=cmd(xy,_screen.cx,iniy+(i*sepy);zoom,initzoom;settext,datalabelslist[i];diffusealpha,0);
		OnCommand=cmd(sleep,initsleeps[i];accelerate,intw;diffusealpha,1;zoom,datazoom-0.25;addy,1);
	};
	
	if GAMESTATE:IsCourseMode() then
		visp1 = IsP1On;
	elseif GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() == PLAYER_1 then
		visp1 = IsP1On;
	elseif GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then
		visp1 = false;
	else
		visp1 = IsP1On;
	end;
	
	t[#t+1] = LoadFont("monsterrat/_montserrat light 60px")..{		--stats p1
		InitCommand=cmd(xy,SCREEN_LEFT+20,iniy+(i*sepy);zoom,initzoom;horizalign,left;visible,visp1;settext,p1datalist[i];diffusealpha,0);
		OnCommand=cmd(sleep,initsleeps[i];accelerate,intw;diffusealpha,1;zoom,datazoom-0.15;);
	};
	
	if GAMESTATE:IsCourseMode() then
		visp2 = IsP2On;
	elseif GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() == PLAYER_1 then
		visp2 = false;
	elseif GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then
		visp2 = IsP2On;
	else
		visp2 = IsP2On;
	end;
	
	t[#t+1] = LoadFont("monsterrat/_montserrat light 60px")..{		--stats p2
		InitCommand=cmd(xy,SCREEN_RIGHT-20,iniy+(i*sepy);zoom,initzoom;horizalign,right;visible,visp2;settext,p2datalist[i];diffusealpha,0);
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
			if p2accuracy == nil then p2accuracy = 0 end
			if p1grade == nil then p1grade = 0 end
			if p2grade == nil then p2grade = 0 end
			setenv("LastStageAccuracyP1",p1accuracy);
			setenv("LastStageAccuracyP2",p2accuracy);
			setenv("LastStageGradeP1",p1grade);
			setenv("LastStageGradeP2",p2grade);
		end;
	};
};
--]]

t[#t+1] = LoadActor("AR Results")..{OnCommand=cmd(play)};	--Music


t[#t+1] = LoadActor("Music (loop)")..{						--The original coder made the music loop a stupid way, when you could literally just put (loop) in the filename.
		OnCommand=cmd(sleep,4;queuecommand,"PlaySound");	--Are you fucking serious? Come on, it's literally the easiest thing in the world to make music loop.
		PlaySoundCommand=cmd(play);
		OffCommand=cmd(stop)
	};



t[#t+1] = LoadActor("unlocks.lua");								--Unlock system


local initzoomp1 = 0.8;
local finalzoomp1 = 0.6;
local initzoomp2 = initzoomp1;
local finalzoomp2 = finalzoomp1;
local p1initx = SCREEN_WIDTH/4.5;
local p1inity = SCREEN_CENTER_Y-30;

local p2initx = SCREEN_RIGHT-p1initx+40;
local p2inity = p1inity;


--[ P1 RANK CODE
if GAMESTATE:IsSideJoined(PLAYER_1) and STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):IsDisqualified()==false then

if GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then
initzoomp1 = 0
finalzoomp1 = 0
end

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
	InitCommand=cmd(visible,visp1;x,p1initx;y,p1inity;draworder,100;diffusealpha,0;zoom,initzoomp1;sleep,3;linear,.2;diffusealpha,1;zoom,initzoomp1-0.25;linear,.3;zoom,finalzoomp1);
};

t[#t+1] = LoadActor("flash")..{
	InitCommand=cmd(visible,visp1;blend,Blend.Add;x,p1initx;y,p1inity;draworder,100;diffusealpha,0;zoom,initzoomp1;sleep,3;diffusealpha,1;linear,.5;diffusealpha,0;zoom,finalzoomp1;);
};

t[#t+1] = LoadActor(THEME:GetPathG("","GradeDisplayEval/"..gradep1))..{
	InitCommand=cmd(visible,visp1;horizalign,center;blend,Blend.Add;x,p1initx;y,p1inity;draworder,101;diffusealpha,0;zoom,initzoomp1;sleep,3;linear,.2;diffusealpha,1;zoom,initzoomp1-0.25;linear,.5;diffusealpha,0;zoom,finalzoomp1;);
};

if MonthOfYear() == 11 then
t[#t+1] = LoadActor("xmas_hat")..{
	InitCommand=cmd(visible,visp1;x,p1initx+15;y,p1inity-45;draworder,100;diffusealpha,0;zoom,initzoomp1/1.5;sleep,3;linear,.2;diffusealpha,1;zoom,initzoomp1-0.25;linear,.3;zoom,finalzoomp1/1.5);
};
end;

t[#t+1] = LoadActor(THEME:GetPathS("","DanceGrade/male/RANK_"..gradep1))..{
	OnCommand=cmd(sleep,2.75;queuecommand,'Play');
	PlayCommand=cmd(stop;play);
	OffCommand=cmd(stop;)
};

end;
--]]

--[ P2 RANK CODE]
if STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):IsDisqualified()==false and GAMESTATE:IsSideJoined(PLAYER_2) then

if GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType() == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() == PLAYER_1 then
initzoomp2 = 0
finalzoomp2 = 0
end

if getenv("StageFailed") == true then
	gradep2="_failed";
elseif p2accuracy == 100 then
	gradep2="S_S";
elseif p2accuracy >= 97 and p2misses == 0 and p2w4 == 0 and p2w3 == 0 then
	if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" then
		gradep2="S_S";
	else
		gradep2="S_plus";
	end;
elseif p2accuracy >= 96 and p2misses == 0 and p2w4 == 0 then
	gradep2="S_normal";
elseif p2accuracy >= 80 then
	gradep2="A";
elseif p2accuracy >= 70 then
	gradep2="B";
elseif p2accuracy >= 60 then
	gradep2="C";
elseif p2accuracy >= 50 then
	gradep2="D";
elseif p2accuracy < 50 then
	gradep2="F";
else
	gradep2="blank";
end;

t[#t+1] = LoadActor(THEME:GetPathG("","GradeDisplayEval/"..gradep2))..{
	InitCommand=cmd(visible,visp2;horizalign,right;x,p2initx;y,p2inity;draworder,100;diffusealpha,0;zoom,initzoomp2;sleep,3;linear,.2;diffusealpha,1;zoom,initzoomp2-0.25;linear,.3;zoom,finalzoomp2;);
};

t[#t+1] = LoadActor("flash")..{
	InitCommand=cmd(visible,visp2;horizalign,right;blend,Blend.Add;x,p2initx;y,p2inity;draworder,100;diffusealpha,0;zoom,initzoomp2;sleep,3;diffusealpha,1;linear,.5;diffusealpha,0;zoom,finalzoomp2;);
};

t[#t+1] = LoadActor(THEME:GetPathG("","GradeDisplayEval/"..gradep2))..{
	InitCommand=cmd(visible,visp2;horizalign,right;blend,Blend.Add;x,p2initx;y,p2inity;draworder,101;diffusealpha,0;zoom,initzoomp2;sleep,3;linear,.2;diffusealpha,1;zoom,initzoomp2-0.25;linear,.5;diffusealpha,0;zoom,finalzoomp2;);
};

if MonthOfYear() == 11 then
t[#t+1] = LoadActor("xmas_hat")..{
	InitCommand=cmd(visible,visp2;horizalign,right;x,p2initx+15;y,p2inity-45;draworder,100;diffusealpha,0;zoom,initzoomp2/1.5;sleep,3;linear,.2;diffusealpha,1;zoom,initzoomp2-0.25;linear,.3;zoom,finalzoomp2/1.5;);
};
end;

t[#t+1] = LoadActor(THEME:GetPathS("","DanceGrade/male/RANK_"..gradep2))..{
	OnCommand=cmd(sleep,2.75;queuecommand,'Play');
	PlayCommand=cmd(stop;play);
	OffCommand=cmd(stop;)
};

end;
--]]


t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(zoom,0;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM+150;);
	OnCommand=cmd(sleep,2;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-40;bounceend,0.5;zoom,0.6;);


	LoadFont("monsterrat/_montserrat semi bold 60px")..{
		InitCommand=cmd(zoom,0.3;skewx,-0.2;horizalign,center;vertalign,middle;);
		Text="PRESS           OR          \nTO CONTINUE.";
	};

	LoadActor("Center Tap Note 3x2")..{
		InitCommand=cmd(x,-3;y,-10;zoom,0.45);
	};

	LoadActor("start")..{
		InitCommand=cmd(x,75;y,-10;zoom,0.5);
	};
};




t[#t+1] = LoadActor(THEME:GetPathG("","USB_stuff"))..{};

return t