local t = Def.ActorFrame {

	LoadActor(THEME:GetPathG("","background/common_bg/shared"))..{
		InitCommand=cmd(diffusealpha,0;zoomx,1.02;zoomy,0.998;linear,2;diffusealpha,1;);
	};

};
	
	--PLAYER STUFF (I'll finish this later...it's bad.) -Gio
	--t[#t+1] = LoadActor("p1_topbar")..{
	--	InitCommand=cmd(x,SCREEN_CENTER_X-160;y,SCREEN_TOP+80;zoomto,275,55;sleep,0.85;visible,GAMESTATE:IsSideJoined(PLAYER_1));
	--	PlayerJoinedMessageCommand=function(self,param)
	--			if param.Player == PLAYER_1 then
	--				self:linear(0.1);
	--				self:diffusealpha(1);
	--			else
	--				self:linear(0.1);
	--				self:diffusealpha(0);
	--			end;
	--		end;
	--};
	
	--t[#t+1] = LoadActor("p2_topbar")..{
	--	InitCommand=cmd(x,SCREEN_CENTER_X+160;y,SCREEN_TOP+80;zoomto,275,55;sleep,0.85;visible,GAMESTATE:IsSideJoined(PLAYER_2));
	--	PlayerJoinedMessageCommand=function(self,param)
	--			if param.Player == PLAYER_2 then
	--				self:linear(0.1);
	--				self:diffusealpha(1);
	--			else
	--				self:linear(0.1);
	--				self:diffusealpha(0);
	--			end;
	--		end;
	--};



--MSG INFO
t[#t+1] = Def.ActorFrame {
	LoadActor("help_info/txt_box")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-50;zoomx,0.9;zoomy,0.65);
	};
	
	Def.Sprite{
		Texture="help_info/messages";
		InitCommand=cmd(animate,false;diffusealpha,0;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-50;zoom,0.6;);
		OnCommand=cmd(playcommand,"Animate");
		AnimateCommand=function(self)
			self:linear(0.2);
			self:diffusealpha(1);
			self:sleep(2);
			self:linear(0.2)
			self:diffusealpha(0);
			local nextState = self:GetState()+1;
			if nextState == self:GetNumStates() then
				self:setstate(0);
			else
				self:setstate(nextState);
			end;
			self:queuecommand("Animate");
		end;
	};
};

t[#t+1] = 	Def.ActorFrame{

	LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/current_group"))..{
		InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP+5;horizalign,left;vertalign,top;zoomx,1;cropbottom,0.3);
	};
	
	LoadFont("monsterrat/_montserrat light 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+18;y,SCREEN_TOP+10;zoom,0.185;skewx,-0.1);
		OnCommand=function(self)
			self:uppercase(true);
			self:settext(THEME:GetString("ScreenSelectProfile","INSERT YOUR USB"));
		end;
	};
	
	LoadFont("monsterrat/_montserrat semi bold 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+16;y,SCREEN_TOP+30;zoom,0.6;skewx,-0.255);
		OnCommand=function(self)
			self:uppercase(true);
			self:settext(THEME:GetString("ScreenSelectProfile","OR SELECT A LOCAL PROFILE"));
		end;
	};
	
	--TIME
	LoadFont("monsterrat/_montserrat light 60px")..{
			Text="TIME";
			InitCommand=cmd(x,SCREEN_CENTER_X-25;y,SCREEN_BOTTOM-92;zoom,0.6;skewx,-0.2);
		};
		

};

--This was a test, ignore it
--[[
local MenuTimer;
local playAt;

local function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

t[#t+1] = Def.ActorFrame{

	--Update command
	LoadActor(THEME:GetPathS("MenuTimer", "warn"))..{
		OnCommand=function(self)
			name = SCREENMAN:GetTopScreen():GetName();
			--SCREENMAN:SystemMessage(name)
			playAt = THEME:GetMetric(THEME:GetMetric(name,"TimerMetricsGroup"),"WarningBeepStart")
			if playAt > 0 then
				MenuTimer = SCREENMAN:GetTopScreen():GetChild("Timer");
				self:queuecommand("CheckTimer");
			end;
		end;
		
		--I think this is the only way to check the timer
		CheckTimerCommand=function(self)
			--SCREENMAN:SystemMessage(MenuTimer:GetSeconds());
			if round(MenuTimer:GetSeconds(), 0) == playAt then
				self:play();
			else
				self:linear(1):queuecommand("CheckTimer");
			end;
		end;
	};
}]]



return t;
