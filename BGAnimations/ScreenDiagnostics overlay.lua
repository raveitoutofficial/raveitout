function IsWindowed()
	if PREFSMAN:GetPreference("Windowed") then
		return "Windowed";
	else
		return "Fullscreen";
	end;
end;

--Stupid hack because ScreenOptionsService doesn't have a transition
local timer = 0;
local t = Def.ActorFrame{
	OnCommand=cmd(sleep,3;queuecommand,"Timer");
	TimerCommand=function(self)
		timer = 3;
	end;

	CodeMessageCommand=function(self, params)
		if params.Name == "Start" or params.Name == "Center" then
			if timer > 0 then
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
			end;
		elseif params.Name == "Secret" or params.Name=="Secret2" then
			SCREENMAN:SetNewScreen("ScreenGreetz");
		else
			SCREENMAN:SystemMessage("Unknown button: "..params.Name);
		end;
	end;
	
	LoadFont("Common Normal")..{
		Text="Press start or center step to exit.";
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_HEIGHT-50;diffusealpha,0);
		OnCommand=function(self)
			self:sleep(3):linear(1):diffusealpha(1);
			--self:settext(getRandomBackgroundDebug("_random wallpapers"));
		end;
	
	};
	
	LoadFont("Common Normal")..{
		Text="System Information";
		InitCommand=cmd(xy,SCREEN_CENTER_X,20);
	};
	LoadFont("Common Normal")..{
		Text="Rave It Out version: "..SysInfo["Version"];
		InitCommand=cmd(xy,SCREEN_CENTER_X,40);
	};
	LoadFont("Common Normal")..{
		Text="StepMania build: "..ProductFamily().." "..ProductVersion();
		InitCommand=cmd(xy,SCREEN_CENTER_X,60;maxwidth,SCREEN_WIDTH-50);
		--[[OnCommand=function(self)
			if ProductVersion() ~= "5.0.12" then
				self:settext(self:GetText().." (Incompatible version?)");
				self:diffuse(Color("Red"));
			else
				self:diffuse(Color("Green"));
			end;
		end;]]
	};
	LoadFont("Common Normal")..{
		Text="Game Mode: "..ToEnumShortString(GAMESTATE:GetCoinMode());
		InitCommand=cmd(xy,20,100;horizalign,left);
	};
	LoadFont("Common Normal")..{
		Text="Event Mode: "..tostring(GAMESTATE:IsEventMode());
		InitCommand=cmd(xy,20,125;horizalign,left)
	};
	LoadFont("Common Normal")..{
		Text="Memory Cards: "..tostring(PREFSMAN:GetPreference("MemoryCards")).." | Memory Card profiles: "..tostring(PREFSMAN:GetPreference("MemoryCardProfiles"));
		InitCommand=cmd(xy,20,150;horizalign,left)
	};
	LoadFont("Common Normal")..{
		OnCommand=cmd(settext,"Player 1 Memory Card Status: "..ToEnumShortString(MEMCARDMAN:GetCardState(PLAYER_1))..MEMCARDMAN:GetName(PLAYER_1));
		StorageDevicesChangedMessageCommand=function(self)
			self:playcommand("On");
			SCREENMAN:SystemMessage("Memory card state was changed");
		end;
		InitCommand=cmd(xy,20,175;horizalign,left)
	
	};
	LoadFont("Common Normal")..{
		OnCommand=cmd(settext,"Player 2 Memory Card Status: "..ToEnumShortString(MEMCARDMAN:GetCardState(PLAYER_2))..MEMCARDMAN:GetName(PLAYER_2));
		StorageDevicesChangedMessageCommand=function(self)
			self:playcommand("On");
			SCREENMAN:SystemMessage("Memory card state was changed");
		end;
		InitCommand=cmd(xy,20,200;horizalign,left)
	
	};
	LoadFont("Common Normal")..{
		Text="Profiles: "..PROFILEMAN:GetNumLocalProfiles().." ("..join(", ",PROFILEMAN:GetLocalProfileDisplayNames())..")";
		InitCommand=cmd(xy,20,225;horizalign,left;maxwidth,SCREEN_WIDTH-50);
		OnCommand=function(self)
			if PREFSMAN:GetPreference("MemoryCardProfiles") == true and PROFILEMAN:GetNumLocalProfiles() == 0 then
				self:diffuse(Color("Green"));
				self:settext("Profiles: 0 | Ok!");
			else
				self:diffuse(Color("Red"));
			end;
		end;
	};
	--[[LoadFont("Common Normal")..{
		Text="Memory card save type: "..tostring(ReadPrefFromFile("GuestSaveType"));
		InitCommand=cmd(xy,20,175;horizalign,left)
	
	};]]
	LoadFont("Common Normal")..{
		Text="Resolution: "..PREFSMAN:GetPreference("DisplayWidth").."x"..PREFSMAN:GetPreference("DisplayHeight").." | Aspect ratio: "..round(GetScreenAspectRatio(),2).." | "..IsWindowed();
		InitCommand=cmd(xy,20,250;horizalign,left);
	};
	LoadFont("Common Normal")..{
		Text="Songs: "..SONGMAN:GetNumSongs().."+"..SONGMAN:GetNumAdditionalSongs().." | Groups/Channels: "..SONGMAN:GetNumSongGroups();
		InitCommand=cmd(xy,20,275;horizalign,left);
	};
	LoadFont("Common Normal")..{
		Text="Courses/Music Trains: "..SONGMAN:GetNumCourses().."+"..SONGMAN:GetNumAdditionalCourses();
		InitCommand=cmd(xy,20,300;horizalign,left);
	};
	LoadFont("Common Normal")..{
		Text="Easy Group: ";
		InitCommand=cmd(xy,20,325;horizalign,left);
		OnCommand=function(self)
			if SONGMAN:DoesSongGroupExist(RIO_FOLDER_NAMES["EasyFolder"]) == false then
				self:settext(self:GetText().." Missing!");
				self:diffuse(Color("Red"));
			else
				self:settext(self:GetText().." Ok! | "..#SONGMAN:GetSongsInGroup(RIO_FOLDER_NAMES["EasyFolder"]).." songs");
				self:diffuse(Color("Green"));
			end;
			self:settext(self:GetText().." | "..RIO_FOLDER_NAMES["EasyFolder"])
			
			if PREFSMAN:GetPreference("HiddenSongs") then
				self:settext(self:GetText().." | Unlock system Ok!");
			else
				self:settext(self:GetText().." | Unlock system Off!");
			end;
		end;
	};
	LoadFont("Common Normal")..{
		Text="Full Songs Group: ";
		InitCommand=cmd(xy,20,350;horizalign,left);
		OnCommand=function(self)
			if SONGMAN:DoesSongGroupExist(RIO_FOLDER_NAMES["FullTracksFolder"]) == false then
				self:settext(self:GetText().." Missing!");
				self:diffuse(Color("Red"));
			else
				self:settext(self:GetText().." Ok! | "..#SONGMAN:GetSongsInGroup(RIO_FOLDER_NAMES["FullTracksFolder"]).." songs");
				self:diffuse(Color("Green"));
			end;
			self:settext(self:GetText().." | "..RIO_FOLDER_NAMES["FullTracksFolder"])
		end;
	};
	LoadFont("Common Normal")..{
		Text="Snap Tracks Group: ";
		InitCommand=cmd(xy,20,375;horizalign,left);
		OnCommand=function(self)
			if SONGMAN:DoesSongGroupExist(RIO_FOLDER_NAMES["SnapTracksFolder"]) == false then
				self:settext(self:GetText().." Missing!");
				self:diffuse(Color("Red"));
			else
				self:settext(self:GetText().." Ok! | "..#SONGMAN:GetSongsInGroup(RIO_FOLDER_NAMES["SnapTracksFolder"]).." songs");
				self:diffuse(Color("Green"));
			end;
			self:settext(self:GetText().." | "..RIO_FOLDER_NAMES["SnapTracksFolder"])
		end;
	};
	--[[LoadFont("Common Normal")..{
		Text="asdadadsassadasdad: "..#SONGMAN:GetSongsInGroup("test");
		InitCommand=cmd(xy,20,375;horizalign,left);
	};]]
	
	LoadFont("Common Normal")..{
		--Text="Uptime: "..SecondsToHHMMSS(GetTimeSinceStart(););
		InitCommand=cmd(xy,20,SCREEN_BOTTOM-65;horizalign,left);
		OnCommand=cmd(queuecommand,"UpdateText");
		UpdateTextCommand=cmd(settext,"Uptime: "..SecondsToHHMMSS(GetTimeSinceStart());sleep,1;queuecommand,"UpdateText");
	};
	LoadFont("Common Normal")..{
		--Text="Uptime: "..SecondsToHHMMSS(GetTimeSinceStart(););
		InitCommand=cmd(xy,20,SCREEN_BOTTOM-40;horizalign,left);
		OnCommand=cmd(queuecommand,"UpdateText");
		UpdateTextCommand=cmd(settext,"Time: "..Hour()..":"..Minute()..":"..Second();sleep,1;queuecommand,"UpdateText");
	};
	

};

return t;
