return Def.ActorFrame{

	LoadActor("/BACKGROUNDS/Arcade")..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoomto,SCREEN_WIDTH+20,SCREEN_HEIGHT);
	OnCommand=function(self)
		mode = getenv("PlayMode")
		--self:Load("/BACKGROUNDS/"..mode..".mpg");
		--self:Load("/BACKGROUNDS/Arcade.mpg");
		--self:x(SCREEN_CENTER_X);
		--self:y(SCREEN_CENTER_Y);
		--self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT+10);
	end;
	};

	LoadActor("fade")..{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH+20,SCREEN_HEIGHT;diffusealpha,0);
	};
};