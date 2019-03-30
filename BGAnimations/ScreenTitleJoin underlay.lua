return Def.ActorFrame{
	InitCommand=cmd(xy,THEME:GetMetric("ScreenTitleJoin","ScrollerX"),THEME:GetMetric("ScreenTitleJoin","ScrollerY")+80;);
	--Causes input locking problems, don't use
	--OnCommand=cmd(decelerate,1;diffusealpha,0;accelerate,1;diffusealpha,1;sleep,.5;queuecommand,"On");
	OnCommand=function(self)
		self:diffuseshift():effectcolor1(color("#FFFFFFFF")):effectcolor2(color("#00000000")):effectperiod(2);
	end;
	LoadFont("letters/_ek mukta Bold 48px")..{
		InitCommand=cmd(zoom,.5;);
		Text="Insert                to save progress";
	};
	LoadActor(THEME:GetPathG("USB","icon"))..{
		InitCommand=cmd(zoom,.2;addx,-57;addy,-5);
	}
};