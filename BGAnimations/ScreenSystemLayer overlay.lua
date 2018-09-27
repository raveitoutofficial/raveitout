--local SysLayerFont = "venacti/_venacti_outline 26px bold diffuse"
local SysLayerFont = "Common normal"
-- Text
local txz = 	0.8			--text zoom
local alttex =	17.5		--altura texto
local altqua =	35			--altura quad

local t = Def.ActorFrame {}
	-- Aux
t[#t+1] = LoadActor(THEME:GetPathB("ScreenSystemLayer","aux"));

	-- Credits Graphic
t[#t+1] = LoadActor(THEME:GetPathG("","credits"))..{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-9;zoom,0.5;queuecommand,'Refresh');
	RefreshCommand=function(self)
		local screen = SCREENMAN:GetTopScreen();
		if screen then
			if screen:GetScreenType() ~= 'ScreenType_Attract' then
				self:visible(true)
			else
				self:visible(false)
			end
		end;
	end;
};

t[#t+1] = LoadFont(SysLayerFont) .. {
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-10;zoom,0.45;queuecommand,'Refresh');
	RefreshCommand=function(self)
		local gMode = GAMESTATE:GetCoinMode();
		if gMode == 'CoinMode_Home' then
			self:settext('HOME MODE');
		elseif gMode == 'CoinMode_Free' then
			self:settext('FREEPLAY');
		elseif gMode == 'CoinMode_Pay' then
			local CoinstoJoin = GAMESTATE:GetCoinsNeededToJoin();
			local Coins = GAMESTATE:GetCoins();
			local Remainder = math.mod(Coins,CoinstoJoin);
			local Credits = math.floor(Coins/CoinstoJoin);
			local CoinsLeft = math.floor(Coins - Credits*CoinstoJoin);
			self:settext('CREDIT(S) '..Credits..' ['..CoinsLeft..'/'..CoinstoJoin..']');
		end;
	end;
	OnCommand = cmd(playcommand,'Refresh');
	RefreshCreditTextMessageCommand = cmd(playcommand,'Refresh');
	CoinInsertedMessageCommand = cmd(playcommand,'Refresh');
	CoinModeChangedMessageCommand = cmd(playcommand,'Refresh');
	PlayerJoinedMessageCommand = cmd(playcommand,'Refresh');
};
	-- Text
t[#t+1] = Def.ActorFrame {
	Def.Quad {
		InitCommand=cmd(zoomtowidth,SCREEN_WIDTH;zoomtoheight,altqua;horizalign,left;vertalign,top;y,SCREEN_TOP-altqua;diffuse,color("0,0,0,0.5"););
		OnCommand=cmd(finishtweening;decelerate,0.25;y,SCREEN_TOP;);
		OffCommand=cmd(sleep,3;accelerate,0.5;y,SCREEN_TOP-altqua;);
	};
	LoadFont(SysLayerFont)..{
		Name="Text";
		--maxwidth,
		InitCommand=cmd(zoom,txz;horizalign,left;y,SCREEN_TOP-alttex;x,SCREEN_LEFT+25;maxwidth,_screen.w*0.9;);
		OnCommand=cmd(finishtweening;decelerate,0.25;y,SCREEN_TOP+alttex;);
		OffCommand=cmd(sleep,3;accelerate,0.5;y,SCREEN_TOP-alttex;);
	};
	SystemMessageMessageCommand = function(self, params)
		self:GetChild("Text"):settext( params.Message );
		self:playcommand( "On" );
		if params.NoAnimate then
			self:finishtweening();
		end
		self:playcommand( "Off" );
	end;
	HideSystemMessageMessageCommand = cmd(finishtweening);
};

--[[
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(playcommand,'Refresh');
	OnCommand=cmd(playcommand,'Refresh');
	RefreshCommand=function(self)
		local gMode = GAMESTATE:GetCoinMode();
		if gMode == 'CoinMode_Home' then
			--Home Mode
		elseif gMode == 'CoinMode_Free' then
			--Free Mode
		elseif gMode == 'CoinMode_Pay' then
			PREFSMAN:SetPreference("CoinMode",'Pay');
			PREFSMAN:SetPreference("EventMode",1);
		end;
	end;
	CoinInsertedMessageCommand=cmd(playcommand,'Refresh');
	CoinModeChangedMessageCommand=cmd(playcommand,'Refresh');
};

--]]
return t;