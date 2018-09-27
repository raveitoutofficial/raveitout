local diffy =	45		--difference Y axis for option spacing
local anim =	0.1		--animation time
local posx =	_screen.cx-160
local posy = 	_screen.cy-diffy*1
local font = 	"venacti/_venacti_outline 26px bold diffuse"

local t = Def.ActorFrame {
--[[	GainFocusCommand=function(self)
	--	SetUserPref("UserPrefSetPreferences", "Yes");
		SCREENMAN:SystemMessage("Selected choice: LIST");
	end		--]]
};

t[#t+1] = Def.Quad{
	InitCommand=cmd(xy,posx+75,posy;diffuse,1,0.25,0.25,1;zoomto,220,32;fadeleft,0.125;faderight,0.5;blend,Blend.Add;);
	GainFocusCommand=cmd(stoptweening;linear,0.15;diffusealpha,1);
	LoseFocusCommand=cmd(stoptweening;linear,0.15;diffusealpha,0.2);
};

t[#t+1] = LoadFont(font)..{
	Text="Disable Nothing";
	InitCommand=cmd(xy,posx,posy;horizalign,left;zoom,0.75;);
	GainFocusCommand=cmd(stoptweening;linear,anim;diffusealpha,1);
	LoseFocusCommand=cmd(stoptweening;linear,anim;diffusealpha,0.25);
};

return t