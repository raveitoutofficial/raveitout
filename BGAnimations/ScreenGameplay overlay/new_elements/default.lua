local t = Def.ActorFrame {};
local IsP1On =		GAMESTATE:IsPlayerEnabled(PLAYER_1)	--Is player 1 present? BRETTY OBIOS :DDDD
local IsP2On =		GAMESTATE:IsPlayerEnabled(PLAYER_2)	--Is player 2 present? BRETTY OBIOS :DDDD

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


local IsP1On =		GAMESTATE:IsPlayerEnabled(PLAYER_1)	--Is player 1 present? BRETTY OBIOS :DDDD
local IsP2On =		GAMESTATE:IsPlayerEnabled(PLAYER_2)	--Is player 2 present? BRETTY OBIOS :DDDD
local notefxp1 =	THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX")	--Note field X position P1
local notefxp2 =	THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX")	--Note field X position P2
if IsP1On then

	if GAMESTATE:IsCourseMode() then
		stepsp1 = GAMESTATE:GetCurrentCourse():GetAllTrails()[1]:GetStepsType();
	else
		stepsp1 = GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType();
	end

	if stepsp1 ~= "StepsType_Pump_Single" or PREFSMAN:GetPreference("Center1Player") then		--"if not single mode"
		notefxp1 = SCREEN_CENTER_X		--HALFDOUBLE/DOUBLE/ROUTINE--Note field X position P1
	end
end
if IsP2On then

	if GAMESTATE:IsCourseMode() then
		stepsp2 = GAMESTATE:GetCurrentCourse():GetAllTrails()[1]:GetStepsType();
	else
		stepsp2 = GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType();
	end

	if stepsp2 ~= "StepsType_Pump_Single" or PREFSMAN:GetPreference("Center1Player") then		--"if not single mode"
		notefxp2 = SCREEN_CENTER_X		--HALFDOUBLE/DOUBLE/ROUTINE--Note field X position P2
	end
end

local stagemaxscore = 100000000*GAMESTATE:GetNumStagesForCurrentSongAndStepsOrCourse()

t[#t+1] = Def.ActorFrame{

};

--AVATAR P1
t[#t+1] = Def.ActorFrame{

	InitCommand=cmd(vertalign,top;horizalign,left;zoom,1.1;x,-80);
	OnCommand=cmd(sleep,1.5;accelerate,0.25;x,getenv("BarPosX")-35);
	
	LoadActor("mask")..{
		InitCommand=cmd(y,18;vertalign,top;horizalign,left;zoomto,45,45;MaskSource);
	};

	LoadActor(THEME:GetPathG("","USB_stuff/avatars/blank")) .. {
		InitCommand=cmd(x,3;y,40;horizalign,left;zoomto,40,40;MaskDest);
		OnCommand=function(self)
			self:visible(GAMESTATE:IsPlayerEnabled(PLAYER_1));
			self:Load(getenv("profile_icon_P1"));
			self:setsize(60,60);
		end;
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");

	};
	
	LoadActor("avatar_frame")..{
		InitCommand=cmd(x,0;y,18;vertalign,top;horizalign,left;zoomto,45,45;visible,GAMESTATE:IsPlayerEnabled(PLAYER_1););
	};
};


--AVATAR P2
t[#t+1] = Def.ActorFrame{

	InitCommand=cmd(vertalign,top;horizalign,right;zoom,1.1;x,SCREEN_RIGHT+80);
	OnCommand=cmd(sleep,1.5;accelerate,0.25;x,getenv("BarPosX")+SCREEN_RIGHT+35);
	LoadActor("mask")..{
		InitCommand=cmd(y,18;vertalign,top;horizalign,right;zoomto,45,45;MaskSource);
	};

	LoadActor(THEME:GetPathG("","USB_stuff/avatars/blank")) .. {
		InitCommand=cmd(x,0;y,40;horizalign,right;zoomto,40,40;MaskDest);
		OnCommand=function(self)
			self:visible(GAMESTATE:IsPlayerEnabled(PLAYER_2));
			self:Load(getenv("profile_icon_P2"));
		end;
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");

	};
	
	LoadActor("avatar_frame")..{
		InitCommand=cmd(x,0;y,18;vertalign,top;horizalign,right;zoomto,45,45;visible,GAMESTATE:IsPlayerEnabled(PLAYER_2););
	};
};



t[#t+1] = Def.ActorFrame {
	OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+15;diffusealpha,0;sleep,1;linear,0.5;diffusealpha,1;);
	
		LoadFont("facu/_zona pro bold 20px")..{	--SONG + (SUBTITLE)
		InitCommand=cmd(uppercase,true;zoom,0.45;diffuse,1,1,1,1;horizalign,center;maxwidth,620);
		OnCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:settext(GAMESTATE:GetCurrentCourse():GetDisplayArtist().." - "..GAMESTATE:GetCurrentCourse():GetDisplayFullTitle());
			else
				self:settext(GAMESTATE:GetCurrentSong():GetDisplayArtist().." - "..GAMESTATE:GetCurrentSong():GetDisplayFullTitle());
			end;
		end;
	};
};

t[#t+1] = Def.ActorFrame {
	OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+50;diffusealpha,0;sleep,1;linear,0.5;diffusealpha,1;);
	
		LoadActor("stage_info/"..stage)..{
			InitCommand=cmd(zoom,0.55);
		};
};

return t
