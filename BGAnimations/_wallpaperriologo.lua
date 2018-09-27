local lzom = 0.5		--zoom
local sepv = 13			--separacion vertical desde l2
local offx = 160
local offy = 30

return Def.ActorFrame{
	--not looped because the "glowshift" at 2nd actor
	LoadActor(THEME:GetPathG("","logo"))..{
		InitCommand=cmd(xy,_screen.w-offx,(_screen.h-sepv*1)-offy;zoomx,lzom/3;zoomy,lzom/4);
	};
	LoadActor(THEME:GetPathG("","l2"))..{
		InitCommand=cmd(xy,_screen.w-offx,(_screen.h-sepv*-1)-offy;zoom,lzom);
	};
};