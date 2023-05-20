return Def.ActorFrame{
    LoadFont("_fixedsys")..{
		InitCommand=cmd(CenterX;y,SCREEN_HEIGHT*.25;wrapwidthpixels,SCREEN_WIDTH*.9);
		Text=THEME:GetString("TourneyModePrompt","Prompt");
	};
}