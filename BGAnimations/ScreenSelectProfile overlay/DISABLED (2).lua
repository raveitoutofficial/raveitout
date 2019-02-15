--[[
This script was taken from KENp's DDR X2 theme
and was recoded by FlameyBoy and Inorizushi
...And then adapted to IIDX by ARC.

Does the code make no sense? I can't understand it either!
]]--


local ProfileInfoCache = {}
setmetatable(ProfileInfoCache, {__index =
function(table, ind)
    local out = {}
    local prof = PROFILEMAN:GetLocalProfileFromIndex(ind-1)
    out.SongsAndCoursesPercentCompleteAllDifficultiesSingle = prof:GetSongsAndCoursesPercentCompleteAllDifficulties('StepsType_Dance_Single')
    out.SongsAndCoursesPercentCompleteAllDifficultiesDouble = prof:GetSongsAndCoursesPercentCompleteAllDifficulties('StepsType_Dance_Double')
    out.TotalCaloriesBurned = prof:GetTotalCaloriesBurned()
    out.CaloriesBurnedToday = prof:GetCaloriesBurnedToday()
    out.LastPlayedSong = prof:GetLastPlayedSong()
    out.DisplayName = prof:GetDisplayName()
    out.NumTotalSongsPlayed = prof:GetNumTotalSongsPlayed()
    out.UserTable = prof:GetUserTable()
    rawset(table, ind, out)
    return out
end
})


