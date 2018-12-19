function VideoMode()		--ScreenFilter (requested by Cortes)		by NeobeatIKK, based on BGAMode by Alisson A2 (Alisson de Oliveira)
	local t = {
		Name = "Graphics Details";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;		--ojo
		ExportOnChange = true;
		Choices = { "SD", "HD"};
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("VideoMode") == nil then
				list[1] = true
				WritePrefToFile("VideoMode","SD");
			else
				if GetUserPref("VideoMode") == "SD" then
					list[1] = true;
				end;
				if GetUserPref("VideoMode") == "HD" then
					list[2] = true;
				end;
				
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val;
				if list[1] then
					val = "SD"
					DisplayAspectRatio = 1.777778
					DisplayColorDepth= 16
					TextureColorDepth= 16
					MovieColorDepth= 16
				end;
				if list[2] then
					val = "HD"
					DisplayAspectRatio = 1.777778
					DisplayColorDepth= 32
					TextureColorDepth= 32
					MovieColorDepth= 32
				end;
			WritePrefToFile("VideoMode",val);
			PREFSMAN:SetPreference("DisplayAspectRatio",DisplayAspectRatio);
			PREFSMAN:SetPreference("DisplayColorDepth",DisplayColorDepth);
			PREFSMAN:SetPreference("MovieColorDepth",MovieColorDepth);
			PREFSMAN:SetPreference("TextureColorDepth",TextureColorDepth);
			PREFSMAN:SavePreferences();
		end;
	};
	setmetatable( t, t );
	return t;
end;

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
