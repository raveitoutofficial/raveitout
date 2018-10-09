return Def.ActorFrame{
	--[[Def.Quad{		--fade in to gameplay screen
		OnCommand=cmd(FullScreen;diffuse,0,0,0,1;linear,0.4;diffusealpha,0);
	};]]
	Def.Sprite{
		InitCommand=cmd(LoadFromCurrentSongBackground;Cover;diffusealpha,0.8);
		OnCommand=cmd(linear,.4;diffusealpha,0);
	};
}