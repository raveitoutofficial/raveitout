local musicwheel; --Need a handle on the MusicWheel to work around a StepMania bug. Also needed to get the folders.

--==========================
--Item Scroller. Must be defined at the top to have 'scroller' var accessible to the rest of the lua.
--==========================
local scroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local numWheelItems = 15

--Item scroller starts at 0, duh.
local currentItemIndex = 0;

-- Scroller function thingy
local item_mt= {
  __index= {
	-- create_actors must return an actor.  The name field is a convenience.
	create_actors= function(self, params)
	  self.name= params.name
		return Def.ActorFrame{		
			InitCommand= function(subself)
				-- Setting self.container to point to the actor gives a convenient
				-- handle for manipulating the actor.
		  		self.container= subself
		  		subself:SetDrawByZPosition(true);
		  		--subself:zoom(.75);
			end;
				
			--[[Def.BitmapText{
				Name= "text",
				Font= "Common Normal",
				InitCommand=cmd(addy,100);
			};]]
			
			Def.Sprite{
				Name="banner";
				--InitCommand=cmd(scaletofit,0,0,1,1;);
			};
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		--PrimeWheel(self.container,offsetFromCenter,item_index,numWheelItems)
		self.container:stoptweening();
		if math.abs(offsetFromCenter) < 4 then
			self.container:decelerate(.5);
			self.container:visible(true);
		else
			self.container:visible(false);
		end;
		self.container:x(offsetFromCenter*500)
		--self.container:rotationy(offsetFromCenter*-45);
		self.container:zoom(math.cos(offsetFromCenter*math.pi/6)*.8)
		
		--[[if offsetFromCenter == 0 then
			self.container:diffuse(Color("Red"));
		else
			self.container:diffuse(Color("White"));
		end;]]
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, info)
		--self.container:GetChild("text"):settext(info)
		local banner = SONGMAN:GetSongGroupBannerPath(info);
		if banner == "" then
			self.container:GetChild("banner"):Load(THEME:GetPathG("common","fallback group"));
			--self.container:GetChild("text"):visible(true);
  		else
  			self.container:GetChild("banner"):Load(banner);
  			--self.container:GetChild("text"):visible(false);
		end;
		self.container:GetChild("banner"):scaletofit(-500,-200,500,200);
	end,
	--[[gettext=function(self)
		return self.container:GetChild("text"):gettext()
	end,]]
}}

--==========================
--Calculate groups and such
--==========================
local hearts = GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer();
groups = {};
local shine_index = 1;
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

if DoDebug then groups = SONGMAN:GetSongGroupNames(); end]]
local groups = getAvailableGroups();
assert(GAMESTATE:GetCurrentSong(), "The current song should have been set in ScreenSelectPlayMode!");
local curGroup = GAMESTATE:GetCurrentSong():GetGroupName();
for key,value in pairs(groups) do
	if curGroup == value then
		selection = key;
	end
end;
setenv("cur_group",groups[selection]);

