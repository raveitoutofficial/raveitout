function RioWheel(self,offsetFromCenter,itemIndex,numItems)
    local spacing = 210;
	local edgeSpacing = 135;
    if math.abs(offsetFromCenter) < .5 then
        self:zoom(1+math.cos(offsetFromCenter*math.pi)/3);
        self:x(offsetFromCenter*(spacing+edgeSpacing*2));
    else
        if offsetFromCenter >= .5 then
            self:x(offsetFromCenter*spacing+edgeSpacing);
        elseif offsetFromCenter <= -.5 then
            self:x(offsetFromCenter*spacing-edgeSpacing);
        end;
            --self:zoom(1);
    end;
end;

local gsCodes = {
	-- steps
	GroupSelect1 = {
		default = "Up",
		--dance = "Up",
		pump = "UpLeft",
	},
	GroupSelect2 = {
		default = "Down",
		--dance = "Down",
		pump = "UpRight",
	},
	OptionList = {
		default = "Left,Right,Left,Right",
		pump = "DownLeft,DownRight,DownLeft,DownRight,DownLeft,DownRight"
	}
};

local function CurGameName()
	return GAMESTATE:GetCurrentGame():GetName()
end

function MusicSelectMappings(codeName)
	local gameName = string.lower(CurGameName())
	local inputCode = gsCodes[codeName]
	return inputCode[gameName] or inputCode["default"]
end

function GetOrCreateChild(tab, field, kind)
    kind = kind or 'table'
    local out
    if not tab[field] then
        if kind == 'table' then
            out = {}
        elseif kind == 'number' then
            out = 0
        elseif kind == 'boolean_df' or kind == 'boolean' then
            out = false
        elseif kind == 'boolean_dt' then
            out = true
        else
            error("GetOrCreateChild: I don't know a default value for type "..kind)
        end
        tab[field] = out
    else out = tab[field] end
    return out
end

--Thank you, DDR SN3 team!
--This function is a port of https://github.com/Inorizushi/DDR-X3/blob/master/Scripts/Starter.lua, please credit them if you want to put it in your theme
local outputPath = "/Themes/"..THEME:GetCurThemeName().."/Other/SongManager DefaultGroups.txt";
local isolatePattern = "/([^/]+)/?$" --in English, "everything after the last forward slash unless there is a terminator"
local combineFormat = "%s/%s"
function AssembleDefaultGroups()
	if not (SONGMAN and GAMESTATE) then return end
	local streamSafeMode = (ReadPrefFromFile("StreamSafeEnabled") == "true");
	local set = {}
	--populate the groups
	for _, song in pairs(SONGMAN:GetAllSongs()) do
		--local steps = song:GetStepsByStepsType('StepsType_Pump_Single');
		--local doublesSteps = song:GetStepsByStepsType('StepsType_Pump_Double');
		--Trace(song:GetDisplayMainTitle());
		if not (streamSafeMode and has_value(STREAM_UNSAFE_AUDIO, song:GetDisplayFullTitle() .. "||" .. song:GetDisplayArtist())) and song:GetGroupName() ~= RIO_FOLDER_NAMES["EasyFolder"] and song:GetMainTitle() ~= "info" then --Filter out unsafe songs.
			local shortSongDir = string.match(song:GetSongDir(),isolatePattern)
			--Trace("sDir: "..shortSongDir)
			local groupName = song:GetGroupName()
			local groupTbl = GetOrCreateChild(set, groupName)
			table.insert(groupTbl,
				string.format(combineFormat, groupName, shortSongDir))
		end
	end
	--Do the whole thing a second time to make a routine group
	for _, song in pairs(SONGMAN:GetAllSongs()) do
		local steps = song:GetStepsByStepsType('StepsType_Pump_Routine');
		if #steps >= 1 and not (streamSafeMode and has_value(STREAM_UNSAFE_AUDIO, song:GetDisplayFullTitle() .. "||" .. song:GetDisplayArtist())) and song:GetGroupName() ~= RIO_FOLDER_NAMES["EasyFolder"] then --Filter out songs that dont have pump, and unsafe songs 
			local shortSongDir = string.match(song:GetSongDir(),isolatePattern)
			local groupName = song:GetGroupName()
			local groupTbl = GetOrCreateChild(set, "Routine")
			table.insert(groupTbl,
				string.format(combineFormat, groupName, shortSongDir))
		end
	end
	--sort all the groups and collect their names, then sort that too
	local groupNames = {}
	for groupName, group in pairs(set) do
		if next(group) == nil then
			set[groupName] = nil
		else
			table.sort(group)
			table.insert(groupNames, groupName)
		end
	end
	table.sort(groupNames)
	--then, let's make a representation of our eventual file in memory.
	local outputLines = {}
	for _, groupName in ipairs(groupNames) do
		table.insert(outputLines, "---"..groupName) --Comment it out if you don't want folders.
		for _, path in ipairs(set[groupName]) do
			table.insert(outputLines, path)
		end
	end
	--now, slam it all out to disk.
	local fHandle = RageFileUtil.CreateRageFile()
	--the mode is Write+FlushToDiskOnClose
	fHandle:Open(outputPath, 10)
	fHandle:Write(table.concat(outputLines,'\n'))
	fHandle:Close()
	fHandle:destroy()
end
--Lol
--AssembleBasicMode();
