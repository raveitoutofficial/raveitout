local defaultzoom = 0.55;
local distance = IsUsingWideScreen() and SCREEN_WIDTH/5 or SCREEN_WIDTH/3;
local shine_index = 1;
if IsUsingWideScreen() then
	default_width = SCREEN_WIDTH+20
else
	default_width = SCREEN_WIDTH
end;

-- Game Mode Choices
local Choices = {
	"easy",
	"arcade",
	"pro",
	-- placeholder as there's no sound yet
	"mixtapes",
	"special",
};

local ChoiceText = {
	"Easiest Choice. Specially selected songs for those new to rhythm games.",
	"Standard Choice. Choose from over 200 popular tracks.",
	"Advanced Choice. Timing will be stricter. Great for competitive play.",
	"Play through various sets of songs with no breaks in between.",
	"Simple songs aren't enough... let's try some weird stuff...",
};

local t = Def.ActorFrame{}

local Static = Def.ActorFrame{
	LoadActor("fade")..{ InitCommand=function(self) self:FullScreen() end; };

	Def.ActorFrame{ OnCommand=function(self) self:CenterX() end;
		LoadActor("top")..{ InitCommand=function(self) self:valign(0):zoom(0.6) end; };		
		LoadActor("layer")..{ InitCommand=function(self) self:y(2):valign(0):zoom(0.66); end; };
		LoadFont("monsterrat/_montserrat light 60px")..{	
			Text="SELECT YOUR GAMEMODE",
			InitCommand=function(self) self:y(11):zoom(0.35):skewx(-.15) end;  };
	};
};

