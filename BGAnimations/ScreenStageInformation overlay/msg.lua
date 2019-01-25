local IsP1On =		GAMESTATE:IsPlayerEnabled(PLAYER_1)	--Is player 1 present? BRETTY OBIOS :DDDD
local IsP2On =		GAMESTATE:IsPlayerEnabled(PLAYER_2)	--Is player 2 present? BRETTY OBIOS :DDDD


if GAMESTATE:IsCourseMode() then
	song = GAMESTATE:GetCurrentCourse(); -- Get current Course xD
	songdir = song:GetCourseDir();--Get current course directory xD
else
	song = GAMESTATE:GetCurrentSong(); 	--Get current song lel
	songdir = song:GetSongDir();--Get current song directory lel
end
local songmsgpath = 	songdir.."msg.txt"

local songhasmsg = 		FILEMAN:DoesFileExist(songmsgpath)

if GAMESTATE:IsCourseMode() and GetCourseDescription(GAMESTATE:GetCurrentCourse():GetCourseDir(),"DESCRIPTION") ~= "" then
	coursehasmsg = true
else  
	coursehasmsg = false
end;

local songmsgtext =		File.Read(songmsgpath)
local msgpath =			THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenStageInformation overlay/fallbacktext.txt"
local fallbacktext =	File.Read(msgpath)
local raw_random_text = GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenStageInformation overlay/random_msg.txt","MSG"..math.random(1,10));
local chars = string.len(raw_random_text);
local random_text = GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenStageInformation overlay/random_msg.txt","MSG"..math.random(1,10));

if coursehasmsg == true then
	message = GetCourseDescription(GAMESTATE:GetCurrentCourse():GetCourseDir(),"DESCRIPTION");
elseif songhasmsg then
	message = songmsgtext;
else
	--message = fallbacktext;
	message = random_text;
end;

--animation controls
local inanit = 0.5		--in animation time
local inefft = 2		--in effect time
local stayat = 5-inanit-inefft		--stay still animation time
local outtwt = 0.25		--out tweening time
local itemy = 13		--item list y separation
local MessageFont = "Common normal"

return Def.ActorFrame{
	Def.ActorFrame{	--main
		--bg
		Def.Sprite{
			InitCommand=cmd(LoadFromCurrentSongBackground;Cover;diffusealpha,0.2);
			OnCommand=cmd(sleep,stayat+inanit+inefft;linear,.4;diffusealpha,.8);
		};
	
		Def.Sprite{				--Song Jacket
			InitCommand=cmd(x,_screen.cx;y,_screen.cy;zoom,10;diffusealpha,0;);
			OnCommand=function(self)
				--[[if song:HasJacket() then
					self:Load(song:GetJacketPath());
				else
					self:Load(song:GetBannerPath());
				end]]
				self:Load(getLargeJacket());
				(cmd(accelerate,inanit;zoomto,300,300;diffusealpha,1;linear,inefft;zoomto,255,255;sleep,stayat))(self)
			end;
			OffCommand=cmd(decelerate,outtwt;rotationz,90*0.5;zoom,0.8;diffusealpha,0);
		};
		LoadFont(MessageFont)..{	--MESSAGE		
			InitCommand=cmd(xy,_screen.cx,SCREEN_BOTTOM-60;zoom,0.75;maxwidth,SCREEN_WIDTH;wrapwidthpixels,780;maxheight,100;settext,message);
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
	};
	Def.ActorFrame{	--debug
		OnCommand=cmd(visible,DoDebug);
		LoadFont(DebugFont)..{	--songhasmsg
			InitCommand=cmd(xy,SCREEN_RIGHT,SCREEN_BOTTOM-(itemy*1);horizalign,right;zoom,0.5);
			OnCommand=function(self)
				if songhasmsg then
					self:settext("songhasmsg: true");
				else
					self:settext("songhasmsg: false");
				end;
			end;
		};
		--[[LoadFont(DebugFont)..{	--songmsgtext
			InitCommand=cmd(xy,SCREEN_RIGHT,SCREEN_BOTTOM-(itemy*4);horizalign,right;zoom,0.5;settext,"songmsgtext"..songmsgtext);
		};--]]
		LoadFont(DebugFont)..{	--msgpath
			InitCommand=cmd(xy,SCREEN_RIGHT,SCREEN_BOTTOM-(itemy*5);horizalign,right;zoom,0.5;settext,"msgpath"..msgpath);
		};
		--[[LoadFont(DebugFont)..{	--fallbacktext
			InitCommand=cmd(xy,SCREEN_RIGHT,SCREEN_BOTTOM-(itemy*6);horizalign,right;zoom,0.5;settext,"fallbacktext"..fallbacktext);
		};--]]
	};
};
