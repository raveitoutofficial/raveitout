local t = Def.ActorFrame{};

--======================
-- HELPER FUNCTIONS
--======================

local function GetTagValue(readfile,tag)
	local fnd = string.find(readfile , "#"..tag..":")
	if not fnd then return nil end
	local last = string.find(readfile , ";" , fnd)
	local found = string.sub(readfile,fnd,last)
	found = string.gsub(found, "\r", "")
	found = string.gsub(found, "\n", "")
	found = string.gsub(found,  "#"..tag..":", "")
	found = string.gsub(found, ";", "")
	return found
end;

--To generate shapes
function parallelogramGen(width,height,clr)
	return Def.ActorFrame{
		Def.Quad{
			InitCommand=cmd(setsize,width-height,height;diffuse,clr);
		};
		Def.ActorMultiVertex{
			InitCommand=function(self)
				self:xy((width-height)/2,-height/2);
				self:SetDrawState{Mode="DrawMode_Triangles"}
				self:SetVertices({
					{{0, 0, 0}, clr},
					{{height, 0, 0}, clr},
					{{0, height, 0}, clr}
			
				});
			end;
		};
		Def.ActorMultiVertex{
			InitCommand=function(self)
				self:xy(-(width+height)/2,-height/2);
				self:SetDrawState{Mode="DrawMode_Triangles"}
				self:SetVertices({
					{{height, height, 0}, clr},
					{{0, height, 0}, clr},
					{{height, 0, 0}, clr}
				});
			end;
		};

	};
end

function rectGen(width, height, lineSize, bgColor)
    return Def.ActorFrame{
    
        --Background transparency
        Def.Quad{
            InitCommand=cmd(setsize,width, height;diffuse,bgColor);
            
        };
        --Bottom line
        Def.Quad{
            InitCommand=cmd(setsize,width + lineSize, lineSize;addy,height/2;--[[horizalign,0;vertalign,2]]);
            
        };
        --Top line
        Def.Quad{
            InitCommand=cmd(setsize,width + lineSize, lineSize;addy,-height/2;--[[horizalign,2;vertalign,0]]); --2 = right aligned
            
        };
        --Left line
        Def.Quad{
            InitCommand=cmd(setsize,lineSize, height + lineSize;addx,-width/2;--[[vertalign,0;horizalign,2]]); --2 = right aligned
            
        };
        --Right line
        Def.Quad{
            InitCommand=cmd(setsize,lineSize, height + lineSize;addx,width/2;--[[vertalign,2;horizalign,0]]); --2 = bottom aligned
            
        };
    };
end;

local function CanSafelyEnterGameplayCourse()
	for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
		if GAMESTATE:GetCurrentTrail(pn) == nil and GAMESTATE:IsPlayerEnabled(pn) then
			return false,"Trail for "..pname(pn).." was not set.";
		end
	end;
	if not GAMESTATE:GetCurrentCourse() then
		return false,"No course was set."
	end;
	if GAMESTATE:GetCurrentSong() then
		return false,"There is a song set in GAMESTATE."
	end;
	if not GAMESTATE:IsCourseMode() then
		return false,"The IsCourseMode flag was not set."
	end;
	return true
end


--Hackjob for now, fix this later.
GAMESTATE:SetCurrentSong(nil);
for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
	GAMESTATE:SetCurrentStyle("Single");
	GAMESTATE:GetPlayerState(pn):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin("delta-note")
	GAMESTATE:ApplyPreferredSongOptionsToOtherLevels()
end;

--1 indexed, because lua.
local currentMissionNum;
local currentGroupNum = 1;
local NUM_MISSION_GROUPS = #RIO_COURSE_GROUPS[QUESTMODE.currentWorld]
--Needs to be defined up here
local GroupCache = {};

