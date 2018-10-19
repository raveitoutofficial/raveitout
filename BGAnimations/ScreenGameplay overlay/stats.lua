local t = Def.ActorFrame {};
local IsP1On =		GAMESTATE:IsPlayerEnabled(PLAYER_1)	--Is player 1 present? BRETTY OBIOS :DDDD
local IsP2On =		GAMESTATE:IsPlayerEnabled(PLAYER_2)	--Is player 2 present? BRETTY OBIOS :DDDD
-- LIVE STATS CONTROLS
local labelalpha =	0.25		--alpha label value
local numberalpha =	0.5			--Global alpha numbers value
local lbhali =		center		--Labels  horizontal align
local lbvali =		middle		--Labels  vertical align
local nmhali =		center		--Numbers horizontal align
local nmvali =		middle		--Numbers verical align
local lbzoom =		0.4			--Global labels zoom
local nmzoom =		lbzoom		--Global numbers zoom
	local curstage = GAMESTATE:GetCurrentStage()

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

--Sorry
function gs(s)
	return THEME:GetString("JudgmentLine",s)
end
local jllist = {gs("W1"),gs("W2"),gs("W3"),gs("W4"),gs("Miss")};	--judgement label list

if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" or stage == "ScreenGameplay stage Demo" then
	jllist = {gs("W2"),gs("W3"),gs("W4"),gs("Miss")};	--judgement label list for easy
end

local LSXoff =		40			--Global X offset
local LSYoff =		0			--Global Y offset --14
local p1lbxset =	THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX")	--Player 1 label set X
local p2lbxset =	THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX")	--Player 2 label set X
local p1lbyset =	SCREEN_BOTTOM-20		--Player 1 label set Y
local p2lbyset =	p1lbyset				--Player 2 label set Y

if IsP1On then	 		--Player 1 label set X (if halfdouble or anything NOT single panel)

	if GAMESTATE:IsCourseMode() then
		p1stype = GAMESTATE:GetCurrentCourse():GetAllTrails()[1]:GetStepsType();
	else
		p1stype = GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType();
	end

	if p1stype ~= "StepsType_Pump_Single" then
		p1lbxset = SCREEN_CENTER_X	--Doubles is always perfectly centered, isn't it?
		p1lbyset = SCREEN_BOTTOM-35
	end;

end;
if IsP2On then			--Player 2 label set X (if halfdouble or anything NOT single panel)

	if GAMESTATE:IsCourseMode() then
		p2stype = GAMESTATE:GetCurrentCourse():GetAllTrails()[1]:GetStepsType();
	else
		p2stype = GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType();
	end

	if p2stype ~= "StepsType_Pump_Single" then
		p2lbxset = _screen.cx	--Doubles is always perfectly centered, isn't it?
		p2lbyset = SCREEN_BOTTOM-35
	end
end;

