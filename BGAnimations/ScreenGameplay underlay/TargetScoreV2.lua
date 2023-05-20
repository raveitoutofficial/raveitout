--[[
The Simply Love target score is broken in RIO because DancePoints are
completely broken. So I had to write my own.
]]

-- nothing handled by this file applies to or should appear in Casual mode
if getenv("PlayMode") == "Easy" or getenv("PlayMode") == "Special" or GAMESTATE:GetMultiplayer() or GAMESTATE:GetCurrentStyle():GetStyleType() ~= 'StyleType_OnePlayerOneSide' then 
	return Def.ActorFrame{};
end;


local GRAPH_WIDTH = 200
local GRAPH_HEIGHT = 320

local player = ...
local pn = ToEnumShortString(player)
local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

 -- Finds the top score for the current song (or course) given a player.
local function GetTopScore(pn, kind)
	if not pn or not kind then return end

	local SongOrCourse, StepsOrTrail, scorelist

	if GAMESTATE:IsCourseMode() then
		SongOrCourse = GAMESTATE:GetCurrentCourse()
		StepsOrTrail = GAMESTATE:GetCurrentTrail(pn)
	else
		SongOrCourse = GAMESTATE:GetCurrentSong()
		StepsOrTrail = GAMESTATE:GetCurrentSteps(pn)
	end

	if kind == "Machine" then
		scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreList(SongOrCourse,StepsOrTrail)
	elseif kind == "Personal" then
		scorelist = PROFILEMAN:GetProfile(pn):GetHighScoreList(SongOrCourse,StepsOrTrail)
	end

	if scorelist then
		local topscore = scorelist:GetHighScores()[1]
		if topscore then return topscore:GetScore() end
	end

	return 0
end

local function GetNotefieldX(p)
	return CenterGameplayWidgets() and SCREEN_CENTER_X or THEME:GetMetric("ScreenGameplay","Player"..p.."OnePlayerOneSideX")
end;

local function GetOppositePlayerShort(p)
	if p==PLAYER_1 then
		return "P2"
	end;
	return "P1"
end;

local numStages = 1;
--Courses are always out of 100000000
if not GAMESTATE:IsCourseMode() then
	if GAMESTATE:GetCurrentSong():IsLong() then
		numStages = 2;
	elseif GAMESTATE:GetCurrentSong():IsMarathon() then
		numStages = 3;
	end;
end;
local stagemaxscore = 100000000*numStages -- GAMESTATE:GetNumStagesForCurrentSongAndStepsOrCourse() returns 3 no matter what... Must be broken


-- get personal best score
local pbGradeScore = GetTopScore(player, "Personal")
local machineBest = GetTopScore(player,"Machine");

local target_grade = {
	-- the index of the target score chosen in the PlayerOptions menu
	selection = ActiveModifiers[pn]["TargetScore"],
	-- the score the player is trying to achieve
	score = 0
}

if (target_grade.selection == 17) then
	-- player set TargetGrade as Machine best
	target_grade.score = GetTopScore(player, "Machine")

elseif (target_grade.selection == 18) then
	-- player set TargetGrade as Personal best
	target_grade.score = pbGradeScore
else
	-- player set TargetGrade as a percentage
	target_grade.score = target_grade.selection;
end

-- if there is no personal/machine score, default to 90% as target
if target_grade.score == 0 then
	target_grade.score = .9
end

local t = Def.ActorFrame{
	InitCommand=cmd(xy,GetNotefieldX(GetOppositePlayerShort(player)),SCREEN_CENTER_Y);
}

t[#t+1] = Def.Quad{
	InitCommand=cmd(setsize,GRAPH_WIDTH,GRAPH_HEIGHT;diffuse,Color.Black);
}


--It's flipped because the y axis draws from top to bottom.
local function percentToYCoordinate(percent)
	return GRAPH_HEIGHT/2-GRAPH_HEIGHT*percent

end;

-- adds alternating grey-black bars to represent each grade and sub-grade
-- (A-, A, A+, etc)
local percentsToDraw = {70,80,90,100}
for i=1,#percentsToDraw-1 do
	local tierStart = percentsToDraw[i]/100
	local tierEnd = (percentsToDraw[i+1])/100
	local yStart = percentToYCoordinate(tierStart)
	local yEnd = percentToYCoordinate(tierEnd)

	t[#t+1] = Def.Quad{
		InitCommand=function(self)
			self:valign(0)
				:zoomto(GRAPH_WIDTH, -yStart+yEnd)
				:xy( 0, yStart )
		end,
		OnCommand=function(self)
			if (i % 2 == 1) then
				self:diffuse(color("#FFFFFFbb"))
			else
				self:diffuse(color("#000000bb"))
			end
		end,
	}
