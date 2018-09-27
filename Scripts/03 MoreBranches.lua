function SelectMusicOrCourse()
	if IsNetSMOnline() then
		return "ScreenNetSelectMusic"
	elseif GAMESTATE:IsCourseMode() then
		return "ScreenSelectCourse"
	else
	--	if GAMESTATE:GetCoinMode() == 'CoinMode_Pay' then
	--		return "ScreenGameOver"
	--	else	
			return "ScreenSelectMusic"
	--	end
	end
end

-- solo usarse con screengameplay u otras que puedan ser "explotables"
function SelectMusicOrCourseAntiCheat()
	if IsNetSMOnline() then
		return "ScreenNetSelectMusic"
	elseif GAMESTATE:IsCourseMode() then
		return "ScreenSelectCourse"
	else
	--	arcade use, no cheating when using keyboards in an arcade cab. -NeobeatIKK
		if GAMESTATE:GetCoinMode() == 'CoinMode_Pay' then
			return "ScreenGameOver"
		else	
			if getenv("PlayMode") == "Easy" then
				return "ScreenSelectEasy"
			else
				return "ScreenSelectMusic"
			end
		end
	end
end

function StartGame()
	if SONGMAN:GetNumSongs() == 0 and SONGMAN:GetNumAdditionalSongs() == 0 then
	--	return "ScreenHowToInstallSongs"
		return "ScreenOptionsService"
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
end

function AfterSelectStyle()
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
end

function AfterSelectProfile()
	if ( THEME:GetMetric("Common","AutoSetStyle") == true ) then
		-- use SelectStyle in online...
		return IsNetConnected() and "ScreenSelectStyle" or "ScreenSelectPlayMode"
	else
		return "ScreenSelectStyle"
	end
end

function AfterProfileLoad()
	return "ScreenSelectPlayMode"
end

function AfterProfileSave()
	-- Might be a little too broken? -- Midiman
	if GAMESTATE:IsEventMode() then
		return SelectMusicOrCourse()
	elseif STATSMAN:GetCurStageStats():AllFailed() then
		return "ScreenGameOver"
	elseif GAMESTATE:GetSmallestNumStagesLeftForAnyHumanPlayer() == 0 then
		return "ScreenEvaluationSummary"
	else
		return SelectMusicOrCourse()
	end
end
