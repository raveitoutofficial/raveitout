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
if CenterGameplayWidgets() then
	notefxp1 = SCREEN_CENTER_X
	notefxp2 = SCREEN_CENTER_X
end

local stagemaxscore = 100000000*GAMESTATE:GetNumStagesForCurrentSongAndStepsOrCourse()

t[#t+1] = Def.ActorFrame{

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
