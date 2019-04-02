--SongExtraData
local fand = RageFileUtil.CreateRageFile()
local DataCache
function ClearExtraDataCache()
	DataCache = setmetatable({}, {__mode="k"})
end
ClearExtraDataCache()

local SongTypeToHearts = {
	arcade = 2,
	shortcut = 1,
	remix = 3,
	fullsong = 4,
	marathon = 6
}
MAX_SECONDS_FOR_SHORTCUT = 95

local function SongTypeTransform(_, data)
	return SongTypeToHearts[string.lower(data)]
end

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

local SongItems = {
	PreviewVid={source="PREVIEWVID", transform=PreviewTransform, fallback=""},
	Hearts={source="SONGTYPE", transform=SongTypeTransform, fallback=SongTypeFallback}
}

local CourseItems = {
	LimitBreak={source="LIMITBREAK", transform=function(_,data) return tonumber(data) end, fallback=51}
}

function GetExtraData(sc, item, course_mode)
	assert(sc, "no Song/Course provided")
	assert(item, "no data item provided")
	local items
	if not course_mode then
		items = SongItems
	else
		items = CourseItems
	end
	assert(items[item], "invalid data item "..item)
	
	local dir
	if not course_mode then
		dir = sc:GetSongDir()
	else
		dir = sc:GetCourseDir()
	end
	local result = nil
	if DataCache[dir] then
		result = DataCache[dir][item]
	else
		local CacheEntry = {}
		
		local UseFallback = false
		local WasOpened = true
		
		local FileContents
		local ItemPath
		if not course_mode then
			ItemPath = sc:GetSongFilePath()
		else
			--i guess???
			ItemPath = dir
		end
		fand:Open(ItemPath, 1)
		if fand:GetError() ~= "" then
			UseFallback = true
			WasOpened = false
		else
			FileContents = fand:Read()
			if not FileContents then
				UseFallback = true
			end
		end

		for name, data in pairs(items) do
			local UsingFallbackThisTime = UseFallback
		
			if not UsingFallbackThisTime then
				local _, __, TagData = string.find(FileContents, "#"..data.source..":([^;]*);")
				if TagData then
					if data.transform then
						TagData = data.transform(sc, TagData)
					end
					CacheEntry[name] = TagData
				else
					UsingFallbackThisTime = true
				end
			end
		
			if UsingFallbackThisTime then
				if type(data.fallback) == "function" then
					CacheEntry[name] = data.fallback(sc)
				else
					CacheEntry[name] = data.fallback
				end
			end
		
		end
		
		result = CacheEntry[item]
		DataCache[dir] = CacheEntry
		if WasOpened then
			fand:Close()
		end
		fand:ClearError()
	
	end

	return result
end

function GetSongExtraData(song, item)
	return GetExtraData(song, item, false)
end