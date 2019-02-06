--[[
THE PIU HEARTS SYSTEM, BROUGHT TO YOU BY ACCELERATOR
Implementation: Hearts are removed during ScreenEvaluation init. If a player got an S or higher they get 1 heart back, max two hearts per session.
]]
MAX_SECONDS_FOR_SHORTCUT = 95
--Using builtin functions
--MIN_SECONDS_FOR_LONG = PREFSMAN:GetPreference("LongVerSongSeconds")
--MIN_SECONDS_FOR_MARATHON = PREFSMAN:GetPreference("MarathonVerSongSeconds")


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
		PlayerNumber_P2 = HeartsPerPlay
	};
	BonusHeartsAdded = {
		PlayerNumber_P1 = 0,
		PlayerNumber_P2 = 0
	};
	NumHeartsRemoved = {
		PlayerNumber_P1 = 0,
		PlayerNumber_P2 = 0
	}
end

function IsExtraStagePIU()
	return NumHeartsRemoved[PLAYER_1] >= HeartsPerPlay or NumHeartsRemoved[PLAYER_2] >= HeartsPerPlay;
end;

function GetNumHeartsForSong()
	local s = GAMESTATE:GetCurrentSong()
	if not s then
		return 0
	elseif s:MusicLengthSeconds() < MAX_SECONDS_FOR_SHORTCUT then
		return 1
	elseif s:IsLong() then
		return 4
	elseif s:IsMarathon() then
		return 6
	else
		return 2
	end;
end;

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
	if BonusHeartsAdded[player] >= 2 then
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
	return (acc > 90);
end;
