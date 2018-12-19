local t = Def.ActorFrame {
	OffCommand=function()
		setenv("StageFailed",false);
	end;
};
t[#t+1] = LoadActor("AR Results")..{OnCommand=cmd(play)};	--Music


t[#t+1] = LoadActor("Music (loop)")..{						--The original coder made the music loop a stupid way, when you could literally just put (loop) in the filename.
		OnCommand=cmd(sleep,4;queuecommand,"PlaySound");	--Are you fucking serious? Come on, it's literally the easiest thing in the world to make music loop.
		PlaySoundCommand=cmd(play);
		OffCommand=cmd(stop)
	};
	--BACKGROUND
	t[#t+1] = LoadActor(THEME:GetPathG("","_BGMovies/dancegrade"))..{
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


t[#t+1] = LoadActor("unlocks.lua");								--Unlock system

--this is the dim for the numbers, it's kind of confusing right now since the numbers and bg is separated
local listcount = (PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never") and 8 or 9;
for i = 1,listcount do
	local initsleeps = {}
    for n=0,listcount do
      initsleeps[n] = 1.7+(0.15*n)
    end
	t[#t+1] = Def.Quad {
		InitCommand=cmd(xy,_screen.cx,100+(i*25)+2;diffuse,0,0,0,0;);
		OnCommand=cmd(sleep,initsleeps[i];accelerate,0.1;diffuse,0,0,0,0.55;zoomto,SCREEN_WIDTH,22;);
	};
end;
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = LoadActor("DanceGrade",pn);
end;

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

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	NumHeartsLeft[pn] = NumHeartsLeft[pn]-GetNumHeartsForSong()
	if GAMESTATE:GetNumStagesLeft(pn) <= 0 and NumHeartsLeft[pn] > 0 then
		GAMESTATE:AddStageToPlayer(pn) --Hack to make sure SM5 doesn't think there are no stages left
	end;
end;

t[#t+1] = LoadActor(THEME:GetPathG("","USB_stuff"))..{};

return t;
