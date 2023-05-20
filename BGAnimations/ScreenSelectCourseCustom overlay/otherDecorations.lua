local t = Def.ActorFrame {
	InitCommand=function(self)
		state = 1;
	end
};

--HAS THIS GUY EVER HEARD OF METRICS???
-- Chart info helpers
local infy =		160					--Chart info Y axis position (both players, includes black quad alt)
local infx =		0					--Chart info X DIFFERENCE FROM DISC
--quad stuff
local infft =		0.125*0.75			--Chart info quad fade top
local inffb =		infft				--Chart info quad fade bottom
local redu =		0					--Chart info vertical reduction value for black quad (pixels)
local bqwid =		_screen.cx			--Chart info quad width
local bqalt =		244-20				--Chart info black quad height
local bqalph =		0.9					--Chart info black quad diffusealpha value
local wqwid =		_screen.cx			--

local npsxz =	_screen.cx*0.5		--next/previous song X zoom
local npsyz =	_screen.cy --*0.75	--next/previous song Y zoom
--
--local css1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
--local css2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
local newranktext = "NEW CHALLENGER"	--text replacing #P1# when someone does a new record
local bpmalt = 	_screen.cy+55			--Y value for BPM Display below banner

	if IsUsingWideScreen() then
		defaultzoom = 0.8;
		else
		defaultzoom = 0.65;
	end;


---DECORATIONS IN GENERAL
t[#t+1] = Def.ActorFrame {
	--MSG INFO
	LoadActor(THEME:GetPathB("ScreenSelectMusic" ,"overlay/help_info/txt_box"))..{
		InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-50;zoomx,0.9;zoomy,0.65);
	};
	
	Def.Sprite{
		--Yeah I dunno why I have to specify the full path
		Texture=THEME:GetPathB("ScreenSelectMusic","overlay/help_info/messages 1x4.png");
		InitCommand=function(self)
			(cmd(x,_screen.cx;y,SCREEN_BOTTOM-50;zoom,.6;animate,false;setstate,0))(self);
			if getenv("PlayMode") == "Easy" then
				self:Load(THEME:GetPathB("ScreenSelectMusic","overlay/help_info/easymessages 1x4.png"));
			end;
		end;
		OnCommand=cmd(queuecommand,"Set");
		SetCommand=function(self)
			--I know hard coding stuff is bad, but there will only ever be 4 states...
			--And also, hide the setlist prompt if we're in Special mode, since there are no folders
			--in special mode.
			if self:GetState()+1 >= 4 or (getenv("PlayMode") == "Special" and self:GetState() == 2) then
				self:setstate(0);
			else
				self:setstate(self:GetState()+1);
			end;
			self:linear(0.2);
			self:diffusealpha(1);
			self:sleep(2);
			self:linear(0.2)
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
		
		TwoPartConfirmCanceledMessageCommand=cmd(playcommand,"PickingSong");
		SongUnchosenMessageCommand=cmd(playcommand,"PickingSong");
		PickingSongCommand=cmd(stoptweening;linear,.2;diffusealpha,1;sleep,2;linear,.2;diffusealpha,0;queuecommand,"Set");
		SongChosenMessageCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
	};
	
	Def.Sprite{
		Texture=THEME:GetPathB("ScreenSelectMusic","overlay/help_info/difficulty_messages 1x4.png");
		InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-50;zoom,.6;animate,false;setstate,0;diffusealpha,0);
		SetCommand=function(self)
			--I know hard coding stuff is bad, but there will only ever be 4 states...
			--And also, hide the command window info if we're in Easy mode.
			if self:GetState()+1 >= 4 or (getenv("PlayMode") == "Easy" and self:GetState() == 2) then
				self:setstate(0);
			else
				self:setstate(self:GetState()+1);
			end;
			self:linear(0.2);
			self:diffusealpha(1);
			self:sleep(2);
			self:linear(0.2)
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
		TwoPartConfirmCanceledMessageCommand=cmd(playcommand,"PickingSong");
		SongUnchosenMessageCommand=cmd(playcommand,"PickingSong");
		PickingSongCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
		SongChosenMessageCommand=cmd(stoptweening;linear,.2;diffusealpha,1;sleep,2;linear,.2;diffusealpha,0;queuecommand,"Set");
	
	};
	
	--TIME
	LoadFont("monsterrat/_montserrat light 60px")..{
		Text="TIME";
		InitCommand=cmd(x,SCREEN_CENTER_X-25;y,SCREEN_BOTTOM-92;zoom,0.6;skewx,-0.2);
	};
 };
 
