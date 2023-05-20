local t = Def.ActorFrame {
	InitCommand=function(self)
		state = 1;
	end
};

--HAS THIS GUY EVER HEARD OF METRICS???

-- Chart info helpers
local infy =		160					--Chart info Y axis position (both players, includes black quad alt)
local infx =		0					--Chart info X DIFFERENCE FROM DISC
--quad stuff
local infft =		0.125*0.75			--Chart info quad fade top
local inffb =		infft				--Chart info quad fade bottom
local redu =		0					--Chart info vertical reduction value for black quad (pixels)
local bqwid =		_screen.cx			--Chart info quad width
local bqalt =		244-20				--Chart info black quad height
local bqalph =		0.9					--Chart info black quad diffusealpha value
local wqwid =		_screen.cx			--

local npsxz =	_screen.cx*0.5		--next/previous song X zoom
local npsyz =	_screen.cy --*0.75	--next/previous song Y zoom
--
local newranktext = "NEW CHALLENGER"	--text replacing #P1# when someone does a new record
local bpmalt = 	_screen.cy+55			--Y value for BPM Display below banner

	if IsUsingWideScreen() then
		defaultzoom = 0.8;
		else
		defaultzoom = 0.65;
	end;

t[#t+1] = Def.ActorFrame{
	PlayerJoinedMessageCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenSelectProfile");
	end;
};

--PREVIEW BOX
t[#t+1] = LoadActor("songPreview");


---DECORATIONS IN GENERAL
t[#t+1] = Def.ActorFrame {
	--MSG INFO
	LoadActor("help_info/txt_box")..{
		InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-50;zoomx,0.9;zoomy,0.65);
	};
	
	Def.Sprite{
		--Yeah I dunno why I have to specify the full path
		Texture=THEME:GetPathB("ScreenSelectMusic","overlay/help_info/messages 1x4.png");
		InitCommand=function(self)
			(cmd(x,_screen.cx;y,SCREEN_BOTTOM-50;zoom,.6;animate,false;setstate,0))(self);
			if getenv("PlayMode") == "Easy" then
				self:Load(THEME:GetPathB("ScreenSelectMusic","overlay/help_info/easymessages 1x4.png"));
			end;
		end;
		OnCommand=cmd(queuecommand,"Set");
		SetCommand=function(self)
			--I know hard coding stuff is bad, but there will only ever be 4 states...
			--And also, hide the setlist prompt if we're in Special mode, since there are no folders
			--in special mode.
			if self:GetState()+1 >= 4 or (getenv("PlayMode") == "Special" and self:GetState() == 2) then
				self:setstate(0);
			else
				self:setstate(self:GetState()+1);
			end;
			self:linear(0.2);
			self:diffusealpha(1);
			self:sleep(2);
			self:linear(0.2)
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
		
		TwoPartConfirmCanceledMessageCommand=cmd(playcommand,"PickingSong");
		SongUnchosenMessageCommand=cmd(playcommand,"PickingSong");
		PickingSongCommand=cmd(stoptweening;linear,.2;diffusealpha,1;sleep,2;linear,.2;diffusealpha,0;queuecommand,"Set");
		SongChosenMessageCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
	};
	
	Def.Sprite{
		Texture=THEME:GetPathB("ScreenSelectMusic","overlay/help_info/difficulty_messages 1x4.png");
		InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-50;zoom,.6;animate,false;setstate,0;diffusealpha,0);
		SetCommand=function(self)
			--I know hard coding stuff is bad, but there will only ever be 4 states...
			--And also, hide the command window info if we're in Easy mode.
			if self:GetState()+1 >= 4 or (getenv("PlayMode") == "Easy" and self:GetState() == 2) then
				self:setstate(0);
			else
				self:setstate(self:GetState()+1);
			end;
			self:linear(0.2);
			self:diffusealpha(1);
			self:sleep(2);
			self:linear(0.2)
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
		TwoPartConfirmCanceledMessageCommand=cmd(playcommand,"PickingSong");
		SongUnchosenMessageCommand=cmd(playcommand,"PickingSong");
		PickingSongCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
		SongChosenMessageCommand=cmd(stoptweening;linear,.2;diffusealpha,1;sleep,2;linear,.2;diffusealpha,0;queuecommand,"Set");
	
	};
	
	--TIME
	LoadFont("monsterrat/_montserrat light 60px")..{
		Text="TIME";
		InitCommand=cmd(x,SCREEN_CENTER_X-25;y,SCREEN_BOTTOM-92;zoom,0.6;skewx,-0.2);
	};

	
	--Current Group/Playlist
	LoadActor("current_group")..{
		InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP+5;horizalign,left;vertalign,top;zoomx,1;cropbottom,0.3);
	};
	
	LoadFont("monsterrat/_montserrat light 60px")..{
		Text=THEME:GetString("ScreenSelectMusic","CURRENT SONGLIST");
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+18;y,SCREEN_TOP+10;zoom,0.185;skewx,-0.1);
		--Wat? Why would this ever change?
		--[[CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
			if song then
				self:uppercase(true);
				self:settext("Current songlist");
			end
		end;]]
	};
	
	LoadFont("monsterrat/_montserrat semi bold 60px")..{
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+16;y,SCREEN_TOP+30;zoom,0.6;skewx,-0.25;uppercase,true);
		OnCommand=function(self)
			--Maybe this is a bad idea. cur_group isn't set if the channel_system isn't loaded, so just set it manually.
			--assert(getenv("cur_group"),"current group not set!");
			if not getenv("cur_group") then setenv("cur_group",SCREENMAN:GetTopScreen():GetMusicWheel():GetSelectedSection()) end
			self:settext(string.gsub(getenv("cur_group"),"^%d%d? ?%- ?", ""));
		end;
		StartSelectingSongMessageCommand=function(self)
			self:playcommand("On");
		end;
	};
 };
 
