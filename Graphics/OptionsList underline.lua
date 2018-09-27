local posy = 0		--vertical position addition
local fadl = 0.75	--fade left
local fadr = 0.75	--fade right
local zomx = 160 	--zoom x
local zomy = 12		--zoom y
local skwx = -0.25	--skewx

return Def.ActorFrame {

	Def.Quad{
		InitCommand=cmd(skewx,skwx;draworder,200;diffuseshift;effectcolor1,color("0,0,0,1");effectcolor2,color("0,0,0,0.5");
		zoomto,zomx,zomy;fadeleft,fadl;faderight,fadr;blend,Blend.Add;y,posy);
	};
	Def.Quad{
		InitCommand=cmd(skewx,skwx;draworder,200;diffuseshift;effectcolor1,color("1,1,1,0.6");effectcolor2,color("1,1,1,0.8");
		zoomto,zomx,zomy;fadeleft,fadl;faderight,fadr;blend,Blend.Add;y,posy);
	};--]]
	
--[[	Def.Quad{
		InitCommand=cmd(diffuse,color("1,1,1,1");zoomto,160,12;);
	};--]]
};