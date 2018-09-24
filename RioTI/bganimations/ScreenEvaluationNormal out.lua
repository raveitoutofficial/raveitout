-- values must be set from 0 to 1
local ratio =	FadeOutRatio 	--screen width ratio
local ani =		FadeOutTween	--animation time

return Def.Quad{
	OffCommand=function(self)
		if GAMESTATE:GetNumSidesJoined() == 2 then
			GAMESTATE:SetCurrentStyle("versus");
		end;
		setenv("routine_switch","on");
	end;

	Def.Quad{
		OnCommand=cmd(FullScreen;diffuse,color("#000000");
			zoomx,_screen.w+(_screen.w*(ratio*1.25));fadeleft,ratio;		-- <-- if 4:3 the math result is 840 with 0.25 ratio
			x,_screen.cx*3+(_screen.w*(ratio*0.5));
			decelerate,ani;
			x,(_screen.cx-(_screen.w*(ratio*0.5)))*0.9166666666666667;
		);
	};
};