t[#t+1] = Def.ActorFrame{

	
	--[[LoadFont("Common normal")..{	--formatted stage display
		InitCommand=cmd(xy,_screen.cx,_screen.cy-190;zoomx,0.75;zoomy,0.65);
		Text=ToEnumShortString(GAMESTATE:GetCurrentStage()).." Stage";
	};]]
	--[[LoadFont("monsterrat/_montserrat semi bold 60px")..{
		InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT-16;y,SCREEN_TOP+23;zoom,0.6;skewx,-0.25;);
		Text=string.upper(ToEnumShortString(GAMESTATE:GetCurrentStage()).." Stage");
	};]]
	
	--Left side background
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT;y,_screen.cy+110;vertalign,middle,horizalign,right);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,SCREEN_CENTER_X);
		SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,SCREEN_LEFT;);
		Def.Quad{		--white quad for Difficulties
			InitCommand=cmd(horizalign,right;zoomto,_screen.cx,35;diffuse,1,1,1,0.75;x,0;y,-3;fadeleft,1;);
		};
		
		Def.Quad{		--Black quad for Chart info P1
			InitCommand=cmd(horizalign,right;fadetop,infft;fadebottom,inffb;xy,-infx,-infy+20;zoomto,bqwid*2,bqalt+50;diffuse,0,0,0,bqalph;);
			--InitCommand=cmd(diffuse,color("0,0,0,"..bqalph);xy,0,SCREEN_CENTER_Y;horizalign,right;setsize,bqwid*2,bqalt+50;);
		};
		LoadFont("bebas/_bebas neue bold 90px")..{
			Text="NOT PRESENT";
			Condition=not GAMESTATE:IsHumanPlayer(PLAYER_1);
			InitCommand=cmd(x,-_screen.cx*0.7;y,-infy;zoom,0.3;skewx,-0.2);
			--PlayerJoinedMessageCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_1));
		};
		Def.Sprite{
			Condition=GAMESTATE:IsHumanPlayer(PLAYER_1);
			Texture=THEME:GetPathB("ScreenSelectMusic","overlay/p1_info");		--PLAYER INFO
			InitCommand=cmd(zoomto,250,45;horizalign,left;xy,-SCREEN_CENTER_X,-_screen.cy);
		};
	};
	--Right side background
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_RIGHT;y,_screen.cy+110;vertalign,middle,horizalign,left);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,SCREEN_CENTER_X);
		SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,SCREEN_RIGHT;);
		Def.Quad{		--white quad for Difficulties
			InitCommand=cmd(horizalign,left;zoomto,_screen.cx,35;diffuse,1,1,1,0.75;x,0;y,-3;faderight,1;);
		};
		
		Def.Quad{		--Black quad for Chart info P1
			InitCommand=cmd(horizalign,left;fadetop,infft;fadebottom,inffb;xy,-infx,-infy+20;zoomto,bqwid*2,bqalt+50;diffuse,0,0,0,bqalph;);
			--InitCommand=cmd(diffuse,color("0,0,0,"..bqalph);xy,0,SCREEN_CENTER_Y;horizalign,right;setsize,bqwid*2,bqalt+50;);
		};
		LoadFont("bebas/_bebas neue bold 90px")..{
			Condition=not GAMESTATE:IsHumanPlayer(PLAYER_2);
			Text="NOT PRESENT";
			InitCommand=cmd(x,_screen.cx*0.7;y,-infy;zoom,0.3;skewx,-0.2);
			--PlayerJoinedMessageCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_2));
		};
		Def.Sprite{
			Condition=GAMESTATE:IsHumanPlayer(PLAYER_2);
			Texture=THEME:GetPathB("ScreenSelectMusic","overlay/p2_info");		--PLAYER INFO
			InitCommand=cmd(zoomto,250,45;horizalign,right;xy,SCREEN_CENTER_X,-_screen.cy);
		};
	};
	Def.Quad{		--White for Chart info P1 EFFECT JOINED
		InitCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2));
			(cmd(horizalign,right;fadetop,infft;fadebottom,inffb;x,-infx;y,-infy;
				 zoomto,bqwid,bqalt-redu;diffuse,1,1,1,0;blend,'BlendMode_Add';))(self)
		end;
		PlayerJoinedMessageCommand=function(self)
			(cmd(zoomy,(bqalt-redu)*1.25;diffuse,1,1,1,1;decelerate,0.75;zoomy,(bqalt-redu)*0.925;diffuse,1,1,1,0))(self)
		end;
	};
	Def.Quad{	--White for Chart info P2 EFFECT JOINED
		InitCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
			(cmd(horizalign,left;fadetop,infft;fadebottom,inffb;x,infx;y,-infy;
				 zoomto,bqwid,bqalt-redu;diffuse,1,1,1,0;blend,'BlendMode_Add';))(self)
		end;
		PlayerJoinedMessageCommand=function(self)
			(cmd(zoomy,(bqalt-redu)*1.25;diffuse,1,1,1,1;decelerate,0.75;zoomy,(bqalt-redu)*0.925;diffuse,1,1,1,0))(self)
		end;
	};
};

