local head =	"Disabled the following songs:\n";
local s1 =		"Rave It Out (Arcade)\\Bangarang\n";
local s2 =		"Rave It Out (Arcade)\\Beauty And A Beat\n";
local s3 =		"Rave It Out (Arcade)\\Blackout";
local foot =	"\n\nReboot/Relaunch for changes to make effect.";

return Def.ActorFrame{
	PREFSMAN:SetPreference("DisabledSongs","Songs/Rave It Out (Arcade)/Bangarang;Songs/Rave It Out (Arcade)/Beauty And A Beat;Songs/Rave It Out (Arcade)/Blackout");
	LoadFont("Common normal")..{
		InitCommand=cmd(Center;zoom,0.75;maxwidth,_screen.w*0.95);
		OnCommand=function(self)
			self:settext(head..s1..s2..s3..foot);
		end;
	};
};