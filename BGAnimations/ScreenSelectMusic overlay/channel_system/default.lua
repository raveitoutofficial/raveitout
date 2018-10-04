--=======================================================
--Input handler. Brought to you by PIU Delta NEX Rebirth.
--=======================================================
local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	if not pn or not SCREENMAN:get_input_redirected(pn) then return end

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	if button == "Center" or button == "Start" then
		SCREENMAN:set_input_redirected(PLAYER_1, false);
		SCREENMAN:set_input_redirected(PLAYER_2, false);
		MESSAGEMAN:Broadcast("StartSelectingSong");
	elseif button == "DownLeft" or button == "Left" then
		--scroller:scroll_by_amount(-1);
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		MESSAGEMAN:Broadcast("PreviousGroup");
	elseif button == "DownRight" or button == "Right" then
		--scroller:scroll_by_amount(1);
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		MESSAGEMAN:Broadcast("NextGroup");
	elseif button == "Back" then
		SCREENMAN:set_input_redirected(PLAYER_1, false);
		SCREENMAN:set_input_redirected(PLAYER_2, false);
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
	else
		--SCREENMAN:SystemMessage(button);
	end;
	
end;

local isPickingDifficulty = false;
local musicwheel; --Need a handle on the MusicWheel to work around a StepMania bug
local t = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
	end;

	SongChosenMessageCommand=function(self)
		isPickingDifficulty = true;
	end;
	TwoPartConfirmCanceledMessageCommand=cmd(sleep,.1;queuecommand,"PickingSong");
	SongUnchosenMessageCommand=cmd(sleep,.1;queuecommand,"PickingSong");
	
	PickingSongCommand=function(self)
		isPickingDifficulty = false;
	end;
	
	CodeMessageCommand=function(self,param)
		local codeName = param.Name		-- code name, matches the one in metrics
		--player is not needed
		--local pn = param.PlayerNumber	-- which player entered the code
		if codeName == "GroupSelect1" or codeName == "GroupSelect2" then
			if isPickingDifficulty then return end; --Don't want to open the group select if they're picking the difficulty.
			MESSAGEMAN:Broadcast("StartSelectingGroup");
			--SCREENMAN:SystemMessage("Group select opened.");
			--No need to check if both players are present... Probably.
			SCREENMAN:set_input_redirected(PLAYER_1, true);
			SCREENMAN:set_input_redirected(PLAYER_2, true);
			musicwheel:Move(0);
		else
			--Debugging only
			--SCREENMAN:SystemMessage(codeName);
		end;
	end;


}		

--==========================
--Group select
--==========================
local hearts = GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer();
groups = {};
local shine_index = 1;
local Banners = {};
local names = SONGMAN:GetSongGroupNames()

selection = 1;
local spacing = 210;
local numplayers = GAMESTATE:GetHumanPlayers();