t[#t+1] = Def.ActorFrame{			
	LoadActor(THEME:GetPathB("ScreenSelectMusic" ,"overlay/judge_back"))..{		--This is my big surprise secret remodel lmfao -Gio
			InitCommand=cmd(zoom,0.35;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-124;diffusealpha,0);
			SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
			SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	};
	LoadFont("facu/_zona pro bold 40px")..{
		Text="MIXTAPE INFO";
		InitCommand=cmd(zoom,0.35;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-125;diffusealpha,0);
		SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
		SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	};
	
	--[[LoadActor(THEME:GetPathB("ScreenSelectMusic" ,"overlay/tab-speed"))..{		--Fancy, eh?
			InitCommand=cmd(zoom,0.35;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-70;diffusealpha,0);
			SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
			SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	};]]
	LoadActor(THEME:GetPathB("ScreenSelectMusic" ,"overlay/tab-score"))..{		--I hope people like it!
			InitCommand=cmd(zoom,0.35;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+20;diffusealpha,0);
			SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
			SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	};
}

local j = Def.ActorFrame{
	InitCommand=cmd(xy,SCREEN_CENTER_X,140;diffusealpha,0);
	SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
	SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	
};
--I don't expect there to be more than 4 songs.
local OBJECT_WIDTH = 300;
for i = 1,4 do
	j[i] = Def.ActorFrame{
		InitCommand=function(self)
			self:addy(30*(i-1));
			--[[if i < 3 then
				self:x(-OBJECT_WIDTH*.65);
			else
				self:x(OBJECT_WIDTH*.65);
			end;]]
		end;
		CurrentCourseChangedMessageCommand=function(self)
			self:stoptweening():diffusealpha(0);
			--if not GAMESTATE:GetCurrentCourse() then return end;
			local trailEntries = getenv("TrailCache"):GetTrailEntries();
			if i <= #trailEntries then
				self:GetChild("SongName"):settext(trailEntries[i]:GetSong():GetDisplayFullTitle());
				if true then
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
				end;
				self:diffusealpha(1);
			else
				--Do nothing.
			end;
		end;
		
		--[[Def.Quad{
			InitCommand=cmd(setsize,OBJECT_WIDTH,10);
		};]]
		
		LoadActor(THEME:GetPathG("StepsDisplayListRow","frame/_icon"))..{
			Name="LabelBG";
			InitCommand=cmd(zoom,0.3;addx,-OBJECT_WIDTH/2;addy,2;animate,false);--draworder,140;);
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			Name="Label";
			InitCommand=cmd(zoom,0.25;skewx,-0.15;addx,-OBJECT_WIDTH/2;y,0.5);
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
			InitCommand=cmd(horizalign,left;zoom,.5;addx,-OBJECT_WIDTH/2+15;maxwidth,OBJECT_WIDTH*2);

		};
	};
