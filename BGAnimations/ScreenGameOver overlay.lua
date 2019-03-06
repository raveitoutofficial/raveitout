return Def.ActorFrame {
	--OnCommand=cmd(sleep,999);

	LoadActor(THEME:GetPathG("","_BGMovies/gameover"))..{
		InitCommand=cmd(Cover);
	};
	
	LoadActor(THEME:GetPathS("ScreenGameOver","music"))..{
		OnCommand=cmd(play);
	};
	Def.Quad{
		InitCommand=cmd(diffuse,Color("White");setsize,SCREEN_WIDTH,SCREEN_HEIGHT;Center;diffusealpha,0);
		OnCommand=cmd(sleep,4.5;linear,.5;diffusealpha,1;);
	};
};

--[[return Def.ActorFrame{
	InitCommand=function(self)
		GAMESTATE:ApplyGameCommand("stopmusic");
		SOUND:PlayOnce(THEME:GetPathS("ScreenGameOver", "music"));
	end;

	Def.Quad{
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,Color("Black");diffusealpha,0;Center);
		OnCommand=cmd(sleep,3;linear,1;diffusealpha,1);
	};
	LoadFont("common normal")..{
		Text="Thank You For Playing";
		InitCommand=cmd(Center;zoom,1.5;diffusebottomedge,Color("HoloBlue"););
		OnCommand=cmd(sleep,3;decelerate,.5;zoomy,0;zoomx,3);
	};
	LoadFont("common normal")..{
		Text="SEE YOU NEXT GAME";
		InitCommand=cmd(Center;addy,50;diffusebottomedge,Color("HoloBlue"));
		OnCommand=cmd(sleep,3;decelerate,.5;zoomy,0;zoomx,3);
	};
};]]
