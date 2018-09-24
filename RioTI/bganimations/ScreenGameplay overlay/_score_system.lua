local t = Def.ActorFrame{};
--ScoringSystem by Alisson - Based on Piu Fiesta series scoring system.
local function CustomScore( player )
	-- do nothing if not enabled
	if not GAMESTATE:IsSideJoined(player) then return Def.ActorFrame{}; end;
	local player_score = 0;
	local combo = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):MaxCombo();
	local combobonus = 1000;
	local meter = GAMESTATE:GetCurrentSteps(player):GetMeter();
	local metermultiplier = meter/10;
	local doublechartmultiplier = 1.2;
	local gradebonus = 0;

	--PRO MODE
	if getenv("PlayMode") == "Pro" then
		combobonus = 1250;
		meter = GAMESTATE:GetCurrentSteps(player):GetMeter();
		metermultiplier = meter/5;
		doublechartmultiplier = 1.5;
	end

	local ScoringValue = {
		TapNoteScore_W1 = 1000;
		TapNoteScore_W2 = 1000;
		TapNoteScore_W3 = 500;
		TapNoteScore_W4 = 100;
		TapNoteScore_W5 = -200;
		TapNoteScore_Miss = -500;
		TapNoteScore_CheckpointHit = 900;
		TapNoteScore_CheckpointMiss = -600;
	};
 
return LoadFont("facu/_zona pro bold 20px")..{
	InitCommand=function(self, param)
		self:settext("0000");
		self:zoom(0.7);
		self:skewx(-0.25);
		self:diffusealpha(0.9);
		setenv("P1_accuracy",0);
		setenv("P2_accuracy",0)
	end;
	
    JudgmentMessageCommand=function(self,param)
        self:visible(GAMESTATE:IsSideJoined(player));
       
        --TAP POINTS
        local points = ScoringValue[param.TapNoteScore]
       
        --COMBO BONUS
        if (param.TapNoteScore == 'TapNoteScore_W1' or param.TapNoteScore == 'TapNoteScore_W2' or param.TapNoteScore == 'TapNoteScore_W3') and combo > 50 then
            player_score = player_score + points + combobonus
        else
            player_score = player_score + points
        end
       
        --METER BONUS
        if meter >= 10 then
            player_score = player_score + ScoringValue[param.TapNoteScore]*metermultiplier
        end
       
        --DOUBLE CHART BONUS
        if GAMESTATE:GetCurrentSteps(player):GetStepsType() == "StepsType_Pump_Double"   then
            player_score = player_score + ScoringValue[param.TapNoteScore]*doublechartmultiplier
        end
       
        --GRADE BONUS
		gradebonus = 0;
        player_score = player_score+gradebonus;
	   
		--ACCURANCY
		local css = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
		local curmaxscore =	stagemaxscore
		local score =		css:GetScore()				--score :v
		local rawaccuracy =	(score/curmaxscore)*100		--Player accuracy RAW number
		--"%.3f" thanks CH32, se cambia el numero para mas decimales
		local accuracy =		tonumber(string.format("%.03f",rawaccuracy));		--Player accuracy formatted number
		if player == PLAYER_1 then setenv("P1_accuracy",accuracy); setenv("P2_accuracy","") else setenv("P2_accuracy",accuracy); setenv("P1_accuracy","") end;
		
		p1ayer_accu = getenv("P1_accuracy");
		
        --SET FINAL SCORE VALUE
        self:settext(player_score);
    end;
	
	OffCommand=function(self, param)
		STATSMAN:GetCurStageStats():GetPlayerStageStats( player ):SetScore( player_score );
	end;
};
end;
 
t[#t+1] = CustomScore(PLAYER_1)..{
    InitCommand=cmd(x,THEME:GetMetric("ScreenGameplay","PlayerP1OnePlayerOneSideX");y,SCREEN_BOTTOM-46;horizalign,'HorizAlign_Center');
};

 
t[#t+1] = CustomScore(PLAYER_2)..{
    InitCommand=cmd(x,THEME:GetMetric("ScreenGameplay","PlayerP2OnePlayerOneSideX");y,SCREEN_BOTTOM-46;horizalign,'HorizAlign_Center');
};


return t;