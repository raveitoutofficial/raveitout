Setup()

return Def.ActorFrame{

	LoadActor(THEME:GetPathG("","_BGMovies/initlogo.mpg"))..{
		OnCommand=cmd(Center;Cover;);
	};

};