function LoadPlayerStuff(Player)

	--This is the card. It's pretty much always shown.
	local t = Def.ActorFrame {
		
		LoadActor("frame1")..{
			InitCommand=cmd(diffuse,PlayerColor(Player));
		};
		
		LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/frame_"..ToEnumShortString(Player)))..{
			InitCommand=cmd(y,-252;);
		};
	};
	
	local pn = (Player == PLAYER_1) and 1 or 2;


	--Only displayed if player is not joined.
	t[#t+1] = Def.ActorFrame {
		Name = 'JoinFrame';
		
		LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/cab_join_overlay_"..ToEnumShortString(Player)))..{
			InitCommand=function(self)
				self:y(10);
				self:cropbottom(.004);
				self:diffusealpha(.5);
				if Player == PLAYER_1 then
					self:x(280*1.5);
					self:horizalign(right);
					self:cropright(.5);
				else
					self:x(-280*1.5);
					self:horizalign(left);
					self:cropleft(.5);
				end;
			end;
			OnCommand=function(self)
				self:decelerate(1);
				self:diffusealpha(1);
				if Player == PLAYER_2 then
					self:x(-280);
					self:cropleft(0);
				else
					self:x(280);
					self:cropright(0);
				end;
			end;
					
		};
		
		--[[LoadActor( THEME:GetPathG("ScreenSelectProfile","Graphics/Press Start") ) .. {
			OnCommand=cmd(diffuseshift;effectperiod,2;effectcolor1,color("1,1,1,1");effectcolor2,color("1,1,1,0"));
		};]]
		Def.ActorFrame {
			Name = 'JoinFrame';
			--OnCommand=cmd(diffuseshift;effectperiod,2;effectcolor1,color("1,1,1,1");effectcolor2,color("1,1,1,0"));
			LoadFont("monsterrat/_montserrat semi bold 60px") .. {
				Text="PRESS         OR       \nTO JOIN THE RAVE.";
				InitCommand=cmd(uppercase,true;skewx,-0.2;zoom,.9);
				OnCommand=cmd(diffuse,Color('White');strokecolor,Color("Black"));
			};
				LoadActor("Center Tap Note 3x2")..{
				InitCommand=cmd(x,200;y,-33;);
			};
				LoadActor("start")..{
				InitCommand=cmd(x,10;y,-33;);
			};
		};


	};

	--Displayed if the player is joined.
	t[#t+1] = Def.ActorFrame {
		Name = 'BigFrame';
		
		--Banner thingy
		Def.ActorFrame{
			LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/top banner/banner"))..{
				InitCommand=cmd(y,-210;);
			};
		
		};
		
		Def.ActorScroller{
			Name="playdata_pages";
			-- (float) Number of items to have visible at one time.
			-- ScrollThroughAllItems divides this value by 2.
			NumItemsToDraw=2, -- Default value is 7 if this parameter is omitted.

			-- (float) The number of seconds to show each item.
			SecondsPerItem=.3, -- Default value is 1 if this parameter is omitted.

			-- Transforms the ActorScroller's children. Usually used for scrolling.
			-- The most important part of an ActorScroller.

			-- "offset" represents the offset from the center of the scroller.
			TransformFunction=function(self,offset,itemIndex,numItems)
				self:xy(550*offset,20);
				--Sadly, doesn't work
				self:cropleft(math.abs(1));
				self:cropright(math.abs(1));
				--SCREENMAN:SystemMessage(ListActorChildren(self));
				--self:GetChild('pd_graphic'):cropleft(math.abs(offset));
				
				if math.abs(offset) < 1 then
					self:diffusealpha(math.cos(offset*math.pi));
				else
					self:diffusealpha(0);
				end;
			end,

			-- children (items to scroll)
			-- CAVEAT: BitmapTexts have to be wrapped in ActorFrames in order to be colored.
			-- This is a long standing issue (ITG? ITG2?)
			Def.ActorFrame{
				Name="page1";
				--It does nothing!!
				--OnCommand=cmd(diffusealpha,0);
				LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/playdata_page1 (stretch).png"))..{
					Name="pd_graphic";
					--InitCommand=cmd(diffusealpha,0);
				};
				
				--[[
				This is the important profile information.
				It gets loaded here, but it gets set at/from UpdateInternal3.
				]]
				LoadFont("Login 36px")..{
					Name="PlayerName";
					--Text="Hello World!";
					InitCommand=cmd(horizalign,right;xy,250,-197);
				
				};
			
				LoadFont("Login 36px")..{
					Name="PlayerID";
					--Text="0108-9999";
					InitCommand=cmd(horizalign,right;xy,250,-155);
				
				};
				
				LoadFont("Login 36px")..{
					Name="PlayerNumSongs";
					--Text="573";
					InitCommand=cmd(horizalign,right;xy,205,40);
				
				};
			
			};
			Def.ActorFrame{
				Name="page2";
				LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/playdata_page2"))..{};
			
			};
			--Single rival
			Def.ActorFrame{
				Name="page3";
				LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/playdata_page3"))..{};
			
			};
			--Double rival
			Def.ActorFrame{
				Name="page4";
				LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/playdata_page3"))..{};
			
			};


			-- Scroller commands
			--InitCommand=cmd(Center),
			--InitCommand=cmd(SetMask,0,0);
			OnCommand=function(self)
				--difficultyScroller = self;
				--self:SetMask(-99,-99);
			end;
			--Turns out nobody will ever use this, so... It's not gonna be used.
			--[[CodeMessageCommand=
				function(self, param)
					if param.Name == "Left" then
						if self:GetDestinationItem() > 0 then
							self:SetDestinationItem(self:GetDestinationItem()-1);
						end;
					elseif param.Name == "Right" then
						if self:GetDestinationItem() < self:GetNumItems()-1 then
							self:SetDestinationItem(self:GetDestinationItem()+1);
						end;
					elseif param.Name == "Up" then
						--SCREENMAN:SystemMessage(self:GetCurrentItem());
						--SCREENMAN:SystemMessage(ListActorChildren(self))
						
					end;
					SOUND:PlayOnce(THEME:GetPathS("Common", "value"), true);
					--SCREENMAN:SystemMessage(param.Name);
				end;]]
				
		};
		
		
		
		
		LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/playdata_cover_"..ToEnumShortString(Player)))..{
			InitCommand=cmd(y,10;);
			OnCommand=cmd(zoomy,1;diffusealpha,1;sleep,1;decelerate,.2;zoomy,0;diffusealpha,0);
			--OffCommand=cmd(zoomy,1);
			PlayerJoinedMessageCommand=function(self, param)
				if param.Player == Player then
					self:finishtweening();
					self:queuecommand("On");
				end;
			end;
		};
		
		
		LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/operate_game_start"))..{
			InitCommand=cmd(y,290);
		};
				
		LoadActor(THEME:GetPathS("ScreenSelectProfile","CardReady"))..{
			OnCommand=cmd(sleep,1;queuecommand,"PlaySound");
			PlayerJoinedMessageCommand=cmd(sleep,1;queuecommand,"PlaySound");
			PlaySoundCommand=cmd(play)
		};
	
	};
	
	--I guess you can switch between profiles with this scroller?
	t[#t+1] = Def.ActorScroller{
		Name = 'Scroller';
		NumItemsToDraw=1;

		OnCommand=cmd(draworder,1000;y,5;SetFastCatchup,true;SetMask,0,58;SetSecondsPerItem,0.15);
		TransformFunction=function(self, offset, itemIndex, numItems)
			local focus = scale(math.abs(offset),0,2,1,0);
			self:visible(false);
			self:y(math.floor( offset*40 ));

		end;
		OffCommand=cmd(linear,0.3;zoomy,0;diffusealpha,0);
	};


	--???
	t[#t+1] = Def.ActorFrame {
		Name = "EffectFrame";
	};



	return t;
end;

