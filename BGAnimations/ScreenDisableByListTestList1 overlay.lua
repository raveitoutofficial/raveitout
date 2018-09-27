local head =	"Disabled the following songs:\n";
local s1 =		"Rave It Out (Arcade)\\50 Ways To Say Goodbye\n";
local s2 =		"Rave It Out (Arcade)\\All Around The World\n";
local s3 =		"Rave It Out (Arcade)\\Ass Back Home";
local foot =	"\n\nReboot/Relaunch for changes to make effect.";

return Def.ActorFrame{
	PREFSMAN:SetPreference("DisabledSongs","Songs/Rave It Out (Arcade)/50 Ways To Say Goodbye;Songs/Rave It Out (Arcade)/All Around The World;Songs/Rave It Out (Arcade)/Ass Back Home;");
	--GAMESTATE:SaveLocalData();	--nope
	LoadFont("Common normal")..{
		InitCommand=cmd(Center;zoom,0.75;maxwidth,_screen.w*0.95);
		OnCommand=function(self)
			self:settext(head..s1..s2..s3..foot);
		end;
	};
};