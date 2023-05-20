local gc = Var("GameCommand");
return Def.ActorFrame{
    LoadFont("_fixedsys")..{
		Text=gc:GetName();
		GainFocusCommand=cmd(diffuse,Color("Red"));
		LoseFocusCommand=cmd(diffuse,Color("White"));
	};
}