local t = Def.ActorFrame {};

local stage = GAMESTATE:GetCurrentStage()

--TODO: Fix for centered player
--[[local IsP1On =		GAMESTATE:IsPlayerEnabled(PLAYER_1)	--Is player 1 present? BRETTY OBIOS :DDDD
local IsP2On =		GAMESTATE:IsPlayerEnabled(PLAYER_2)	--Is player 2 present? BRETTY OBIOS :DDDD
local notefxp1 =	THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX")	--Note field X position P1
local notefxp2 =	THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX")	--Note field X position P2
if CenterGameplayWidgets() then
	notefxp1 = SCREEN_CENTER_X
	notefxp2 = SCREEN_CENTER_X
end

local stagemaxscore = 100000000*GAMESTATE:GetNumStagesForCurrentSongAndStepsOrCourse()

t[#t+1] = Def.ActorFrame{

};]]



t[#t+1] = Def.ActorFrame {
	OnCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+15;diffusealpha,0;sleep,1;linear,0.5;diffusealpha,1;);
	
		LoadFont("facu/_zona pro bold 20px")..{	--SONG + (SUBTITLE)
		InitCommand=cmd(uppercase,true;zoom,0.45;diffuse,1,1,1,1;horizalign,center;maxwidth,1280);
		OnCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:settext(GAMESTATE:GetCurrentCourse():GetScripter().." - "..GAMESTATE:GetCurrentCourse():GetDisplayFullTitle());
			else
				self:settext(GAMESTATE:GetCurrentSong():GetDisplayArtist().." - "..GAMESTATE:GetCurrentSong():GetDisplayFullTitle());
			end;
		end;
	};
};

t[#t+1] = Def.ActorFrame {
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X);
		if CenterGameplayWidgets() then
			self:y(SCREEN_BOTTOM-75);
		else
			self:y(SCREEN_TOP+50);
		end;
	end;
	OnCommand=cmd(diffusealpha,0;sleep,1;linear,0.5;diffusealpha,1;);

	Def.Sprite{
		--We don't have course mode graphics..
		Condition=(not GAMESTATE:IsCourseMode());
		--Texture=stage;
		InitCommand=cmd(zoom,0.55);
		--If it's not an OnCommand it will return a regular stage index...
		OnCommand=function(self)
			self:Load(THEME:GetPathB("ScreenGameplay","overlay/new_elements/"..GAMESTATE:GetCurrentStage()));
		end;
	};
};

return t
