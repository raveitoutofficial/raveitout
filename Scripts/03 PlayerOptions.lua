function table.shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--[[
This defines the custom player options. PlayerDefaults is initialized from InitGame.lua
Use ActiveModifiers["P1"] or ActiveModifiers["P2"] to access options. ActiveModifiers
is automatically set when the profile is loaded.
]]
PlayerDefaults = {
	DetailedPrecision = false, --Options: false, EarlyLate, ProTiming
	ReverseGrade = false, --Like the PIU thing? Perfect is shown as bad
	ScreenFilter = 0,
	BGAMode = "On", --Options: Black, Off, Dark, On
	ProfileIcon = false, -- Technically not an OptionsList option, but it gets saved at ScreenProfileSave so it's here anyway. Don't set it to nil the SL-CustomProfiles code is retarded and won't iterate over it
	JudgmentGraphic = "Season2", --Judgment graphic
	CompetitionMode = false, --Show score and HP in the middle to make things more exciting
	--[[
	Like IIDX, Simply Love, etc.
	Possible values: 70%, 80%, 90%, 95%, 100%, Player's Best, Machine Best
	We use percentages, not grades for target score
	because PIU/RIO grading is weird and you can't get an S if you miss a note.
	]]
	TargetScore = false,
}

--PerfectionistMode should NEVER be written to profile, so it's not in the PlayerDefaults table.
PerfectionistMode = {
	PlayerNumber_P1 = false,
	PlayerNumber_P2 = false,
	PlayerNumber_P3 = false,
	PlayerNumber_P4 = false
};

--Custom func that returns dict with keys instead of a list. Needed for noteskin filtering.
local function custSplit(delimiter, text)
	local list = {}
	local pos = 1
	while 1 do
		local first,last = string.find(text, delimiter, pos)
		if first then
			list[string.sub(text, pos, first-1)]=true
			pos = last+1
		else
			list[string.sub(text, pos)]=true
			break
		end
	end
	return list
end

