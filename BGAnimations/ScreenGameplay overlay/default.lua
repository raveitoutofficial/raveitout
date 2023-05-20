local EasterEggs = PREFSMAN:GetPreference("EasterEggs");
local master_player = GAMESTATE:GetMasterPlayerNumber();

local stage = GAMESTATE:GetCurrentStage();

local numStages = 1;
--Courses are always out of 100000000
if not GAMESTATE:IsCourseMode() then
	if GAMESTATE:GetCurrentSong():IsLong() then
		numStages = 2;
	elseif GAMESTATE:GetCurrentSong():IsMarathon() then
		numStages = 3;
	end;
end;

local stagemaxscore = 100000000*numStages -- GAMESTATE:GetNumStagesForCurrentSongAndStepsOrCourse() returns 3 no matter what... Must be broken
--SCREENMAN:SystemMessage(GAMESTATE:GetCurrentCourse():GetEstimatedNumStages());


if GAMESTATE:IsCourseMode() then
	song = GAMESTATE:GetCurrentCourse(); -- Get current Course xD
	songdir = song:GetCourseDir();--Get current course directory xD
else
	song = GAMESTATE:GetCurrentSong(); 	--Get current song lel
	songdir = song:GetSongDir();--Get current song directory lel
end


local notefxp1 =	THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX")	--Note field X position P1
local notefxp2 =	THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX")	--Note field X position P2
if CenterGameplayWidgets() then
	notefxp1 = SCREEN_CENTER_X
	notefxp2 = SCREEN_CENTER_X
end


				
local t = Def.ActorFrame{

 	Def.ActorFrame{	--Main
		
		LoadActor("new_elements");
		LoadActor("score_system");
		
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			Condition=DoDebug;
			InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y;);
			BeatCrossedMessageCommand=cmd(
				settext,"Beat: "..math.round(GAMESTATE:GetSongBeat())..
				"\nBPS: "..string.format("%.03f",GAMESTATE:GetSongBPS())..
				"\nSeconds: "..string.format("%.03f",GAMESTATE:GetCurMusicSeconds())..
				"\nTotal: "..string.format(GAMESTATE:GetSongPercent(GAMESTATE:GetSongBeat()))
				--"\nCalculated: "..string.format("%.03f",GAMESTATE:GetSongBeat()/GAMESTATE:GetSongBPS())
			);
		};
		
		--[[LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			Condition=DoDebug;
			InitCommand=cmd(Center);
			ComboChangedMessageCommand=function(self)
				self:settext(string.format("%.02f",STATSMAN:GetCurStageStats():GetPlayerStageStats(master_player):GetCurrentLife()*100).."%")
			end;
		};]]
		
		--[[LoadFont("monsterrat/_montserrat light 60px")..{	--percentage scoring P2
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
		};]]
		--[[Def.Actor{		--TO DO: Only activate the gamecommand IF the player is using Sink and or Rise
			InitCommand=cmd(queuecommand,"SinkRise");
			SinkRiseCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				local bpm = song:GetDisplayBpms() 
				local vel = (60/((bpm[1]+bpm[2])/2)).."x";
				GAMESTATE:ApplyGameCommand("mod, "..vel,pn);
			end;
		};--]]
		LoadActor("song meter")..{};
		
		LoadActor("demoplay")..{
			Condition=(stage=="Stage_Demo");
			InitCommand=cmd(x,notefxp1;y,SCREEN_BOTTOM-70;zoom,0.5;playcommand,"Set");
			OnCommand=function(self)
				if stage == "Stage_Demo" then
					GAMESTATE:ApplyGameCommand("stopmusic");
				else
					self:visible(false);
				end;
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
			Condition=(stage=="Stage_Demo");
			InitCommand=cmd(x,notefxp2;y,SCREEN_BOTTOM-70;zoom,0.5;playcommand,"Set");			
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

	--LoadActor("MenuOptions");	
};

