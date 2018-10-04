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

--This defines the custom player options. PlayerDefaults is initialized from InitGame
PlayerDefaults = {
	DetailedPrecision = false,
	JudgmentType = "Normal",
	ScreenFilter = 0,
	PerfectionistMode = false,
	BGAMode = "On", --Options: Black, Off, Dark, On
	ProfileIcon = "Default" -- Technically not an OptionsList option, but it gets saved at ScreenProfileSave so it's here anyway.
}

--Set tables so you can do ActiveModifiers["P1"] to get the table of custom player modifiers, ex ActiveModifiers["P1"]["JudgmentType"]
--No metatable because it was too hard to implement
--[[ActiveModifiers = {
	P1 = table.shallowcopy(PlayerDefaults),
	P2 = table.shallowcopy(PlayerDefaults),
	MACHINE = table.shallowcopy(PlayerDefaults),
}]]

--Test
--[[local AM = { P1 = setmetatable({}, {JT = "Normal"})}
local AM = {{"Test"}, {"Test2"}}
local AM = { P1 = {JT = "Normal"}}
ActiveModifiers = {
	P1 = setmetatable({}, PlayerDefaults),
	P2 = setmetatable({}, PlayerDefaults),
	MACHINE = setmetatable({}, PlayerDefaults)
}
]]

--Requires string:split from Utils
function OptionRowAvailableNoteskins()
	local ns = NOTESKIN:GetNoteSkinNames();
	local disallowedNS = THEME:GetMetric("Common","NoteSkinsToHide"):split(",");
	for i = 1, #disallowedNS do
		for k,v in pairs(ns) do
			if v == disallowedNS[i] then
				table.remove(ns, k)
			end
		end;
	end;
	
	local t = {
		Name="NoteskinsCustom",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = ns,
		LoadSelections = function(self, list, pn)
			--This returns an instance of playerOptions, you need to set it back to the original
			local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			local curNS = playerOptions:NoteSkin();
			local found = false;
			for i=1,#list do
				if ns[i] == curNS then
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
			local pName = ToEnumShortString(pn)
			--list[1] = true;
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin(ns[i]);
						found = true
						--SCREENMAN:SystemMessage("NS set to "..ns[i]);
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

function PerfectionistMode()		--Perfectionist Mode 2.0 rewritten by Rhythm Lunatic
	local t = {
		Name = "PerfectionistMode";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = false;		--We actually DON'T want this true, we want it to only apply to one player.
		ExportOnChange = false;
		Choices = { "Off", "On"};
		LoadSelections = function(self, list, pn)
			local perfMode = ActiveModifiers[pname(pn)]["PerfectionistMode"] --Get the player's PerfectionistMode preference
			if perfMode == true then --You don't really need the == true here but whatever
				list[2] = true; --Make the "On" choice selected
			else
				list[1] = true; --Else, make the "Off" choice selected
			end;
		end;
		SaveSelections = function(self, list, pn)
			--If list[2] (The On choice) is selected, then it would get set true in ActiveModifiers. If it's not selected, it's false, so it gets set false in ActiveModifiers.
			ActiveModifiers[pname(pn)]["PerfectionistMode"] = list[2];
		end;
	};
	setmetatable( t, t );
	return t;
end;

function BGAMode()		--BGAMode		by Alisson A2 (Alisson de Oliveira)
	local t = {
		Name = "UserPrefBGAMode";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		--Once again, we DON'T want this true for both players, because it should be a per profile preference.
		--If one player has a BGA preference it would apply to both during the song, but it should still be
		--individually selectable. The order of preference is first to last, so Black Screen overrides No BGA.
		OneChoiceForAllPlayers = false;
		ExportOnChange = true;
		Choices = { "Black", "No BGA", "Darkened", "BGA On"};
		LoadSelections = function(self, list, pn)
			local bgaMode = ActiveModifiers[pname(pn)]["BGAMode"]
			if bgaMode == "Black" then
				list[1] = true
			elseif bgaMode == "Off" then
				list[2] = true
			elseif bgaMode == "Dark" then
				list[3] = true
			else
				list[4] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				ActiveModifiers[pname(pn)]["BGAMode"] = "Black"
			elseif list[2] then
				ActiveModifiers[pname(pn)]["BGAMode"] = "Off"
			elseif list[3] then
				ActiveModifiers[pname(pn)]["BGAMode"] = "Dark"
			else
				ActiveModifiers[pname(pn)]["BGAMode"] = "On";
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;
function ReverseGrade()		--Reverse Grade			by Alisson A2 (Alisson de Oliveira)
	local t = {
		Name = "UserPrefReverseGrade";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "Reverse", "Normal"};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("UserPrefReverseGrade") == nil then
				list[1] = true;
				WritePrefToFile("UserPrefReverseGrade",true);
			else
				if GetUserPrefB("UserPrefReverseGrade") == true then
					list[2] = true;
				end;
				if GetUserPrefB("UserPrefReverseGrade") == false then
					list[1] = true;
				end;
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val;
				if list[1] then
					val = false
					WritePrefToFile("UserPrefJudgmentType","Normal");
				end;
				if list[2] then
					val = true
					WritePrefToFile("UserPrefJudgmentType","Reverse");
				end;
			WritePrefToFile("UserPrefReverseGrade",val);
		end;
	};
	setmetatable( t, t );
	return t;
end
