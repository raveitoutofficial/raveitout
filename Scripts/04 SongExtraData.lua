--SongExtraData
local fand = RageFileUtil.CreateRageFile()
local SongDataCache = setmetatable({}, {__mode="k"})

local SongTypeToHearts = {
	arcade = 2,
	shortcut = 1,
	remix = 3,
	fullsong = 4,
	marathon = 6
}
local function SongTypeTransform(_, data)
	return SongTypeToHearts[string.lower(data)]
end
MAX_SECONDS_FOR_SHORTCUT = 95
local function SongTypeFallback(song)
	if song:MusicLengthSeconds() < MAX_SECONDS_FOR_SHORTCUT then
		return SongTypeToHearts.shortcut
	elseif song:IsLong() then
		return SongTypeToHearts.fullsong
	elseif song:IsMarathon() then
		return SongTypeToHearts.marathon
	else
		return SongTypeToHearts.arcade
	end
end

local function PreviewTransform(song, VideoName)
	--original code by Alisson, see Alisson.lua for reference
	if VideoName ~= "" then
		if FILEMAN:DoesFileExist(song:GetSongDir().."/"..VideoName) then
			VideoName = song:GetSongDir().."/"..VideoName
		elseif FILEMAN:DoesFileExist("/SongPreviews/"..VideoName) then
			VideoName = "/SongPreviews/"..VideoName
		else
			--this video doesn't appear to exist. Just return "" instead.
			VideoName = ""
		end
	else
		--nothing yet, maybe something eventually
	end
	return VideoName
end

local items = {
	PreviewVid={source="PREVIEWVID", transform=PreviewTransform, fallback=""},
	Hearts={source="SONGTYPE", transform=SongTypeTransform, fallback=SongTypeFallback}
}

function GetSongExtraData(song, item)
	assert(song, "no Song provided")
	assert(item, "no data item provided")
	assert(items[item], "invalid data item "..item)
	
	local dir = song:GetSongDir()
	local result = nil
	if SongDataCache[dir] then
		result = SongDataCache[dir][item]
	else
		fand:Open(song:GetSongFilePath(), 1)
		local FileContents = fand:Read()
		fand:Close()
		local CacheEntry = {}
		for name, data in pairs(items) do
			local _, __, TagData = string.find(FileContents, "#"..data.source..":([^;]*);")
			if TagData then
				if data.transform then
					TagData = data.transform(song, TagData)
				end
				CacheEntry[name] = TagData
			else
				if type(data.fallback) == "function" then
					CacheEntry[name] = data.fallback(song)
				else
					CacheEntry[name] = data.fallback
				end
			end
		end
		result = CacheEntry[item]
		SongDataCache[dir] = CacheEntry
	end

	return result
end