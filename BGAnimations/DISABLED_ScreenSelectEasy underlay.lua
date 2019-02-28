--Ever wanted to give a programmer a stroke? Show them this file.
--lua music wheel, brought to you by Accel.
-- Get screen handle so we can adjust the timer.
local MenuTimer;

-- SONGS
local songs = SONGMAN:GetSongsInGroup("StepMania 5");
for k,v in pairs(songs) do
	if v == "info" then
		table.remove(songs, k)
	end
end

-- GROUPS
function groupItem()
	local mt = {
		__index = {
			GetTitle = function()
				return "IIDX 22 Pendual";
			end;
			GetJacketPath = function()
				return THEME:GetPathG("common", "fallback jacket");
			end;
			GetWheelArt = function()
			
			end;
			HasBanner = function()
			
			end;
			GetBanner = function()
			
			end;
			GetType = function()
				return 1;
			end;
		};
	};
	return setmetatable({}, mt)
end;
--table.insert(songs,1,"IIDX 22 Pendual")
local info_set = songs;

-- ITEM SCROLLER
-- /////////////////////////////////
--Lol get fucked
scroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local numWheelItems = 7
--local numWheelItems = THEME:GetMetric("MusicWheel", "NumWheelItems")

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
		  		--subself:SetDrawByZPosition(true);
		  		--subself:zoom(.75);
			end;
			
			Def.Sprite{
				Name="banner";
				InitCommand=cmd(scaletoclipped,204,204);
			};

		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		self.container:stoptweening();
		if offsetFromCenter > numWheelItems/2-1 or offsetFromCenter < -numWheelItems/2-3 then
			self.container:visible(false);
		else
			self.container:visible(true);
		end;
		local spacing = 170;
		local edgeSpacing = 110;
		self.container:decelerate(.3);
		if math.abs(offsetFromCenter) < 1 then
			self.container:zoom(1);
			self.container:x(offsetFromCenter*(spacing+edgeSpacing*2));
		else
			self.container:zoom(.8);
			if offsetFromCenter >= 1 then
				self.container:x(offsetFromCenter*spacing+edgeSpacing);
			elseif offsetFromCenter <= -.5 then
				self.container:x(offsetFromCenter*spacing-edgeSpacing);
			end;
				--self:zoom(1);
		end;
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, song)
		if song then
			local banner = self.container:GetChild("banner");
			local path = song:GetJacketPath();
			if path then
				banner:Load(path)
				--self:LoadFromCached("Jacket",path);
			else
				path = song:GetBannerPath();
				if path then
					banner:Load(path)
					--self:LoadFromCached("Banner",path);
				else
					banner:Load(THEME:GetPathG("Common","fallback banner"))
				end;
			end;
		else return end;
	end,
	--[[gettext=function(self)
		return self.container:GetChild("text"):gettext()
	end,]]
}}
--local info_set= {"fin", "tail", "gorg", "lilk", "zos", "mink", "aaa"}


-- INPUT HANDLER
-- /////////////////////////
local function GoToNextScreen()
	--Has no effect.
	--MenuTimer:pause()
	--SCREENMAN:SystemMessage(scroller:get_info_at_focus_pos());
	--IT'S A HACK! (if you don't put local it makes a global variable)
	if initialGroup ~= scroller:get_info_at_focus_pos() then
		currentGroup = scroller:get_info_at_focus_pos();
	end;
	local curItem = scroller:get_actor_item_at_focus_pos();
	--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
	curItem.container:GetChild("banner"):accelerate(.3):zoom(2);
	secondsLeft = MenuTimer:GetSeconds();
	SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
