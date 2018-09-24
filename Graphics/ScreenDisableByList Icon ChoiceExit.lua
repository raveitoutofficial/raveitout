local diffy =	45		--difference Y axis for option spacing
local anim =	0.1		--animation time
local posx =	SCREEN_LEFT+80
local posy = 	_screen.cy+diffy*2
local font = 	"venacti/_venacti_outline 26px bold diffuse"
--
local ceny = 	_screen.cy
local tpsx =	SCREEN_RIGHT-80/2
local maxw =	_screen.cx

local t = Def.ActorFrame {};

t[#t+1] = Def.Quad{
	InitCommand=cmd(xy,posx+75,posy;diffuse,0.75,0.75,0.75,1;zoomto,220,32;fadeleft,0.125;faderight,0.5;blend,Blend.Add;);
	GainFocusCommand=cmd(stoptweening;linear,0.15;diffusealpha,1);
	LoseFocusCommand=cmd(stoptweening;linear,0.15;diffusealpha,0.2);
};

t[#t+1] = LoadFont(font)..{
	Text="Exit";
	InitCommand=cmd(xy,posx,posy;horizalign,left;zoom,0.75;);
	GainFocusCommand=cmd(stoptweening;linear,anim;diffusealpha,1);
	LoseFocusCommand=cmd(stoptweening;linear,anim;diffusealpha,0.25);
};

local t1 = "Exit this screen without making any changes."
t[#t+1] = LoadFont("Common normal")..{
	InitCommand=function(self)
		self:settext(t1);
		(cmd(xy,tpsx,ceny;horizalign,right;zoom,0.75;maxwidth,maxw))(self)
	end;
	GainFocusCommand=cmd(stoptweening;linear,anim;diffusealpha,1);
	LoseFocusCommand=cmd(stoptweening;linear,anim;diffusealpha,0);
};

return t