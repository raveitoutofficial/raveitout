local highxz = 186		--188	--highlight X zoom
local highyz = 40		--highlight Y zoom

function GetLocalProfiles()
	local t = {};
	for p = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
		local profile=PROFILEMAN:GetLocalProfileFromIndex(p);
		local ProfileCard = Def.ActorFrame {
			LoadFont("monsterrat/_montserrat semi bold 60px") .. {
				Text=profile:GetDisplayName();
				InitCommand=cmd(uppercase,true;shadowlength,0.5;y,-8;zoom,0.325;ztest,true;maxwidth,400;skewx,-0.125;);	--maxwidth added -nikk
			};
			LoadFont("monsterrat/_montserrat light 60px") .. {
				InitCommand=cmd(uppercase,true;shadowlength,0.5;y,8;zoom,0.2;vertspacing,-8;ztest,true;skewx,-0.125;);
				BeginCommand=function(self)
					local numSongsPlayed = profile:GetNumTotalSongsPlayed();
					local s = numSongsPlayed == 1 and "Song" or "Songs";
					-- todo: localize
					self:settext( numSongsPlayed.." "..s.." Played" );
				end;
			};
		};
		t[#t+1]=ProfileCard;
	end;
	return t;
end;

function LoadCard(cColor)
	local t = Def.ActorFrame {
		LoadActor("CardBackground")..{
			InitCommand=cmd(diffuse,cColor);
		};
		LoadActor("CardFrame");
	};
	return t
end

function LoadPlayerStuff(Player)
	local t = {};
	local pn = (Player == PLAYER_1) and 1 or 2;
	t[#t+1] = Def.ActorFrame {
		Name = 'JoinFrame';
		LoadCard(Color('White'));	--uncolor -nikk
		LoadFont("monsterrat/_montserrat semi bold 60px") .. {
			Text="PRESS         OR       \nTO JOIN THE RAVE.";
			InitCommand=cmd(uppercase,true;zoom,0.25;skewx,-0.2);
			OnCommand=cmd(diffuse,Color('Black'));
	};
		LoadActor("Center Tap Note 3x2")..{
		InitCommand=cmd(x,56;y,-8;zoom,0.35);
	};
		LoadActor("start")..{
		InitCommand=cmd(x,3;y,-8;zoom,0.35);
	};
};
	
	
	t[#t+1] = Def.ActorFrame {
		Name = 'BigFrame';
		LoadCard(PlayerColor(Player));
	};
	t[#t+1] = Def.ActorFrame {
		Name = 'SmallFrame';	--Profile scroller highlight
		InitCommand=cmd(y,-2);
		Def.Quad {
		--zoomto,200-10,40+2
			InitCommand=cmd(zoomto,highxz,highyz+2);	--barra highlight, sombra
			OnCommand=cmd(diffuse,Color('Black');diffusealpha,0.5);
		};
		Def.Quad {
			InitCommand=cmd(zoomto,highxz,highyz);		--sombras laterales
			OnCommand=cmd(diffuse,PlayerColor(Player);fadeleft,0.25;faderight,0.25;glow,color("1,1,1,0.25"));
		};
		Def.Quad {
			InitCommand=cmd(zoomto,highxz,highyz;y,-40/2+20);
			OnCommand=cmd(diffuse,Color("Black");fadebottom,1;diffusealpha,0.35);
		};
		Def.Quad {
			InitCommand=cmd(zoomto,highxz,1;y,-40/2+1);		--linea roja efecto
			OnCommand=cmd(diffuse,PlayerColor(Player);glow,color("1,1,1,0.25"));
		};	
	};

	t[#t+1] = Def.ActorScroller{
		Name = 'Scroller';
		NumItemsToDraw=6;
	--	InitCommand=cmd(y,-230/2+20;);
		OnCommand=cmd(SetFastCatchup,true;SetMask,200,62;SetSecondsPerItem,0.15);
		TransformFunction=function(self, offset, itemIndex, numItems)
			local focus = scale(math.abs(offset),0,2,1,0);
			self:visible(false);
			self:y(math.floor( offset*40 ));
		end;
		children = GetLocalProfiles();
	};

	t[#t+1] = Def.ActorFrame {
		Name = "EffectFrame";
	};
	t[#t+1] = LoadFont("bebas/_bebas neue bold 90px") .. {
		Name = 'SelectedProfileText';
		InitCommand=cmd(uppercase,true;zoom,0.35;skewx,-0.2;y,130;shadowlength,0.5;maxwidth,500);		--added maxwidth -nikk
	};																									--then I changed it lmfao -Gio

	return t;
end;

function UpdateInternal3(self, Player)
	local pn = (Player == PLAYER_1) and 1 or 2;
	local frame = self:GetChild(string.format('P%uFrame', pn));
	local scroller = frame:GetChild('Scroller');
	local seltext = frame:GetChild('SelectedProfileText');
	local joinframe = frame:GetChild('JoinFrame');
	local smallframe = frame:GetChild('SmallFrame');
	local bigframe = frame:GetChild('BigFrame');
	
	if GAMESTATE:IsHumanPlayer(Player) then
		frame:visible(true);
		if MEMCARDMAN:GetCardState(Player) == 'MemoryCardState_none' then
			--using profile if any
			joinframe:visible(false);
			smallframe:visible(true);
			bigframe:visible(true);
			seltext:visible(true);
			scroller:visible(true);
			
			local ind = SCREENMAN:GetTopScreen():GetProfileIndex(Player);
			if ind > 0 then
				scroller:SetDestinationItem(ind-1);
				seltext:settext(PROFILEMAN:GetLocalProfileFromIndex(ind-1):GetDisplayName());
			else
				if SCREENMAN:GetTopScreen():SetProfileIndex(Player, 1) then
					scroller:SetDestinationItem(0);
					self:queuecommand('UpdateInternal2');
				else
					joinframe:visible(true);
					smallframe:visible(false);
					bigframe:visible(false);
					scroller:visible(false);
					seltext:settext('No profile');
				end;
			end;
		else
			--using card
			smallframe:visible(false);
			scroller:visible(false);
			seltext:settext('USB CONNECTED');
			SCREENMAN:GetTopScreen():SetProfileIndex(Player, 0);
		end;
	else
		joinframe:visible(true);
		scroller:visible(false);
		seltext:visible(false);
		smallframe:visible(false);
		bigframe:visible(false);
	end;
end;

local t = Def.ActorFrame {

	StorageDevicesChangedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	CodeMessageCommand = function(self, params)
		if params.Name == 'Start' or params.Name == 'Center' then
			MESSAGEMAN:Broadcast("StartButton");
			if not GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, -1);
			else
				SCREENMAN:GetTopScreen():Finish();
			end;
		end;
		if params.Name == 'Up' or params.Name == 'Up2' or params.Name == 'Left' or params.Name == 'Left2' or params.Name == 'DownLeft' then
			if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(params.PlayerNumber);
				if ind > 1 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, ind - 1 ) then
						MESSAGEMAN:Broadcast("DirectionButton");
						self:queuecommand('UpdateInternal2');
					end;
				end;
			end;
		end;
		if params.Name == 'Down' or params.Name == 'Down2' or params.Name == 'Right' or params.Name == 'Right2' or params.Name == 'DownRight' then
			if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				local ind = SCREENMAN:GetTopScreen():GetProfileIndex(params.PlayerNumber);
				if ind > 0 then
					if SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, ind + 1 ) then
						MESSAGEMAN:Broadcast("DirectionButton");
						self:queuecommand('UpdateInternal2');
					end;
				end;
			end;
		end;
		if params.Name == 'Back' then
			if GAMESTATE:GetNumPlayersEnabled()==0 then
				SCREENMAN:GetTopScreen():Cancel();
			else
				MESSAGEMAN:Broadcast("BackButton");
				SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, -2);
			end;
		end;
	end;

	PlayerJoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	PlayerUnjoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	OnCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	UpdateInternal2Command=function(self)
		UpdateInternal3(self, PLAYER_1);
		UpdateInternal3(self, PLAYER_2);
	end;


	children = {
		Def.ActorFrame {
			Name = 'P1Frame';
			InitCommand=cmd(x,SCREEN_CENTER_X-200;y,SCREEN_CENTER_Y-15);
			OnCommand=cmd(zoom,1.75;bounceend,0.35;zoom,1);
			OffCommand=cmd(bouncebegin,0.35;zoom,0);
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_1 then
					(cmd(;zoom,1.15;bounceend,0.175;zoom,1.0;))(self);
				end;
			end;
			children = LoadPlayerStuff(PLAYER_1);
		};
		Def.ActorFrame {
			Name = 'P2Frame';
			InitCommand=cmd(x,SCREEN_CENTER_X+200;y,SCREEN_CENTER_Y-15);
			OnCommand=cmd(zoom,1.75;bounceend,0.35;zoom,1);
			OffCommand=cmd(bouncebegin,0.35;zoom,0);
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_2 then
					(cmd(zoom,1.15;bounceend,0.175;zoom,1.0;))(self);
				end;
			end;
			children = LoadPlayerStuff(PLAYER_2);
		};

		--//////////////////      SOUNDS      //////////////////
		LoadActor(THEME:GetPathS("Common","start"))..{StartButtonMessageCommand=cmd(play);};
		LoadActor(THEME:GetPathS("Common","cancel"))..{BackButtonMessageCommand=cmd(play);};
		LoadActor(THEME:GetPathS("Common","value"))..{DirectionButtonMessageCommand=cmd(play);};
		
		--P1 USB PROFILE INFO
		LoadFont("Common normal")..{
			InitCommand=cmd(x,SCREEN_CENTER_X-160;y,SCREEN_CENTER_Y-50;zoom,0.7;);
			OnCommand=function(self)
				if MEMCARDMAN:GetCardState(PLAYER_1) == 'MemoryCardState_none' then
					self:settext("");
				else
					self:settext("Player name:\n"..MEMCARDMAN:GetName(PLAYER_1));
				end;
			end;
			ScreenChangedMessageCommand=cmd(playcommand,"On");
			PlayerJoinedMessageCommand=cmd(playcommand,"On");
			CoinInsertedMessageCommand=cmd(playcommand,"On");
			CoinModeChangedMessageCommand=cmd(playcommand,"On");
			StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
		};
		
		LoadActor("pendrive")..{
			InitCommand=cmd(x,SCREEN_CENTER_X-160;y,SCREEN_CENTER_Y+25;zoom,0.7;);
			OnCommand=function(self)
				if MEMCARDMAN:GetCardState(PLAYER_1) == 'MemoryCardState_none' then
					self:linear(0.3);
					self:diffusealpha(0);
				else
					self:linear(0.3);
					self:diffusealpha(1);
				end;
			end;
			ScreenChangedMessageCommand=cmd(playcommand,"On");
			PlayerJoinedMessageCommand=cmd(playcommand,"On");
			CoinInsertedMessageCommand=cmd(playcommand,"On");
			CoinModeChangedMessageCommand=cmd(playcommand,"On");
			StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
		};
	};
};
return t;