t[#t+1] = LoadActor("arrow_shine");
t[#t+1] = Def.ActorFrame{

	
	--[[LoadFont("Common normal")..{	--formatted stage display
		InitCommand=cmd(xy,_screen.cx,_screen.cy-190;zoomx,0.75;zoomy,0.65);
		Text=ToEnumShortString(GAMESTATE:GetCurrentStage()).." Stage";
	};]]
	--[[LoadFont("monsterrat/_montserrat semi bold 60px")..{
		InitCommand=cmd(horizalign,right;x,SCREEN_RIGHT-16;y,SCREEN_TOP+23;zoom,0.6;skewx,-0.25;);
		Text=string.upper(ToEnumShortString(GAMESTATE:GetCurrentStage()).." Stage");
	};]]
	
	--Left side background
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT;y,_screen.cy+110;vertalign,middle,horizalign,right);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,SCREEN_CENTER_X);
		SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,SCREEN_LEFT;);
		Def.Quad{		--white quad for Difficulties
			InitCommand=cmd(horizalign,right;zoomto,_screen.cx,35;diffuse,1,1,1,0.75;x,0;y,-3;fadeleft,1;);
		};
		
		Def.Quad{		--Black quad for Chart info P1
			InitCommand=cmd(horizalign,right;fadetop,infft;fadebottom,inffb;xy,-infx,-infy+20;zoomto,bqwid*2,bqalt+50;diffuse,0,0,0,bqalph;);
			--InitCommand=cmd(diffuse,color("0,0,0,"..bqalph);xy,0,SCREEN_CENTER_Y;horizalign,right;setsize,bqwid*2,bqalt+50;);
		};
		LoadFont("bebas/_bebas neue bold 90px")..{
			Text=THEME:GetString("ScreenSelectMusic","NOT PRESENT");
			Condition=not GAMESTATE:IsHumanPlayer(PLAYER_1);
			InitCommand=cmd(x,-_screen.cx*0.7;y,-infy;zoom,0.3;skewx,-0.2);
			--PlayerJoinedMessageCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_1));
		};
	};
	--Right side background
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_RIGHT;y,_screen.cy+110;vertalign,middle,horizalign,left);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,SCREEN_CENTER_X);
		SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,SCREEN_RIGHT;);
		Def.Quad{		--white quad for Difficulties
			InitCommand=cmd(horizalign,left;zoomto,_screen.cx,35;diffuse,1,1,1,0.75;x,0;y,-3;faderight,1;);
		};
		
		Def.Quad{		--Black quad for Chart info P1
			InitCommand=cmd(horizalign,left;fadetop,infft;fadebottom,inffb;xy,-infx,-infy+20;zoomto,bqwid*2,bqalt+50;diffuse,0,0,0,bqalph;);
			--InitCommand=cmd(diffuse,color("0,0,0,"..bqalph);xy,0,SCREEN_CENTER_Y;horizalign,right;setsize,bqwid*2,bqalt+50;);
		};
		LoadFont("bebas/_bebas neue bold 90px")..{
			Condition=not GAMESTATE:IsHumanPlayer(PLAYER_2);
			Text=THEME:GetString("ScreenSelectMusic","NOT PRESENT");
			InitCommand=cmd(x,_screen.cx*0.7;y,-infy;zoom,0.3;skewx,-0.2);
			--PlayerJoinedMessageCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_2));
		};
	};
	Def.Quad{		--White for Chart info P1 EFFECT JOINED
		InitCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2));
			(cmd(horizalign,right;fadetop,infft;fadebottom,inffb;x,-infx;y,-infy;
				 zoomto,bqwid,bqalt-redu;diffuse,1,1,1,0;blend,'BlendMode_Add';))(self)
		end;
		PlayerJoinedMessageCommand=function(self)
			(cmd(zoomy,(bqalt-redu)*1.25;diffuse,1,1,1,1;decelerate,0.75;zoomy,(bqalt-redu)*0.925;diffuse,1,1,1,0))(self)
		end;
	};
	Def.Quad{	--White for Chart info P2 EFFECT JOINED
		InitCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
			(cmd(horizalign,left;fadetop,infft;fadebottom,inffb;x,infx;y,-infy;
				 zoomto,bqwid,bqalt-redu;diffuse,1,1,1,0;blend,'BlendMode_Add';))(self)
		end;
		PlayerJoinedMessageCommand=function(self)
			(cmd(zoomy,(bqalt-redu)*1.25;diffuse,1,1,1,1;decelerate,0.75;zoomy,(bqalt-redu)*0.925;diffuse,1,1,1,0))(self)
		end;
	};
};


