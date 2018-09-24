return Def.ActorFrame{	
	PREFSMAN:SetPreference("DisabledSongs",0);		--Clean "DisabledSongs" preference
	LoadFont("Common normal")..{
		InitCommand=cmd(x,_screen.cx;y,_screen.cy;zoom,0.9;maxwidth,_screen.w*0.9);
		OnCommand=cmd(settext,"DisabledSongs setting resetted\n relaunch game in order to changes make effect\n(Press CENTER to continue)");
	};
};