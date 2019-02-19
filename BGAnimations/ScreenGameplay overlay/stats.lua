local player = ...
---assert(player, "You have to supply a player!");
local t = Def.ActorFrame {};

-- LIVE STATS CONTROLS
local labelalpha =	0.25		--alpha label value
local numberalpha =	0.5			--Global alpha numbers value
local lbhali =		center		--Labels  horizontal align
local lbvali =		middle		--Labels  vertical align
local nmhali =		center		--Numbers horizontal align
local nmvali =		middle		--Numbers verical align
local lbzoom =		0.4			--Global labels zoom
local nmzoom =		lbzoom		--Global numbers zoom

--Sorry
function gs(s)
	return THEME:GetString("JudgmentLine",s)
end
local jllist = {gs("W1"),gs("W2"),gs("W3"),gs("W4"),gs("Miss")};	--judgement label list

if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" or GAMESTATE:GetCurrentStage() == "Stage_Demo" then
	jllist = {gs("W2"),gs("W3"),gs("W4"),gs("Miss")};	--judgement label list for easy
end
local numLabels = #jllist

local LSXoff = 5*(45/numLabels) --Spacing between numbers

--
local nmxoff =		0						--Number X offset (from W values)
local nmyoff =		11						--Number Y offset (from W values)
local lbfon =		"Common normal"			--Live stats labels font
local nbfon =		"Common normal"			--Live stats numbers font
--

--


local p1stats =		STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
for i = 1,#jllist,1 do
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,LSXoff*(i-1)-LSXoff*(numLabels-1)/2);
		OnCommand=function(self)
			if p1stype == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() ~= player then
				self:visible(false)
			end;
		end;
		LoadFont(lbfon)..{	--LABELS P1
			InitCommand=cmd(vertalign,lbvali;zoom,lbzoom;diffusealpha,labelalpha;);
			OnCommand=function(self)
				self:settext(jllist[i]);
			end;
		};
		LoadFont(nbfon)..{	--NUMBERS P1
			InitCommand=cmd(vertalign,nmvali;addy,nmyoff;zoom,nmzoom;diffusealpha,numberalpha;);
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
				
				self:settext(p1stlist[i]);
			end;
		};
	};
end;


t[#t+1] = Def.ActorFrame{		-- DEBUG STUFF
	Condition=DoDebug;		--Don't show anything on this group if not executing Debug Mode
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