end;
for i=1,#percentsToDraw do 
	t[#t+1] = Def.Quad{
		InitCommand=cmd(zoomto,GRAPH_WIDTH,1;y,percentToYCoordinate(percentsToDraw[i]/100));
	};
	t[#t+1] = Def.BitmapText{
		Font="venacti/_venacti_outline 26px bold monospace numbers",
		Text=(percentsToDraw[i]).."%",
		InitCommand=function(self)
			self:valign(1):halign(0)
				:xy( -GRAPH_WIDTH/2, percentToYCoordinate(percentsToDraw[i]/100)-2 )
			self:zoom(.5);
		end,
		-- zoom the label once we reach a grade, but only in 16:9
		GradeChangedCommand=function(self)
			if (bothWantBars and not IsUsingWideScreen()) then
				return
			end
		end,
	}
	
end;

--CURRENT SCORE (good luck lol)

local scoreBars = Def.ActorFrame{
	InitCommand=cmd(xy,-GRAPH_WIDTH/2,GRAPH_HEIGHT/2);
	-- any time we receive a judgment
	JudgmentMessageCommand=function(self,params)
		currentGrade = pss:GetGrade()

		-- this broadcasts a message to tell other actors that we have changed grade
		if (currentGrade ~= previousGrade) then
			if currentGrade ~= "Grade_Failed" then
				self:queuecommand("GradeChanged")
			end
			previousGrade = currentGrade
		end
		self:queuecommand("Update")
	end,
}

--[[
scoreBars[#scoreBars+1] = Def.Quad{
	InitCommand=cmd(zoomto,50,320;x,GRAPH_WIDTH*3/8;valign,1;croptop,1);
	UpdateCommand=function(self)
		self:croptop(.995-(pss:GetScore()/stagemaxscore))
	end;
}
scoreBars[#scoreBars+1] = Def.Quad{
	InitCommand=cmd(zoomto,50,320;x,GRAPH_WIDTH*5/8;valign,1;croptop,1);
	UpdateCommand=function(self)
		local mult = pbGradeScore/stagemaxscore
		if pbGradeScore==0 then
			mult = machineBest/stagemaxscore
		end;
		self:croptop(.995-pss:GetCurMaxScore()/stagemaxscore*mult)
	end;
}
scoreBars[#scoreBars+1] = Def.Quad{
	InitCommand=cmd(zoomto,50,320;x,GRAPH_WIDTH*7/8;valign,1;croptop,1);
	UpdateCommand=function(self)
		self:croptop(.995-pss:GetCurMaxScore()/stagemaxscore*target_grade.score)
	end;
}]]

