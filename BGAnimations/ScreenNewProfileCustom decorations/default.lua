return Def.ActorFrame{

	LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/current_group"))..{
		InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP+5;horizalign,left;vertalign,top;zoomx,1;cropbottom,0.3);
	};
	LoadFont("monsterrat/_montserrat light 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+18;y,SCREEN_TOP+10;zoom,0.185;skewx,-0.1);
		OnCommand=function(self)
			self:uppercase(true);
			self:settext("NEW PLAYER");
		end;
	};
	LoadFont("monsterrat/_montserrat semi bold 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+16;y,SCREEN_TOP+30;zoom,0.6;skewx,-0.255);
		OnCommand=function(self)
			self:uppercase(true);
			self:settext("ENTER YOUR PROFILE NAME");
		end;
	};
	
	--TIME
	LoadFont("monsterrat/_montserrat light 60px")..{
		Text="TIME";
		InitCommand=cmd(x,THEME:GetMetric("ScreenNewProfileCustom","TimerX");y,THEME:GetMetric("ScreenNewProfileCustom","TimerY")-30;zoom,0.6;skewx,-0.2);
	};
};