local EasterEggs = PREFSMAN:GetPreference("EasterEggs");

local curstage = GAMESTATE:GetCurrentStage()

	local gfxNames = {
		Stage_Extra1=	"ScreenGameplay stage extra1";
		Stage_Extra2=	"ScreenGameplay stage extra1";
		Stage_Demo=	"ScreenGameplay stage Demo";
		Stage_Event="ScreenGameplay stage event";
		Stage_1st=	"ScreenGameplay stage 1";
		Stage_2nd=	"ScreenGameplay stage 2";
		Stage_3rd=	"ScreenGameplay stage 3";
		Stage_4th=	"ScreenGameplay stage 4";
		Stage_5th=	"ScreenGameplay stage 5";
		Stage_6th=	"ScreenGameplay stage 6";
		StageFinal=	"ScreenGameplay stage final";
	};

	local stage = gfxNames[curstage];


local stagemaxscore = 100000000*GAMESTATE:GetNumStagesForCurrentSongAndStepsOrCourse()


if GAMESTATE:IsCourseMode() then
	song = GAMESTATE:GetCurrentCourse(); -- Get current Course xD
	songdir = song:GetCourseDir();--Get current course directory xD
else
	song = GAMESTATE:GetCurrentSong(); 	--Get current song lel
	songdir = song:GetSongDir();--Get current song directory lel
end

local IsP1On =		GAMESTATE:IsPlayerEnabled(PLAYER_1)	--Is player 1 present? BRETTY OBIOS :DDDD
local IsP2On =		GAMESTATE:IsPlayerEnabled(PLAYER_2)	--Is player 2 present? BRETTY OBIOS :DDDD
local notefxp1 =	THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX")	--Note field X position P1
local notefxp2 =	THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX")	--Note field X position P2
if IsP1On then

	if GAMESTATE:IsCourseMode() then
		stepsp1 = GAMESTATE:GetCurrentCourse():GetAllTrails()[1]:GetStepsType();
	else
		stepsp1 = GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType();
	end

	if stepsp1 ~= "StepsType_Pump_Single" or PREFSMAN:GetPreference("Center1Player") then		--"if not single mode"
		notefxp1 = SCREEN_CENTER_X		--HALFDOUBLE/DOUBLE/ROUTINE--Note field X position P1
	end
end
if IsP2On then

	if GAMESTATE:IsCourseMode() then
		stepsp2 = GAMESTATE:GetCurrentCourse():GetAllTrails()[1]:GetStepsType();
	else
		stepsp2 = GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType();
	end

	if stepsp2 ~= "StepsType_Pump_Single" or PREFSMAN:GetPreference("Center1Player") then		--"if not single mode"
		notefxp2 = SCREEN_CENTER_X		--HALFDOUBLE/DOUBLE/ROUTINE--Note field X position P2
	end
end

if PREFSMAN:GetPreference("Center1Player") and GAMESTATE:GetNumSidesJoined() == 1 then
	stats_x = SCREEN_CENTER_X/2-20;
	stats_y = -SCREEN_HEIGHT+45;
	
elseif stepsp1 ~= "StepsType_Pump_Single" or stepsp2 ~= "StepsType_Pump_Single" then
	stats_y = -SCREEN_HEIGHT+59;
else
	stats_x = 5;
	stats_y = -SCREEN_HEIGHT+50;
end
				