end;
t[#t+1] = j;

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
	local alignment = (pn == PLAYER_1) and right or left;
	local negativeOffset = (pn == PLAYER_1) and 1 or -1;
	local start = (pn == PLAYER_1) and SCREEN_LEFT or SCREEN_RIGHT;
	
	t[#t+1] = Def.ActorFrame{
		Condition=PROFILEMAN:IsPersistentProfile(pn); --Don't show scores for players without profiles. Or maybe MACHINE BEST could be shown instead?
		InitCommand=cmd(x,start;y,SCREEN_CENTER_Y+50;vertalign,middle,horizalign,alignment);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,SCREEN_CENTER_X);
		SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,start;);
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			Text="YOUR BEST:";
			InitCommand=cmd(x,-60*negativeOffset;y,-8;zoom,0.25;skewx,-0.25;horizalign,alignment;);
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{--Player Top Score (numbers)
			InitCommand=cmd(x,-60*negativeOffset;y,8;zoom,0.25;skewx,-0.25;horizalign,alignment;);
			SongChosenMessageCommand=cmd(queuecommand,"Set");
			SetCommand=function(self)
				-- ROAD24: and more checks
				-- TODO: decide what to do when no song is selected
				local cursong =	GAMESTATE:GetCurrentCourse()
				if cursong then
					profile = PROFILEMAN:GetProfile(pn);
					scorelist = profile:GetHighScoreList(cursong,GAMESTATE:GetCurrentTrail(pn));
					local scores = scorelist:GetHighScores();
					local topscore = scores[1];
					if topscore then
					--	if topscore >= stagemaxscore then		--temporary workaround
					--		pscore = stagemaxscore
					--	else
							pscore = topscore:GetScore();
					--	end
					else
						pscore = "0";
					end
					--local percen = tonumber(string.format("%.03f",((pscore/stagemaxscore)*100)));
					if topscore then
						--self:settext(pscore.." - "..percen.."%");
						self:settext(pscore);
					else
						self:settext("0");
					end;
				end;
			end;
		};
		
		Def.Sprite {
			InitCommand=cmd(x,-15*negativeOffset;zoom,0.15;horizalign,alignment;);
			SongChosenMessageCommand=cmd(queuecommand,"Set");
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentCourse();
				if song then
					self:diffusealpha(1);
					profile = PROFILEMAN:GetProfile(pn);
					scorelist = profile:GetHighScoreList(song,GAMESTATE:GetCurrentTrail(pn));
					assert(scorelist);
					local scores = scorelist:GetHighScores();
					local topscore = scores[1];
					
					if topscore then 
						local grade = getGradeFromScore(topscore)
						self:Load(THEME:GetPathG("","GradeDisplayEval/"..grade));
					else
						--if no score
						self:diffusealpha(0);
					end
				else
					--if no song
					self:diffusealpha(0);
				end;
			end;
		};
	};
end;

t[#t+1] = LoadActor(THEME:GetPathB("","ProfileBanner"))..{};

--[[t[#t+1] = LoadActor("ready")..{		-- 1 PLAYER JOINED READY
	InitCommand=cmd(visible,false;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoom,2;);
	WaitingConfirmMessageCommand=cmd(playcommand,"Ready";);
	StepsChosenMessageCommand=cmd(playcommand,"Ready";);
	ReadyCommand=function(self)
		if GAMESTATE:GetNumSidesJoined() == 1 and state > 1 then
			self:stoptweening();
			self:visible(false);
			self:zoom(1);
			self:linear(0.3);
			self:zoom(2);
			self:visible(true);
		end;
	end;
	CurrentSongChangedMessageCommand=cmd(visible,false);
	StepsUnchosenMessageCommand=cmd(visible,false);
	SongUnchosenMessageCommand=cmd(visible,false);
};]]


return t
