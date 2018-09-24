setenv("random_avatar_p1",THEME:GetPathG("","USB_stuff/avatars/"..string.format("%03i",tostring(math.random(40)))));
math.randomseed(Hour()*3600+Second());
setenv("random_avatar_p2",THEME:GetPathG("","USB_stuff/avatars/"..string.format("%03i",tostring(math.random(40)))));

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

	LoadActor(THEME:GetPathG("","_BGMovies"),"Title.mp4")..{
		InitCommand=cmd(Center;diffusealpha,0;);
		OnCommand=cmd(accelerate,1;diffusealpha,1;);
	};

};
