--[[
-- Used for custom wheel
-- This is from Simply Love, it is modded a little though
The copyright statement is for play_sample_music and stop_music functions only

MIT License

Copyright (c) 2013-2019 Daniel Joshua Guzek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]
function play_sample_music(song, sample_len)

	if song then
	
		local songpath = song:GetMusicPath()
		local sample_start = song:GetSampleStart()
		--local sample_len = song:GetSampleLength()
		if not sample_len then sample_len = song:GetSampleLength() end

		if songpath == song:GetPreviewMusicPath() then
			if songpath and sample_start and sample_len then
				SOUND:DimMusic(PREFSMAN:GetPreference("SoundVolume"), math.huge)
				SOUND:PlayMusicPart(songpath, sample_start,sample_len, 0.5, 1.5, false, true)
			else
				stop_music()
			end
		else
			--SOUND:DimMusic(PREFSMAN:GetPreference("SoundVolume"), math.huge)
			SOUND:PlayMusicPart(song:GetPreviewMusicPath(), 0.0, sample_len, 0.5, 1.5, true, true)
		end;
	else
		stop_music()
	end
end

-- From Simply Love
function stop_music()
	SOUND:PlayMusicPart("", 0, 0)
end

-- ======================
-- End Simply Love code
-- ======================

function RioWheel(self,offsetFromCenter,itemIndex,numItems)
    local spacing = 210;
	local edgeSpacing = 135;
    if math.abs(offsetFromCenter) < .5 then
        if not MUSICWHEEL_SONG_NAMES then
			self:zoom(1+math.cos(offsetFromCenter*math.pi)/3);
		end;
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
	GroupSelect3 = {
		default = "MenuUp"
	},
	GroupSelect4 = {
		default= "MenuDown"
	},
	OptionList = {
		default = "Left,Right,Left,Right",
		pump = "DownLeft,DownRight,DownLeft,DownRight,DownLeft,DownRight"
	},
	--Alternative for menu buttons instead of pads
	OptionList2 = {
		default = "MenuLeft,MenuRight,MenuLeft,MenuRight,MenuLeft,MenuRight"
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


--[[
Thank you, DDR SN3 team!
The below functions are from https://github.com/Inorizushi/DDR-X3/blob/master/Scripts/Starter.lua, please credit Midflight Digital if you want to put it in your theme

MIT License

Copyright (c) 2017 Inorizushi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]
local isolatePattern = "/([^/]+)/?$" --in English, "everything after the last forward slash unless there is a terminator"
local combineFormat = "%s/%s"
function AssembleDefaultGroups()
	local outputPath = "/Themes/"..THEME:GetCurThemeName().."/Other/SongManager DefaultGroups.txt";
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

function AssembleCoopGroup()
	local outputPath = "/Themes/"..THEME:GetCurThemeName().."/Other/SongManager CoopSongs.txt";
	if not (SONGMAN and GAMESTATE) then return end
	local set = {}
	for _, song in pairs(SONGMAN:GetAllSongs()) do
		local steps = song:GetStepsByStepsType('StepsType_Pump_Routine');
		if #steps >= 1 and song:GetGroupName() ~= RIO_FOLDER_NAMES["EasyFolder"] then --Filter out songs that dont have pump, and unsafe songs 
			local shortSongDir = string.match(song:GetSongDir(),isolatePattern)
			local groupName = song:GetGroupName()
			local groupTbl = GetOrCreateChild(set, "CO-OP Mode")
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

-- I don't think this is even used.
function AssembleShortcutGroup()
	local outputPath = "/Themes/"..THEME:GetCurThemeName().."/Other/SongManager SnapTracks.txt";
	if not (SONGMAN and GAMESTATE) then return end
	local set = {}
	for _, song in pairs(SONGMAN:GetAllSongs()) do
		local tagValue = string.lower(GetTagValue(song:GetSongFilePath(),"SONGTYPE"))
		if (song:MusicLengthSeconds() < MAX_SECONDS_FOR_SHORTCUT and tagValue ~= "special") or tagValue == "shortcut" then
			local shortSongDir = string.match(song:GetSongDir(),isolatePattern)
			local groupName = song:GetGroupName()
			local groupTbl = GetOrCreateChild(set, "Snap Tracks")
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
