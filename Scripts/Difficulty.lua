-- Remove functions in fallback that we shoouldn't be using.
DifficultyColor = nil;

DifficultyAndStepsTypeInfo = {
	{ difficulty = "Difficulty_Beginner",	stepsType = "StepsType_Pump_Single",	color = color("#04fe04") },
	{ difficulty = "Difficulty_Easy",	stepsType = "StepsType_Pump_Single",	color = color("#fefb04") },
	{ difficulty = "Difficulty_Medium",	stepsType = "StepsType_Pump_Single",	color = color("#fe7704") },
	{ difficulty = "Difficulty_Hard",	stepsType = "StepsType_Pump_Single",	color = color("#fe0a04") },
	{ difficulty = "Difficulty_Medium",	stepsType = "StepsType_Pump_Halfdouble",	color = color("#04feba") },
	{ difficulty = "Difficulty_Medium",	stepsType = "StepsType_Pump_Double",	color = color("#fe04f5") },
	{ difficulty = "Difficulty_Hard",	stepsType = "StepsType_Pump_Double",	color = color("#04c6fe") },
	{ difficulty = "Difficulty_Edit",	stepsType = "StepsType_Pump_Single",	color = color("#c0c0c0") },
	{ difficulty = "Difficulty_Edit",	stepsType = "StepsType_Pump_Halfdouble",	color = color("#c0c0c0") },
	{ difficulty = "Difficulty_Edit",	stepsType = "StepsType_Pump_Double",	color = color("#c0c0c0") },
};

function StepsOrTrailToLocalizedString(StepsOrTrail)
	if not StepsOrTrail then
		return "";
	end
	if lua.CheckType("Trail", StepsOrTrail) then
		local s = THEME:GetString("DifficultyAndStepsType", "Course");
		return s;
	end

	local dc = StepsOrTrail:GetDifficulty();
	local st = StepsOrTrail.GetStepsType and StepsOrTrail:GetStepsType();
	return DifficultyAndStepsTypeToLocalizedString( dc, st );
end
function TrailColor()
	return color("#30f0c8");
end;

function StepsOrTrailToColor(StepsOrTrail)
	if not StepsOrTrail then return color("#000000"); end
	if lua.CheckType("Trail", StepsOrTrail) then return TrailColor() end

	local dc = StepsOrTrail:GetDifficulty();
	local st = StepsOrTrail.GetStepsType and StepsOrTrail:GetStepsType();
	return DifficultyAndStepsTypeToColor( dc, st );
end

function DifficultyAndStepsTypeToLocalizedString( difficulty, stepsType )
	if( not difficulty or not stepsType ) then
		return "";
	end
	return THEME:GetString( "DifficultyAndStepsType", difficulty .. "-" .. stepsType );
end

function DifficultyAndStepsTypeToIndex( difficulty, stepsType )
	for idx, entry in ipairs(DifficultyAndStepsTypeInfo) do
		if entry.difficulty == difficulty and entry.stepsType == stepsType then 
			return idx;
		end
	end
	return nil;
end

function DifficultyAndStepsTypeToColor( difficulty, stepsType )
	local idx = DifficultyAndStepsTypeToIndex( difficulty, stepsType );
	if not idx then return color("#000000"); end
	return DifficultyAndStepsTypeInfo[idx].color;
end

function Actor:SetDifficultyAndStepsTypeFrame(StepsOrTrail)
	if lua.CheckType("Trail", StepsOrTrail) then
		self:setstate(8); -- 1 frame past the last regular difficulty frame
		return;
	end

	local dc = StepsOrTrail:GetDifficulty();
	local st = StepsOrTrail.GetStepsType and StepsOrTrail:GetStepsType();
	local idx = DifficultyAndStepsTypeToIndex( dc, st );
	if dc == "Difficulty_Edit" then
		idx = 8;
	end;
	if idx then
		self:setstate(idx-1);
	end
end


-- (c) 2005 Chris Danford
-- All rights reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, and/or sell copies of the Software, and to permit persons to
-- whom the Software is furnished to do so, provided that the above
-- copyright notice(s) and this permission notice appear in all copies of
-- the Software and that both the above copyright notice(s) and this
-- permission notice appear in supporting documentation.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
-- THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
-- INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
-- OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
-- OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.

