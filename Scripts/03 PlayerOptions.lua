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
--Use ActiveModifiers["P1"] or ActiveModifiers["P2"] to access options. ActiveModifiers
--is automatically set when the profile is loaded.
PlayerDefaults = {
	DetailedPrecision = false, --Options: false, EarlyLate, ProTiming
	ReverseGrade = false, --Like the PIU thing? Perfect is shown as bad
	ScreenFilter = 0,
	BGAMode = "On", --Options: Black, Off, Dark, On
	ProfileIcon = nil, -- Technically not an OptionsList option, but it gets saved at ScreenProfileSave so it's here anyway.
	JudgmentGraphic = "Season2", --Judgment graphic
}

--PerfectionistMode should NEVER be written to profile, so it's not in the PlayerDefaults table.
PerfectionistMode = {
	PlayerNumber_P1 = false,
	PlayerNumber_P2 = false
};

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

--Requires string:split
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

function OptionRowJudgmentGraphic()
	--The true name of the graphic is stored in ActiveModifiers to make it easier to load.
	local judgementFileNames = { "Season1", "Season2", "Montserrat"}
	local judgementNames = {"Season 1", "Season 2", "Montserrat"}
	local t = {
		Name="JudgmentType",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = judgementNames,
		LoadSelections = function(self, list, pn)
			local found = false;
			for i=1,#list do
				if judgementFileNames[i] == ActiveModifiers[pname(pn)]["JudgmentGraphic"] then
					list[i] = true;
					found = true;
				end;
			end;
			if not found then
				list[2] = true;
				--Need to replace the setting in the modifiers table too
				ActiveModifiers[pname(pn)]["JudgmentGraphic"] = judgementFileNames[2]
				assert(found, "Should have defaulted to S2 judgement, but none was found")
			end;
		end,
		SaveSelections = function(self, list, pn)
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						ActiveModifiers[pname(pn)]["JudgmentGraphic"] = judgementFileNames[i];
						found = true
					end
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
				MESSAGEMAN:Broadcast("SpeedModChange");
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
	assert(playerOptions:MMod(),"NO MMOD SET!!!!")
	if amount+playerOptions:MMod() < 100 then
		playerOptions:MMod(800);
	elseif amount+playerOptions:MMod() > 1000 then
		playerOptions:MMod(100);
	else
		playerOptions:MMod(playerOptions:MMod()+amount);
	end;
	GAMESTATE:GetPlayerState(pn):SetPlayerOptions('ModsLevel_Preferred', playerState:GetPlayerOptionsString("ModsLevel_Preferred"));
	SCREENMAN:SystemMessage(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred"));
end

--MMod only
function SpeedMods2()
	local t = {
		Name = "UserPrefSpeedMods";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = false;
		ExportOnChange = true;
		Choices = { "OFF", "ON", "AV -100", "AV -10","AV +10", "AV +100"};
		LoadSelections = function(self, list, pn)
			if GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):MMod() then
				list[2] = true
			else
				list[1] = true
			end;
		end;
		SaveSelections = function(self, list, pn)
				if list[1] then
					GAMESTATE:ApplyGameCommand("mod,2x",pn);
				elseif list[2] then
					if not GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):MMod() then
						GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():MMod(200)
						--SCREENMAN:SystemMessage("New MMod: "..GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():MMod())
					end;
				else
					if not GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():MMod() then
						local playerState = GAMESTATE:GetPlayerState(pn);
						--This returns an instance of playerOptions, you need to set it back to the original
						local playerOptions = playerState:GetPlayerOptions("ModsLevel_Preferred")
						playerOptions:MMod(200)
						GAMESTATE:GetPlayerState(pn):SetPlayerOptions('ModsLevel_Preferred', playerState:GetPlayerOptionsString("ModsLevel_Preferred"));
					end;
					if list[3] then
						adjustPlayerMMod(pn,-100)
					elseif list[4] then
						adjustPlayerMMod(pn,-10)
					elseif list[5] then
						adjustPlayerMMod(pn,10)
					elseif list[6] then
						adjustPlayerMMod(pn,100)
					end;
					
					--Hacky shit so it will say Auto Velocity ON in the main menu
					for i=1,#list do
						list[i] = false
					end
					list[2] = true
					--SCREENMAN:SystemMessage("New MMod: "..GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():MMod())
				end
				MESSAGEMAN:Broadcast("SpeedModChange");
		end
	};
	setmetatable( t, t );
	return t;
end
