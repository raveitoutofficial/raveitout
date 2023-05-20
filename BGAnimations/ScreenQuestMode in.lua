return Def.Sprite{
	Texture=THEME:GetPathG("","PlayModes/splash/Special");
	InitCommand=cmd(Cover);
	OnCommand=cmd(linear,.3;diffusealpha,0);
}
