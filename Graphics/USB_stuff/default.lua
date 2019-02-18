
--If player got a bonus heart, show a message to congratulate them.
local showP1BonusMessage, showP2BonusMessage = ...

local function PlayerLevel(player)
	--return LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	return LoadFont("common normal")..{
		SetCommand=function(self)
			local numSongs = PROFILEMAN:GetProfile(player):GetTotalNumSongsPlayed();
			--This is literally used nowhere
			--local currentplayer = pname(player) -- PLAYER_1 -> P1
			--setenv("level_"..currentplayer, string.format("%02d",level));
			--end
			
			if DoDebug then
				self:settext(" ∞");
			else
				self:settext("Lv. "..string.format("%02d",calcPlayerLevel(numSongs)));
			end;
			self:visible(GAMESTATE:IsSideJoined(player));
		end;
		PlayerJoinedMessageCommand=cmd(playcommand,"Set");
		CoinInsertedMessageCommand=cmd(playcommand,"Set");
		CoinModeChangedMessageCommand=cmd(playcommand,"Set");
		ScreenChangedMessageCommand=cmd(playcommand,"Set");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"Set");
	};
end;

local function PlayerName(player)

	--return LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	return LoadFont("common normal")..{
		SetCommand=function(self)
			self:settext("bla");
			local profile = PROFILEMAN:GetProfile(player)
			local name = profile:GetDisplayName()
			
			if MEMCARDMAN:GetCardState(player) == 'MemoryCardState_none' then
				
				if name == "" then		
					self:settext(string.upper("RIO-000"));
				else
					self:settext(string.upper(name));
				end
				
			else
				self:settext(string.upper(MEMCARDMAN:GetName(player)));
			end
			
			self:visible(GAMESTATE:IsSideJoined(player));
		end;
		PlayerJoinedMessageCommand=cmd(playcommand,"Set");
		CoinInsertedMessageCommand=cmd(playcommand,"Set");
		CoinModeChangedMessageCommand=cmd(playcommand,"Set");
		ScreenChangedMessageCommand=cmd(playcommand,"Set");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"Set");
	};
end

local t = Def.ActorFrame{};

local heartXPos = 260;
local heartsLength = HeartsPerPlay*16;

--[[t[#t+1] = Def.Quad{
	InitCommand=cmd(setsize,heartsLength,15;xy,heartXPos,SCREEN_BOTTOM-15);
};]]
--P1 HEARTS
if IsUsingWideScreen() then
	for i=1,HeartsPerPlay do
		t[#t+1] = LoadActor("heart_background") .. {
			InitCommand=cmd(zoom,0.5;x,heartXPos+i*16-heartsLength/2;y,SCREEN_BOTTOM-10;horizalign,right;visible,GAMESTATE:IsSideJoined(PLAYER_1));
			OnCommand=cmd(visible,GAMESTATE:IsSideJoined(PLAYER_1));
		};
	end;

	for i=1,NumHeartsLeft[PLAYER_1] do
		t[#t+1] = LoadActor("heart_foreground") .. {
			--The order of diffuseshift matters! Make sure you put it BEFORE effectcolor1 and effectcolor2!
			InitCommand=cmd(zoom,0.5;x,heartXPos+i*16-heartsLength/2;y,SCREEN_BOTTOM-10;horizalign,right;diffuseshift;effectcolor1,color("#FFFFFF");effectcolor2,color("#FFFFFF");visible,GAMESTATE:IsSideJoined(PLAYER_1));
			--[[OnCommand=function(self)
				--Don't pulse the hearts anywhere else
				if SCREENMAN:GetTopScreen():GetName() == "ScreenSelectMusic" then
					self:playcommand("CurrentSongChangedMessage");
				end
			end;]]
			CurrentSongChangedMessageCommand=function(self)
				if i > NumHeartsLeft[PLAYER_1]-GetNumHeartsForSong() then
					self:effectcolor1(color("#7e7e7e"))
				else
					self:effectcolor1(color("#FFFFFF"))
				end;
			end;
		};
	end;
else
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(xy,heartXPos-56,SCREEN_BOTTOM-10;visible,GAMESTATE:IsSideJoined(PLAYER_1));
		
		LoadActor("heart_foreground")..{
			InitCommand=cmd(zoom,.5;);
		};
		LoadFont("common normal")..{
			Text="x"..NumHeartsLeft[PLAYER_1];
			InitCommand=cmd(zoom,.5;horizalign,left;addx,7);
		};
	};
end;

t[#t+1] = Def.ActorFrame {

	InitCommand=cmd(x,5;y,SCREEN_BOTTOM-18;);
	OnCommand=cmd(visible,GAMESTATE:IsSideJoined(PLAYER_1));
	ScreenChangedMessageCommand=cmd(playcommand,"On");
	PlayerJoinedMessageCommand=cmd(playcommand,"On");
	CoinInsertedMessageCommand=cmd(playcommand,"On");
	CoinModeChangedMessageCommand=cmd(playcommand,"On");
	ScreenChangedMessageCommand=cmd(playcommand,"On");
	StorageDevicesChangedMessageCommand=cmd(playcommand,"On");

	LoadActor("p1_indicator") .. {
		InitCommand=cmd(horizalign,left;zoom,.75;addy,1;);
	};
	LoadActor("avatars/blank") .. {
		InitCommand=cmd(zoom,1;addx,35;horizalign,left;);
		OnCommand=function(self)
			self:Load(getenv("profile_icon_P1"));
			self:setsize(30,30);
		end;
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");

	};

	LoadFont("Common Normal")..{
		Condition=(DoDebug and GAMESTATE:IsSideJoined(PLAYER_1));
		InitCommand=function(self)
			self:zoom(.5):horizalign(left):addx(100):addy(-10);
			self:settext("Icon: "..getenv("profile_icon_P1").." Setting: "..tostring(ActiveModifiers["P1"]['ProfileIcon']));
			--self:settext(THEME:GetPathG("","USB_stuff/avatars").."/"..ActiveModifiers["P1"]["ProfileIcon"]);
		end;
	};
	
	PlayerName(PLAYER_1)..{
		InitCommand=cmd(zoom,0.8;addx,68;addy,7;horizalign,left;);
	};

	--[[LoadActor("level") .. {
		InitCommand=cmd(zoom,0.6;x,213;y,SCREEN_BOTTOM-15;horizalign,left;);
	};]]
	
	PlayerLevel(PLAYER_1)..{
		InitCommand=cmd(zoom,0.45;addx,68;addy,-7;horizalign,left;);
	};
	
	
}



