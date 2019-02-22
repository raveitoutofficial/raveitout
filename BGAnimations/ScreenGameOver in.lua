--Not the same as fade_in, this sleeps for 4.5 seconds to lock input
return Def.Quad{
	OnCommand=cmd(FullScreen;diffuse,color("#000000");diffusealpha,1;linear,0.25;diffusealpha,0;sleep,4.25);
};