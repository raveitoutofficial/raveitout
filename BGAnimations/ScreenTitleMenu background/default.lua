if IsUsingWideScreen() then
	default_width = SCREEN_WIDTH+20
else
	default_width = SCREEN_WIDTH
end;

return Def.ActorFrame{

	Def.Quad{
		--InitCommand=cmd(FullScreen;color,"White");
		-- This Work like this , anyway Quad default color is white
		InitCommand=cmd(FullScreen,color,Color.White);
		OnCommand=cmd(decelerate,0.75;diffusealpha,0;zoomy,0);
	};

	LoadActor(THEME:GetPathG("","_BGMovies/title.mpeg"))..{
		InitCommand=cmd(diffusealpha,0;Cover;);
		OnCommand=cmd(accelerate,1;diffusealpha,1;);
	};

};