--This shit is completely broken in multiplayer.
-- Snap Songs
--[[if hearts >= 1*GAMESTATE:GetNumSidesJoined() then
	groups[#groups+1] = "00 Rave It Out (Snap Tracks)";
	if GAMESTATE:GetCurrentSong():GetGroupName() == "00 Rave It Out (Snap Tracks)" then selection = 1; end;
end;

local total_arcade_folders = #names-3;
--Arcade Songs
if hearts >=(2*GAMESTATE:GetNumSidesJoined()) then
	for i=2,total_arcade_folders do
		groups[#groups+1] = names[i];
	
		if GAMESTATE:GetCurrentSong():GetGroupName() == names[i] or GAMESTATE:GetPreferredSongGroup() == names[i] then 
			selection = i; 
		end
	end;
end

--Full Songs
if hearts >= 3*GAMESTATE:GetNumSidesJoined() then 	
	groups[#groups+1] = "80 Rave It Out (Full Tracks)";
	if GAMESTATE:GetCurrentSong():GetGroupName() == "80 Rave It Out (Full Tracks)" then selection = total_arcade_folders+1; end;
end;

-- Rave Songs
if hearts >= 4*GAMESTATE:GetNumSidesJoined() then 	
	groups[#groups+1] = "81 Rave It Out (Rave)";
	if GAMESTATE:GetCurrentSong():GetGroupName() == "81 Rave It Out (Rave)" then selection = total_arcade_folders+2; end;
end;

if DevMode() then groups = SONGMAN:GetSongGroupNames(); end]]
groups = SONGMAN:GetSongGroupNames();
local curGroup = GAMESTATE:GetCurrentSong():GetGroupName();
for key,value in pairs(groups) do
	if curGroup == value then
		selection = key;
	end
end;
setenv("cur_group",groups[selection]);

t[#t+1] = Def.Actor{
	NextGroupMessageCommand=function(self,params)
		if selection == #groups then
			selection = 1;
		else
			selection = selection + 1
		end
		setenv("cur_group",groups[selection]);
		MESSAGEMAN:Broadcast("GroupChange");

	end;
	PreviousGroupMessageCommand=function(self,params)
		if selection == 1 then
			selection = #groups;
		else
			selection = selection - 1 ;
		end;
		setenv("cur_group",groups[selection]);
		MESSAGEMAN:Broadcast("GroupChange");
	end;
	
	
	StartSelectingSongMessageCommand=function(self,params)
		SOUND:DimMusic(1,65536);
		SCREENMAN:GetTopScreen():GetMusicWheel():ChangeSort('SortOrder_Group');
		SCREENMAN:GetTopScreen():GetMusicWheel():SetOpenSection(groups[selection]);
		SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_SongChanged', 0.5 );
		state = 1;
	end;
	
	StartSelectingGroupMessageCommand=function(self,params)
		SOUND:DimMusic(0.3,65536);
		MESSAGEMAN:Broadcast("GroupChange");
	end;
};

t[#t+1] = LoadActor(THEME:GetPathG("","background/common_bg"))..{
		InitCommand=cmd(diffusealpha,0);
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1);
		StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	};

t[#t+1] = Def.Quad{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,0;fadetop,1;blend,Blend.Add);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,0.87);
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
}
--FLASH
t[#t+1] = Def.Quad{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,1,1,1,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,1;linear,0.3;diffusealpha,0);
};


--CENTER BANNER
--[[
for k = 1, #groups do
	
	if FILEMAN:DoesFileExist("/Songs/"..groups[k].."/banner.png") then
		banner = "/Songs/"..groups[k].."/banner.png";
	else
		banner = THEME:GetPathG("","_NoBanner");
	end;
	
	Banners[#Banners+1] =
		LoadActor( banner )..{
		InitCommand=cmd(stoptweening;linear,0.3;zoom,0;diffusealpha,0;scaletoclipped,500,375);
	};
	
end;
--]]
--[
for k = 1, #groups do
	
	banner = "/"..SONGMAN:GetSongGroupBannerPath(groups[k]);
	
	if FILEMAN:DoesFileExist(banner) == false then
		banner = THEME:GetPathG("","_NoBanner");
	end;
	
	Banners[#Banners+1] =
		LoadActor( banner )..{
		InitCommand=cmd(scaletoclipped,500,375;zoom,0;diffusealpha,0;);
	};
	
end;
--]]

-- GENRE SOUNDS
	t[#t+1] = LoadActor(THEME:GetPathS("","nosound.ogg"))..{
		InitCommand=cmd(stop);
		StartSelectingSongMessageCommand=function(self)
			self:load(soundext("/Songs/"..getenv("cur_group").."/info/sound"));
			self:play();
			self:play();
		end;
	};

t[#t+1] =
	Def.ActorScroller {
		Name="GroupsBannersScroller";
		NumItemsToDraw=1;
		SecondsPerItem=0.1;
		InitCommand = function(self)
			self:Center();
			self:diffusealpha(0);
			self:SetLoop(true);
			for i=1,#groups do
				if GAMESTATE:GetCurrentSong():GetGroupName() == names[i] or GAMESTATE:GetPreferredSongGroup() == names[i] then 
					selection = i; 
				end
			end;
			self:SetCurrentAndDestinationItem(selection-1);
			self:zoom(0);
		end;
		
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;zoom,1;diffusealpha,1);
		StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;zoom,0;diffusealpha,0);
		
		PreviousGroupMessageCommand=function(self,params)
		(cmd(stoptweening;zoom,1;decelerate,.05;zoom,1.03;linear,.3;zoom,1))(self);
			if self:GetDestinationItem() == 0 then
				self:SetCurrentAndDestinationItem(self:GetNumChildren()-1)
			else
				self:SetCurrentAndDestinationItem(self:GetCurrentItem()-1)
			end
		end;
		
		NextGroupMessageCommand=function(self,params)
			(cmd(stoptweening;zoom,1;decelerate,.05;zoom,1.03;linear,.3;zoom,1))(self);
			if self:GetDestinationItem() == self:GetNumChildren()-1 then
				self:SetCurrentAndDestinationItem(0)
			else
				self:SetCurrentAndDestinationItem(self:GetCurrentItem()+1)
			end
		end;
		
		OffCommand=function(self)
			selection = self:GetCurrentItem();
		end;
		
		TransformFunction = function (self,offsetFromCenter,itemIndex,numItems)
			local x = offsetFromCenter * 310;
			local ry = clamp( offsetFromCenter, 0,0) * 90;
			self:x( x );
			self:z((-clamp(math.abs(offsetFromCenter),0,0)*280)-math.abs(offsetFromCenter));
			self:rotationy( ry );
		end;
		children = Banners;
		};

	--Current Group/Playlist
t[#t+1] = LoadActor("../current_group")..{
		InitCommand=cmd(x,0;y,5;horizalign,left;vertalign,top;zoomx,1;cropbottom,0.3);
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"Text");
		StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	};
	
t[#t+1] = LoadFont("monsterrat/_montserrat light 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+18;y,SCREEN_TOP+10;zoom,0.185;skewx,-0.1);
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"GroupChangeMessage");
		StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
		GroupChangeMessageCommand=function(self)
			self:uppercase(true);
			self:settext("Set songlist");
		end;
	};
	
t[#t+1] = LoadFont("monsterrat/_montserrat semi bold 60px")..{
		Name="CurrentGroupName";
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+16;y,SCREEN_TOP+30;zoom,0.6;skewx,-0.25);
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"GroupChangeMessage");
		StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
		GroupChangeMessageCommand=function(self)
			--[[if string.find(getenv("cur_group"),"Rave It Out") then
				self:settext(string.sub(getenv("cur_group"), 17, string.len(getenv("cur_group"))-1));
			else
				self:settext(string.sub(getenv("cur_group"), 4, string.len(getenv("cur_group"))));
			end;]]
			if not getenv("cur_group") then
				self:settext("cur_group env var missing!");
			else	
				self:settext(string.gsub(getenv("cur_group"),"^%d%d? ?%- ?", ""));
			end;
		end;
	};
	
--Game Folder counters
--Text BACKGROUND
t[#t+1] = LoadActor("../songartist_name")..{
	InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-75;diffusealpha,0;zoomto,547,46);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"Text");
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
};

t[#t+1] = LoadFont("monsterrat/_montserrat light 60px")..{
	InitCommand=cmd(Center;zoom,0.2;y,SCREEN_BOTTOM-75;uppercase,true;strokecolor,0,0.15,0.3,0.5;diffusealpha,0;);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"GroupChangeMessage");
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	GroupChangeMessageCommand=function(self)
		self:finishtweening();
		self:linear(0.3);
		self:diffusealpha(1);
		songcounter = "There are "..(#SONGMAN:GetSongsInGroup(getenv("cur_group"))-1).." songs inside this setlist"
		foldercounter = string.format("%02i",selection).." / "..string.format("%02i",#groups)
		self:settext(songcounter.."\n"..foldercounter);
	end;
};

t[#t+1] = 	LoadActor("../arrow_shine")..{};

return t;