function setCurrentCourse()
	local course = GroupCache.courses[currentMissionNum]
	GAMESTATE:SetCurrentCourse(course);
	--SCREENMAN:SystemMessage(#course:GetAllTrails())
	local trail;
	if GroupCache.courseRequirements[currentMissionNum].style then
		trail = course:GetTrails(GroupCache.courseRequirements[currentMissionNum].style)[1];
	else
		trail = course:GetAllTrails()[1]
	end;
	if trail then
		for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
			GAMESTATE:SetCurrentTrail(pn, trail)
			--GAMESTATE:SetCurrentSteps(pn, trail:GetTrailEntry(0):GetSteps());
		end;
	else
		SCREENMAN:SystemMessage("Trail was nil! Number of trails: "..#course:GetAllTrails().. " | Course: "..course:GetDisplayFullTitle());
	end;
	
	QUESTMODE.CurMissionRequirements = {
		minGrade = GroupCache.courseRequirements[currentMissionNum].minGrade,
		minCombo = GroupCache.courseRequirements[currentMissionNum].minCombo,
		minAccuracy = GroupCache.courseRequirements[currentMissionNum].minAccuracy,
		maxBreak = GroupCache.courseRequirements[currentMissionNum].maxBreak
	};
	--setenv("BreakCombo",GroupCache.courseRequirements[currentMissionNum].limitBreak or THEME:GetMetric("CustomRIO","MissToBreak"));
end

function updateGroupCache()
	GroupCache.currentGroup = RIO_COURSE_GROUPS[QUESTMODE.currentWorld][currentGroupNum];
	--Clear courses from the table.
	GroupCache.courses = {}
	GroupCache.courseRequirements = {};
	for course in ivalues(SONGMAN:GetCoursesInGroup(GroupCache.currentGroup,false)) do
		--assert(course,"Hey idiot, don't give an invalid course");
		local readfile = File.Read( course:GetCourseDir() )
		local missionNum = GetTagValue(readfile,"MISSIONID")
		if missionNum and missionNum ~= "" then
			missionNum = tonumber(missionNum)
			GroupCache.courses[missionNum] = course
		else
			lua.ReportScriptError("Course "..course:GetDisplayFullTitle().. " doesn't have a #MISSIONID tag.")
		end;
		
		
		local style = nil
		if GetTagValue(readfile,"STYLE") == "DOUBLE" then --God I fucking hate the course parser in stepmania
			style = "StepsType_Pump_Double"
		end;
		GroupCache.courseRequirements[missionNum] = {
			minGrade = GetTagValue(readfile,"MINGRADE"),
			minCombo = GetTagValue(readfile,"MINCOMBO"),
			minAccuracy = GetTagValue(readfile,"MINACCURACY"),
			maxBreak = GetTagValue(readfile,"MAXBREAK"),
			
			style = style --This shouldn't be here but fuck it I'm not restructuring the tables
			--limitBreak = GetTagValue(readfile,"LIMITBREAK") --limit break is fucking dumb anyway just use #LIFE for missions
		}
		
	end
	GroupCache.numCourses = #GroupCache.courses;
	assert(GroupCache.numCourses > 0,"GroupCache did not generate corrrectly. Course folder '"..GroupCache.currentGroup.."' either has no valid songs or doesn't exist.");
	--Reset the mission num when switching groups.
	currentMissionNum = 1;
	setCurrentCourse();
	MESSAGEMAN:Broadcast("CurrentMissionGroupChanged");
end;
updateGroupCache();


--======================
-- FRAMES
--======================

--This is a bunch of math to make sure it fits in 4:3

--SCREENMAN:SystemMessage(GetScreenAspectRatio())
local scale_factor;
if IsUsingWideScreen() then
	scale_factor = 1;
else
	scale_factor = .86;
end;

--Should be 300 for 16:9
local LEFT_WIDTH = 300*scale_factor;
--Should be 160 for 4:3, 200 for 16:9 (or higher?)
local LEFT_X_POS = LEFT_WIDTH/2+(IsUsingWideScreen() and 60 or 10);
local RIGHT_X_POS = LEFT_X_POS+LEFT_WIDTH/2+10;
--Default is 410.
local RIGHT_WIDTH = 410*scale_factor;
local REQUIREMENTS_WIDTH = RIGHT_WIDTH*.95;

t[#t+1] = Def.ActorFrame{
	--Header stuff
	LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/current_group"))..{
		InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP+5;horizalign,left;vertalign,top;zoomx,1;cropbottom,0.3);
	};
	LoadFont("monsterrat/_montserrat light 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+18;y,SCREEN_TOP+10;zoom,0.185;skewx,-0.1);
		OnCommand=function(self)
			self:uppercase(true);
			self:settext("QUEST MODE");
		end;
	};
	LoadFont("monsterrat/_montserrat semi bold 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+16;y,SCREEN_TOP+30;zoom,0.6;skewx,-0.255);
		OnCommand=function(self)
			self:uppercase(true);
			self:settext("SELECT A MISSION");
		end;
	};
	
	--TIME
	--[[LoadFont("monsterrat/_montserrat light 60px")..{
			Text="TIME";
			InitCommand=cmd(x,SCREEN_CENTER_X-25;y,SCREEN_BOTTOM-92;zoom,0.6;skewx,-0.2);
	};]]
	
	Def.Quad{
		InitCommand=cmd(diffuse,color("0,0,0,.5");setsize,LEFT_WIDTH,50;xy,LEFT_X_POS,90;);
	};
	LoadFont("facu/_zona pro bold 40px")..{
		Text="Mission Group Name Goes here";
		InitCommand=cmd(xy,LEFT_X_POS,90;zoom,.75;skewx,-0.255;maxwidth,LEFT_WIDTH*1.25;);
		OnCommand=function(self)
			
			self:settext(string.match(GroupCache.currentGroup," %- (.*)"));
		end;
		CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"On");
	
	};
	Def.Quad{
		InitCommand=cmd(diffuse,color("0,0,0,.5");setsize,120,20;xy,RIGHT_X_POS,90-50/2;horizalign,left;vertalign,top;);
	};
	Def.ActorMultiVertex{
		InitCommand=function(self)
			self:xy(RIGHT_X_POS+120,90-50/2);
			self:SetDrawState{Mode="DrawMode_Triangles"}
            self:SetVertices({
                {{0, 0, 0}, color("0,0,0,.5")},
        		{{0, 20, 0}, color("0,0,0,.5")},
				{{20, 0, 0}, color("0,0,0,.5")}
            });
        end;
	};
	--[[LoadFont("Common Normal")..{
		Condition=RIO_COURSE_GROUPS[currentGroupNum+1];
		Text=RIO_COURSE_GROUPS[currentGroupNum+1];
		InitCommand=cmd(xy,200+160,90-50/2;horizalign,left;vertalign,top;maxwidth,120);
	};]]
	
	--Mission 2...
	parallelogramGen(130,20,color("0,0,0,.5"))..{
		InitCommand=cmd(xy,560,90-50/2+20/2;);
	};
	--Mission 3..
	parallelogramGen(130,20,color("0,0,0,.5"))..{
		InitCommand=cmd(xy,560+130+5,90-50/2+20/2;);
	};
	

	--Mission info..
	Def.Quad{
		InitCommand=cmd(setsize,RIGHT_WIDTH,300;diffuse,color("0,0,0,.5");xy,RIGHT_X_POS,100;horizalign,left;vertalign,top;);
	};
	--Mission title
	LoadFont("monsterrat/_montserrat semi bold 60px")..{	
		InitCommand=cmd(xy,RIGHT_X_POS+RIGHT_WIDTH/2,110;vertalign,top;zoom,0.6;skewx,-0.255;maxwidth,RIGHT_WIDTH+120);
		--Text="aaaaaaaaaaaaaaaaaaaaaaaaaaaa";
		OnCommand=cmd(settext,GroupCache.courses[currentMissionNum]:GetDisplayFullTitle();stoptweening;diffusealpha,0;x,RIGHT_X_POS+RIGHT_WIDTH/2+75;decelerate,0.5;x,RIGHT_X_POS+RIGHT_WIDTH/2;diffusealpha,1;);
		CurrentCourseChangedMessageCommand=cmd(playcommand,"On");
		CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"On");
	};
	--Title underline
	Def.Quad{
		InitCommand=cmd(setsize,RIGHT_WIDTH,2;diffuse,color("1,1,1,1");xy,RIGHT_X_POS,140;horizalign,left;vertalign,top;fadeleft,.8;faderight,.8;);
	};
	--Mission requirements
	--[[Def.Sprite{
		Texture=THEME:GetPathG("QuestMode","MissionRequirements");
		InitCommand=cmd(Resize,SCREEN_WIDTH,SCREEN_HEIGHT;Center);
	};]]
	Def.ActorFrame{
		CurrentCourseChangedMessageCommand=function(self)
			local r = QUESTMODE.CurMissionRequirements;
			if r.maxBreak then
				self:GetChild("BreakText"):settext(r.maxBreak):visible(true);
				self:GetChild("BreakBG"):diffusealpha(1);
			else
				self:GetChild("BreakText"):visible(false);
				self:GetChild("BreakBG"):diffusealpha(.5);
			end;
			
			if r.minCombo then
				self:GetChild("ComboText"):settext(r.minCombo):visible(true);
				self:GetChild("ComboBG"):diffusealpha(1);
			else
				self:GetChild("ComboText"):visible(false);
				self:GetChild("ComboBG"):diffusealpha(.5);
			end;
			
			if r.minGrade then
				self:GetChild("GradeText"):Load(THEME:GetPathG("","GradeDisplayEval/"..r.minGrade)):visible(true);
				self:GetChild("GradeBG"):diffusealpha(1);
			else
				self:GetChild("GradeText"):visible(false);
				self:GetChild("GradeBG"):diffusealpha(.5);
			end;
			
			if r.minAccuracy then
				self:GetChild("AccuracyText"):settext(r.minAccuracy.."%"):visible(true);
				self:GetChild("AccuracyBG"):diffusealpha(1);
			else
				self:GetChild("AccuracyText"):visible(false);
				self:GetChild("AccuracyBG"):diffusealpha(.5);
			end;
			
		end;
	
		InitCommand=cmd(xy,RIGHT_X_POS+RIGHT_WIDTH/2,110+220;);
		--Debug helpers.
		--[[Def.Quad{
			InitCommand=cmd(x,-REQUIREMENTS_WIDTH/2;setsize,REQUIREMENTS_WIDTH/4,100;diffuse,Color("Red");horizalign,left);
		};
		Def.Quad{
			InitCommand=cmd(x,-REQUIREMENTS_WIDTH/4;setsize,REQUIREMENTS_WIDTH/4,100;diffuse,Color("Blue");horizalign,left);
		};
		Def.Quad{
			InitCommand=cmd(setsize,REQUIREMENTS_WIDTH/4,100;diffuse,Color("Red");horizalign,left);
		};
		Def.Quad{
			InitCommand=cmd(x,REQUIREMENTS_WIDTH/4;setsize,REQUIREMENTS_WIDTH/4,100;diffuse,Color("Blue");horizalign,left);
		};]]
		
		Def.Sprite{
			Name="MissionBG";
			Texture=THEME:GetPathG("QuestMode","MissionBG");
			InitCommand=cmd(zoom,.67;zoomtowidth,RIGHT_WIDTH-10);
			--InitCommand=cmd(zoomy,.2;zoomx,.46;diffusealpha,.5);
		};
		--left
		Def.Sprite{
			Name="BreakBG";
			Texture=THEME:GetPathG("QuestMode","BreakRequirement");
			InitCommand=cmd(zoom,.67;addx,(-REQUIREMENTS_WIDTH)/2+REQUIREMENTS_WIDTH/8);
		};
		LoadFont("monsterrat/_montserrat light 60px")..{
			Name="BreakText";
			--(SCREEN_WIDTH/numChoices*i-SCREEN_WIDTH/numChoices/2)
			InitCommand=cmd(zoom,.5;addy,-5;addx,(-REQUIREMENTS_WIDTH)/2+REQUIREMENTS_WIDTH/8;maxwidth,130);
			OnCommand=function(self)
				--self:uppercase(true);
				self:settext("123");
			end;
		};
		
		--Left
		Def.Sprite{
			Name="ComboBG";
			Texture=THEME:GetPathG("QuestMode","ComboRequirement");
			InitCommand=cmd(zoom,.67;addx,-REQUIREMENTS_WIDTH/8);
		};
		LoadFont("monsterrat/_montserrat light 60px")..{
			Name="ComboText";
			InitCommand=cmd(zoom,.5;addy,-5;addx,-REQUIREMENTS_WIDTH/8;maxwidth,130);
			OnCommand=function(self)
				--self:uppercase(true);
				self:settext("456");
			end;
		};
		
		Def.Sprite{
			Name="AccuracyBG";
			Texture=THEME:GetPathG("QuestMode","AccuracyRequirement");
			InitCommand=cmd(zoom,.67;addx,REQUIREMENTS_WIDTH/8);
		};
		LoadFont("monsterrat/_montserrat light 60px")..{
			Name="AccuracyText";
			InitCommand=cmd(zoom,.5;addy,-5;addx,REQUIREMENTS_WIDTH/8;maxwidth,130);
			OnCommand=function(self)
				self:settext("15%");
			end;
		};
		--Left
			Def.Sprite{
			Name="GradeBG";
			Texture=THEME:GetPathG("QuestMode","GradeRequirement");
			InitCommand=cmd(zoom,.67;addx,REQUIREMENTS_WIDTH/4+REQUIREMENTS_WIDTH/8);
		};
		Def.Sprite{
			Name="GradeText";
			Texture=THEME:GetPathG("","GradeDisplayEval/B");
			--The grade icons are 2px off for whatever dumb reason
			InitCommand=cmd(zoom,.25;addy,-5;addx,REQUIREMENTS_WIDTH/4+REQUIREMENTS_WIDTH/8);
		};
	};
	
	
	--Mission description, if there is one
	LoadFont("facu/_zona pro bold 40px")..{
		Text="Mission Description Goes Here";
		InitCommand=cmd(xy,RIGHT_X_POS+RIGHT_WIDTH/2,288;vertalign,bottom;maxwidth,RIGHT_WIDTH*1.8;skewx,-0.255;zoom,.5);
		OnCommand=cmd(settext,GroupCache.courses[currentMissionNum]:GetDescription();stoptweening;diffusealpha,0;decelerate,.2;diffusealpha,1;);
		CurrentCourseChangedMessageCommand=cmd(playcommand,"On");
	};

	--[[Def.Quad{
		InitCommand=cmd(setsize,410,80;diffuse,color("1,1,1,.2");xy,200+160,150;horizalign,left;vertalign,top;);
	};]]
	
	Def.Quad{
		InitCommand=cmd(diffuse,color("1,1,1,.5");setsize,LEFT_WIDTH,35;xy,LEFT_X_POS,135;);
		CodeMessageCommand=function(self, params)
			if params.Name == "UpLeft" then
				if currentGroupNum > 1 then
					currentGroupNum = currentGroupNum-1;
					updateGroupCache();
					SOUND:PlayOnce(THEME:GetPathS("","iidx/syssd_sub_opt"),true);
				end;
			elseif params.Name== "UpRight" then
				if currentGroupNum < NUM_MISSION_GROUPS then
					currentGroupNum = currentGroupNum+1;
					updateGroupCache();
					SOUND:PlayOnce(THEME:GetPathS("","iidx/syssd_sub_opt"),true);
				end;
			elseif params.Name == "DownLeft" then
				if currentMissionNum > 1 then
					currentMissionNum = currentMissionNum -1;
					setCurrentCourse()
					MESSAGEMAN:Broadcast("CurrentCourseChanged")
					self:stoptweening():decelerate(.2):y(135+35*(currentMissionNum-1));
					SOUND:PlayOnce(THEME:GetPathS("MusicWheel","change"),true);
				end;
			elseif params.Name == "DownRight" then
				if currentMissionNum < GroupCache.numCourses then
					currentMissionNum = currentMissionNum + 1;
					setCurrentCourse()
					MESSAGEMAN:Broadcast("CurrentCourseChanged")
					self:stoptweening():decelerate(.2):y(135+35*(currentMissionNum-1));
					SOUND:PlayOnce(THEME:GetPathS("MusicWheel","change"),true);
				end;
			elseif params.Name == "Center" then
				local can, reason = CanSafelyEnterGameplayCourse()
				if can then
					SOUND:PlayOnce(THEME:GetPathS("","ready/offcommand"));
					GAMESTATE:prepare_song_for_gameplay();
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
				else
					lua.ReportScriptError("Cannot enter gameplay: "..reason);
				end
			elseif params.name == "OpenOpList" or params.Name == "OpenOpList2" then
				SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber);
			elseif params.Name == "Back" then
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen")
			end;
		end;
		CurrentMissionGroupChangedMessageCommand=cmd(stoptweening;decelerate,.2;xy,LEFT_X_POS,135;);
	};
};



