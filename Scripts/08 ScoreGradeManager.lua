--[[
A reversed index, so you can do gradeTable["A"] and it will tell you the corresponding int
Pretty much only used to check if you're above or below a certain grade
It's global because I want to use it in QuestMode ok?
]]
GRADE_TABLE = {
	["S3"] = 0,
	["S2"] = 1,
	["S1"] = 2,
	["A"]  = 3,
	["B"]  = 4,
	["C"]  = 5,
	["D"]  = 6,
	["E"]  = 7,
	["F"]  = 8
}

function getGradeFromStats(player)
	
	local p1accuracy = getenv(pname(player).."_accuracy") or 0;
	local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);
	-- old convention is commented
	if getenv("StageFailed") == true then
		return "F"; -- _failed
	elseif p1accuracy == 100 then
		return "S3"; -- S_S
	elseif p1accuracy >= 97 and stats:GetTapNoteScores("TapNoteScore_Miss") == 0 and stats:GetTapNoteScores("TapNoteScore_W4") == 0 and stats:GetTapNoteScores("TapNoteScore_W3") == 0 then
		if PREFSMAN:GetPreference("AllowW1") == "AllowW1_Never" then 
			return "S3"; -- S_S
		else 
			return "S2"; -- S_plus
		end;
	elseif p1accuracy >= 96 and stats:GetTapNoteScores("TapNoteScore_Miss") == 0 and stats:GetTapNoteScores("TapNoteScore_W4") == 0 then
		return "S1"; -- S_normal
	elseif p1accuracy >= 80 then
		return "A";
	elseif p1accuracy >= 70 then
		return "B";
	elseif p1accuracy >= 60 then
		return "C";
	elseif p1accuracy >= 50 then
		return "D";
	elseif p1accuracy < 50 then
		return "E"; -- F
	else
		return "F"; -- _failed
	end;
end;

--WTF uses the above one? 
function getGradeFromScore(topscore)
	local dancepoints = topscore:GetPercentDP()*100
	local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")

	if dancepoints == 100 and misses == 0 then
		return "S_S";
	elseif dancepoints >= 90 and misses == 0 then
		return "S_plus";
	elseif dancepoints >= 80 and misses == 0 then
		return "S_normal";
	elseif dancepoints >= 80 then
		return "A";
	elseif dancepoints >= 70 then
		return "B"
	elseif dancepoints >= 60 then
		return "C"
	elseif dancepoints >= 50 then
		return "D"
	else
		return "F"
	end;
end;

function getGradeAsInt(stats)
	return GRADE_TABLE[getGradeFromStats(stats)]
end;

function setScores(PlayerScores)
	setenv("PlayerScores",PlayerScores);
end;

function getScores()
	return getenv("PlayerScores");
end;
