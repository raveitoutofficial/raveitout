local gc = Var("GameCommand");

return Def.ActorFrame {
	
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH/1.5,40;fadeleft,1;faderight,1;y,50;diffusealpha,0;diffuse,0,0,0,0.75);
		GainFocusCommand=cmd(diffusealpha,1);
		LoseFocusCommand=cmd(diffusealpha,0);
	};

	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH/2,2;fadeleft,1;faderight,1;y,30;diffuse,color("#008dff"));
	};
	
	Def.Quad{
		InitCommand=cmd(zoomto,SCREEN_WIDTH/2,2;fadeleft,1;faderight,1;y,70;diffuse,color("#008dff"));
	};
	
	LoadActor(gc:GetText()) .. {
		InitCommand=cmd(zoom,0.6;y,46.5);
		GainFocusCommand=cmd(x,-15;stoptweening;linear,0.2;zoomx,0.6;zoomy,0.6;diffusealpha,1;x,0);
		LoseFocusCommand=cmd(x,0;stoptweening;linear,0.05;zoomx,0.6;zoomy,0;diffusealpha,0;x,15);
	};


};