--I don't think this is correct
local q = Def.ActorFrame{
	InitCommand=cmd(xy,LEFT_X_POS-LEFT_WIDTH/2+20,100);
};
for i = 1,6 do
	q[i] = Def.ActorFrame{
		InitCommand=cmd(addy,35*i);
		Def.Quad{
			InitCommand=cmd(diffuse,color(".5,.5,.5,.5");setsize,30,30);
		};
		Def.Sprite{
			Texture=THEME:GetPathG("","medal_gold");
			InitCommand=cmd(zoom,.15;addx,-40;);
			OnCommand=cmd(playcommand,"Update");
			CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"Update");
			UpdateCommand=function(self)
				self:stoptweening():diffusealpha(0);
				--self:sleep(i*.05):decelerate(.2):diffusealpha(1);
				if i <= GroupCache.numCourses and QUESTMODE[GAMESTATE:GetMasterPlayerNumber()][QUESTMODE.currentWorld][GroupCache.courses[i]:GetDisplayFullTitle()] then
					self:sleep(i*.05):decelerate(.2):diffusealpha(1);
				end;
			end;
		
		};
		LoadFont("_roboto Bold 54px")..{
			Text=i;
			InitCommand=cmd(zoom,.6;addy,3);
		};
		LoadFont("letters/_ek mukta Bold 24px")..{
			Text="Mission title goes here";
			InitCommand=cmd(horizalign,left;x,20;addy,2;maxwidth,LEFT_WIDTH-40);
			OnCommand=function(self)
				self:stoptweening():diffusealpha(0);
				if i <= GroupCache.numCourses then
					self:settext(GroupCache.courses[i]:GetDisplayFullTitle());
				else
					self:settext("");
				end;
				self:sleep(i*.05):decelerate(.2):diffusealpha(1);
			end;
			CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"On");
		};
	};
