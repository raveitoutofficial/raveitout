local function PlayerLevel(player)

--return LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
return LoadFont("common normal")..{
	SetCommand=function(self)
	local profile = PROFILEMAN:GetProfile(player);
	local level = profile:GetTotalNumSongsPlayed();
	local uplevelfactor = 25;
	local maxlevelnum = 99;
	
		if player == PLAYER_1 then
		currentplayer = "p1"
		else
		currentplayer = "p2"
		end
	
	--	if MEMCARDMAN:GetCardState(player) == 'MemoryCardState_none' then
		--	setenv("level_"..currentplayer,"??");
		--else
		
			--level = 4951;
			if level < uplevelfactor*10 then
				setenv("level_"..currentplayer,"0"..math.ceil(level/uplevelfactor));
			elseif level > uplevelfactor*maxlevelnum then
				setenv("level_"..currentplayer,"??");
			else
				setenv("level_"..currentplayer,math.ceil(level/uplevelfactor));
			end			
		--end
		
		if DevMode() then
			self:settext(" ∞");
		else
			--self:settext("Lv."..getenv("level_"..currentplayer).." / Life: "..string.format("%02i",GAMESTATE:GetNumStagesLeft(player)));
			self:settext(getenv("level_"..currentplayer));
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

t = Def.ActorFrame {

	LoadActor("avatars/blank") .. {
		InitCommand=cmd(zoom,1;x,SCREEN_CENTER_X-293;y,SCREEN_BOTTOM-15;horizalign,left;draworder,350;);
		OnCommand=function(self)
			self:visible(GAMESTATE:IsSideJoined(PLAYER_1));
			self:Load(getenv("profile_icon_P1"));
			self:setsize(20,20);
		end;
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");

	};

	LoadActor("p1_indicator") .. {
		InitCommand=cmd(zoomx,0.55;zoomy,0.52;x,SCREEN_CENTER_X-318;y,SCREEN_BOTTOM-15;horizalign,left;visible,GAMESTATE:IsSideJoined(PLAYER_1));
		OnCommand=cmd(playcommand,"Init");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};
	
	PlayerName(PLAYER_1)..{
		InitCommand=cmd(zoom,0.55;x,SCREEN_CENTER_X-270;y,SCREEN_BOTTOM-15;horizalign,left;visible,GAMESTATE:IsSideJoined(PLAYER_1));
		OnCommand=cmd(playcommand,"Set");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};

	LoadActor("level") .. {
		InitCommand=cmd(visible,GAMESTATE:IsSideJoined(PLAYER_1);zoom,0.6;x,SCREEN_CENTER_X-105;y,SCREEN_BOTTOM-15;horizalign,left;);
		OnCommand=cmd(playcommand,"Init");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};
	
	PlayerLevel(PLAYER_1)..{
		InitCommand=cmd(zoom,0.45;x,SCREEN_CENTER_X-85;y,SCREEN_BOTTOM-15;horizalign,left;visible,GAMESTATE:IsSideJoined(PLAYER_1));
		OnCommand=cmd(playcommand,"Set");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};


--################# PLAYER 2 ##############

	LoadActor("avatars/blank") .. {
		InitCommand=cmd(zoom,1;x,SCREEN_CENTER_X+293;y,SCREEN_BOTTOM-15;horizalign,right;draworder,350;);
		OnCommand=function(self)
			self:visible(GAMESTATE:IsSideJoined(PLAYER_2));
			self:Load(getenv("profile_icon_P2"));
			self:setsize(20,20);
		end;
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");

	};

	LoadActor("p2_indicator") .. {
		InitCommand=cmd(zoomx,0.55;zoomy,0.52;x,SCREEN_CENTER_X+318;y,SCREEN_BOTTOM-15;horizalign,right;visible,GAMESTATE:IsSideJoined(PLAYER_2));
		OnCommand=cmd(playcommand,"Init");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};
	
	PlayerName(PLAYER_2)..{
		InitCommand=cmd(maxwidth,100;zoom,0.55;x,SCREEN_CENTER_X+270;y,SCREEN_BOTTOM-15;horizalign,right;visible,GAMESTATE:IsSideJoined(PLAYER_2));
		OnCommand=cmd(playcommand,"Set");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};
	
	LoadActor("level") .. {
		InitCommand=cmd(visible,GAMESTATE:IsSideJoined(PLAYER_2);zoom,0.6;x,SCREEN_CENTER_X+102;y,SCREEN_BOTTOM-15;horizalign,right;);
		OnCommand=cmd(playcommand,"Init");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};

	PlayerLevel(PLAYER_2)..{
		InitCommand=cmd(zoom,0.45;x,SCREEN_CENTER_X+102;y,SCREEN_BOTTOM-15;horizalign,right;visible,true);
		OnCommand=cmd(playcommand,"Set");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};
	
}
local total = GetMaxLife();

local diff = total*1.66;

--P1 HEARTS
for i=1,total do
	t[#t+1] = LoadActor("heart_background") .. {
		InitCommand=cmd(zoom,0.5;x,SCREEN_CENTER_X-205-diff+i*16;y,SCREEN_BOTTOM-15;horizalign,right;visible,GAMESTATE:IsSideJoined(PLAYER_1));
		OnCommand=cmd(visible,GAMESTATE:IsSideJoined(PLAYER_1));
	};
end;

for i=1,GAMESTATE:GetNumStagesLeft(PLAYER_1) do
	t[#t+1] = LoadActor("heart_foreground") .. {
		InitCommand=cmd(zoom,0.5;x,SCREEN_CENTER_X-205-diff+i*16;y,SCREEN_BOTTOM-15;horizalign,right;visible,GAMESTATE:IsSideJoined(PLAYER_1);playcommand,"Blink");
		BlinkCommand=cmd(diffuseshift;effectcolor1,color("#7e7e7e");effectcolor2,color("#FFFFFF"););
		OnCommand=cmd(visible,GAMESTATE:IsSideJoined(PLAYER_1));
	};
end;	


--P2 HEARTS
for i=1,total do
	t[#t+1] = LoadActor("heart_background") .. {
		InitCommand=cmd(zoom,0.5;x,SCREEN_CENTER_X+205+diff-i*16;y,SCREEN_BOTTOM-15;horizalign,left;visible,GAMESTATE:IsSideJoined(PLAYER_2));
		OnCommand=cmd(visible,GAMESTATE:IsSideJoined(PLAYER_2));
	};
end;

for i=1,GAMESTATE:GetNumStagesLeft(PLAYER_2) do
	t[#t+1] = LoadActor("heart_foreground") .. {
		InitCommand=cmd(zoom,0.5;x,SCREEN_CENTER_X+205+diff-i*16;y,SCREEN_BOTTOM-15;horizalign,left;visible,GAMESTATE:IsSideJoined(PLAYER_2);playcommand,"Blink");
		BlinkCommand=cmd(diffuseshift;effectcolor1,color("#7e7e7e");effectcolor2,color("#FFFFFF"););
		OnCommand=cmd(visible,GAMESTATE:IsSideJoined(PLAYER_2));
	};
end;	

return t;
