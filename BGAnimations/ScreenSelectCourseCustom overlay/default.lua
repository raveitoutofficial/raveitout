local function CanSafelyEnterGameplayCourse()
	for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
		if GAMESTATE:GetCurrentTrail(pn) == nil and GAMESTATE:IsPlayerEnabled(pn) then
			return false,"Trail for "..pname(pn).." was not set.";
		end
	end;
	if not GAMESTATE:GetCurrentCourse() then
		return false,"No course was set."
	end;
	if GAMESTATE:GetCurrentSong() then
		return false,"There is a song set in GAMESTATE."
	end;
	if not GAMESTATE:IsCourseMode() then
		return false,"The IsCourseMode flag was not set."
	end;
	return true
end
--We don't want any songs set! Though I'm not sure how this is possible.
GAMESTATE:SetCurrentSong(nil);

--We want the names of the items in the RIO_COURSE_FOLDERS so we need a separate table
local folderNames = {};
for k,v in pairs(RIO_COURSE_FOLDERS) do
	if v['Style'] == "StepsType_Pump_Double" then
		if GAMESTATE:GetNumSidesJoined() == 1 then --Don't add doubles groups in multiplayer
			folderNames[#folderNames+1] = k
		end;
	else
		folderNames[#folderNames+1] = k
	end;
end;
assert(#folderNames > 0,"Wat?");
--TrailCache;

local numWheelItems = 15

-- Scroller for the courses
local courseScroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local courseSelection = 1;
local item_mt_course= {
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
				

			
			Def.Sprite{
				Name="banner";
				--InitCommand=cmd(scaletofit,0,0,1,1;);
			};
			--[[Def.BitmapText{
				Name= "text",
				Text="HELLO WORLD!!!!!!!!!";
				Font= "Common Normal",
				InitCommand=cmd(addy,100;DiffuseAndStroke,Color("White"),Color("Black");shadowlength,1);
			};]]
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	--[[
	function RioWheel(self,offsetFromCenter,itemIndex,numItems)
    local spacing = 210;
	local edgeSpacing = 135;
    if math.abs(offsetFromCenter) < .5 then
        if not MUSICWHEEL_SONG_NAMES then
			self:zoom(1+math.cos(offsetFromCenter*math.pi)/3);
		end;
        self:x(offsetFromCenter*(spacing+edgeSpacing*2));
    else
        if offsetFromCenter >= .5 then
            self:x(offsetFromCenter*spacing+edgeSpacing);
        elseif offsetFromCenter <= -.5 then
            self:x(offsetFromCenter*spacing-edgeSpacing);
        end;
            --self:zoom(1);
    end;
end;
	]]
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		local spacing = 210;
		local edgeSpacing = 135;
		self.container:stoptweening();
		if math.abs(offsetFromCenter) < 5 then
			self.container:decelerate(.42);
			self.container:visible(true);
		else
			self.container:visible(false);
		end;
		self.container:x(offsetFromCenter*spacing);
		
		--[[if offsetFromCenter == 0 then
			self.container:diffuse(Color("Red"));
		else
			self.container:diffuse(Color("White"));
		end;]]
	end,
	-- info is one entry in the info set that is passed to the scroller.
	-- In this case, those are course objects.
	set= function(self, info)
		--self.container:GetChild("text"):settext(info);
		--TODO
		local banner = info:GetBannerPath()
		if banner == nil then
			self.container:GetChild("banner"):Load(THEME:GetPathG("common","fallback banner"));
  		else
  			self.container:GetChild("banner"):Load(banner);
  			--self.container:GetChild("text"):visible(false);
		end;
		self.container:GetChild("banner"):scaletoclipped(204,204);
	end,
	--[[gettext=function(self)
		--return self.container:GetChild("text"):gettext()
		return self.get_info_at_focus_pos();
	end,]]
}}

-- Scroller for course groups
local groupScroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local groupSelection = 1;

local item_mt_group= {
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
				

			
			Def.Sprite{
				Name="banner";
				--InitCommand=cmd(scaletofit,0,0,1,1;);
			};
			--[[Def.BitmapText{
				Name= "text",
				Text="HELLO WORLD!!!!!!!!!";
				Font= "Common Normal",
				InitCommand=cmd(addy,100;DiffuseAndStroke,Color("White"),Color("Black");shadowlength,1);
			};]]
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		--PrimeWheel(self.container,offsetFromCenter,item_index,numWheelItems)
		--self.container:hurrytweening(2);
		--self.container:finishtweening();
		self.container:stoptweening();
		if math.abs(offsetFromCenter) < 4 then
			self.container:decelerate(.45);
			self.container:visible(true);
		else
			self.container:visible(false);
		end;
		self.container:x(offsetFromCenter*350)
		--self.container:rotationy(offsetFromCenter*-45);
		self.container:zoom(math.cos(offsetFromCenter*math.pi/3)*.9):diffusealpha(math.cos(offsetFromCenter*math.pi/3)*.9);
		
		--[[if offsetFromCenter == 0 then
			self.container:diffuse(Color("Red"));
		else
			self.container:diffuse(Color("White"));
		end;]]
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, info)
		--self.container:GetChild("text"):settext(info);
		--TODO
		--local banner = SONGMAN:GetCourseGroupBannerPath(info);

		if FILEMAN:DoesFileExist("/Courses/"..info.."/banner.png") then
			self.container:GetChild("banner"):Load("/Courses/"..info.."/banner.png");
		else
			self.container:GetChild("banner"):Load(THEME:GetPathG("common","fallback group"));
		end;
		self.container:GetChild("banner"):scaletofit(-500,-200,500,200);
	end,
	--[[gettext=function(self)
		--return self.container:GetChild("text"):gettext()
		return self.get_info_at_focus_pos();
	end,]]
}}