end;
local function inputs(event)
	--do return end
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	if not pn then return end

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	if button == "Center" or button == "Start" then
		GoToNextScreen()
	elseif button == "MenuUp" or button == "Up" or button == "Scratch up" then
		scroller:scroll_by_amount(-1);
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		GAMESTATE:SetCurrentSong(scroller:get_info_at_focus_pos());
		--MESSAGEMAN:Broadcast("CurrentSongChanged", {index=scroller:get_index(), total=#songs});
	elseif button == "MenuDown" or button == "Down" or button == "Scratch down" then
		scroller:scroll_by_amount(1);
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		GAMESTATE:SetCurrentSong(scroller:get_info_at_focus_pos());
		--MESSAGEMAN:Broadcast("CurrentSongChanged", {index=scroller:get_index(), total=#songs});
	elseif button == "MenuLeft" or button == "Left" then
		--local diff = GAMESTATE:GetPreferredDifficulty(pn)
		--SCREENMAN:SystemMessage(diff);
		SCREENMAN:SystemMessage(scroller:get_index());
		--GAMESTATE:SetPreferredDiff
	elseif button == "Back" then
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
	elseif button == "Select" then
		SCREENMAN:SystemMessage(type(fakeSong()));
	else
		SCREENMAN:SystemMessage(button);
	end;
	
	--[[if button == "MenuDown" then
		local groupName = scroller:get_info_at_focus_pos()
		if initialGroup then
			SCREENMAN:SystemMessage(groupName.." | "..initialGroup);
		else
			SCREENMAN:SystemMessage(groupName.." | No initial group.");
		end;
		--SCREENMAN:SystemMessage(groupName.." | "..SONGMAN:GetSongGroupBannerPath(groupName));
	end;
	
	if button == "MenuUp" then
		SCREENMAN:SystemMessage(tostring(ReadPrefFromFile("UserPrefHiddenChannels") == "Enabled"));
	end;]]
	
end;

-- ACTORFRAMES FOR BOTH
-- ////////////////////////

local t = Def.ActorFrame{
	OnCommand=function(self)
		scroller:set_info_set(info_set, 1);
		for key,value in pairs(info_set) do
			if initialGroup == value then
				scroller:scroll_by_amount(key-1)
			end
		end;
		
		
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		MenuTimer = SCREENMAN:GetTopScreen():GetChild("Timer");
		--SecondsLeft is a global variable hack, brought over from ScreenSelectMusic overlay.
		--MenuTimer:SetSeconds(secondsLeft);
		--SCREENMAN:SystemMessage(math.ceil(numWheelItems/2));
		--self:linear(5);
		--self:queuecommand("CheckTimer");
	end;
	--I think this is the only way to check the timer
	CheckTimerCommand=function(self)
		--For some reason it ends the timer instantly because it's at 0 (Maybe it's unitialized?) So just stop the timer at 1 second.
		--Someone is going to see this and complain.
		if MenuTimer:GetSeconds() > 0 and MenuTimer:GetSeconds() < 1 then
			MenuTimer:SetSeconds(0.1);
			GoToNextScreen()
		else
			--self:linear(1):queuecommand("CheckTimer");
		end;
	end;
	
	Def.Actor{
		Name="AudioPreview";
		CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				local ss = song:GetSampleStart();
				local length = song:GetSampleLength();
				local audioPath = song:GetPreviewMusicPath();
				--SCREENMAN:SystemMessage(audioPath.." , "..song:GetSampleLength());
				--SOUND:PlayOnce(audioPath, false);
				SOUND:PlayMusicPart(song:GetPreviewMusicPath(), song:GetSampleStart(), song:GetSampleLength(), .2, 5, false, false, false);
			end;
		end;
	};
};

t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, THEME:GetMetric("ScreenSelectMusic", "MusicWheelX"), THEME:GetMetric("ScreenSelectMusic", "MusicWheelY"))..{
	Name="MusicWheel";
};


t[#t+1] = Def.ActorFrame{
	
	LoadActor(THEME:GetPathB("ScreenSelectMusic", "underlay"));
	LoadActor(THEME:GetPathB("ScreenSelectMusic", "overlay/songPreview"), true);
	LoadActor(THEME:GetPathG("","USB_stuff"))
};

t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/EasyDifficultyList"))..{
	InitCommand=cmd(Center;addy,107;zoom,.4);
};


return t;
