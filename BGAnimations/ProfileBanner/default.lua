
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
	return LoadFont("facu/_zona pro bold 40px")..{
		InitCommand=function(self)
			self:skewx(-.2)
			--self:settext("bla");
			local name = PROFILEMAN:GetPlayerName(player)
			--SCREENMAN:SystemMessage(name)
			
			--If no USB
			if MEMCARDMAN:GetCardState(player) == 'MemoryCardState_none' then
				--If name is blank, it's probably the machine profile... After all, the name entry screen doesn't allow blank names.
				if name == "" then		
					if player == PLAYER_1 then
						self:settext("PLAYER 1");
					else
						self:settext("PLAYER 2");
					end;
				else
					--TODO: Adjust maxwidth based on the number of hearts per play.
					self:settext(string.upper(name)):maxwidth(200);
				end
			else
				if state == 'MemoryCardState_removed' then
					self:settext("CARD REMOVED")
				elseif state == "MemoryCardState_error" then
					self:settext("CARD ERROR")
				else
					self:settext(string.upper(name)):maxwidth(200);
				end;
			end
			
		end;
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
			--Mixtapes mode is all hearts, but special mode is only 3 hearts
			CurrentCourseChangedMessageCommand=function(self)
				--why the FUCK does ScreenSelectMusic broadcast CurrentCourseChanged when it's not changing the course?
				if not GAMESTATE:IsCourseMode() then return end;
				if getenv("PlayMode") == "Mixtapes" then
					self:effectcolor1(color("#7e7e7e"))
				elseif i > NumHeartsLeft[PLAYER_1]-3 then
					self:effectcolor1(color("#7e7e7e"))
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

if GAMESTATE:IsSideJoined(PLAYER_1) then
	t[#t+1] = Def.ActorFrame {

		InitCommand=cmd(x,5;y,SCREEN_BOTTOM-18;);

		LoadActor("p1_indicator") .. {
			InitCommand=cmd(horizalign,left;zoom,.75;addy,1;);
		};
		Def.Sprite{
			Texture=getenv("profile_icon_P1");
			InitCommand=cmd(zoom,1;addx,35;horizalign,left;setsize,30,30);
		};
		LoadFont("Common Normal")..{
			Condition=(DoDebug and GAMESTATE:IsSideJoined(PLAYER_1));
			InitCommand=function(self)
				self:zoom(.5):horizalign(left):addx(100):addy(-10);
				if getenv("profile_icon_P1") then
					self:settext("Icon: "..getenv("profile_icon_P1").." Setting: "..tostring(ActiveModifiers["P1"]['ProfileIcon']));
				else
					
					self:settext("Icon: None (profile_icon_P1 is nil)");
				end;
				
			end;
		};
		PlayerName(PLAYER_1)..{
			InitCommand=cmd(zoom,0.5;addx,68;addy,7;horizalign,left;);
		};
		PlayerLevel(PLAYER_1)..{
			InitCommand=cmd(zoom,0.45;addx,68;addy,-7;horizalign,left;);
		};
	}
	
	--[[t[#t+1] = LoadActor("alternate",PLAYER_1)..{
		InitCommand=cmd(zoom,.75;xy,250/2-28,SCREEN_BOTTOM-22;);
		OnCommand=cmd(addy,55;decelerate,0.5;addy,-55;diffusealpha,1);
		OffCommand=cmd(decelerate,0.5;addy,55;diffusealpha,0);
	};]]
end;


t[#t+1] = Def.ActorFrame{


--################# PLAYER 2 ##############
	Condition=GAMESTATE:IsSideJoined(PLAYER_2);
	InitCommand=cmd(xy,SCREEN_RIGHT-5,SCREEN_BOTTOM-18;);

	LoadActor("p2_indicator") .. {
		InitCommand=cmd(zoom,.75;addy,.5;horizalign,right;);
	};
	Def.Sprite{
		Texture=THEME:GetPathG("ProfileBanner","avatars/blank");
		InitCommand=cmd(zoom,1;addx,-35;horizalign,right;draworder,350;);
		OnCommand=function(self)
			self:Load(getenv("profile_icon_P2"));
			self:setsize(30,30);
		end;

	};
	LoadFont("Common Normal")..{
		Condition=DoDebug;
		InitCommand=function(self)
			self:zoom(.5):horizalign(left):addx(-500):addy(-10);
			if PROFILEMAN:ProfileWasLoadedFromMemoryCard(PLAYER_2) then
				local dir = PROFILEMAN:GetProfileDir('ProfileSlot_Player2')
				--self:settext(dir.." "..boolToString(FILEMAN:DoesFileExist(dir.."avatar.png")));
				local listing = FILEMAN:GetDirListing(dir)
				self:settext(dir)
			else
				self:settext("Icon: "..getenv("profile_icon_P2").." Setting: "..tostring(ActiveModifiers["P2"]['ProfileIcon']));
			end;
			--self:settext(THEME:GetPathG("","USB_stuff/avatars").."/"..ActiveModifiers["P1"]["ProfileIcon"]);
		end;
	};
	
	PlayerName(PLAYER_2)..{
		InitCommand=cmd(zoom,0.5;addx,-68;addy,7;horizalign,right;);
	};

	PlayerLevel(PLAYER_2)..{
		InitCommand=cmd(zoom,0.45;addx,-68;addy,-7;horizalign,right;);
	};

}

--P2 HEARTS
if GAMESTATE:IsSideJoined(PLAYER_2) then
	if IsUsingWideScreen() then
		for i=1,HeartsPerPlay do
			t[#t+1] = LoadActor("heart_background") .. {
				InitCommand=cmd(zoom,0.5;x,(SCREEN_RIGHT-heartXPos)+i*16-heartsLength/2;y,SCREEN_BOTTOM-10;horizalign,right;);
			};
		end;

		for i=1,NumHeartsLeft[PLAYER_2] do
			t[#t+1] = LoadActor("heart_foreground") .. {
				InitCommand=cmd(zoom,0.5;x,(SCREEN_RIGHT-heartXPos)+i*16-heartsLength/2;y,SCREEN_BOTTOM-10;horizalign,right;diffuseshift;effectcolor1,color("#FFFFFF");effectcolor2,color("#FFFFFF"););
				CurrentSongChangedMessageCommand=function(self)
					if i > NumHeartsLeft[PLAYER_2]-GetNumHeartsForSong() then
						self:effectcolor1(color("#7e7e7e"))
					else
						self:effectcolor1(color("#FFFFFF"))
					end;
				end;
				CurrentCourseChangedMessageCommand=function(self)
					if not GAMESTATE:IsCourseMode() then return end;
					if getenv("PlayMode") == "Mixtapes" then
						self:effectcolor1(color("#7e7e7e"))
					elseif i > NumHeartsLeft[PLAYER_1]-3 then
						self:effectcolor1(color("#7e7e7e"))
					end;
				end;
			};
		end;
	else
		t[#t+1] = Def.ActorFrame{
			InitCommand=cmd(xy,SCREEN_RIGHT-heartXPos+46,SCREEN_BOTTOM-10;);
			
			LoadActor("heart_foreground")..{
				InitCommand=cmd(zoom,.5;);
			};
			LoadFont("common normal")..{
				Text="x"..NumHeartsLeft[PLAYER_2];
				InitCommand=cmd(zoom,.5;horizalign,left;addx,7);
			};
		};
	end;
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