local t = Def.ActorFrame{

 	Def.ActorFrame{	--Main
		LoadActor("stats.lua")..{
			InitCommand=cmd(y,stats_y;x,stats_x)
		};		--Stats at screen bottom
		
		LoadActor("new_elements");
		LoadActor("score_system");
		
		LoadFont("monsterrat/_montserrat light 60px")..{	--percentage scoring P1
			InitCommand=cmd(visible,IsP1On;zoom,0.3;x,notefxp1;y,SCREEN_BOTTOM-30;skewx,-0.25);
			ComboChangedMessageCommand=function(self,param)
			--LifeChangedMessageCommand=function(self,param)
				-- percentage scoring stuff:
				local State = GAMESTATE:GetPlayerState(PLAYER_1);
				local PlayerType = State:GetPlayerController();				
				local css = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
				local curmaxscore =	stagemaxscore
				local score =		css:GetScore()				--score :v
				local rawaccuracy =	(score/curmaxscore)*100		--Player accuracy RAW number
				--"%.3f" thanks CH32, se cambia el numero para mas decimales
				local accuracy =		tonumber(string.format("%.02f",rawaccuracy)) or 0;		--Player accuracy formatted number
				
				--accuracy = getenv("P1_accuracy") or 0;
				
				if stepsp1 == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() ~= PLAYER_1 then
					self:settext("");
				else
					if accuracy == 0 then
						self:settext("0.00%");
					else
						self:settext(accuracy.."%");
					end;
				end;
				-- sets the accuracy (ugly workaround) -ROAD24
				setenv("P1_accuracy",accuracy);
				end;
			
		};
		
		LoadFont("monsterrat/_montserrat light 60px")..{	--percentage scoring P2
			InitCommand=cmd(visible,IsP2On;zoom,0.3;x,notefxp2;y,SCREEN_BOTTOM-30;skewx,-0.25);
			ComboChangedMessageCommand=function(self,param)
			--LifeChangedMessageCommand=function(self,param)
				-- percentage scoring stuff:
				local State = GAMESTATE:GetPlayerState(PLAYER_2);
				local PlayerType = State:GetPlayerController();				
				local css = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
				local curmaxscore =	stagemaxscore
				local score =		css:GetScore()				--score :v
				local rawaccuracy =	(score/curmaxscore)*100		--Player accuracy RAW number
				--"%.3f" thanks CH32, se cambia el numero para mas decimales
				local accuracy =		tonumber(string.format("%.02f",rawaccuracy)) or 0;		--Player accuracy formatted number

				if stepsp2 == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() ~= PLAYER_2 then
					self:settext("");
				else
					if accuracy == 0 or PlayerType ~= 'PlayerController_Human' then
						self:settext("0.00%");
					else
						self:settext(accuracy.."%");
					end;
				end;
				-- sets the accuracy (ugly workaround) -ROAD24
				setenv("P2_accuracy",accuracy);
			end;
		};

		Def.Quad{		--fade in to gameplay screen
			OnCommand=cmd(FullScreen;diffuse,0,0,0,1;linear,0.4;diffusealpha,0);
		};
		--[[Def.Actor{		--TO DO: Only activate the gamecommand IF the player is using Sink and or Rise
			InitCommand=cmd(queuecommand,"SinkRise");
			SinkRiseCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				local bpm = song:GetDisplayBpms() 
				local vel = (60/((bpm[1]+bpm[2])/2)).."x";
				GAMESTATE:ApplyGameCommand("mod, "..vel,pn);
			end;
		};--]]
		LoadActor("song meter")..{
			--this would never NOT be visible... Items are visible by default
			--[[OnCommand=function(self)
				if stage == "ScreenGameplay stage Demo" then self:visible(true); end
			end;]]
		};
		
		LoadActor("demoplay")..{
			InitCommand=cmd(x,notefxp1;y,SCREEN_BOTTOM-70;zoom,0.5;playcommand,"Set");
			OnCommand=function(self)
				if stage ~= "ScreenGameplay stage Demo" then self:visible(false); end
			end;
			
			SetCommand=function(self)
				self:linear(0.2);
				self:diffusealpha(1);
				self:sleep(0.5);
				self:linear(0.2)
				self:diffusealpha(0);
				self:queuecommand("Set");
			end;
		};
		
		LoadActor("demoplay")..{
			InitCommand=cmd(x,notefxp2;y,SCREEN_BOTTOM-70;zoom,0.5;playcommand,"Set");
			OnCommand=function(self)
				if stage ~= "ScreenGameplay stage Demo" then self:visible(false); end
			end;
			
			SetCommand=function(self)
				self:linear(0.2);
				self:diffusealpha(1);
				self:sleep(0.5);
				self:linear(0.2)
				self:diffusealpha(0);
				self:queuecommand("Set");
			end;
		};

	};
	
	Def.ActorFrame {
		InitCommand=cmd(x,notefxp1;y,SCREEN_CENTER_Y;visible,GAMESTATE:IsSideJoined(PLAYER_1));
			ComboChangedMessageCommand=function (self, params)
				local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
	
				if stats:GetCurrentCombo() == 420 and EasterEggs then
					MESSAGEMAN:Broadcast("WeedP1");
				end
			end;

			LoadActor(THEME:GetPathG("","WeedCombo/explosion")) .. {
				InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';hide_if,not EasterEggs);
				WeedP1MessageCommand=cmd(rotationz,0;zoom,2;diffusealpha,0.5;linear,0.5;rotationz,90;zoom,1.75;diffusealpha,0);
			};
			LoadActor(THEME:GetPathG("","WeedCombo/explosion")) .. {
				InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';hide_if,not EasterEggs);
				WeedP1MessageCommand=cmd(rotationz,0;zoom,2;diffusealpha,0.5;linear,0.5;rotationz,-90;zoom,2.5;diffusealpha,0);
			};


	};

	Def.ActorFrame {
		InitCommand=cmd(x,notefxp2;y,SCREEN_CENTER_Y;visible,GAMESTATE:IsSideJoined(PLAYER_2));
			ComboChangedMessageCommand=function (self, params)
				local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
	
				if stats:GetCurrentCombo() == 420 and EasterEggs then
					MESSAGEMAN:Broadcast("WeedP2");
				end
			end;

			LoadActor(THEME:GetPathG("","WeedCombo/explosion")) .. {
				InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';hide_if,not EasterEggs);
				WeedP2MessageCommand=cmd(rotationz,0;zoom,2;diffusealpha,0.5;linear,0.5;rotationz,90;zoom,1.75;diffusealpha,0);
			};
			LoadActor(THEME:GetPathG("","WeedCombo/explosion")) .. {
				InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';hide_if,not EasterEggs);
				WeedP2MessageCommand=cmd(rotationz,0;zoom,2;diffusealpha,0.5;linear,0.5;rotationz,-90;zoom,2.5;diffusealpha,0);
			};
	};
	
	-- Player 1
	LoadFont("facu/_zona pro bold 20px")..{
		InitCommand=cmd(player,PLAYER_1;x,THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX");y,SCREEN_BOTTOM-46;horizalign,'HorizAlign_Center');
		OnCommand=function(self, param)
		p1stype = GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType();
		if p1stype ~= "StepsType_Pump_Single" and GAMESTATE:GetNumSidesJoined() == 1 or PREFSMAN:GetPreference("Center1Player") then
			self:x(_screen.cx);
		end
			self:settext("Score: ".."0000");
			self:zoom(0.7);
			self:skewx(-0.25);
			self:diffusealpha(0.9);
		end;
		--Score is updated in score_system then broadcast and this recieves it
		RIOScoreChangedMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then
				if params.Score > 0 then
					self:settext("Score: "..params.Score);
				else
					self:settext("Score: 0000");
				end;				
			end;
		end;
		OffCommand=function(self, param)
			--STATSMAN:GetCurStageStats():GetPlayerStageStats( PLAYER_1 ):SetScore( getScores()[PLAYER_1] );
		end;
	};	
	-- Player 2
	LoadFont("facu/_zona pro bold 20px")..{
		InitCommand=cmd(player,PLAYER_2;x,THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX");y,SCREEN_BOTTOM-46;horizalign,'HorizAlign_Center');
		OnCommand=function(self, param)
		p2stype = GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType();
		if p2stype ~= "StepsType_Pump_Single" and GAMESTATE:GetNumSidesJoined() == 1 or PREFSMAN:GetPreference("Center1Player") then
			self:x(_screen.cx);
		end
			self:settext("Score: ".."0000");
			self:zoom(0.7);
			self:skewx(-0.25);
			self:diffusealpha(0.9);
		end;
		RIOScoreChangedMessageCommand=function(self,params)
			if params.Player == PLAYER_2 then
				if params.Score > 0 then
					self:settext("Score: "..params.Score);
				else
					self:settext("Score: ".."0000");
				end;
			end;
		end;
		OffCommand=function(self, param)
			--STATSMAN:GetCurStageStats():GetPlayerStageStats( PLAYER_2 ):SetScore( getScores()[PLAYER_2] );
		end;
	};

	LoadActor("MenuOptions");	
};

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = LoadActor("Failed")..{
		InitCommand=function(self)
			local style = ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType())
			if style == "OnePlayerOneSide" and PREFSMAN:GetPreference("Center1Player") == true then
				self:x(SCREEN_CENTER_X);
			else
				self:x(THEME:GetMetric("ScreenGameplay","Player"..pname(pn).."OnePlayerOneSideX"));
			end;
			self:y(SCREEN_CENTER_Y):visible(false);
		end;
		ComboChangedMessageCommand=function(self,params)
			if STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetFailed() then
				self:visible(true);
			end;
		end;
	
	};
end;

return t;