t[#t+1] = Def.ActorFrame{			
	LoadActor("judge_back")..{		--This is my big surprise secret remodel lmfao -Gio
			InitCommand=cmd(zoom,0.35;x,SCREEN_CENTER_X;y,THEME:GetMetric("ScreenSelectMusic","StepsInfoY");diffusealpha,0);
			SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
			SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	};
	LoadFont("facu/_zona pro bold 40px")..{
		Text="STEPS INFO";
		InitCommand=cmd(zoom,0.35;x,SCREEN_CENTER_X;y,THEME:GetMetric("ScreenSelectMusic","StepsInfoY")-1;diffusealpha,0);
		SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
		SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	};
	
	LoadActor("tab-speed")..{		--Fancy, eh?
			InitCommand=cmd(zoom,0.35;x,SCREEN_CENTER_X;y,THEME:GetMetric("ScreenSelectMusic","SpeedInfoY");diffusealpha,0);
			SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
			SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	};
	LoadActor("tab-score")..{		--I hope people like it!
			InitCommand=cmd(zoom,0.35;x,SCREEN_CENTER_X;y,THEME:GetMetric("ScreenSelectMusic","ScoreInfoY");diffusealpha,0);
			SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
			SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	};
}

--This is what has the steps info, speed, score, etc
for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor("DifficultySelectObjects", pn, infx, infy);
end;

if getenv("PlayMode") == "Easy" then
	t[#t+1] = LoadActor("EasyDifficultyList")..{
		InitCommand=cmd(Center;addy,107;zoom,.4);
	};
