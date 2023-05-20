return Def.Sprite{
	Texture=THEME:GetPathG("","PlayModes/splash/Special");
	InitCommand=cmd(Cover;diffusealpha,0);
	OnCommand=cmd(linear,.3;diffusealpha,1);
}