t[#t+1] = Def.ActorFrame{


--################# PLAYER 2 ##############
	InitCommand=cmd(xy,SCREEN_RIGHT-5,SCREEN_BOTTOM-18;visible,GAMESTATE:IsSideJoined(PLAYER_2));

	LoadActor("p2_indicator") .. {
		InitCommand=cmd(zoom,.75;addy,.5;horizalign,right;);
		OnCommand=cmd(playcommand,"Init");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};
	LoadActor("avatars/blank") .. {
		InitCommand=cmd(zoom,1;addx,-35;horizalign,right;draworder,350;);
		OnCommand=function(self)
			self:Load(getenv("profile_icon_P2"));
			self:setsize(30,30);
		end;
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");

	};
	LoadFont("Common Normal")..{
		Condition=(DoDebug and GAMESTATE:IsSideJoined(PLAYER_2));
		InitCommand=function(self)
			self:zoom(.5):horizalign(left):addx(-500):addy(-10);
			if PROFILEMAN:ProfileWasLoadedFromMemoryCard(PLAYER_2) then
				local dir = PROFILEMAN:GetProfileDir('ProfileSlot_Player2')
				--self:settext(dir.." "..boolToString(FILEMAN:DoesFileExist(dir.."avatar.png")));
				local listing = FILEMAN:GetDirListing(dir)
				self:settext(strArrayToString(listing))
			else
				self:settext("Icon: "..getenv("profile_icon_P2").." Setting: "..tostring(ActiveModifiers["P2"]['ProfileIcon']));
			end;
			--self:settext(THEME:GetPathG("","USB_stuff/avatars").."/"..ActiveModifiers["P1"]["ProfileIcon"]);
		end;
	};
	
	PlayerName(PLAYER_2)..{
		InitCommand=cmd(zoom,0.8;addx,-68;addy,7;horizalign,right;);
		OnCommand=cmd(playcommand,"Set");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};
	
	--[[LoadActor("level") .. {
		InitCommand=cmd(visible,GAMESTATE:IsSideJoined(PLAYER_2);zoom,0.6;x,SCREEN_CENTER_X+102;y,SCREEN_BOTTOM-15;horizalign,right;);
		OnCommand=cmd(playcommand,"Init");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};]]

	PlayerLevel(PLAYER_2)..{
		InitCommand=cmd(zoom,0.45;addx,-68;addy,-7;horizalign,right;);
		OnCommand=cmd(playcommand,"Set");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};

}

--P2 HEARTS
if IsUsingWideScreen() then
	for i=1,HeartsPerPlay do
		t[#t+1] = LoadActor("heart_background") .. {
			InitCommand=cmd(zoom,0.5;x,(SCREEN_RIGHT-heartXPos)+i*16-heartsLength/2;y,SCREEN_BOTTOM-10;horizalign,right;visible,GAMESTATE:IsSideJoined(PLAYER_2));
			OnCommand=cmd(visible,GAMESTATE:IsSideJoined(PLAYER_2));
		};
	end;

	for i=1,NumHeartsLeft[PLAYER_2] do
		t[#t+1] = LoadActor("heart_foreground") .. {
			InitCommand=cmd(zoom,0.5;x,(SCREEN_RIGHT-heartXPos)+i*16-heartsLength/2;y,SCREEN_BOTTOM-10;horizalign,right;diffuseshift;effectcolor1,color("#FFFFFF");effectcolor2,color("#FFFFFF");visible,GAMESTATE:IsSideJoined(PLAYER_2));
			CurrentSongChangedMessageCommand=function(self)
				if i > NumHeartsLeft[PLAYER_2]-GetNumHeartsForSong() then
					self:effectcolor1(color("#7e7e7e"))
				else
					self:effectcolor1(color("#FFFFFF"))
				end;
			end;
		};
	end;
else
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(xy,SCREEN_RIGHT-heartXPos+46,SCREEN_BOTTOM-10;visible,GAMESTATE:IsSideJoined(PLAYER_2));
		
		LoadActor("heart_foreground")..{
			InitCommand=cmd(zoom,.5;);
		};
		LoadFont("common normal")..{
			Text="x"..NumHeartsLeft[PLAYER_2];
			InitCommand=cmd(zoom,.5;horizalign,left;addx,7);
		};
	};
end;

--Yeah yeah I'll move it later
if showP1BonusMessage then
	t[#t+1] = LoadFont("Common Normal")..{
		Text=THEME:GetString("ScreenEvaluation", "AchievedBonusHeart");
		InitCommand=cmd(xy,heartXPos,SCREEN_BOTTOM-27;zoom,.5);
	};
end;
if showP2BonusMessage then
	t[#t+1] = LoadFont("Common Normal")..{
		Text=THEME:GetString("ScreenEvaluation", "AchievedBonusHeart");
		InitCommand=cmd(xy,(SCREEN_RIGHT-heartXPos),SCREEN_BOTTOM-27;zoom,.5);
	};
end;

return t;