scoreBars[#scoreBars+1] = LoadActor("PerPlayer/currentScore")..{
	InitCommand=cmd(zoomto,46,320;x,GRAPH_WIDTH*3/8;valign,1);
	OnCommand=function(self)
		self:croptop(1)
	end;
	UpdateCommand=function(self)
		self:croptop(1-(pss:GetScore()/stagemaxscore))
	end;
}
--scoreBars[#scoreBars+1] = LoadFont("

scoreBars[#scoreBars+1] = LoadActor("PerPlayer/personalBest")..{
	InitCommand=cmd(zoomto,46,320;x,GRAPH_WIDTH*5/8;valign,1;croptop,1);
	UpdateCommand=function(self)
		local mult = pbGradeScore/stagemaxscore
		if pbGradeScore==0 then
			mult = machineBest/stagemaxscore
		end;
		self:croptop(1-pss:GetCurMaxScore()/stagemaxscore*mult)
	end;
}


scoreBars[#scoreBars+1] = LoadActor("PerPlayer/targetImage")..{
	InitCommand=cmd(zoomto,46,320;x,GRAPH_WIDTH*7/8;valign,1);
	OnCommand=function(self)
		self:croptop(1)
	end;
	UpdateCommand=function(self)
		--local percent = GAMESTATE:GetSongPercent(GAMESTATE:GetSongBeat())
		local percent = pss:GetCurMaxScore()/stagemaxscore
		self:croptop(1-percent*target_grade.score)
		--local targetDP = target_grade.score * GetCurMaxPercentDancePoints()
		--self:croptop(1-
	end;
}

scoreBars[#scoreBars+1] = Def.ActorFrame{
	LoadFont("letters/_ek mukta Bold 24px")..{
		Text=THEME:GetString("TargetScoreGraph", "You"),
		InitCommand=function(self)
			self:xy( GRAPH_WIDTH*3/8, 8 ):vertalign(top):zoom(.75):maxwidth(50);
		end,
	},

	LoadFont("letters/_ek mukta Bold 24px")..{
		Text=THEME:GetString("TargetScoreGraph", "Personal"),
		InitCommand=function(self)
			if pbGradeScore == 0 then
				self:settext(THEME:GetString("TargetScoreGraph", "Machine"))
			end;
			self:xy( GRAPH_WIDTH*5/8, 8 ):vertalign(top):zoom(.75):maxwidth(55)
		end,
	},

	LoadFont("letters/_ek mukta Bold 24px")..{
		Text=THEME:GetString("TargetScoreGraph", "Target"),
		InitCommand=function(self)
			self:xy( GRAPH_WIDTH*7/8, 8 ):vertalign(top):zoom(.75):maxwidth(55);
		end,
	},
}

if DoDebug then
	scoreBars[#scoreBars+1] = LoadFont(DebugFont)..{
		Text="lmao";
		InitCommand=function(self)
			self:xy( GRAPH_WIDTH*3/8, -10 ):zoom(.5):valign(1);
		end;
		UpdateCommand=function(self)
			self:settext(string.format("%.02f",pss:GetScore()/stagemaxscore*100).."%")
		end;
	}
	scoreBars[#scoreBars+1] = LoadFont(DebugFont)..{
		Text=pbGradeScore;
		InitCommand=function(self)
			if pbGradeScore == 0 then
				self:settext(machineBest);
			end;
			self:xy( GRAPH_WIDTH*5/8, -10 ):zoom(.5):valign(1);
		end;
		UpdateCommand=function(self)
			local mult = pbGradeScore/stagemaxscore
			if pbGradeScore==0 then
				mult = machineBest/stagemaxscore
			end;
			--percent = percent*pss:GetCurMaxScore()/stagemaxscore
			self:settext(string.format("%.02f",pss:GetCurMaxScore()/stagemaxscore*100)..
			"%\n x "..string.format("%.02f",mult).." = "..
			"\n"..string.format("%.02f",pss:GetCurMaxScore()/stagemaxscore*mult*100).."%"
			)
			--self:settext(string.format("%.02f",percent*100).."%")
			--self:settext(pss:GetCurMaxScore());
			--self:settext(string.format("%.02f",pss:GetCurrentPossibleDancePoints()*100))
		end;
	}
	scoreBars[#scoreBars+1] = LoadFont(DebugFont)..{
		Text="lmao";
		InitCommand=function(self)
			self:xy( GRAPH_WIDTH*7/8, -10 ):zoom(.5):valign(1);
		end;
		OnCommand=function(self)
			local targetDP = target_grade.score
			self:settext(targetDP)
		end;
		UpdateCommand=function(self)
			local percent = pss:GetCurMaxScore()/stagemaxscore
			self:settext(string.format("%.02f",percent*100)..
			"%\n x "..target_grade.score.." = "..
			"\n"..string.format("%.02f",percent*target_grade.score*100).."%"
			)
		end;
	}
end;

scoreBars[#scoreBars+1] = Def.ActorFrame{
	InitCommand=cmd(diffusealpha,.8);
	--[[OnCommand=function(self)
		self:diffuse(Color.Red);
	end;]]
	UpdateCommand=function(self)
		local playerCurrentScore = pss:GetScore()
		local currentTargetScore = pss:GetCurMaxScore()*target_grade.score
		local percent = target_grade.score/stagemaxscore
		self:GetChild("num"):settextf("%04d",(playerCurrentScore-currentTargetScore)/10000)
		if playerCurrentScore<currentTargetScore then
			self:diffusebottomedge(Color.Red);
		else
			self:diffusebottomedge(Color.Blue);
		end;
	end;
	LoadFont("facu/_bebas neue 40px")..{
		Text="TARGET: ";
		OnCommand=cmd(valign,1;halign,1;xy,GRAPH_WIDTH-75,-5;zoom,.70;skewx,-.2);
	};
	LoadFont("_roboto Bold 54px")..{
		Text="-1235";
		Name="num";
		OnCommand=cmd(valign,1;halign,1;xy,GRAPH_WIDTH-5,-5;zoom,.5);
		--[[UpdateCommand=function(self)
			self:settextf("%04d",math.random(4000))
		end;]]
	};
}

t[#t+1]=scoreBars;

return t;