else

	--Difficulty List Orbs Shadows
	for i=1,12 do
		t[#t+1] = LoadActor("DifficultyList/background_orb") .. {
			InitCommand=cmd(diffusealpha,0.85;zoom,0.375;x,_screen.cx-245+i*35;y,_screen.cy+107;horizalign,left);
		};
	end;
	--Difficulty List Orbs
	t[#t+1] = Def.ActorFrame{			
		LoadActor("DifficultyList")..{
			OnCommand=cmd(finishtweening;sleep,0.1;playcommand,"Update");
			UpdateCommand=function(self)
				local song = GAMESTATE:GetCurrentSong();
				if song then
					self:stoptweening();
					self:rotationz(270);
					self:linear(0.1);
					self:x(_screen.cx-187);
					self:y(_screen.cy+105);
					self:zoom(0.7);
				end;
			end;
			TwoPartConfirmCanceledMessageCommand=cmd(finishtweening;playcommand,"SongUnchosenMessage");
			SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.1;playcommand,"Update");
			PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"Update");
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Update");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Update");
			CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"Update");

		};
	}
	--Don't load if not used.
	if THEME:GetMetric("ScreenSelectMusic","UseOptionsList") then
		t[#t+1] = LoadActor("OptionsList");
	end;
end;
 
t[#t+1] = LoadActor("code_detector.lua")..{};
--t[#t+1] = LoadActor("PlayerMods")..{};
--t[#t+1] = LoadActor("GenreSounds.lua")..{};
if getenv("PlayMode") == "Arcade" or getenv("PlayMode") == "Pro" then 
	
	if GetSmallestNumHeartsLeftForAnyHumanPlayer() > 1 then
		t[#t+1] = LoadActor("channel_system")..{};
	else
		if SONGMAN:DoesSongGroupExist(RIO_FOLDER_NAMES["SnapTracksFolder"]) then
			--assert(SONGMAN:DoesSongGroupExist(RIO_FOLDER_NAMES["SnapTracksFolder"]),"You are missing the snap tracks folder from SYSTEM_PARAMETERS.lua which is required. The game cannot continue.");
			local folder = SONGMAN:GetSongsInGroup(RIO_FOLDER_NAMES["SnapTracksFolder"]);
			local randomSong = folder[math.random(1,#folder)]
			GAMESTATE:SetCurrentSong(randomSong);
			GAMESTATE:SetPreferredSong(randomSong);
		else
			lua.ReportScriptError("You are missing the snap tracks folder from SYSTEM_PARAMETERS.lua which is required. The game will continue, but there will be glitches.");
			t[#t+1] = LoadActor("channel_system")..{};
		end;
	end;
end;

t[#t+1] = LoadActor(THEME:GetPathB("","ProfileBanner"))..{};

t[#t+1] = LoadActor("ready")..{		-- 1 PLAYER JOINED READY
	InitCommand=cmd(visible,false;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoom,2;);
	WaitingConfirmMessageCommand=cmd(playcommand,"Ready";);
	StepsChosenMessageCommand=cmd(playcommand,"Ready";);
	ReadyCommand=function(self)
		if GAMESTATE:GetNumSidesJoined() == 1 and state > 1 then
			self:stoptweening();
			self:visible(false);
			self:zoom(1);
			self:linear(0.3);
			self:zoom(2);
			self:visible(true);
		end;
	end;
	CurrentSongChangedMessageCommand=cmd(visible,false);
	StepsUnchosenMessageCommand=cmd(visible,false);
	SongUnchosenMessageCommand=cmd(visible,false);
};

--TODO: Refactor it eventually since it's a waste of code
if getenv("PlayMode") == "Easy" then
	if GAMESTATE:IsSideJoined(PLAYER_1) then
		t[#t+1] = Def.ActorFrame{

			InitCommand=cmd(x,SCREEN_WIDTH/4;y,SCREEN_CENTER_Y+150);
			--PLAYER 1
			LoadActor("DifficultyList/background_orb")..{
				InitCommand=cmd(horizalign,center;zoom,0.5;);
				OffCommand=function(self,param)
					self:linear(0.3);
					self:Load(THEME:GetPathG("","_white"));
				end;
			};
			
			LoadFont("facu/_zona pro bold 20px")..{
				InitCommand=cmd(uppercase,true;horizalign,center;zoom,0.45;);
				OnCommand = function(self, params)
					self:settext("Speed:\n"..GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():XMod().."x");
				end;
				CodeMessageCommand = function(self, params)
					self:playcommand("On");
				end;
			};
			
		};
	end;
	if GAMESTATE:IsSideJoined(PLAYER_2) then
		t[#t+1] = Def.ActorFrame{
		
			InitCommand=cmd(x,SCREEN_WIDTH*.75;y,SCREEN_CENTER_Y+150);
			--PLAYER 2
			LoadActor("DifficultyList/background_orb")..{
				InitCommand=cmd(horizalign,center;zoom,0.5;);
				OffCommand=function(self,param)
					self:linear(0.3);
					self:Load(THEME:GetPathG("","_white"));
				end;
			};
			
			LoadFont("facu/_zona pro bold 20px")..{
				InitCommand=cmd(uppercase,true;horizalign,center;zoom,0.45;);
				OnCommand = function(self, params)
					self:settext("Speed:\n"..GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():XMod().."x");
				end;
				CodeMessageCommand = function(self, params)
					self:playcommand("On");
				end;
			};
		};
	end;
end;
	

--[[

t[#t+1] = LoadActor("new_song") ..{

	InitCommand=cmd(zoom,0.1;visible,false;x,SCREEN_CENTER_X+200;y,SCREEN_CENTER_Y-150;);
	CurrentSongChangedMessageCommand=function(self)
		if PROFILEMAN:IsSongNew(GAMESTATE:GetCurrentSong()) then self:visible(true); else self:visible(false); end;
	end;
};

--]]
return t
