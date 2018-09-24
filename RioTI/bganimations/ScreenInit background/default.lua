Setup()

return Def.ActorFrame{

	LoadActor("/Backgrounds/initlogo.mpg")..{
		OnCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEM_HEIGHT;);
	};

};