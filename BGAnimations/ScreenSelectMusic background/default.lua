local npsxz = _screen.cx*0.5	--next/previous song X zoom

return Def.ActorFrame {

	LoadActor("sounds");	--lel sounds
	
	LoadActor(THEME:GetPathG("","background/common_bg"))..{
		InitCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1;);
	};

	LoadActor("songwheel")..{
		InitCommand=cmd(horizalign,center;zoomto,SCREEN_WIDTH,183;x,_screen.cx;y,_screen.cy-30);
	};
		

	LoadActor("particle.lua")..{ --snow effect, triggers only in December
		InitCommand=function(self)
			if MonthOfYear() == 11 then self:visible(true); else self:visible(false); end;
		end;
	};

};