--
local P1W1X =		p1lbxset+LSXoff*-2	--Player 1, W1 X value
local P1W2X =		p1lbxset+LSXoff*-1	--Player 1, W2 X value
local P1W3X =		p1lbxset+LSXoff*0	--Player 1, W3 X value
local P1W4X =		p1lbxset+LSXoff*1		--Player 1, W4 X value
--local P1W5X =		p1lbxset+LSXoff*2		--Player 1, W5 X value
local P1MSX =		p1lbxset+LSXoff*2		--Player 1, Miss X value
--local p1xlist =	{P1W1X,P1W2X,P1W3X,P1W4X,P1W5X,P1MSX};
local p1xlist =		{P1W1X,P1W2X,P1W3X,P1W4X,P1MSX};
--
local P1W1Y =		p1lbyset+LSYoff*0		--Player 1, W1 Y value
local P1W2Y =		p1lbyset+LSYoff*1		--Player 1, W2 Y value
local P1W3Y =		p1lbyset+LSYoff*2		--Player 1, W3 Y value
local P1W4Y =		p1lbyset+LSYoff*3		--Player 1, W4 Y value
--local P1W5Y =		p1lbyset+LSYoff*4		--Player 1, W5 Y value
local P1MSY =		p1lbyset+LSYoff*4		--Player 1, Miss Y value
--local p1ylist =	{P1W1Y,P1W2Y,P1W3Y,P1W4Y,P1W5Y,P1MSY,};
local p1ylist =		{P1W1Y,P1W2Y,P1W3Y,P1W4Y,P1MSY,};
--
local P2W1X =		p2lbxset+LSXoff*-2	--Player 2, W1 X value
local P2W2X =		p2lbxset+LSXoff*-1	--Player 2, W2 X value
local P2W3X =		p2lbxset+LSXoff*0	--Player 2, W3 X value
local P2W4X =		p2lbxset+LSXoff*1		--Player 2, W4 X value
--local P2W5X =		p2lbxset+LSXoff*2		--Player 2, W5 X value
local P2MSX =		p2lbxset+LSXoff*2		--Player 2, Miss X value
--local p2xlist =	{P2W1X,P2W2X,P2W3X,P2W4X,P2W5X,P2MSX};
local p2xlist =		{P2W1X,P2W2X,P2W3X,P2W4X,P2MSX};
--
local P2W1Y =		p2lbyset+LSYoff*0		--Player 2, W1 Y value
local P2W2Y =		p2lbyset+LSYoff*1		--Player 2, W2 Y value
local P2W3Y =		p2lbyset+LSYoff*2		--Player 2, W3 Y value
local P2W4Y =		p2lbyset+LSYoff*3		--Player 2, W4 Y value
--local P2W5Y =		p2lbyset+LSYoff*4		--Player 2, W5 Y value
local P2MSY =		p2lbyset+LSYoff*4		--Player 2, Miss Y value
--local p2ylist =	{P2W1Y,P2W2Y,P2W3Y,P2W4Y,P2W5Y,P2MSY,};
local p2ylist =		{P2W1Y,P2W2Y,P2W3Y,P2W4Y,P2MSY,};
--
local nmxoff =		0						--Number X offset (from W values)
local nmyoff =		11						--Number Y offset (from W values)
local lbfon =		"Common normal"			--Live stats labels font
local nbfon =		"Common normal"			--Live stats numbers font
--
local p1stats =		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
local p2stats =		STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
--
if IsP1On and not PerfectionistMode[PLAYER_1] then	--p1 live stats
	for i = 1,#jllist,1 do
		t[#t+1] = LoadFont(lbfon)..{	--LABELS P1
			InitCommand=cmd(horizalign,lbhali;vertalign,lbvali;xy,p1xlist[i],p1ylist[i];zoom,lbzoom;diffusealpha,labelalpha;);
			OnCommand=function(self)
				self:settext(jllist[i]);
				if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" then
					self:addx(17);
				end

				if p1stype == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() ~= PLAYER_1 then
					self:settext("");
				else
					self:settext(jllist[i]);
				end;
			end;
		};
		t[#t+1] = LoadFont(nbfon)..{	--NUMBERS P1
			InitCommand=cmd(horizalign,nmhali;vertalign,nmvali;xy,p1xlist[i]+nmxoff,p1ylist[i]+nmyoff;zoom,nmzoom;diffusealpha,numberalpha;);
			OnCommand=function(self)
				if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" then
					self:addx(17);
				end
			end;
			ComboChangedMessageCommand=function(self)
				local p1w1st = p1stats:GetTapNoteScores("TapNoteScore_W1")+p1stats:GetTapNoteScores("TapNoteScore_CheckpointHit");
				local p1w2st = p1stats:GetTapNoteScores("TapNoteScore_W2");
				local p1w3st = p1stats:GetTapNoteScores("TapNoteScore_W3");
				local p1w4st = p1stats:GetTapNoteScores("TapNoteScore_W4");
			--	local p1w5st = p1stats:GetTapNoteScores("TapNoteScore_W5");
				local p1wmst = p1stats:GetTapNoteScores("TapNoteScore_Miss")+p1stats:GetTapNoteScores("TapNoteScore_CheckpointMiss");
			--	local p1stlist = {p1w1st,p1w2st,p1w3st,p1w4st,p1w5st,p1wmst,};
				local p1stlist = {p1w1st,p1w2st,p1w3st,p1w4st,p1wmst};
				if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" then
					p1stlist = {p1w1st+p1w2st,p1w3st,p1w4st,p1wmst};
				end

				if p1stype == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() ~= PLAYER_1 then
					self:settext("");
				else
					self:settext(p1stlist[i]);
				end;
			end;
		};	--]]
	end;