--This monstrous command updates everything when a player joins or leaves or switches profiles
function UpdateInternal3(self, Player)

	local pn = (Player == PLAYER_1) and 1 or 2;
	--Frames
	local frame = self:GetChild(string.format('P%uFrame', pn));
	local scroller = frame:GetChild('Scroller');
	local joinframe = frame:GetChild('JoinFrame');
	local bigframe = frame:GetChild('BigFrame');
	--Profile stuff
	local playdata_pages = bigframe:GetChild('playdata_pages');
	local playerName = playdata_pages:GetChild('page1'):GetChild("PlayerName");
	local playerID = playdata_pages:GetChild('page1'):GetChild("PlayerID");
	local playerNumSongs = playdata_pages:GetChild('page1'):GetChild("PlayerNumSongs");
	if GAMESTATE:IsHumanPlayer(Player) then
		frame:visible(true);
		if MEMCARDMAN:GetCardState(Player) == 'MemoryCardState_none' then
			--using profile if any
			joinframe:visible(false);
			bigframe:visible(false);
			--seltext:visible(true);

			local ind = SCREENMAN:GetTopScreen():GetProfileIndex(Player);


			if ind > 0 then --If profile
				local profile = PROFILEMAN:GetLocalProfileFromIndex(ind-1);
				bigframe:visible(true);
				scroller:SetDestinationItem(ind-1);
				playerName:settext(ProfileInfoCache[ind].DisplayName);
				selPlayerUID = PROFILEMAN:GetLocalProfileFromIndex(ind-1):GetGUID();
				playerID:settext(string.upper(string.sub(selPlayerUID,1,4).."-"..string.sub(selPlayerUID,5,8)));
				playerNumSongs:settext(tostring(math.ceil(ProfileInfoCache[ind].NumTotalSongsPlayed)));

			--If there are no profiles
			else
				if SCREENMAN:GetTopScreen():SetProfileIndex(Player, 1) then
					bigframe:visible(false);
					scroller:SetDestinationItem(0);
					self:queuecommand('UpdateInternal2');
				else
					joinframe:visible(false);
					bigframe:visible(false);
					scroller:visible(false);
					--seltext:settext('No profile');
					--selectPlayerUID:settext('------------');
          
				end;
			end;
		else
			--using card
			smallframe:visible(false);
			scroller:visible(false);
			--seltext:settext('CARD');
			SCREENMAN:GetTopScreen():SetProfileIndex(Player, 0);
		end;
	else
		joinframe:visible(true);
		scroller:visible(false);
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
		if params.Name == 'Up' or params.Name == 'Up2' or params.Name == 'DownLeft' then
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
		if params.Name == 'Down' or params.Name == 'Down2' or params.Name == 'DownRight' then
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
		
		
		--[[Def.ActorFrame{
			LoadActor( THEME:GetPathG("ScreenSelectProfile","Graphics/CardBackground_"..ToEnumShortString(PLAYER_1)) ) .. {
				InitCommand=cmd(x,SCREEN_CENTER_X-320;y,SCREEN_CENTER_Y;);
			};
			
			LoadActor( THEME:GetPathG("ScreenSelectProfile","Graphics/CardBackground_"..ToEnumShortString(PLAYER_2)) ) .. {
				InitCommand=cmd(x,SCREEN_CENTER_X+320;y,SCREEN_CENTER_Y;);
			};
		};]]
		
		Def.ActorFrame {
		
			Name = 'P1Frame';
			InitCommand=cmd(x,SCREEN_CENTER_X/2;y,SCREEN_CENTER_Y;zoom,.7);
			OnCommand=cmd(--[[queuecommand,"Animate";]]sleep,8);
			OffCommand=cmd();
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_1 then
					--self:queuecommand("Animate");
				end;
			end;
			AnimateCommand=cmd(finishtweening;zoomy,0;linear,.5;zoomy,1);
			
			children = LoadPlayerStuff(PLAYER_1);
		};
		Def.ActorFrame {
			Name = 'P2Frame';
			InitCommand=cmd(x,SCREEN_WIDTH*.75;y,SCREEN_CENTER_Y;zoom,.7);
			OnCommand=cmd(sleep,8);
			OffCommand=cmd();
			--[[PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_2 then
					(cmd(zoomx,1;zoomy,0.15;linear,0.175;zoomy,1;))(self);
				end;
			end;]]
			children = LoadPlayerStuff(PLAYER_2);
		};
		
		-- sounds

		--[[LoadActor( THEME:GetPathS("Common","start") )..{
			StartButtonMessageCommand=cmd(play);
		};
		LoadActor( THEME:GetPathS("","Profile_start") )..{
			StartButtonMessageCommand=cmd(play);
		};
		LoadActor( THEME:GetPathS("Common","cancel") )..{
			BackButtonMessageCommand=cmd(play);
		};
		LoadActor( THEME:GetPathS("ScreenSelectProfile","Move") )..{
			DirectionButtonMessageCommand=cmd(play);
		};]]
	};
};


return t;
