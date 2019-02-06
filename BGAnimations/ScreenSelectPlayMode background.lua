return Def.ActorFrame{
	LoadActor(THEME:GetPathG("","_BGMovies/selplaymode"))..{
		InitCommand=cmd(Center;Cover;);
	};
	Def.Quad{
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,Color("White");blend,"BlendMode_WeightedMultiply";Center);
	};
};