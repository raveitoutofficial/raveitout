--Since we have spanish translation, the strings are in Languages/en.ini
local phrases = {
	THEME:GetString("ScreenStageInformation","PerfectionistMessage"),
	THEME:GetString("ScreenStageInformation","ModifiersMessage"),
	THEME:GetString("ScreenStageInformation","BugsMessage"),
	THEME:GetString("ScreenStageInformation","HoldsMessage"),
	THEME:GetString("ScreenStageInformation","ScreenFilterMessage"),
	THEME:GetString("ScreenStageInformation","ProModeMessage"),
	THEME:GetString("ScreenStageInformation","AdvancedOptionsMessage"),
	THEME:GetString("ScreenStageInformation","SpecialModeMessage"),
	THEME:GetString("ScreenStageInformation","GirlMessage"),
	THEME:GetString("ScreenStageInformation","WeatherMessage"),
	THEME:GetString("ScreenStageInformation","TriviaMessage"),
	THEME:GetString("ScreenStageInformation","LoadingBackgroundsMessage"),
	THEME:GetString("ScreenStageInformation","BonusHeartsMessage"),
	THEME:GetString("ScreenStageInformation","OvertimeStageMessage")
};

local message;
local song = GAMESTATE:GetCurrentSong()
if not song then
	local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
	local e = trail:GetTrailEntries()
	if #e > 0 then
		song = e[1]:GetSong()
	end
end
local songmsgpath = song:GetSongDir().."msg.txt";
local songhasmsg = FILEMAN:DoesFileExist(songmsgpath)

if GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse():GetDescription() ~= "" then
	message = GAMESTATE:GetCurrentCourse():GetDescription();
elseif songhasmsg then
	local file = File.Read(songmsgpath)
	local messages = split("\r\n",file);
	--SCREENMAN:SystemMessage(tostring(#messages).." "..strArrayToString(messages));
	message = messages[math.random(#messages)];
else
	message = phrases[math.random(#phrases)];
end;



--animation controls
local inanit = 0.5		--in animation time
local inefft = 2		--in effect time
local stayat = 5-inanit-inefft		--stay still animation time
local outtwt = 0.25		--out tweening time
local itemy = 13		--item list y separation
local MessageFont = "Common normal"

return Def.ActorFrame{
	--bg
	Def.Sprite{
		InitCommand=cmd(LoadFromCurrentSongBackground;Cover;diffuse,color(".2,.2,.2,1"));
		OnCommand=cmd(sleep,stayat+inanit+inefft;linear,.4;diffusealpha,.8);
	};

	Def.Sprite{				--Song Jacket
		InitCommand=cmd(x,_screen.cx;y,_screen.cy;zoom,10;diffusealpha,0;);
		OnCommand=function(self)
			if GAMESTATE:IsCourseMode() and getenv("PlayMode") == "Mixtapes" and GAMESTATE:GetCurrentCourse():HasBanner() then
				self:Load(GAMESTATE:GetCurrentCourse():GetBannerPath());
			else
				self:Load(getLargeJacket());
			end;
			(cmd(accelerate,inanit;zoomto,300,300;diffusealpha,1;linear,inefft;zoomto,255,255;sleep,stayat))(self)
		end;
		OffCommand=cmd(decelerate,outtwt;rotationz,90*0.5;zoom,0.8;diffusealpha,0);
	};
	LoadFont(MessageFont)..{	--MESSAGE		
		Text=message;
		InitCommand=cmd(xy,_screen.cx,SCREEN_BOTTOM-60;zoom,0.75;maxwidth,SCREEN_WIDTH;wrapwidthpixels,780;maxheight,100);
	};
	Def.Quad{				--Fade in/out
		InitCommand=function(self)
			(cmd(FullScreen;diffuse,color("1,1,1,1");linear,inanit*0.5;diffuse,color("0,0,0,0")))(self);
			(cmd(sleep,(inanit*0.5)+inefft+(stayat)))(self);
			--[[ ^ this shit needs some explanation:
			-- inanit is always the half the time as the disc image one
			-- resolved should be:
			--  sleep,(0.5*0.5)+2+(5-(0.5+2))
			--  sleep,0.25+2+(5-2.5)
			--  sleep,0.25+2+2.5
			--  sleep,4.75
			--]]
			--(cmd(linear,inanit*0.5;diffuse,color("0,0,0,1")))(self);
		end;
	};
	LoadFont("letters/_ek mukta Bold 40px")..{
		Condition=(getenv("IsOMES_RIO") == true);
		Text=THEME:GetString("ScreenStageInformation","GetFullCombo");
		InitCommand=cmd(Center;addx,600;diffusealpha,0;--[[diffuseleftedge,Color("Purple");faderight,1]]);
		OnCommand=cmd(decelerate,inanit+inefft;addx,-600;diffusealpha,.5;linear,stayat;diffusealpha,1;);
		OffCommand=cmd(decelerate,outtwt;diffusealpha,0);
	};
	LoadFont("letters/_ek mukta Bold 40px")..{
		Condition=(getenv("IsOMES_RIO") == true);
		Text=THEME:GetString("ScreenStageInformation","GetFullCombo");
		InitCommand=cmd(Center;addx,-600;diffusealpha,0;--[[diffuserightedge,Color("Blue");fadeleft,1]]);
		OnCommand=cmd(decelerate,inanit+inefft;addx,600;diffusealpha,.5;linear,stayat;diffusealpha,1;);
		OffCommand=cmd(decelerate,outtwt;diffusealpha,0);
	};
	
	--Debug
	LoadFont(DebugFont)..{	--songhasmsg
		Condition=DoDebug;
		InitCommand=cmd(xy,SCREEN_RIGHT,SCREEN_BOTTOM-(itemy*1);horizalign,right;zoom,0.5);
		OnCommand=function(self)
			if songhasmsg then
				self:settext("songhasmsg: true");
			else
				self:settext("songhasmsg: false");
			end;
		end;
	};
};