local STATE_PICKING_FOLDER = 0;
local STATE_PICKING_COURSE = 1;
local STATE_READY = 2;

local curState = STATE_PICKING_FOLDER;
local currentCourseGroup;
local lastSelectedGroupIndex = 0;

local function updateCurrentCourse()
	assert(currentCourseGroup[courseSelection],"This course selection is nil! Selection:"..courseSelection);
		if RIO_COURSE_FOLDERS[folderNames[groupSelection]]['Style'] then
		setenv("TrailCache",currentCourseGroup[courseSelection]:GetTrails(RIO_COURSE_FOLDERS[folderNames[groupSelection]]['Style'])[1]);
	else
		setenv("TrailCache",currentCourseGroup[courseSelection]:GetAllTrails()[1]);
	end;
	assert(getenv("TrailCache"));
	GAMESTATE:SetCurrentCourse(currentCourseGroup[courseSelection]) --So this actually fires CurrentCourseChanged but I didn't know that... And I reimplemented it so it would have selection and total values.. So it's firing twice?

	MESSAGEMAN:Broadcast("CurrentCourseChanged",{Selection=courseSelection,Total=#currentCourseGroup});
end;

local screen; --To go to next screen and to check if OptionsList is currently open.

--To open OptionsList using LRLR
--[[local buttonHistory = {
	[PLAYER_1] = {"none","none","none","none"},
	[PLAYER_2] = {"none","none","none","none"}
}]]
local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	--[[if not pn or not SCREENMAN:get_input_redirected(pn) then 
		--SCREENMAN:SystemMessage("Not redirected");
		return
	end]]

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" or 
		not pn or 
		not screen:CanOpenOptionsList(pn) or --Don't move wheel when OptionsList is open
		button == "Select" --Select opens OptionsList
		then return end
	
	if curState == STATE_READY then
		if button == "UpRight" or button == "UpLeft" or button == "Up" or button == "MenuUp" then
			curState = STATE_PICKING_COURSE;
			MESSAGEMAN:Broadcast("SongUnchosen");
		elseif button == "Center" or button == "Start" then
			local can, reason = CanSafelyEnterGameplayCourse();
			if can then
				if RIO_COURSE_FOLDERS[folderNames[groupSelection]]['Lifebar'] == "Pro" then
					setenv("Lifebar","Pro")
				end;
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
			else
				SCREENMAN:SystemMessage(reason);
			end;
		end;
	elseif curState == STATE_PICKING_COURSE then
		if button == "UpRight" or button == "UpLeft" or button == "Up" or button == "MenuUp" then
			curState = STATE_PICKING_FOLDER;
			--Has no effect?
			--SOUND:DimMusic(0, math.huge)
			MESSAGEMAN:Broadcast("StartSelectingGroup");
		elseif button == "DownLeft" or button == "Left" or button == "MenuLeft" then
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
			if courseSelection == 1 then
				courseSelection = #currentCourseGroup;
			else
				courseSelection = courseSelection - 1 ;
			end;
			courseScroller:scroll_by_amount(-1);
			updateCurrentCourse()

		elseif button == "DownRight" or button == "Right" or button == "MenuRight" then
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
			if courseSelection == #currentCourseGroup then
				courseSelection = 1;
			else
				courseSelection = courseSelection + 1
			end
			courseScroller:scroll_by_amount(1);
			updateCurrentCourse()
		elseif button == "Center" or button == "Start" then
			--The trail should be set immediately on selection so the score can be obtained.
			local course = GAMESTATE:GetCurrentCourse();
			local trail = getenv("TrailCache");
			if trail ~= nil then
				--Is this actually necessary? AutoSetStyle should take care of it.
				--if RIO_COURSE_FOLDERS[folderNames[groupSelection]]['Style'] then
				--	GAMESTATE:SetCurrentStyle(string.match(RIO_COURSE_FOLDERS[folderNames[groupSelection]]['Style'],"_([^_]+)$"))
				--end;
				for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
					GAMESTATE:SetCurrentTrail(pn, trail)
					--GAMESTATE:SetCurrentSteps(pn, trail:GetTrailEntry(0):GetSteps());
				end;
			else
				SCREENMAN:SystemMessage("Trail was nil! Number of trails: "..#course:GetAllTrails().. " | Course: "..course:GetDisplayFullTitle());
			end;
			curState = STATE_READY;
			MESSAGEMAN:Broadcast("SongChosen");
		elseif button == "Back" then
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
		end;
	else
		if button == "Center" or button == "Start" then
			--[[SCREENMAN:set_input_redirected(PLAYER_1, false);
			SCREENMAN:set_input_redirected(PLAYER_2, false);]]
			if lastSelectedGroupIndex ~= groupSelection then
				currentCourseGroup = SONGMAN:GetCoursesInGroup(folderNames[groupSelection],true)
				assert(#currentCourseGroup > 0,"Hey idiot, you don't have any courses in this group.")
				courseScroller:set_info_set(currentCourseGroup,1);
				courseSelection = 1;
				updateCurrentCourse()
				lastSelectedGroupIndex = groupSelection;
			end;
			--SOUND:PlayOnce(THEME:GetPathS("", "SongChosen"), true);
			MESSAGEMAN:Broadcast("StartSelectingSong");
			curState = STATE_PICKING_COURSE;
			
		elseif button == "DownLeft" or button == "Left" or button == "MenuLeft" then
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
			if groupSelection == 1 then
				groupSelection = #folderNames;
			else
				groupSelection = groupSelection - 1 ;
			end;
			groupScroller:scroll_by_amount(-1);
			setenv("cur_group",folderNames[groupSelection]);
			MESSAGEMAN:Broadcast("GroupChange");
			MESSAGEMAN:Broadcast("PreviousGroup");
			
		elseif button == "DownRight" or button == "Right" or button == "MenuRight" then
			SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
			if groupSelection == #folderNames then
				groupSelection = 1;
			else
				groupSelection = groupSelection + 1
			end
			groupScroller:scroll_by_amount(1);
			setenv("cur_group",folderNames[groupSelection]);
			MESSAGEMAN:Broadcast("GroupChange");
			MESSAGEMAN:Broadcast("NextGroup");
		--elseif button == "UpLeft" or button == "UpRight" then
			--SCREENMAN:AddNewScreenToTop("ScreenSelectSort");
		
		elseif button == "Back" then
			--[[SCREENMAN:set_input_redirected(PLAYER_1, false);
			SCREENMAN:set_input_redirected(PLAYER_2, false);]]
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
		elseif button == "MenuDown" then
			--[[local curItem = scroller:get_actor_item_at_focus_pos().container:GetChild("banner");
			local scaledHeight = testScaleToWidth(curItem:GetWidth(), curItem:GetHeight(), 500);
			SCREENMAN:SystemMessage(curItem:GetWidth().."x"..curItem:GetHeight().." -> 500x"..scaledHeight);]]
			
			--local curItem = scroller:get_actor_item_at_focus_pos();
			--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
		else
			SCREENMAN:SystemMessage("unknown button: "..button)
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
	--Not needed, CodeNames will handle it
	--[[buttonHistory[pn][1] = buttonHistory[pn][2];
	buttonHistory[pn][2] = buttonHistory[pn][3];
	buttonHistory[pn][3] = buttonHistory[pn][4];
	buttonHistory[pn][4] = button;
	if buttonHistory[pn][1] == "DownLeft" and buttonHistory[pn][2] == "DownRight" and buttonHistory[pn][3] == "DownLeft" and buttonHistory[pn][4] == "DownRight"
	
	end;]]
	
end;

local t = Def.ActorFrame{
	OnCommand=function(self)
		screen = SCREENMAN:GetTopScreen();
		screen:AddInputCallback(inputs);
		--[[SCREENMAN:set_input_redirected(PLAYER_1, true);
		SCREENMAN:set_input_redirected(PLAYER_2, true);]]
	end;
}

--CourseScroller frame

local curSongPlaying = 1;
local s = Def.ActorFrame{

	--READY COMMAND
	LoadActor(THEME:GetPathS("","ready/select.mp3"))..{
		--SongChosenMessageCommand=cmd(play);
		--StepsChosenMessageCommand=cmd(playcommand,"Check2";);
		--[[Check2Command=function(self)
			if state == 2 then state = 3; self:stoptweening(); self:play(); end;
		end;]]
	};
	
	LoadActor(THEME:GetPathS("","SongChosen"))..{
		SongChosenMessageCommand=cmd(play);
		StartSelectingSongMessageCommand=cmd(play);
	};
	
	--UPRIGHT/UPLEFT
	LoadActor(THEME:GetPathS("","SongUnchosen"))..{
		TwoPartConfirmCanceledMessageCommand=cmd(play);
		StartSelectingGroupMessageCommand=cmd(play);
		SongUnchosenMessageCommand=cmd(play);
		--[[StepsUnchosenMessageCommand=cmd(playcommand,"Check";);
		SongUnchosenMessageCommand=cmd(playcommand,"Check";);
		TwoPartConfirmCanceledMessageCommand=cmd(playcommand,"Check");
		StartSelectingGroupMessageCommand=cmd(playcommand,"Check");
		CheckCommand=function(self)
			if state == 1 then--StartGroupSelection
				self:stoptweening(); self:play();
				state = 0;
			elseif state == 2 then--SelectSongSelectingAgain
				self:stoptweening(); self:play();
				state = 1;
			elseif state == 3 then--SelectSongSelectingAgain
				self:stoptweening(); self:play();
				state = 2;
			end;
		end;]]
	};
	LoadActor(THEME:GetPathS("","ready/offcommand"))..{
		OffCommand=cmd(play);
	};
	
	CurrentCourseChangedMessageCommand=function(self)
		curSongPlaying = 1;
		self:stoptweening():queuecommand("PlayCourseMusics");
	end;
	PlayCourseMusicsCommand=function(self)
		stop_music();
		local song = getenv("TrailCache"):GetTrailEntries()[curSongPlaying]:GetSong();
		play_sample_music(song,5);
		if curSongPlaying < #getenv("TrailCache"):GetTrailEntries() then
			curSongPlaying = curSongPlaying + 1;
			self:sleep(5):queuecommand("PlayCourseMusics");
		end;
	end;
	
	--handle opening the OptionsList here
	CodeMessageCommand=function(self,param)
		local codeName = param.Name		-- code name, matches the one in metrics
		--local pn = param.PlayerNumber	-- which player entered the code
		if codeName == "OpenOpList" or codeName == "OpenOpList2" or codeName == "Select" then
			screen:OpenOptionsList(param.PlayerNumber);
		
		end;
	end;
	
}
--THE BACKGROUND VIDEO
s[#s+1] = LoadActor(THEME:GetPathG("","background/common_bg"))..{};
s[#s+1] = courseScroller:create_actors("foo", numWheelItems, item_mt_course, SCREEN_CENTER_X, SCREEN_CENTER_Y-25);
s[#s+1] = LoadActor("coursePreview");
s[#s+1] = LoadActor("otherDecorations");
s[#s+1] = LoadActor("difficultyIcons");

--GroupScroller frame
local g = Def.ActorFrame{
	
	--InitCommand=cmd(diffusealpha,0);
	OnCommand=function(self)
		groupScroller:set_info_set(folderNames, 1);
	end;
	
	StartSelectingGroupMessageCommand=function(self,params)
		local curItem = groupScroller:get_actor_item_at_focus_pos();
		--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
		curItem.container:GetChild("banner"):stoptweening():scaletofit(-500,-200,500,200);
		self:stoptweening():linear(.5):diffusealpha(1);
		--SOUND:DimMusic(0.3,65536);
		MESSAGEMAN:Broadcast("GroupChange");
	end;

	StartSelectingSongMessageCommand=function(self)
		self:linear(.3):diffusealpha(0);
		groupScroller:get_actor_item_at_focus_pos().container:GetChild("banner"):linear(.3):zoom(0);
	end;

}

--THE BACKGROUND VIDEO
g[#g+1] = LoadActor(THEME:GetPathG("","background/common_bg"))..{
	--InitCommand=cmd(diffusealpha,0);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1);
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
};

g[#g+1] = Def.Quad{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,0,0,0,0;fadetop,1;blend,Blend.Add);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,0.87);
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
}
--FLASH
g[#g+1] = Def.Quad{
	InitCommand=cmd(Center;zoomto,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,1,1,1,0);
	StartSelectingSongMessageCommand=cmd(stoptweening;diffusealpha,1;linear,0.3;diffusealpha,0);
};

--Add scroller here
g[#g+1] = groupScroller:create_actors("foo", numWheelItems, item_mt_group, SCREEN_CENTER_X, SCREEN_CENTER_Y);


	
--Game Folder counters
--Text BACKGROUND
g[#g+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/songartist_name"))..{
	InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-75;zoomto,547,46);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"Text");
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
};

g[#g+1] = LoadFont("monsterrat/_montserrat light 60px")..{
	InitCommand=cmd(Center;zoom,0.2;y,SCREEN_BOTTOM-75;uppercase,true;strokecolor,0,0.15,0.3,0.5;);
	StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"GroupChangeMessage");
	StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	GroupChangeMessageCommand=function(self)
		self:finishtweening();
		self:linear(0.3);
		self:diffusealpha(1);
		--songcounter = string.format(THEME:GetString("ScreenSelectGroup","SongCount"),#SONGMAN:GetSongsInGroup(getenv("cur_group"))-1)
		local songcounter = string.format(THEME:GetString("ScreenSelectCourse","CourseCount"),#SONGMAN:GetCoursesInGroup(folderNames[groupSelection],true))
		local foldercounter = string.format("%02i",groupSelection).." / "..string.format("%02i",#RIO_COURSE_FOLDERS)
		self:settext(songcounter.."\n"..foldercounter);
	end;
};

t[#t+1] = s;
t[#t+1] = g;
	--Current Group/Playlist
t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/current_group"))..{
		InitCommand=cmd(x,0;y,5;horizalign,left;vertalign,top;zoomx,1;cropbottom,0.3);
		--StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"Text");
		--StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
	};
	
t[#t+1] = LoadFont("monsterrat/_montserrat light 60px")..{	
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+18;y,SCREEN_TOP+10;zoom,0.185;skewx,-0.1);
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"GroupChangeMessage");
		StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
		GroupChangeMessageCommand=function(self)
			self:uppercase(true);
			self:settext("Pick mixtapes");
		end;
	};
	
t[#t+1] = LoadFont("monsterrat/_montserrat semi bold 60px")..{
		Name="CurrentGroupName";
		InitCommand=cmd(uppercase,true;horizalign,left;x,SCREEN_LEFT+16;y,SCREEN_TOP+30;zoom,0.6;skewx,-0.25);
		OnCommand=cmd(playcommand,"UpdateText");
		StartSelectingGroupMessageCommand=cmd(stoptweening;linear,0.35;diffusealpha,1;playcommand,"UpdateText");
		--StartSelectingSongMessageCommand=cmd(stoptweening;linear,0.3;diffusealpha,0);
		GroupChangeMessageCommand=cmd(playcommand,"UpdateText");
		UpdateTextCommand=function(self)
			self:settext(folderNames[groupSelection]);
		end;
	};
	
	
--OpList
t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/OptionsList"));

t[#t+1] = 	LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/arrow_shine"))..{};



return t;