end;

if IsP2On and not PerfectionistMode[PLAYER_2] then	--p2 live stats
	for i = 1,#jllist,1 do
		t[#t+1] = LoadFont(lbfon)..{	--LABELS P2
			InitCommand=cmd(horizalign,lbhali;vertalign,lbvali;xy,p2xlist[i],p2ylist[i];zoom,lbzoom;diffusealpha,labelalpha;);
			OnCommand=function(self)
				self:settext(jllist[i]);
				if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" then
					self:addx(17);
				end

				if p2stype == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() ~= PLAYER_2 then
					self:settext("");
				else
				
					self:settext(jllist[i]);
				end;
			end;

		};
		t[#t+1] = LoadFont(nbfon)..{	--NUMBERS P2
			InitCommand=cmd(horizalign,nmhali;vertalign,nmvali;xy,p2xlist[i]+nmxoff,p2ylist[i]+nmyoff;zoom,nmzoom;diffusealpha,numberalpha;);
			OnCommand=function(self)
				if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" then
					self:addx(17);
				end
			end;
			ComboChangedMessageCommand=function(self)
				local p2w1st = p2stats:GetTapNoteScores("TapNoteScore_W1")+p2stats:GetTapNoteScores("TapNoteScore_CheckpointHit");
				local p2w2st = p2stats:GetTapNoteScores("TapNoteScore_W2");
				local p2w3st = p2stats:GetTapNoteScores("TapNoteScore_W3");
				local p2w4st = p2stats:GetTapNoteScores("TapNoteScore_W4");
			--	local p2w5st = p2stats:GetTapNoteScores("TapNoteScore_W5");
				local p2wmst = p2stats:GetTapNoteScores("TapNoteScore_Miss")+p2stats:GetTapNoteScores("TapNoteScore_CheckpointMiss");
			--	local p2stlist = {p2w1st,p2w2st,p2w3st,p2w4st,p2w5st,p2wmst,};
				local p2stlist = {p2w1st,p2w2st,p2w3st,p2w4st,p2wmst,};
				if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" then
					p2stlist = {p2w1st+p2w2st,p2w3st,p2w4st,p2wmst};
				end

				if p2stype == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() ~= PLAYER_2 then
					self:settext("");
				else
					self:settext(p2stlist[i]);
				end;
			end;
		};	--]]
	end;
end;


t[#t+1] = Def.ActorFrame{		-- DEBUG STUFF
	OnCommand=cmd(visible,DoDebug);		--Don't show anything on this group if not executing Debug Mode
	LoadFont("Common normal")..{		--[DEBUG] Column being pressed, by Alisson
		InitCommand=cmd(xy,_screen.cx,_screen.cy+10;zoom,0.5;);
	--	ComboChangedMessageCommand=cmd(settext,customscore);
	--	Text=customscore;
		StepMessageCommand=function(self, param)
			self:settext(param.Column);
		end;
	};
	LoadFont("Common normal")..{		--[DEBUG] Judgement, by Alisson
		InitCommand=cmd(xy,_screen.cx,_screen.cy+20;zoom,0.5;);
	--	ComboChangedMessageCommand=cmd(settext,customscore);
	--	Text=customscore;
		JudgmentMessageCommand=function(self, param)
			self:settext(param.TapNoteScore);
		end;
	};
};
return t
