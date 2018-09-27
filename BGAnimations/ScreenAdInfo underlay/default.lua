local t = Def.ActorFrame {}

local TIMER =	THEME:GetMetric("ScreenAdInfo","TimerSeconds")

size = SCREEN_WIDTH/2.5;
distance = SCREEN_WIDTH/4;

t[#t+1] = LoadActor(THEME:GetPathG("","background/common_bg/shared"))..{
		InitCommand=cmd(diffusealpha,0;linear,2;diffusealpha,1;sleep,TIMER-1;linear,1;diffusealpha,0);
		OffCommand=cmd(linear,0.15;diffusealpha,0);
};

t[#t+1] = LoadActor("1_ad")..{
	InitCommand=cmd(x,SCREEN_CENTER_X-distance;y,SCREEN_CENTER_Y;rotationy,90;zoomto,size,size;horizalign,center;);
	OnCommand=cmd(sleep,.1;decelerate,1;rotationy,0;sleep,TIMER-0.25;linear,1;diffusealpha,0;);
	OffCommand=cmd(linear,0.15;diffusealpha,0);
};

t[#t+1] = LoadActor("2_ad")..{
	InitCommand=cmd(x,SCREEN_CENTER_X+distance;y,SCREEN_CENTER_Y;rotationy,90;zoomto,size,size;horizalign,center;);
	OnCommand=cmd(sleep,.1;decelerate,1;rotationy,0;sleep,TIMER-0.25;linear,1;diffusealpha,0;);
	OffCommand=cmd(linear,0.15;diffusealpha,0);
};

return t