local competitionMode = (ActiveModifiers["P1"]["CompetitionMode"] and ActiveModifiers["P2"]["CompetitionMode"]) and not CenterGameplayWidgets()

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	--We don't really support P3/P4 yet, as cool as it would be
	if pn == "PlayerNumber_P3" or pn == "PlayerNumber_P4" then
		break
	end;

	local notefxp =	THEME:GetMetric("ScreenGameplay","Player"..pname(pn).."OnePlayerOneSideX")	--Note field X position P1/P2 (pname evaluates to P1/P2 so it would be doing ScreenGameplay PlayerP1OnePlayerOneSideX)
	local style = ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType())
	if (style == "OnePlayerOneSide" and PREFSMAN:GetPreference("Center1Player")) or style == "OnePlayerTwoSides" then
		notefxp = SCREEN_CENTER_X;
	end;
	local steps;
	if GAMESTATE:IsCourseMode() then
		steps = GAMESTATE:GetCurrentTrail(pn):GetStepsType();
	else
		steps = GAMESTATE:GetCurrentSteps(pn):GetStepsType();
	end;
	
	--Percentage thing
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			if competitionMode then
				if pn == PLAYER_1 then
					self:x(SCREEN_CENTER_X-80);
				else
					self:x(SCREEN_CENTER_X+80);
				end;
			else
				self:x(notefxp);
			end;
		end;
		--P1 PERCENTAGE
		Def.ActorFrame{
			LoadActor(pname(pn).."_bg_percentage")..{
				InitCommand=cmd(zoom,0.8;y,SCREEN_BOTTOM-23.5;);
				--Hide the "completed" text in competition mode... I'm sorry for this
				OnCommand=function(self)
					if competitionMode then
						self:cropbottom(.33);
					end;
				end;
			};
			
			LoadActor(pname(pn).."_percentage_bar")..{
				InitCommand=cmd(zoomx,0.8;zoomy,0.7;playcommand,"ComboChangedMessage";y,SCREEN_BOTTOM-28;);
				ComboChangedMessageCommand=function(self,param)
					local State = GAMESTATE:GetPlayerState(pn);
					--local PlayerType = State:GetPlayerController();
					local css = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
					local score =		css:GetScore()				--score :v
					local rawaccuracy =	(score/stagemaxscore)*100		--Player accuracy RAW number
					--rawaccuracy = getenv("P1_accuracy");
					local maxzoomx = 0.8;
					local multiplier = (maxzoomx/100)*rawaccuracy
					
					self:cropright((maxzoomx-multiplier)/maxzoomx);
					
					if competitionMode and pn == PLAYER_1 then
						local css2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
						local p2acc = (css2:GetScore()/stagemaxscore)*100
						if rawaccuracy < p2acc then
							self:diffuse(color(".5,.5,.5,1"));
						else
							self:diffuse(Color("White"))
						end;
					elseif competitionMode and pn == PLAYER_2 then
						local css2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
						local p2acc = (css2:GetScore()/stagemaxscore)*100
						if rawaccuracy < p2acc then
							self:diffuse(color(".5,.5,.5,1"));
						else
							self:diffuse(Color("White"))
						end;
					end;

					if steps == "StepsType_Pump_Routine" and GAMESTATE:GetMasterPlayerNumber() ~= pn then
						self:visible(false);
					end;
				end;
			};
		};
		Def.BitmapText{	--percentage scoring
			--If steps are not routine or this is the master player (if playing routine)
			--The first conditional has to be false for it to check the second one.
			Condition=(steps ~= "StepsType_Pump_Routine" or GAMESTATE:GetMasterPlayerNumber() == pn);
			Font="monsterrat/_montserrat light 60px";
			InitCommand=cmd(zoom,0.3;y,SCREEN_BOTTOM-30;skewx,-0.25;);
			--[[OnCommand=function(self)
				self:Load("RollingNumbersPercent");
			end;]]
			ComboChangedMessageCommand=function(self,param)
			--LifeChangedMessageCommand=function(self,param)
				-- percentage scoring stuff:
				local State = GAMESTATE:GetPlayerState(pn);
				--local PlayerType = State:GetPlayerController();				
				local css = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
				local curmaxscore =	stagemaxscore
				local score =		css:GetScore()				--score :v
				local rawaccuracy =	(score/curmaxscore)*100		--Player accuracy RAW number
				--"%.3f" thanks CH32, se cambia el numero para mas decimales
				local accuracy =		string.format("%.02f",rawaccuracy) or "0.00";		--Player accuracy formatted number
				
				--accuracy = getenv("P1_accuracy") or 0;
				
				if rawaccuracy <= 0 then
					self:settext("0.00%");
				else
					self:settext(accuracy.."%");
				end;
				-- sets the accuracy (ugly workaround) -ROAD24
				setenv(pname(pn).."_accuracy",rawaccuracy);
			end;
				
		};
		LoadFont("monsterrat/_montserrat light 60px")..{	--percentage scoring (debug display)
			Condition=DoDebug;
			InitCommand=cmd(zoom,0.3;y,SCREEN_BOTTOM-60;skewx,-0.25);
			ComboChangedMessageCommand=function(self,param)
			--LifeChangedMessageCommand=function(self,param)
				-- percentage scoring stuff:
				local State = GAMESTATE:GetPlayerState(pn);
				--local PlayerType = State:GetPlayerController();				
				local css = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
				local curmaxscore =	stagemaxscore
				local score =		css:GetScore()				--score :v
				--local rawaccuracy =	(score/curmaxscore)*100		--Player accuracy RAW number
				--"%.3f" thanks CH32, se cambia el numero para mas decimales
				--local accuracy =		tonumber(string.format("%.02f",rawaccuracy)) or 0;		--Player accuracy formatted number
				
				--accuracy = getenv("P1_accuracy") or 0;
				
				self:settext(score.."/"..stagemaxscore);
			end;
				
		};
		--Weedcombo
		Def.ActorFrame {
			Condition=EasterEggs;
			InitCommand=cmd(y,SCREEN_CENTER_Y;);
			ComboChangedMessageCommand=function (self, params)
				local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn);
	
				if stats:GetCurrentCombo() == 420 then
					--MESSAGEMAN:Broadcast("Weed"..pname(pn));
					self:playcommand("Weed");
				end
			end;

			LoadActor(THEME:GetPathG("","WeedCombo/explosion")) .. {
				--Name="Weed1";
				InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';);
				WeedCommand=cmd(rotationz,0;zoom,2;diffusealpha,0.5;linear,0.5;rotationz,90;zoom,1.75;diffusealpha,0);
			};
			LoadActor(THEME:GetPathG("","WeedCombo/explosion")) .. {
				--Name="Weed2";
				InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';);
				WeedCommand=cmd(rotationz,0;zoom,2;diffusealpha,0.5;linear,0.5;rotationz,-90;zoom,2.5;diffusealpha,0);
			};


		};
		-- Player 1
		LoadFont("facu/_zona pro bold 20px")..{
			InitCommand=cmd(y,SCREEN_BOTTOM-46;horizalign,'HorizAlign_Center');
			OnCommand=function(self, param)
				self:settext("Score: ".."0000");
				self:zoom(0.7);
				self:skewx(-0.25);
				self:diffusealpha(0.9);
			end;
			--Score is updated in score_system then broadcast and this recieves it
			RIOScoreChangedMessageCommand=function(self,params)
				if params.Player == pn then
					if params.Score > 0 then
						self:settext("Score: "..params.Score);
					else
						self:settext("Score: 0000");
					end;				
				end;

			end;
		};
		--[[Def.RollingNumbers{
			Font="facu/_zona pro bold 20px";
			InitCommand=cmd(y,SCREEN_BOTTOM-46;horizalign,'HorizAlign_Left';Load,"RollingNumbersScore");
			RIOScoreChangedMessageCommand=function(self,params)
				if params.Player == pn then
					self:targetnumber(params.Score);
				end;
			end;
		};]]
	};
	
	--The judgement stats above the note receptors
	if not PerfectionistMode[pn] and not getenv("IsOMES_RIO") then	--p1 live stats
		t[#t+1] = LoadActor("stats", pn)..{
			InitCommand=cmd(xy,notefxp,35);
		};
	end;
end;

t[#t+1] = LoadActor("playerFailed");

if stage=="Stage_Demo" then
	t[#t+1] = LoadActor(THEME:GetPathG("ScreenAttract", "cardInserted"))..{
		InitCommand=cmd(Center);
	};
end;

return t;
