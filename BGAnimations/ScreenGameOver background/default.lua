local t = Def.ActorFrame {

	LoadActor("/Backgrounds/gameover")..{
		InitCommand=cmd(zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
	};
	
	LoadActor(THEME:GetPathS("","gameover"))..{
		OnCommand=cmd(queuecommand,'Play');
		PlayCommand=cmd(stop;play);
		OffCommand=cmd(stop;)
	};
};

return t;
