--[[
[en] The Branch table replaces the various functions used for branching in the
StepMania 4 default theme.
Lines with a single string (e.g. TitleMenu = "ScreenTitleMenu") are referenced
in the metrics as Branch.keyname.
If the line is a function, you'll have to use Branch.keyname() instead.
--]]

-- used for various SMOnline-enabled screens:
function SMOnlineScreen()
	for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
		if not IsSMOnlineLoggedIn(pn) then
			return "ScreenSMOnlineLogin"
		end
	end
	return "ScreenNetRoom"
end

function SelectMusicOrCourse()
	if IsNetSMOnline() then
		return "ScreenNetSelectMusic"
	elseif GAMESTATE:IsCourseMode() then
		if getenv("PlayMode") == "Special" then
			return "ScreenQuestMode"
		else
			return "ScreenSelectCourseCustom"
		end;
	else
		if getenv("PlayMode") == "Easy" then
			return "ScreenSelectEasy"
		else
			return "ScreenSelectMusic"
		end
	end
end

function JumpToCredits()
	local song = SONGMAN:FindSong(OMES_SONG)
	if song then
		GAMESTATE:SetCurrentSong(song);
		GAMESTATE:SetCurrentPlayMode("PlayMode_Regular");
		GAMESTATE:SetCurrentStyle("Single");
		local steps = song:GetOneSteps('StepsType_Pump_Single', 0);
		GAMESTATE:SetCurrentSteps('PlayerNumber_P1',steps);
		GAMESTATE:ApplyGameCommand('mod,failoff',PLAYER_1);
		local can, reason = GAMESTATE:CanSafelyEnterGameplay()
		if can then
			return "ScreenGameplayBlank";
		else
			SCREENMAN:SystemMessage("Can't play credits! "..reason);
		end;
	else
		SCREENMAN:SystemMessage("Can't play credits! OMES_SONG is missing. Check SYSTEM_PARAMETERS.lua.");
	end;
	return "ScreenTitleMenu";
end;

-- functions used for Routine mode
function IsRoutine()
	return GAMESTATE:GetCurrentStyle() and GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_TwoPlayersSharedSides"
end

