local t = Def.ActorFrame{
	InitCommand=cmd(zoom,0;CenterX;y,SCREEN_CENTER_Y*1.85;fov,90;rotationx,-7;y,SCREEN_TOP+7;);
	OnCommand=cmd(sleep,0.2;queuecommand,"TweenOn");
	TweenOnCommand=cmd(linear,0.3;zoomy,0.175;decelerate,1.2;zoomx,1);

		LoadActor("base")..{
		InitCommand=cmd(y,-4;zoomto,SCREEN_WIDTH-40,80;);
		OffCommand=cmd(sleep,0.4;queuecommand,"TweenOff");
		TweenOffCommand=cmd(accelerate,1.5;zoomx,0;);
	};
	
	Def.SongMeterDisplay{
		InitCommand=cmd(x,10;SetStreamWidth,SCREEN_WIDTH-40;y,-20;);
		OffCommand=cmd(sleep,0.4;queuecommand,"TweenOff");
		TweenOffCommand=cmd(accelerate,1.5;zoomx,0;);
		Stream=LoadActor("meter")..{
			OnCommand=cmd(y,-4;zoomto,SCREEN_WIDTH-40,60;);		
		};
		Tip=LoadActor("tip")..{
			OnCommand=cmd(x,15;y,2;zoomto,30,170;);
		};
	};

};

return t;
