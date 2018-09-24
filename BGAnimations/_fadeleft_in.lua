local t =		Def.ActorFrame {};
local ratio =	FadeInRatio		--screen width ratio must be set from 0 to 1
local ani =		FadeInTween		--animation time

t[#t+1] = Def.ActorFrame{
	Def.Quad{
		OnCommand=cmd(FullScreen;;diffuse,color("#000000");
			zoomx,_screen.w+(_screen.w*ratio);faderight,ratio;
			x,_screen.cx+(_screen.w*(ratio*0.5));
			decelerate,ani;
			x,-_screen.cx-(_screen.w*(ratio*0.5));
		);
	};
};

return t