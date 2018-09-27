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

local function MsgScroll()
	local index = 1
	return LoadActor("help_info/msg_1")..{
		SetCommand=function(self)
			index = index+1
			path = "/Themes/RioTI/Bganimations/ScreenSelectProfile background/help_info/";
			total = #FILEMAN:GetDirListing(path)-1
			if index == 3 then index = 1 end
			
			self:Load(path.."msg_"..index..".png");
			self:linear(0.2);
			self:diffusealpha(1);
			self:sleep(2);
			self:linear(0.2)
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
	}		
end;

--MSG INFO
t[#t+1] = Def.ActorFrame {
	LoadActor("help_info/txt_box")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-50;zoomx,0.9;zoomy,0.65);
	};
	
	MsgScroll()..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-50;zoom,0.6;queuecommand,"Set");
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
			self:settext("INSERT YOUR USB");
		end;
	};
	
	LoadFont("monsterrat/_montserrat semi bold 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+16;y,SCREEN_TOP+30;zoom,0.6;skewx,-0.255);
		OnCommand=function(self)
			self:uppercase(true);
			self:settext("OR SELECT A LOCAL PROFILE");
		end;
	};
	
	--TIME
	LoadFont("monsterrat/_montserrat light 60px")..{
			Text="TIME";
			InitCommand=cmd(x,SCREEN_CENTER_X-25;y,SCREEN_BOTTOM-92;zoom,0.6;skewx,-0.2);
		};
};



return t;