end;
t[#t+1] = q;

local j = Def.ActorFrame{
	InitCommand=cmd(xy,RIGHT_X_POS+15,130;);
};
--I don't expect there to be more than 4 songs.
for i = 1,4 do
	j[i] = Def.ActorFrame{
		InitCommand=cmd(addy,30*i;);
		SetCommand=function(self)
			self:stoptweening():diffusealpha(0);
			local trailEntries = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber()):GetTrailEntries();
			local hasRandomEntries = not GAMESTATE:GetCurrentCourse():AllSongsAreFixed();
			if i <= #trailEntries then
				if hasRandomEntries then
					self:GetChild("SongName"):settext("???");
				else
					self:GetChild("SongName"):settext(trailEntries[i]:GetSong():GetDisplayFullTitle());
				end;
				
				local steps = trailEntries[i]:GetSteps()
				local meter = steps:GetMeter();
				if meter >= 99 then
					self:GetChild("Label"):settext("??");
				else
					self:GetChild("Label"):settextf("%02d",meter);
				end;
				
				local StepsType = steps:GetStepsType();
				local labelBG = self:GetChild("LabelBG");
				if StepsType then
					sString = THEME:GetString("StepsDisplay StepsType",ToEnumShortString(StepsType));
					if sString == "Single" then
						--There is no way to designate a single trail as DANGER, unfortunately.
						if meter >= 99 then
							labelBG:setstate(4);
						else
							labelBG:setstate(0);
						end
					elseif sString == "Double" then
						labelBG:setstate(1);
					elseif sString == "SinglePerformance" or sString == "Half-Double" then
						labelBG:setstate(2);
					elseif sString == "DoublePerformance" or sString == "Routine" then
						labelBG:setstate(3);	
					else
						labelBG:setstate(5);
					end;
				end;
				
				self:sleep(.05*i):decelerate(.2):diffusealpha(1);
			else
				--Do nothing.
			end;
		end;
		OnCommand=cmd(playcommand,"Set");
		CurrentCourseChangedMessageCommand=cmd(playcommand,"Set");
		CurrentMissionGroupChangedMessageCommand=cmd(playcommand,"Set");
		
		LoadActor(THEME:GetPathG("StepsDisplayListRow","frame/_icon"))..{
			Name="LabelBG";
			InitCommand=cmd(zoom,0.3;addy,2;animate,false);--draworder,140;);
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			Name="Label";
			InitCommand=cmd(zoom,0.25;skewx,-0.15;y,0.5);
		};
		-- NEW LABEL
		--[[LoadActor(THEME:GetPathG("StepsDisplayListRow","frame/danger"))..{
			InitCommand=cmd(zoom,0.5;y,22);
			OnCommand=cmd(diffuseshift; effectoffset,1; effectperiod, 0.5; effectcolor1, 1,1,0,1; effectcolor2, 1,1,1,1;);
			SetMessageCommand=function(self,param)
				profile = PROFILEMAN:GetMachineProfile();
				scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),param.Steps);
				scores = scorelist:GetHighScores();
				topscore = scores[1];
				
				local descrp = param.Steps:GetDescription();

				if descrp == "DANGER!" then
					self:visible(true);
				else
					self:visible(false);
				end;
			
			end;
		};]]
		LoadFont("facu/_zona pro bold 40px")..{
			Name="SongName";
			Text="Song names here";
			InitCommand=cmd(horizalign,left;zoom,.5;addx,15;maxwidth,RIGHT_WIDTH+120);

		};
	};
end;
t[#t+1] = j;

t[#t+1] = LoadActor(THEME:GetPathB("","ProfileBanner"));

--OpList
t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/OptionsList"));

return t;
