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
--Only display help when the help is relevant. Aka no "press left and right to select a profile" when there are no profiles to select.
if PROFILEMAN:GetNumLocalProfiles() > 0 and not USING_RFID then
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
end;

t[#t+1] = 	Def.ActorFrame{

	LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/current_group"))..{
		InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP+5;horizalign,left;vertalign,top;zoomx,1;cropbottom,0.3);
	};
	
	LoadFont("monsterrat/_montserrat light 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+18;y,SCREEN_TOP+10;zoom,0.185;skewx,-0.1);
		OnCommand=function(self)
			self:uppercase(true);
			if USING_RFID then
				self:settext(THEME:GetString("ScreenSelectProfile","INSERT YOUR USB FLASH DRIVE OR"));
			else
				self:settext(THEME:GetString("ScreenSelectProfile","SELECT A LOCAL PROFILE OR"));
			end;
		end;
	};
	
	LoadFont("monsterrat/_montserrat semi bold 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;xy,16,30;zoom,0.6;skewx,-0.255;maxwidth,700*GetScreenAspectRatio());
		OnCommand=function(self)
			self:uppercase(true);
			if USING_RFID then
				self:settext(THEME:GetString("ScreenSelectProfile","SCAN YOUR RAVE IT OUT PASS"));
			else
				self:settext(THEME:GetString("ScreenSelectProfile","INSERT YOUR USB FLASH DRIVE"));
			end;
		end;
	};
	
	--[[Def.Quad{
		InitCommand=cmd(xy,SCREEN_CENTER_X,THEME:GetMetric("ScreenSelectProfile","TimerY");diffuse,Color.Red;setsize,200,20);
	};]]
	--TIME
	LoadFont("monsterrat/_montserrat light 60px")..{
		Text="TIME";
		Condition=PREFSMAN:GetPreference("MenuTimer");
		InitCommand=cmd(x,THEME:GetMetric("ScreenSelectProfile","TimerX")-90;y,THEME:GetMetric("ScreenSelectProfile","TimerY");zoom,0.675;skewx,-0.25;);
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
