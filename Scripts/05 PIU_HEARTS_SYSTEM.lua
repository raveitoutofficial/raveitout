--[[
THE PIU HEARTS SYSTEM, BROUGHT TO YOU BY ACCELERATOR
Implementation: Hearts are removed during ScreenEvaluation init. If a player got an S or higher they get 1 heart back, max two hearts per session.
]]

-- Set to true to test obtaining extra hearts without any of the hard work.
local Debug_AlwaysGetBonusHearts = false;


--[[
Called by InitGame. No need to define them anywhere since a variable
without 'local' will become global.
]]
function Reset_PIU_Hearts()
	HeartsPerPlay = tonumber(ReadPrefFromFile("HeartsPerPlay"))
	if not HeartsPerPlay then
		--SCREENMAN:SystemMessage("HeartsPerPlay initialized.");
		HeartsPerPlay = 6;
		WritePrefToFile("HeartsPerPlay",6);
	end;
	
	PREFSMAN:SetPreference("SongsPerPlay",math.ceil(HeartsPerPlay/2));
	NumHeartsLeft = {
		PlayerNumber_P1 = HeartsPerPlay,
		PlayerNumber_P2 = HeartsPerPlay,
		--Whatever
		PlayerNumber_P3 = 999,
		PlayerNumber_P4 = 999
	};
	BonusHeartsAdded = {
		PlayerNumber_P1 = 0,
		PlayerNumber_P2 = 0,
		PlayerNumber_P3 = 0,
		PlayerNumber_P4 = 0
	};
	NumHeartsRemoved = {
		PlayerNumber_P1 = 0,
		PlayerNumber_P2 = 0,
		PlayerNumber_P3 = 0,
		PlayerNumber_P4 = 0
	}
end

function IsExtraStagePIU()
	return NumHeartsRemoved[PLAYER_1] >= HeartsPerPlay or NumHeartsRemoved[PLAYER_2] >= HeartsPerPlay;
end;


--This is a static function meaning DO NOT do any setting of variables here! Do it in the branch.lua that checks this function!
function UnlockedOMES_RIO()
	--do return true end; --For debugging
	--If they just played the extra stage, and there is an extra stage song defined, and they played said extra stage song...
	if IsExtraStagePIU() and extraStageSong == GAMESTATE:GetCurrentSong() then
		--Loop through both players, if one of them got >95% then both of them can play the OMES.
		for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
			local acc = getenv(pname(pn).."_accuracy") or 0
			if (acc > 95 and GetNumHeartsForSong() == 2) then
				return true;
			end;
		end;
	end;
	--Didn't achieve it.
	return false;
end;

function GetNumHeartsForSong()
	local s = GAMESTATE:GetCurrentSong()
	if not s then
		return 0
	end
	return s:GetPIUStageCost();
	--return GetSongExtraData(s, "Hearts")
end;

--TODO: This should be renamed to GetLargestNumHeartsLeftForAnyHumanPlayer, not smallest...
function GetSmallestNumHeartsLeftForAnyHumanPlayer()
	if GAMESTATE:IsHumanPlayer(PLAYER_1) and GAMESTATE:IsHumanPlayer(PLAYER_2) then
		return math.max(NumHeartsLeft[PLAYER_1], NumHeartsLeft[PLAYER_2])
	else
		return NumHeartsLeft[GAMESTATE:GetMasterPlayerNumber()]
	end;
end;

function GiveBonusHeart(player)
	NumHeartsLeft[player] = NumHeartsLeft[player] + 1
	BonusHeartsAdded[player] = BonusHeartsAdded[player] + 1
end;

function RemoveHearts(player, hearts)
	NumHeartsLeft[player] = NumHeartsLeft[player] - hearts;
	NumHeartsRemoved[player] = NumHeartsRemoved[player] + hearts;
end;


function PlayerAchievedBonusHeart(player)
	--Can only earn up to 2 bonus hearts.
	--Not sure why IsSideJoined has to be checked but if I don't it shows the bonus heart message for the wrong player
	if BonusHeartsAdded[player] >= 2 or GAMESTATE:IsSideJoined(player) == false or GetNumHeartsForSong() < 2 then
		return false;
	end;
	local acc = getenv(pname(player).."_accuracy") or 0
	--Old system was too hard
	--[[local css1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
	local misses = css1:GetTapNoteScores("TapNoteScore_Miss")				--MISS
	
	if THEME:GetMetric("Gameplay","MineHitIncrementsMissCombo") then
		misses = misses+css1:GetTapNoteScores("TapNoteScore_CheckpointMiss")+css1:GetTapNoteScores("TapNoteScore_HitMine")
	end;
	return (STATSMAN:GetCurStageStats():GetPlayerStageStats(player):IsDisqualified()==false and acc >= 96 and misses == 0 and css1:GetTapNoteScores("TapNoteScore_W4") == 0)]]
	return (acc > 90 or Debug_AlwaysGetBonusHearts);
end;