t[#t+1] = Static;

t[#t+1] = Def.ActorFrame{

	OnCommand=function(self)
		if not RIO_FOLDER_NAMES["DefaultArcadeFolder"] then
			groups = getAvailableGroups();
			--TODO: Is this global or something? What's going on?
			total_arcade_folders = #groups;
			RIO_FOLDER_NAMES["DefaultArcadeFolder"] = groups[math.random(2,total_arcade_folders)];
			
			--What?
			--if RIO_FOLDER_NAMES["DefaultArcadeFolder"] == groups[1] then RIO_FOLDER_NAMES["DefaultArcadeFolder"] = groups[7]; end;
		end;
	end;

	OffCommand=function(self)
		
		PREFSMAN:SetPreference("AllowW1",'AllowW1_Never');
		WriteGamePrefToFile("DefaultFail","");
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			GAMESTATE:ApplyGameCommand( "mod,3x,rio,30% mini;", pn );
		end
		setenv("StageBreak",true);
		--[[WritePrefToFile("UserPrefProtimingP1",false);
		WritePrefToFile("UserPrefProtimingP2",false);]]

		if SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 0 then
			-- Easy Mode
			setenv("PlayMode","Easy");
			setenv("HeaderTitle","SELECT MUSIC");
			folder = SONGMAN:GetSongsInGroup(RIO_FOLDER_NAMES["EasyFolder"]);
			randomSong = folder[math.random(1,#folder)]
			GAMESTATE:SetCurrentSong(randomSong);
			GAMESTATE:SetPreferredSong(randomSong);
		elseif SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 1 then
			-- Arcade Mode
			setenv("PlayMode","Arcade");
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
				folder = SONGMAN:GetSongsInGroup(RIO_FOLDER_NAMES["DefaultArcadeFolder"]);
				randomSong = folder[math.random(#folder)]
				GAMESTATE:SetCurrentSong(randomSong);
				GAMESTATE:SetPreferredSong(randomSong);
			else
				GAMESTATE:SetCurrentSong(lastPlayedSong);
			end;
		elseif SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 2 then
			-- Pro Mode
			setenv("HeaderTitle","SELECT MUSIC");
			setenv("PlayMode","Pro");
			
			--same as above
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
				folder = SONGMAN:GetSongsInGroup(RIO_FOLDER_NAMES["DefaultArcadeFolder"]);
				randomSong = folder[math.random(#folder)]
				GAMESTATE:SetCurrentSong(randomSong);
				GAMESTATE:SetPreferredSong(randomSong);
			else
				GAMESTATE:SetCurrentSong(lastPlayedSong);
			end;
			
			PREFSMAN:SetPreference("AllowW1",'AllowW1_Everywhere');
			--[[WritePrefToFile("UserPrefProtimingP1",false);
			WritePrefToFile("UserPrefProtimingP2",false);]]
			ActiveModifiers["P1"]["BGAMode"] = "Off"
			ActiveModifiers["P2"]["BGAMode"] = "Off"
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				GAMESTATE:ApplyGameCommand( "mod,3x,rhythm;", pn );
			end
		elseif SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 3 then
			-- Mixtapes Mode
			setenv("PlayMode","Mixtapes");
		elseif SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 4 then
			-- Special Mode
			local folder = SONGMAN:GetSongsInGroup(RIO_FOLDER_NAMES["SpecialFolder"]);
			local randomSong = folder[math.random(1,#folder)]
			GAMESTATE:SetCurrentSong(randomSong);
			GAMESTATE:SetPreferredSong(randomSong);
			setenv("PlayMode","Special");
		end
		
	end;

};

local SoundBank = Def.ActorFrame{ OnCommand=function(self) SBank = self; MESSAGEMAN:Broadcast("RefreshOption") end };
local ItemChoices = Def.ActorFrame{
	InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_BOTTOM+500;);
	OnCommand=cmd(sleep,0.3;decelerate,0.5;x,distance/2;y,SCREEN_CENTER_Y);
};
local ChoiceIntroPlayed = false

for i=1,#Choices do
	-- Choice Sound
	SoundBank[#SoundBank+1] = Def.Sound{
		Condition=FILEMAN:DoesFileExist( THEME:GetPathS("","PlayModes/"..Choices[i]) );
		File=THEME:GetPathS("","PlayModes/"..Choices[i]);
		Name=Choices[i];
		InitCommand=function(self)
			local ragesound_file = self:get()
			ragesound_file:volume(0.4)
			--TODO: Fix duplicated select game mode sound
			SOUND:PlayOnce( THEME:GetPathS("","PlayModes/select_game_mode") )
			self:sleep(1)
			self:queuecommand("IntroCheck")
		end;
		IntroCheckCommand=function(self) ChoiceIntroPlayed = true end;
		RefreshOptionMessageCommand=function(self)
			local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber());
			if ChoiceIntroPlayed then
				SBank:GetChild( Choices[sel+1] ):play()
			end
		end;
	};

	-- Choice Selection Sprite
	ItemChoices[#ItemChoices+1] = Def.ActorFrame{
		OnCommand=function(self) self:xy( -distance+distance*i,0 ) end;

		Def.Sprite{
			Texture=THEME:GetPathG("","PlayModes/"..Choices[i]);
			InitCommand=cmd(zoom,0.45);
			OffCommand=cmd(bouncebegin,0.4;zoom,0);
			RefreshOptionMessageCommand=function(self)
				local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())+1
				local match = (sel == i)
				self:stoptweening():stopeffect():decelerate(0.15)
				
				:zoom( sel == i and defaultzoom or 0.5 )
				:diffusealpha( match and 1 or 0.45 )
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

-- ALL ACTIONS
local Actions = Def.ActorFrame{
	MenuLeftP1MessageCommand=function(self) MESSAGEMAN:Broadcast("RefreshOption") end;
	MenuLeftP2MessageCommand=function(self) MESSAGEMAN:Broadcast("RefreshOption") end;
	MenuUpP1MessageCommand=function(self) MESSAGEMAN:Broadcast("RefreshOption") end;
	MenuUpP2MessageCommand=function(self) MESSAGEMAN:Broadcast("RefreshOption") end;
	MenuRightP1MessageCommand=function(self) MESSAGEMAN:Broadcast("RefreshOption") end;
	MenuRightP2MessageCommand=function(self) MESSAGEMAN:Broadcast("RefreshOption") end;
	MenuDownP1MessageCommand=function(self) MESSAGEMAN:Broadcast("RefreshOption") end;
	MenuDownP2MessageCommand=function(self) MESSAGEMAN:Broadcast("RefreshOption") end;
};

t[#t+1] = Actions;

-- Selector Sprite
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(y,SCREEN_BOTTOM+500;);
	OnCommand=cmd(sleep,0.3;decelerate,0.5;y,SCREEN_CENTER_Y);
		Def.Sprite{
		Texture="border_ani 6x6";
		InitCommand=cmd(zoom,defaultzoom+0.12;x,distance;SetAllStateDelays,0.03);
		OffCommand=cmd(bouncebegin,0.4;zoom,0);
		RefreshOptionMessageCommand=function(self)
			self:stoptweening();
			self:decelerate(0.15);
			self:zoom(defaultzoom+0.12);
			self:diffusealpha(1);
			self:pulse();
			self:effectmagnitude(1,1.05,1);
			self:effectperiod(1);
			self:x( distance*SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())+86 )
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
		self:settext( ChoiceText[sel+1] );
		end;

	};
};

--loading splash
t[#t+1] = LoadActor(THEME:GetPathG("","PlayModes/splash/Arcade"))..{
	OnCommand=cmd(diffusealpha,0;FullScreen);
	RefreshCommand=function(self)
	end;
	--TODO: Why does animation not work here? decelerate,.5;
	--ANSWER: Check ScreenSelectPlayMode out.lua
	OffCommand=function(self)
	local sel = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())
		self:Center():Cover()
		self:Load( THEME:GetPathG("","PlayModes/splash/"..Choices[sel+1] ) )
		:decelerate(0.5)
		:diffusealpha(1)
	end;
};

return t;