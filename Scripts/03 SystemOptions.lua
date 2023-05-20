--ScreenFilter (requested by Cortes)		by NeobeatIKK, based on BGAMode by Alisson A2 (Alisson de Oliveira)
--Modified by Accelerator, now only sets TextureResolution because color depth is pointless
function VideoMode()
	local t = {
		Name = "Graphics Details";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;		--ojo
		ExportOnChange = false;
		Choices = {"SD", "HD"}; --Maybe add an Auto option.
		LoadSelections = function(self, list, pn)
			if PREFSMAN:GetPreference("MaxTextureResolution") == 2048 then
				list[2] = true;
			else
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			--Want more options? TOO BAD!
			if list[1] then
				PREFSMAN:SetPreference("MaxTextureResolution",1024);
			else
				PREFSMAN:SetPreference("MaxTextureResolution",2048);
			end;
			--Always do 32bit
			PREFSMAN:SetPreference("DisplayColorDepth",32);
			PREFSMAN:SetPreference("MovieColorDepth",32);
			PREFSMAN:SetPreference("TextureColorDepth",32);
			PREFSMAN:SavePreferences();
		end;
	};
	setmetatable( t, t );
	return t;
end;

--Depreciated
--[[
function CustomSongsPerPlay() -- by Alisson A2 (Alisson de Oliveira)
	local t = {
		Name = "SongsPerPlay";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;		--ojo
		ExportOnChange = true;
		Choices = {4, 5, 6, 7};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("SongsPerPlay") == nil then
				list[1] = true
				WritePrefToFile("SongsPerPlay",4);
			else
				if GetUserPref("SongsPerPlay") == "4" then
					list[1] = true;
				end;
				if GetUserPref("SongsPerPlay") == "5" then
					list[2] = true;
				end;
				if GetUserPref("SongsPerPlay") == "6" then
					list[3] = true;
				end;
				if GetUserPref("SongsPerPlay") == "7" then
					list[4] = true;
				end;
				
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val;
				if list[1] then
					val = 4
				end;
				if list[2] then
					val = 5
				end;
				if list[3] then
					val = 6
				end;
				if list[4] then
					val = 7
				end;
			WritePrefToFile("SongsPerPlay",val);
			PREFSMAN:SetPreference("SongsPerPlay",val);
			PREFSMAN:SavePreferences();
		end;
	};
	setmetatable( t, t );
	return t;
end;
]]

--By Accelerator

