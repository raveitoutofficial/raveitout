--Not the same as fade_in, this sleeps to lock input.
--You can set sleep to anything above 6, it will stop locking once it gets to the next screen.
return Def.Quad{
	OnCommand=cmd(FullScreen;diffuse,color("#000000");diffusealpha,1;linear,0.25;diffusealpha,0;sleep,10);
};