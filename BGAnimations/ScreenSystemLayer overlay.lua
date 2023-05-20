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
		local eMode = GAMESTATE:IsEventMode();
		if gMode == 'CoinMode_Home' then
			if eMode then
				self:settext(THEME:GetString("Common","HOME EVENT"));
			else
				self:settext(THEME:GetString("Common","HOME MODE"));
			end;
		elseif gMode == 'CoinMode_Free' then
			if eMode then
				self:settext(THEME:GetString("Common","EVENT MODE"));
			else
				self:settext(THEME:GetString("Common","FREE PLAY"));
			end;
		elseif gMode == 'CoinMode_Pay' then
			local CoinstoJoin = GAMESTATE:GetCoinsNeededToJoin();
			local Coins = GAMESTATE:GetCoins();
			local Remainder = math.mod(Coins,CoinstoJoin);
			local Credits = math.floor(Coins/CoinstoJoin);
			local CoinsLeft = math.floor(Coins - Credits*CoinstoJoin);
			--self:settext('CREDIT(S) '..Credits..' ['..CoinsLeft..'/'..CoinstoJoin..']');
			self:settextf(THEME:GetString("Common","CREDIT(S) %i [%i/%i]"),Credits,CoinsLeft,CoinstoJoin)
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

--[[t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathG("Network","Icon");
	InitCommand=cmd(animate,false;xy,SCREEN_CENTER_X+95,SCREEN_BOTTOM-12);
}]]

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

--The lights debugger
if PREFSMAN:GetPreference("DebugLights") then
	local function diffuseLight(actor,b,color)
		actor:diffuse(b and color or Color.White);
	end;

	l = Def.ActorFrame{
		InitCommand=cmd(xy,SCREEN_WIDTH*.75,SCREEN_CENTER_Y);
		LightsDebugMessageCommand=function(self,param)
			local m = self:GetChild("Mode"):settext(param.LightsMode);
			local cab = param.Cabinet;
			diffuseLight(self:GetChild("UpLeft"),cab[1],Color.Red)
			diffuseLight(self:GetChild("UpRight"),cab[2],Color.Red)
			diffuseLight(self:GetChild("DownLeft"),cab[3],Color.Red)
			diffuseLight(self:GetChild("DownRight"),cab[4],Color.Red)
			diffuseLight(self:GetChild("BassLeft"),cab[5],Color.HoloBlue)
			diffuseLight(self:GetChild("BassRight"),cab[6],Color.HoloBlue)
			
			for i=1,2 do
				local c = param['Controller'..i]
				local p = self:GetChild("Controller"..i);
				local m = self:GetChild("MenuP"..i);
				
				diffuseLight(p:GetChild("UpLeft"),c[3] or c[12],Color.Red);
				diffuseLight(p:GetChild("UpRight"),c[4] or c[13],Color.Red);
				diffuseLight(p:GetChild("Center"),c[14],Color.Yellow);
				diffuseLight(p:GetChild("DownLeft"),c[15],Color.HoloBlue);
				diffuseLight(p:GetChild("DownRight"),c[16],Color.HoloBlue);
				
				diffuseLight(m:GetChild("MenuLeft"),c[1],Color.Yellow);
				diffuseLight(m:GetChild("MenuRight"),c[2],Color.Yellow);
				diffuseLight(m:GetChild("MenuStart"),c[5],Color.Green);
			end;
		end;
		LoadFont("Common Normal")..{
			Name="Mode";
			InitCommand=cmd(y,-75;shadowlength,2);
		};
		Def.Quad{
			Name="UpLeft";
			InitCommand=cmd(setsize,25,25;xy,-25,-25);
		};
		Def.Quad{
			Name="UpRight";
			InitCommand=cmd(setsize,25,25;xy,25,-25);
		};
		Def.Quad{
			Name="DownLeft";
			InitCommand=cmd(setsize,25,25;xy,-25,25);
		};
		Def.Quad{
			Name="DownRight";
			InitCommand=cmd(setsize,25,25;xy,25,25);
		};
		
		Def.Quad{
			Name="BassLeft";
			InitCommand=cmd(setsize,25,50;addx,-25;addy,100);
		};
		Def.Quad{
			Name="BassRight";
			InitCommand=cmd(setsize,25,50;addx,25;addy,100);
		};
	}
	
	for i=1,2 do
		l[#l+1] = Def.ActorFrame{
			Name="MenuP"..i;
			InitCommand=function(self)
				self:y(100);
				if i == 1 then
					self:x(-100)
				else
					self:x(100)
				end;
			end;
			
			Def.Quad{
				Name="MenuStart";
				InitCommand=cmd(setsize,25,25);
			};
			Def.ActorMultiVertex{
				Name="MenuLeft";
				InitCommand=function(self)
					self:xy(-25,0)
					self:SetDrawState{Mode="DrawMode_Triangles"}
					self:SetVertices({
						{{0, -25/2, 0}, Color.White},
						{{-25, 0, 0}, Color.White},
						{{0, 25/2, 0}, Color.White},
					})
				end;
			};
			Def.ActorMultiVertex{
				Name="MenuRight";
				InitCommand=function(self)
					self:xy(25,0)
					self:SetDrawState{Mode="DrawMode_Triangles"}
					self:SetVertices({
						{{0, -25/2, 0}, Color.White},
						{{25, 0, 0}, Color.White},
						{{0, 25/2, 0}, Color.White},
					})
				end;
			};
		};
	end;

	for i=1,2 do
		l[#l+1] = Def.ActorFrame{
			Name="Controller"..i;
			InitCommand=function(self)
				self:y(175);
				if i == 1 then
					self:x(-100)
				else
					self:x(100)
				end;
			end;
			Def.Quad{
				Name="Center";
				InitCommand=cmd(setsize,25,25);
			};
			Def.Quad{
				Name="UpLeft";
				InitCommand=cmd(setsize,25,25;xy,-25,-25);
			};
			Def.Quad{
				Name="UpRight";
				InitCommand=cmd(setsize,25,25;xy,25,-25);
			};
			Def.Quad{
				Name="DownLeft";
				InitCommand=cmd(setsize,25,25;xy,-25,25);
			};
			Def.Quad{
				Name="DownRight";
				InitCommand=cmd(setsize,25,25;xy,25,25);
			};
		}
	end;

	t[#t+1] = l;
end;

return t;