function MixtapeModeConfig()
	local t = {
		Name = "MixtapeModeConfig";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		--False exports on screen exit
		ExportOnChange = false;
		--Get the text for the choices from language files (en.ini, es.ini, etc)
		Choices = {"Off", "On"};
		
		-- Used internally, this will set the selection on the screen when it is loaded.
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("MixtapeModeEnabled") == "false" then
				list[1] = true;
			else
				list[2] = true;
			end;
		end;
		
		
		SaveSelections = function(self, list, pn)
			if list[2] then
				WritePrefToFile("MixtapeModeEnabled","true");
			else
				WritePrefToFile("MixtapeModeEnabled","false");
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;

--By Accelerator, same as above
function SpecialModeConfig()
	local t = {
		Name = "SpecialModeConfig";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		--False exports on screen exit
		ExportOnChange = false;
		Choices = {"Off", "On"};
		
		-- Used internally, this will set the selection on the screen when it is loaded.
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("SpecialModeEnabled") == "false" then
				list[1] = true;
			else
				list[2] = true;
			end;
		end;
		
		
		SaveSelections = function(self, list, pn)
			if list[2] then
				WritePrefToFile("SpecialModeEnabled","true");
			else
				WritePrefToFile("SpecialModeEnabled","false");
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;

--The functionality was removed, this doesn't do anything.
function StreamSafeConfig()
	local t = {
		Name = "StreamSafeConfig";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		--False exports on screen exit
		ExportOnChange = false;
		--Get the text for the choices from language files (en.ini, es.ini, etc)
		Choices = {"Off", "On"};
		
		-- Used internally, this will set the selection on the screen when it is loaded.
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("StreamSafeEnabled") == "false" then
				list[1] = true;
			else
				list[2] = true;
			end;
		end;
		
		
		SaveSelections = function(self, list, pn)
			if list[2] then
				WritePrefToFile("StreamSafeEnabled","true");
			else
				WritePrefToFile("StreamSafeEnabled","false");
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;

function SongNameConfig()
	local t = {
		Name = "SongNameConfig";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		--False exports on screen exit
		ExportOnChange = false;
		Choices = {"Off", "On"};
		
		-- Used internally, this will set the selection on the screen when it is loaded.
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("ShowSongNames") == "false" then
				list[1] = true;
			else
				list[2] = true;
			end;
		end;
		
		
		SaveSelections = function(self, list, pn)
			if list[2] then
				WritePrefToFile("ShowSongNames","true");
			else
				WritePrefToFile("ShowSongNames","false");
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;

--Accelerator
function HeartsPerPlayConfig()
	local t = {
		Name = "HeartsPerPlay";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		--False exports on screen exit
		ExportOnChange = false;
		Choices = {"2", "3", "4", "5", "6 (default)", "7", "8"};
		
		-- Used internally, this will set the selection on the screen when it is loaded.
		LoadSelections = function(self, list, pn)
			local choice = tonumber(ReadPrefFromFile("HeartsPerPlay"))
			if not choice then
				list[5] = true
			else
				--tonumber("2") -> 2, but 2 is the first element on the table so subtract 1 to highlight it
				list[choice-1] = true
			end;
		end;
		
		SaveSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						--The actual value is 1 above whatever is true in the list, so add 1.
						WritePrefToFile("HeartsPerPlay",(i+1));
						found = true
					end
				end
			end
		end;
	};
	setmetatable( t, t );
	return t;
end;

function SaveTypeConfig()
	local t = {
		Name = "SaveType";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		--False exports on screen exit
		ExportOnChange = false;
		Choices = {"USB and Local","USB and RFID"};
		
		-- Used internally, this will set the selection on the screen when it is loaded.
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("SaveType") == "RFID" then
				list[2] = true
			else
				list[1] = true
			end;
		end;
		
		SaveSelections = function(self, list, pn)
			if list[2] then
				WritePrefToFile("SaveType","RFID");
			else
				WritePrefToFile("SaveType","USB");
			end;
		end;
	};
	setmetatable( t, t );
	return t;
end;

function USBSongConfig()
	local t = {
		Name = "AllowUSBSongs";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = {"Disabled", "Enabled"};
		LoadSelections = function(self, list, pn)
			if PREFSMAN:GetPreference("CustomSongsEnable") == true then
				list[2] = true;
			else
				list[1] = true;
			end;
		end;
		SaveSelections = function(self, list, pn)
			if list[1] then
				PREFSMAN:SetPreference("CustomSongsEnable",false);
			else
				PREFSMAN:SetPreference("CustomSongsEnable",true);
			end;
			PREFSMAN:SavePreferences();
		end;
	};
	setmetatable( t, t );
	return t;
end;

function CustomSongsMaxSeconds()
	local t = {
		Name = "CustomSongsMaxSeconds";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = false;
		Choices = {"60", "90", "120 (default)","150","180","210","240","270","300"};
		LoadSelections = function(self, list, pn)
			local c = PREFSMAN:GetPreference("CustomSongsMaxSeconds")
			if c%30 == 0 and (c-30)/30 < #self.Choices then
				list[(c-30)/30] = true
				return;
			end;
			--If we got here, no choice was found
			lua.ReportScriptError("Song seconds was set to "..c.." which isn't a valid choice.")
			list[3] = true
		end;
		SaveSelections = function(self, list, pn)
			local found = false
			for i=1, #list do
				if list[i] then
					PREFSMAN:SetPreference("CustomSongsMaxSeconds",30+30*i);
					PREFSMAN:SavePreferences();
					return;
				end;
			end;
			--If we got here, nothing was found
			--lua.ReportScriptError("No choice found!");
		end;
	};
	setmetatable( t, t );
	return t;
end;

--Unimplemented. The default is S+.
--[[function ExtraHeartsConfig()
	local t = {
		Name = "ExtraHearts";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		--False exports on screen exit
		ExportOnChange = false;
		Choices = {"A", "S", "S+", "SS"};
		
		-- Used internally, this will set the selection on the screen when it is loaded.
		LoadSelections = function(self, list, pn)
			local choice = ReadPrefFromFile("MinGradeForExtraHeart")
			if choice == "A" then
				list[1] = true
			elseif choice == "S" then
				list[2] = true
			--Skipping "S+" because it's the fallback and no need to check.
			elseif choice == "SS" then
				list[4] = true
			else
				list[3] = true
			end;
		end;
		
		SaveSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						--The actual value is 1 above whatever is true in the list, so add 1.
						WritePrefToFile("HeartsPerPlay",(i+1));
						found = true
					end
				end
			end
		end;
	};
	setmetatable( t, t );
	return t;
end;]]