function OptionRowAvailableNoteskins()
	--faster than table.remove by ~3.7x
	--Thanks 2 tertu for telling me about it :^)
	local disallowedNS = custSplit(',',THEME:GetMetric("Common","NoteSkinsToHide"));
	local allowedNS = {}
	for _,n in ipairs(NOTESKIN:GetNoteSkinNames()) do
		if not disallowedNS[n] then
			allowedNS[#allowedNS+1]=n
		end;
	end;
	--assert(#allowedNS > 0)
	
	local t = {
		Name="NoteskinsCustom",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = allowedNS,
		LoadSelections = function(self, list, pn)
			--SCREENMAN:SystemMessage("Num items: "..#ns)
			--This returns an instance of playerOptions, you need to set it back to the original
			local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			local curNS = playerOptions:NoteSkin();
			local found = false;
			for i=1,#list do
				if allowedNS[i] == curNS then
					list[i] = true;
					found = true;
				end;
			end;
			if not found then
				assert(found,"There was no noteskin selected, but the player's noteskin should be "..curNS);
				list[1] = true;
			end;
		end,
		SaveSelections = function(self, list, pn)
			--local pName = ToEnumShortString(pn)
			--list[1] = true;
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin(allowedNS[i]);
						found = true
						--SCREENMAN:SystemMessage("NS set to "..allowedNS[i]);
					end
				end
			end
		end,
	};
	setmetatable(t, t)
	return t
end

--Thanks to Midflight Digital (again)
function OptionRowScreenFilter()
	local t = {
		Name="Filter",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { "0%", "20%", "40%", "60%", "80%", "100%"},
		LoadSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			--Stored filterValue is a number out of 100
			local filterValue = ActiveModifiers[pName]["ScreenFilter"]

			if filterValue ~= nil then
				--Ex: If filterValue is 100, then 100/20 -> 5, +1 -> 6 because lua has 1-indexed lists
				list[filterValue/20+1] = true;
			else
				list[1] = true
			end
		end,
		SaveSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						--If selected value in the list is the 6th it would be 100%
						--Substract 1 because lua is 1-indexed, so 5*20 -> 100.
						ActiveModifiers[pName]["ScreenFilter"] = (i-1)*20;
						found = true
					end
				end
			end
		end,
	};
	setmetatable(t, t)
	return t
end

function OptionRowPerfectionistMode()		--Perfectionist Mode 2.0 rewritten by Rhythm Lunatic
	local t = {
		Name = "PerfectionistMode";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = false;		--We actually DON'T want this true, we want it to only apply to one player.
		ExportOnChange = false;
		Choices = { "Off", "On"};
		LoadSelections = function(self, list, pn)
			local perfMode = PerfectionistMode[pn] --Get the player's PerfectionistMode preference
			if perfMode == true then --You don't really need the == true here but whatever
				list[2] = true; --Make the "On" choice selected
			else
				list[1] = true; --Else, make the "Off" choice selected
			end;
		end;
		SaveSelections = function(self, list, pn)
			--If list[2] (The On choice) is selected, then it would get set true in ActiveModifiers. If it's not selected, it's false, so it gets set false in ActiveModifiers.
			PerfectionistMode[pn] = list[2];
		end;
	};
	setmetatable( t, t );
	return t;
end;

function OptionRowCompetitionMode()
	local t = {
		Name = "CompetitionMode";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = false;
		ExportOnChange = false;
		Choices = { "Off", "On"};
		LoadSelections = function(self, list, pn)
			local perfMode = ActiveModifiers[pname(pn)]['CompetitionMode'] --Get the player's PerfectionistMode preference
			if perfMode == true then --You don't really need the == true here but whatever
				list[2] = true; --Make the "On" choice selected
			else
				list[1] = true; --Else, make the "Off" choice selected
			end;
		end;
		SaveSelections = function(self, list, pn)
			--If list[2] (The On choice) is selected, then it would get set true in ActiveModifiers. If it's not selected, it's false, so it gets set false in ActiveModifiers.
			ActiveModifiers[pname(pn)]['CompetitionMode'] = list[2];
		end;
	};
	setmetatable( t, t );
	return t;
end;

function OptionRowBGAMode() --BGAMode v2 by Rhythm Lunatic, original by Alisson A2 (Alisson de Oliveira)
	local t = {
		Name = "UserPrefBGAMode";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		--Once again, we DON'T want this true for both players, because it should be a per profile preference.
		--If one player has a BGA preference it would apply to both during the song, but it should still be
		--individually selectable. The order of preference is first to last, so Black Screen overrides No BGA.
		OneChoiceForAllPlayers = false;
		ExportOnChange = true;
		Choices = { "Black", "Generic BGA", "BGA On"};
		LoadSelections = function(self, list, pn)
			local bgaMode = ActiveModifiers[pname(pn)]["BGAMode"]
			if bgaMode == "Black" then
				list[1] = true
			elseif bgaMode == "Off" then
				list[2] = true
			else
				list[3] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				ActiveModifiers[pname(pn)]["BGAMode"] = "Black"
			elseif list[2] then
				ActiveModifiers[pname(pn)]["BGAMode"] = "Off"
			else
				ActiveModifiers[pname(pn)]["BGAMode"] = "On";
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;
function OptionRowReverseGrade() --Reverse Grade v2 by Rhythm Lunatic, original by Alisson A2
	local t = {
		Name = "UserPrefReverseGrade";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = false;
		ExportOnChange = true;
		Choices = { "Reverse", "Normal"};
		LoadSelections = function(self, list, pn)
			if ActiveModifiers[pname(pn)]["ReverseGrade"] then
				list[1] = true;
			else
				list[2] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			ActiveModifiers[pname(pn)]["ReverseGrade"] = list[1]; --if reverse is selected list[1] is true, else list[2] is true.
		end;
	};
	setmetatable( t, t );
	return t;
end

function OptionRowDetailedPrecision()
	local t = {
		Name = "UserPrefDetailedPrecision";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = false;
		ExportOnChange = true;
		Choices = {"Early/Late Indicators", "ProTiming Graph", "Off"};
		LoadSelections = function(self, list, pn)
			local opt = ActiveModifiers[pname(pn)]["DetailedPrecision"]
			if opt == "EarlyLate" then
				list[1] = true
			elseif opt == "ProTiming" then
				list[2] = true
			else
				list[3] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				ActiveModifiers[pname(pn)]["DetailedPrecision"] = "EarlyLate";
			elseif list[2] then
				ActiveModifiers[pname(pn)]["DetailedPrecision"] = "ProTiming";
			else
				ActiveModifiers[pname(pn)]["DetailedPrecision"] = false;
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;

function OptionRowTargetScore()
	local t = {
		Name = "UserPrefTargetScore";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = false;
		ExportOnChange = true;
		--Choices that get shown, not the actual choices.
		Choices = {"None", "70%", "80%", "90%", "95%", "100%", "Player's Best", "Machine Best"};
		--The actual choices that get saved and loaded. 17 and 18 are special values for code that I stole from Simply Love. But if you do anything other than that it will work as a percentage.
		ChoiceValues = {false, .7, .8, .9, .95, 1, 18, 17};
		
		LoadSelections = function(self, list, pn)
			local opt = ActiveModifiers[pname(pn)]["TargetScore"]
			--A for loop might not be necessary here since opt is false if first choice is selected.
			local found = false;
			for i=1,#list do
				if self.ChoiceValues[i] == opt then
					list[i] = true;
					found = true;
				end;
			end;
			if not found then
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			for i=1,#list do
				if list[i] == true then
					ActiveModifiers[pname(pn)]["TargetScore"] = self.ChoiceValues[i];
					break
				end
			end
		end;
	};
	setmetatable( t, t );
	return t;
end;

function OptionRowJudgmentGraphic()
	local t = {
		Name="JudgmentType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		
		--[[
			The Choices line is just the NAME of the choices. the judgementFileNames name is the
			actual file name of the graphic.
			Ex. With a file named "Judgment Ace 1x6 (doubleres).png", you can put whatever you want on the first line,
			then "Ace" on the second line.
		]]
		Choices = 			 {"Season 1", "Season 2", "Zona", "Simply Love", "Mikado", "Ace", "None"},
		judgementFileNames = {"Season1",  "Season2",  "Zona", "Simply Love", "Mikado", "Ace", "None"},
		
		LoadSelections = function(self, list, pn)
			local found = false;
			for i=1,#list do
				if self.judgementFileNames[i] == ActiveModifiers[pname(pn)]["JudgmentGraphic"] then
					list[i] = true;
					found = true;
				end;
			end;
			if not found then
				list[2] = true;
				--Need to replace the setting in the modifiers table too
				ActiveModifiers[pname(pn)]["JudgmentGraphic"] = self.judgementFileNames[2]
				lua.Warn("Should have defaulted to S2 judgement, but none was found")
			end;
		end,
		SaveSelections = function(self, list, pn)
			for i=1,#list do
				if list[i] == true then
					ActiveModifiers[pname(pn)]["JudgmentGraphic"] = self.judgementFileNames[i];
					break
				end
			end
		end,
	};
	setmetatable(t, t)
	return t
end

--By Alisson, I don't think this function is used though
function SpeedMods()
	local t = {
		Name = "UserPrefSpeedMods";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = false;
		ExportOnChange = false;
		Choices = { "+0.25", "+0.5","+0.75"};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefSpeedMods") == nil then
				list[1] = true;
				--WritePrefToFile("UserPrefSpeedMods","+0.25");
			else

				if GetUserPref("UserPrefSpeedMods") == "+0.25" then
					list[1] = true;
				end

				if GetUserPref("UserPrefSpeedMods") == "+0.5" then
					list[2] = true;
				end

				if GetUserPref("UserPrefSpeedMods") == "+0.75" then
					list[3] = true;

				end

			end;
		end;
		SaveSelections = function(self, list, pn)
				if list[1] then
					--WritePrefToFile("UserPrefSpeedMods","+0.25");
					local speed = (math.ceil(GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():XMod()*100)/100)+0.25;
					GAMESTATE:ApplyGameCommand("mod,"..speed.."x",pn);
				end

				if list[2] then
					--WritePrefToFile("UserPrefSpeedMods","+0.5");
					local speed = (math.ceil(GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():XMod()*100)/100)+0.5;
					GAMESTATE:ApplyGameCommand("mod,"..speed.."x",pn);
				end

				if list[3] then
					--WritePrefToFile("UserPrefSpeedMods","+0.75");
					local speed = (math.ceil(GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():XMod()*100)/100)+0.75;
					GAMESTATE:ApplyGameCommand("mod,"..speed.."x",pn);
				end
				MESSAGEMAN:Broadcast("SpeedModChanged",{Player=pn});
		end
	};
	setmetatable( t, t );
	return t;
end

function adjustPlayerMMod(pn, amount)
	--SCREENMAN:SystemMessage(playerState);
	local playerState = GAMESTATE:GetPlayerState(pn);
	--This returns an instance of playerOptions, you need to set it back to the original
	local playerOptions = playerState:GetPlayerOptions("ModsLevel_Preferred")
	--SCREENMAN:SystemMessage(PlayerState:GetPlayerOptionsString("ModsLevel_Current"));
	--assert(playerOptions:MMod(),"NO MMOD SET!!!!")
	if not playerOptions:MMod() then
		playerOptions:MMod(200)
	end;
	if amount+playerOptions:MMod() < 100 then
		playerOptions:MMod(800);
	elseif amount+playerOptions:MMod() > 1000 then
		playerOptions:MMod(100);
	else
		playerOptions:MMod(playerOptions:MMod()+amount);
	end;
	GAMESTATE:GetPlayerState(pn):SetPlayerOptions('ModsLevel_Preferred', playerState:GetPlayerOptionsString("ModsLevel_Preferred"));
	--SCREENMAN:SystemMessage(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred"));
	return playerOptions:MMod();
end

--MMod only
function SpeedMods2()
	local t = {
		Name = "UserPrefSpeedMods";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectMultiple";
		GoToFirstOnStart= false;
		OneChoiceForAllPlayers = false;
		ExportOnChange = false;
		Choices = { "AV -100", "AV -10","AV +10", "AV +100"};
		LoadSelections = function(self, list, pn)
			if GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):MMod() then
				list[1] = true
				--SCREENMAN:SystemMessage("MMod!")
			end;
		end;
		--We're not saving anything!
		SaveSelections = function(self, list, pn)
		
		end;
		--Abuse the heck out of this one since we're checking what button they pressed and not what's selected or deselected
		NotifyOfSelection = function(self,pn,choice)
			--SCREENMAN:SystemMessage("choice "..choice)
			local speed;
			if choice == 1 then
				speed = adjustPlayerMMod(pn, -100);
			elseif choice == 2 then
				speed = adjustPlayerMMod(pn, -10);
			elseif choice == 3 then
				speed = adjustPlayerMMod(pn, 10);
			elseif choice == 4 then
				speed = adjustPlayerMMod(pn, 100);
			end;
			--MESSAGEMAN:Broadcast("MModChanged", {Player=pn,Speed=speed});
			MESSAGEMAN:Broadcast("SpeedModChanged",{Player=pn});
			--Always return true because we don't want anything to get highlighted.
			return true;
			
			--self.Choices = {"asdON", "AasdadV -100", "AV222 -10","A21313V +10", "AV +1asdad00"};
		end;
	};
	setmetatable( t, t );
	return t;
end