Branch = {
	Init = function() return "ScreenInit" end,
	AfterInit = function()
		if GAMESTATE:GetCoinMode() == 'CoinMode_Home' then
			return Branch.TitleMenu()
		else
			return "ScreenLogo"
		end
	end,
	NoiseTrigger = function()
		local hour = Hour()
		return hour > 3 and hour < 6 and "ScreenNoise" or "ScreenInit"
	end,
	TitleMenu = function()
		-- home mode is the most assumed use of sm-ssc.
		if GAMESTATE:GetCoinMode() == "CoinMode_Home" then
			return "ScreenTitleMenu"
		end
		-- arcade junk:
		if GAMESTATE:GetCoinsNeededToJoin() > GAMESTATE:GetCoins() then
			-- if no credits are inserted, don't show the Join screen. SM4 has
			-- this as the initial screen, but that means we'd be stuck in a
			-- loop with ScreenInit. No good.
			return "ScreenTitleJoin"
		else
			return "ScreenTitleJoin"
		end
	end,
	StartGame = function()
		-- Check to see if there are 0 songs installed. Also make sure to check
		-- that the additional song count is also 0, because there is
		-- a possibility someone will use their existing StepMania simfile
		-- collection with sm-ssc via AdditionalFolders/AdditionalSongFolders.
		if SONGMAN:GetNumSongs() == 0 and SONGMAN:GetNumAdditionalSongs() == 0 then
			return "ScreenHowToInstallSongs"
		end
		if PROFILEMAN:GetNumLocalProfiles() >= 2 then
			return "ScreenSelectProfile"
		else
			if IsNetConnected() then
				return "ScreenSelectStyle"
			else
				if THEME:GetMetric("Common","AutoSetStyle") == false then
					return "ScreenSelectStyle"
				else
					return "ScreenProfileLoad"
				end
			end
		end
	end,
	OptionsEdit = function()
		-- Similar to above, don't let anyone in here with 0 songs.
		if SONGMAN:GetNumSongs() == 0 and SONGMAN:GetNumAdditionalSongs() == 0 then
			return "ScreenHowToInstallSongs"
		end
		return "ScreenOptionsEdit"
	end,
	AfterSelectStyle = function()
		if IsNetConnected() then
			ReportStyle()
			GAMESTATE:ApplyGameCommand("playmode,regular")
		end
		if IsNetSMOnline() then
			return SMOnlineScreen()
		end
		if IsNetConnected() then
			return "ScreenNetRoom"
		end
		return "ScreenProfileLoad"

		--return CHARMAN:GetAllCharacters() ~= nil and "ScreenSelectCharacter" or "ScreenGameInformation"
	end,
	--This function isn't used, AfterProfileLoad is used
	AfterSelectProfile = function()
		if ( THEME:GetMetric("Common","AutoSetStyle") == true ) then
			-- use SelectStyle in online...
			return IsNetConnected() and "ScreenSelectStyle" or "ScreenSelectPlayMode"
		else
			return "ScreenSelectStyle"
		end
	end,
	AfterProfileLoad = function()
		for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
			--ProfileFromMemoryCardIsNew checks if it's a memory card internally so no need to check additionally
			if PROFILEMAN:ProfileFromMemoryCardIsNew(pn) then
				return "ScreenNewProfileCustom"
			else
				--If it's an RFID scanned (local) profile
				if PROFILEMAN:IsPersistentProfile(pn) and PROFILEMAN:GetProfile(pn):GetTotalNumSongsPlayed() == 0 then
					return "ScreenNewProfileCustom"
				end;
			end;
		end;
		return "ScreenSelectPlayMode"
	end,
	
	--I'm not sure this is even used?
	AfterProfileSave = function()
		-- Might be a little too broken? -- Midiman
		if GAMESTATE:IsEventMode() then
			return SelectMusicOrCourse()
		elseif STATSMAN:GetCurStageStats():AllFailed() or GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer() <= 0 then
			return "ScreenGameOver"
		else
			return SelectMusicOrCourse()
		end
	end,
	GetGameInformationScreen = function()
		bTrue = PREFSMAN:GetPreference("ShowInstructions")
		return (bTrue and GoToMusic() or "ScreenGameInformation")
	end,
	AfterSMOLogin = SMOnlineScreen(),
	BackOutOfPlayerOptions = function()
		return SelectMusicOrCourse()
	end,
	BackOutOfStageInformation = function()
		return SelectMusicOrCourse()
	end,
	AfterSelectMusic = function()
		if SCREENMAN:GetTopScreen():GetGoToOptions() then
			return SelectFirstOptionsScreen()
		else
			return "ScreenStageInformation"
		end
	end,
	PlayerOptions = function()
		local pm = GAMESTATE:GetPlayMode()
		local restricted = { "PlayMode_Oni", "PlayMode_Rave",
			--"PlayMode_Battle" -- ??
		}
		local optionsScreen = "ScreenPlayerOptions"
		for i=1,#restricted do
			if restricted[i] == pm then
				optionsScreen = "ScreenPlayerOptionsRestricted"
			end
		end
		if SCREENMAN:GetTopScreen():GetGoToOptions() then
			return optionsScreen
		else
			return "ScreenStageInformation"
		end
	end,
	SongOptions = function()
		if SCREENMAN:GetTopScreen():GetGoToOptions() then
			return "ScreenSongOptions"
		else
			return "ScreenStageInformation"
		end
	end,
	GameplayScreen = function()
		return IsRoutine() and "ScreenGameplayShared" or "ScreenGameplay"
	end,
	AfterGameplay = function()
		-- pick an evaluation screen based on settings.
		if IsNetSMOnline() then
			return "ScreenNetEvaluation"
		else
			-- todo: account for courses etc?
			return "ScreenEvaluationNormal"
		end
	end,
	AfterEvaluation = function()
		if GAMESTATE:IsCourseMode() then
			return "ScreenProfileSave"
		else
			if UnlockedOMES_RIO() then
				--Set stage break to 1. Gotta get that full combo!
				setenv("BreakCombo",1);
				setenv("IsOMES_RIO",true)
				
				assert(OMES_SONG,"Hey genius, you need to define an OMES_SONG.")
				local s = SONGMAN:FindSong(OMES_SONG);
				if not s then
					SCREENMAN:SystemMessage("The OMES song was not found, giving up.");
					return "ScreenProfileSaveSummary";
				end;
				
				--Use same StepsType as the last played song.
				if GAMESTATE:GetNumSidesJoined() > 1 then
					local p1steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
					local p2steps = GAMESTATE:GetCurrentSteps(PLAYER_2)
					--Never choose EDIT difficulty
					local p1difficulty = (p1steps:GetDifficulty() and p1steps:GetDifficulty() ~= 5) or 4
					local p2difficulty = (p2steps:GetDifficulty() and p2steps:GetDifficulty() ~= 5) or 4
					if s:HasStepsTypeAndDifficulty(p1steps:GetStepsType(),p1difficulty) and s:HasStepsTypeAndDifficulty(p2steps:GetStepsType(),p2difficulty) then
						GAMESTATE:SetCurrentSong(s);
						GAMESTATE:SetCurrentSteps(PLAYER_1,s:GetOneSteps(p1steps:GetStepsType(),p1difficulty))
						GAMESTATE:SetCurrentSteps(PLAYER_2,s:GetOneSteps(p2steps:GetStepsType(),p2difficulty))
						return "ScreenStageInformation";
					end;
					SCREENMAN:SystemMessage("There was no available difficulties for the OMES.")
					return "ScreenProfileSaveSummary"
				else
					local steps = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber())
					local difficulty = (steps:GetDifficulty() ~= 'Difficulty_Edit') and steps:GetDifficulty() or 'Difficulty_Challenge'
					--local difficulty = steps:GetDifficulty();
					--assert(difficulty,"No steps???")
					if s:HasStepsTypeAndDifficulty(steps:GetStepsType(),difficulty) then
						GAMESTATE:SetCurrentSong(s);
						GAMESTATE:SetCurrentSteps(GAMESTATE:GetMasterPlayerNumber(),s:GetOneSteps(steps:GetStepsType(),difficulty))
						return "ScreenStageInformation";
					end;
					SCREENMAN:SystemMessage("The OMES did not have "..steps:GetStepsType()..","..steps:GetDifficulty().." and the game cannot continue.")
					return "ScreenProfileSaveSummary"
				end;
			else
				local maxHearts = HeartsPerPlay
				local heartsLeft = GetSmallestNumHeartsLeftForAnyHumanPlayer();
				local allFailed = STATSMAN:GetCurStageStats():AllFailed()
				local song = GAMESTATE:GetCurrentSong()
				--SCREENMAN:SystemMessage(heartsLeft);
				if GAMESTATE:IsEventMode() or heartsLeft >= 1 then
					return "ScreenProfileSave"
				elseif song:IsLong() and maxHearts <= 4 and heartsLeft < 1 and allFailed then
					return "ScreenProfileSaveSummary"
				elseif song:IsMarathon() and maxHearts <= 6 and heartsLeft < 1 and allFailed then
					return "ScreenProfileSaveSummary"
				elseif maxHearts >= 4 and heartsLeft < 1 and allFailed then
					return "ScreenProfileSaveSummary"
				elseif allFailed then
					return "ScreenProfileSaveSummary"
				elseif heartsLeft <= 0 then
					return "ScreenProfileSaveSummary"
				else
					return "ScreenProfileSave"
				end
			end
		end
	end,
	AfterProfileSave = function()
		-- Might be a little too broken? -- Midiman
		if GAMESTATE:IsEventMode() then
			return SelectMusicOrCourse()
		elseif STATSMAN:GetCurStageStats():AllFailed() then
			return GameOverOrContinue()
		elseif GetSmallestNumHeartsLeftForAnyHumanPlayer() == 0 then
			if not GAMESTATE:IsCourseMode() then
				return "ScreenEvaluationSummary"
			else
				return GameOverOrContinue()
			end
		else
			return SelectMusicOrCourse()
		end
	end,
	AfterSummary = function()
		return "ScreenProfileSaveSummary"
	end,
	Network = function()
		return IsNetConnected() and "ScreenTitleMenu" or "ScreenTitleMenu"
	end,
 	AfterSaveSummary = function()

		--Check for high scores for people without USB or local profiles so they can enter a high score name.
		--[[for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
			--Trace("Running high score check.")
			if not PROFILEMAN:IsPersistentProfile(pn) and PlayerAchievedAnyHighScores(pn) then
				return "ScreenEnterRankingName"
			end;
		end;]]
		return "ScreenGameOver"
	end,
}
