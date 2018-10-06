-- Scorin system similar to zero ( no bonus por triples aun )
local TapNoteScorePoints = {
	TapNoteScore_CheckpointHit = 1000;	-- HOLD PERFECT
	TapNoteScore_W1 = 1000;	-- SUPERB
	TapNoteScore_W2 = 1000;	-- PERFECT
	TapNoteScore_W3 = 500;	-- GREAT
	TapNoteScore_W4 = 100;	-- GOOD
	TapNoteScore_W5 = -200;	-- BAD
	TapNoteScore_Miss = -500;	-- MISS
	TapNoteScore_CheckpointMiss = -300;	-- HOLD MISS
	TapNoteScore_None =	0;
	TapNoteScore_HitMine =	-1000;
	TapNoteScore_AvoidMine = 0;
};

local ComboTapNoteScorePoints = {
	TapNoteScore_CheckpointHit = 2000;	-- HOLD PERFECT
	TapNoteScore_W1 = 2000;	-- SUPERB
	TapNoteScore_W2 = 2000;	-- PERFECT
	TapNoteScore_W3 = 1500;	-- GREAT
	TapNoteScore_W4 = 100;	-- GOOD
	TapNoteScore_W5 = -200;	-- BAD
	TapNoteScore_Miss = -500;	-- MISS
	TapNoteScore_CheckpointMiss = -300;	-- HOLD MISS
	TapNoteScore_None =	0;
	TapNoteScore_HitMine =	-1000;
	TapNoteScore_AvoidMine = 0;

};

local TapNoteScorePointsMultiplier = {
	TapNoteScore_CheckpointHit 		= { 1,1,1.5,2,2,2,2,2,2,2 }; -- Bonus Multiplier
	TapNoteScore_W1 				= { 1,1,1.5,2,2,2,2,2,2,2 }; -- Bonus Multiplier
	TapNoteScore_W2 				= { 1,1,1.5,1,1,1,1,1,1,1 }; -- Bonus Multiplier
	TapNoteScore_W3 				= { 1,1,1  ,1,1,1,1,1,1,1 }; -- No Bonus
	TapNoteScore_W4 				= { 1,1,1  ,1,1,1,1,1,1,1 }; -- No Bonus
	TapNoteScore_W5 				= { 1,1,1  ,1,1,1,1,1,1,1 }; -- No Bonus
	TapNoteScore_Miss 				= { 1,1,1  ,1,1,1,1,1,1,1 }; -- No Bonus
	TapNoteScore_CheckpointMiss 	= { 1,1,1  ,1,1,1,1,1,1,1 }; -- No Bonus

}
local PlayerScores = {
	PlayerNumber_P1 = 0;
	PlayerNumber_P2 = 0;
	PlayerNumber_Invalid = 0;
};

local TapNoteType = {
	TapNoteType_Empty = "TapNoteType_Empty",
	TapNoteType_Tap = "TapNoteType_Tap",
	TapNoteType_HoldHead = "TapNoteType_HoldHead",
	TapNoteType_HoldTail = "TapNoteType_HoldTail",
	TapNoteType_Mine = "TapNoteType_Mine",
	TapNoteType_Lift = "TapNoteType_Lift",
	TapNoteType_Attack = "TapNoteType_Attack",
	TapNoteType_AutoKeysound = "TapNoteType_AutoKeysound",
	TapNoteType_Fake = "TapNoteType_Fake"
};

function boolToString(b)
	return (b and "true" or "false")
end;

return Def.ActorFrame {
		JudgmentMessageCommand=function(self,params)
			local Notes = {};
			local Holds = {};
			local iStepsCount = 0;
			local Player = params.Player;
			local TapNoteScore = params.TapNoteScore;
			local State = GAMESTATE:GetPlayerState(Player);
			local PlayerType = State:GetPlayerController();
			
			-- first of all get the combo
			local CSS = STATSMAN:GetCurStageStats();
			local PSS = CSS:GetPlayerStageStats(Player);
			local iCombo = PSS:GetCurrentCombo();
			if true then
				-- now we can safely calculate the number of arrows in this tapnote
				Holds = params.Holds;
				Notes = params.Notes;
				iStepsCount = getNumberOfElements(Holds) + getNumberOfElements(Notes);
				local PlayerScore = PlayerScores[Player];
				-- get new scores
				if iCombo >= 50 then
					local scorepoints = ComboTapNoteScorePoints[TapNoteScore];
					PlayerScore = PlayerScore + scorepoints;
				else
					PlayerScore = PlayerScore + TapNoteScorePoints[TapNoteScore];
				end;

				-- we dont want negative scores
				if PlayerScore <= 0 then
					PlayerScores[Player] = 0;
				else
					PlayerScores[Player] = PlayerScore;
				end;

				setScores(PlayerScores);
				--Broadcast a message to update scores
				MESSAGEMAN:Broadcast("RIOScoreChanged",{Player = Player , Score = PlayerScore });
			end
		end;
};