--=======================================================
--Input handler. Brought to you by PIU Delta NEX Rebirth.
--=======================================================
local button_history = {"none", "none", "none", "none"};
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
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		if selection == 1 then
			selection = #groups;
		else
			selection = selection - 1 ;
		end;
		scroller:scroll_by_amount(-1);
		setenv("cur_group",groups[selection]);
		MESSAGEMAN:Broadcast("GroupChange");
		
	elseif button == "DownRight" or button == "Right" then
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		if selection == #groups then
			selection = 1;
		else
			selection = selection + 1
		end
		scroller:scroll_by_amount(1);
		setenv("cur_group",groups[selection]);
		MESSAGEMAN:Broadcast("GroupChange");
	--elseif button == "UpLeft" or button == "UpRight" then
		--SCREENMAN:AddNewScreenToTop("ScreenSelectSort");
	
	elseif button == "Back" then
		SCREENMAN:set_input_redirected(PLAYER_1, false);
		SCREENMAN:set_input_redirected(PLAYER_2, false);
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
	elseif button == "MenuDown" then
		--[[local curItem = scroller:get_actor_item_at_focus_pos().container:GetChild("banner");
		local scaledHeight = testScaleToWidth(curItem:GetWidth(), curItem:GetHeight(), 500);
		SCREENMAN:SystemMessage(curItem:GetWidth().."x"..curItem:GetHeight().." -> 500x"..scaledHeight);]]
		
		--local curItem = scroller:get_actor_item_at_focus_pos();
		--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
	else
		button_history[1] = button_history[2]
		button_history[2] = button_history[3]
		button_history[3] = button_history[4]
		button_history[4] = button
		if button_history[1] == "UpLeft" and button_history[2] == "UpRight" and button_history[3] == "UpLeft" and button_history[4] == "UpRight" then
			--SCREENMAN:AddNewScreenToTop("ScreenSelectSort");
		end;
		--SCREENMAN:SystemMessage(strArrayToString(button_history));
		--musicwheel:SetOpenSection("");
		--SCREENMAN:SystemMessage(musicwheel:GetNumItems());
		--[[local wheelFolders = {};
		for i = 1,7,1 do
			wheelFolders[#wheelFolders+1] = musicwheel:GetWheelItem(i):GetText();
		end;
		SCREENMAN:SystemMessage(strArrayToString(wheelFolders));]]
		--SCREENMAN:SystemMessage(musicwheel:GetWheelItem(0):GetText());
	end;
	
end;

local isPickingDifficulty = false;
local t = Def.ActorFrame{
	
	InitCommand=cmd(diffusealpha,0);
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		scroller:set_info_set(groups, 1);
		scroller:scroll_by_amount(selection-1)
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
	
	StartSelectingGroupMessageCommand=function(self,params)
		local curItem = scroller:get_actor_item_at_focus_pos();
		--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
		curItem.container:GetChild("banner"):stoptweening():scaletofit(-500,-200,500,200);
		self:stoptweening():linear(.5):diffusealpha(1);
		SOUND:DimMusic(0.3,65536);
		MESSAGEMAN:Broadcast("GroupChange");
	end;

	StartSelectingSongMessageCommand=function(self)
		self:linear(.3):diffusealpha(0);
		scroller:get_actor_item_at_focus_pos().container:GetChild("banner"):linear(.3):zoom(0);
	end;
}

-- GENRE SOUNDS
t[#t+1] = LoadActor(THEME:GetPathS("","nosound.ogg"))..{
	InitCommand=cmd(stop);
	StartSelectingSongMessageCommand=function(self)
		SOUND:DimMusic(1,65536);
		SCREENMAN:GetTopScreen():GetMusicWheel():ChangeSort('SortOrder_Group');
		SCREENMAN:GetTopScreen():GetMusicWheel():SetOpenSection(groups[selection]);
		SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_SongChanged', 0.5 );
		state = 1;
		--SCREENMAN:SystemMessage(SONGMAN:GetSongGroupBannerPath(getenv("cur_group")))
		
		--It works... But only if there's a banner.
		local fir = SONGMAN:GetSongGroupBannerPath(getenv("cur_group"));
		if not fir then
			return;
		end;
		self:load(soundext(gisub(fir,'banner.png','info/sound')));
		--Unreliable, current song doesn't update fast enough.
		--[[if SONGMAN:WasLoadedFromAdditionalSongs(GAMESTATE:GetCurrentSong()) then
			self:load(soundext("/AdditionalSongs/"..getenv("cur_group").."/info/sound"));
		else
			self:load(soundext("/Songs/"..getenv("cur_group").."/info/sound"));
		end]]
		self:play();
		self:play();
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

--Add scroller here
t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, SCREEN_CENTER_X, SCREEN_CENTER_Y);

	--Current Group/Playlist
t[#t+1] = LoadActor("current_group")..{
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
t[#t+1] = LoadActor("songartist_name")..{
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
		songcounter = string.format(THEME:GetString("ScreenSelectGroup","SongCount"),#SONGMAN:GetSongsInGroup(getenv("cur_group"))-1)
		foldercounter = string.format("%02i",selection).." / "..string.format("%02i",#groups)
		self:settext(songcounter.."\n"..foldercounter);
	end;
};

t[#t+1] = 	LoadActor("arrow_shine")..{};

return t;
