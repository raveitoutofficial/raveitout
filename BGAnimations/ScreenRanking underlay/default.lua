local t = Def.ActorFrame {
};

t[#t+1] = LoadActor(THEME:GetPathG("","background/common_bg/shared"))..{
		InitCommand=cmd(diffusealpha,0;linear,2;diffusealpha,1;sleep,TIMER-1;linear,1;diffusealpha,0);
		OffCommand=cmd(linear,0.15;diffusealpha,0);
};

t[#t+1] = LoadActor( THEME:GetPathG("_frame", "1D"),
	{ 18/42, 6/42, 18/42 },
	LoadActor("back frame")
) .. {
	InitCommand = cmd(rotationz,0;
			x,SCREEN_CENTER_X;
			y,SCREEN_CENTER_Y+10;
	);
	BeginCommand = cmd(
		playcommand,"SetSize", { Width=228; tween=cmd(stoptweening;diffusealpha,0); };
		playcommand,"SetSize", { Width=628; tween=cmd(linear,0.30;diffusealpha,1); };
	);
};

t[#t+1] = Def.Quad {
	InitCommand = cmd(valign,0;setsize,852,70;x,SCREEN_CENTER_X;y,SCREEN_TOP;zwrite,true;blend,"BlendMode_NoEffect");
};

t[#t+1] = LoadActor("bottom mask") .. {
	InitCommand = cmd(valign,1;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM+8;zwrite,true;blend,"BlendMode_NoEffect");
};

return t;
