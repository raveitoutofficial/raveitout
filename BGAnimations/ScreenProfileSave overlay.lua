local t = Def.ActorFrame{
	LoadFont("Common Normal")..{
		Text=ScreenString("Saving Profiles");
		InitCommand=cmd(xy,_screen.cx,_screen.h+30;diffuse,color("1,1,1,1");shadowlength,1);
		OffCommand=cmd(linear,0.15;diffusealpha,0);
	};
};

--NEXT STAGE
local curstage = GAMESTATE:GetCurrentStage()

local delay_time = {
	Stage_Extra1 = 9;
	Stage_1st = 8;
	Stage_2nd = 8;
	Stage_3rd = 7;
	Stage_4th = 10;
	Stage_5th = 10;
	Stage_6th = 10;
	Stage_Final = 9;
};

local NextStageSleepTime = delay_time[curstage];
local WallpaperSleepTime = 5;
local bg = THEME:GetPathG("","_BGMovies/nextstage_"..curstage);
local sound = THEME:GetPathS("","nextstage_"..curstage)

if curstage == 'Stage_Event' then
	ran_nst = {"Stage_2nd","Stage_3rd","Stage_4th"};
	random_name = ran_nst[math.random(1,#ran_nst)]
	bg = THEME:GetPathG("","_BGMovies/nextstage_"..random_name);
	sound = THEME:GetPathS("","nextstage_"..random_name)
	NextStageSleepTime = delay_time[random_name];
end;

local UseNextStage = true;

if GAMESTATE:IsSideJoined(PLAYER_1) and GAMESTATE:GetNumStagesLeft(PLAYER_1) > 0 then
	UseNextStage = true;
elseif GAMESTATE:IsSideJoined(PLAYER_2) and GAMESTATE:GetNumStagesLeft(PLAYER_2) > 2 then
	UseNextStage = true;
else
	NextStageSleepTime = 0;
	UseNextStage = false;
end;

t[#t+1] = LoadActor(bg)..{
	InitCommand=cmd(visible,UseNextStage;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;sleep,NextStageSleepTime;queuecommand,"Wall");
	WallCommand=cmd(linear,0.25;diffuse,color("#000000");diffusealpha,1;linear,0.25;diffusealpha,0);
};


t[#t+1] = LoadActor(sound)..{
	OnCommand=function(self)
		if UseNextStage then self:queuecommand('Play'); end;
	end;
	PlayCommand=cmd(stop;play);
	OffCommand=cmd(stop;)
};


		
t[#t+1] = Def.Actor {
	BeginCommand=function(self)
		self:sleep(NextStageSleepTime+WallpaperSleepTime);
		self:queuecommand("Load");
	end;
	LoadCommand=function() SCREENMAN:GetTopScreen():Continue(); end;
};

--[[DEBUG

t[#t+1] = LoadFont("Common Normal")..{	--percentage scoring P1
			InitCommand=cmd(zoom,2;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y);
			Text=curstage.." - Delay: "..NextStageSleepTime;
		};
--]]
return t;