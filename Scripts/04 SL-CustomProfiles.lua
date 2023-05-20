--[[
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

local path =  "UserPrefs/" .. THEME:GetThemeDisplayName() .. "/"

-- Hook called during profile load
-- This will NOT get called for the machine profile!!
function LoadProfileCustom(profile, dir, isEdit)

	local PrefPath =  dir .. path

	if isEdit ~= true then
		local pn
		-- we've been passed a profile object as the variable "profile"
		-- see if it matches against anything returned by PROFILEMAN:GetProfile(pn)
		local Players = GAMESTATE:GetHumanPlayers()

		if Players then
			for player in ivalues(Players) do
				if profile == PROFILEMAN:GetProfile(player) then
					pn = player;
				end
			end
		end
			-- ...and then, if a player profile exists, read .cfg files from it
		if pn then
			local pns = pname(pn); --pn = PlayerNumber_PX, pns = PX
			local f = RageFileUtil.CreateRageFile()
			local setting
			--This uses the ActiveModifiers table from PlayerOptions.lua
			for k,v in pairs( ActiveModifiers[pns] ) do

				local fullFilename = PrefPath..k..".cfg"

				if f:Open(fullFilename,1) then

					-- RageFile's Read() method always returns a string
					setting = f:Read()

					-- but maybe we don't want a string; attempt to convert
					if setting == "true" then setting = true
					elseif setting == "false" then setting = false
					end

					ActiveModifiers[pns][k] = setting
				else
					local fError = f:GetError()
					Trace( "[FileUtils] Error reading ".. fullFilename ..": ".. fError )
					f:ClearError()
				end
			end
			
			--Custom profile icon handling
			--Check for icons inside the profile directory first (local profile, USB stick, whatever)
			local profileIcon = getLocalProfileIcon(dir)
			if profileIcon then
				setenv("profile_icon_"..pns,profileIcon);
			else --None found, check if it's a built in profile icon in the ActiveModifiers table
				--Will return nil if there isn't a profile icon, but if there was one we want to check that the icon hasn't been removed or renamed
				if ActiveModifiers[pns]["ProfileIcon"] and FILEMAN:DoesFileExist(THEME:GetPathG("ProfileBanner","avatars").."/"..ActiveModifiers[pns]["ProfileIcon"]) then
					setenv("profile_icon_"..pns,THEME:GetPathG("ProfileBanner","avatars").."/"..ActiveModifiers[pns]["ProfileIcon"]);
				else --Still none found, just pick a random one
					setenv("profile_icon_"..pns,getRandomProfileIcon(pn));
				end;
			end;

			-- don't destroy the RageFile until we've tried to load all custom options
			-- and set them to the env table to make them accessible from anywhere in SM
			f:destroy()
		end
	--Special handling for editing profiles from operator menu because neither P1 or P2 is joined.
	else
		local f = RageFileUtil.CreateRageFile()
		local setting
		--This uses the ActiveModifiers table from PlayerOptions.lua
		for k,v in pairs( ActiveModifiers["EDIT"] ) do

			local fullFilename = PrefPath..k..".cfg"

			if f:Open(fullFilename,1) then

				-- RageFile's Read() method always returns a string
				setting = f:Read()

				-- but maybe we don't want a string; attempt to convert
				if setting == "true" then setting = true
				elseif setting == "false" then setting = false
				end

				ActiveModifiers["EDIT"][k] = setting
			else
				local fError = f:GetError()
				Trace( "[FileUtils] Error reading ".. fullFilename ..": ".. fError )
				f:ClearError()
			end
		end
		
		-- don't destroy the RageFile until we've tried to load all custom options
		-- and set them to the env table to make them accessible from anywhere in SM
		f:destroy()
	end;

	return true
end

-- Hook called during profile save
function SaveProfileCustom(profile, dir, isEdit)

	local PrefPath =  dir .. path
	if isEdit ~= true then
		local pn

		local Players = GAMESTATE:GetHumanPlayers()

		for player in ivalues(Players) do
			if profile == PROFILEMAN:GetProfile(player) then
				pn = ToEnumShortString(player)
			end
		end

		if pn then
			-- a generic ragefile (?)
			local f = RageFileUtil.CreateRageFile()

			-- then loop through the prefs, saving one .cfg file per available setting
			-- if a particular value is nil, nothing gets written
			for k,v in pairs( ActiveModifiers[pn] ) do

				local fullFilename = PrefPath..k..".cfg"

				if f:Open(fullFilename, 2) then
					--Warn("[FileUtils] Writing to"..fullFilename);
					-- if a setting exists (it should) write that to the .cfg file
					if v ~= nil then
						f:Write( tostring( v ) )
					end
				else
					local fError = f:GetError()
					Trace( "[FileUtils] Error writing to ".. fullFilename ..": ".. fError )
					f:ClearError()
				end
			end

			-- again, don't destroy the file until after we're done looping
			-- through all possible custom options
			f:destroy()
		end
	else --Same as above function
		-- a generic ragefile (?)
		local f = RageFileUtil.CreateRageFile()

		-- then loop through the prefs, saving one .cfg file per available setting
		-- if a particular value is nil, nothing gets written
		for k,v in pairs( ActiveModifiers["EDIT"] ) do

			local fullFilename = PrefPath..k..".cfg"

			if f:Open(fullFilename, 2) then
				--Warn("[FileUtils] Writing to"..fullFilename);
				-- if a setting exists (it should) write that to the .cfg file
				if v ~= nil then
					f:Write( tostring( v ) )
				end
			else
				local fError = f:GetError()
				Trace( "[FileUtils] Error writing to ".. fullFilename ..": ".. fError )
				f:ClearError()
			end
		end

		-- again, don't destroy the file until after we're done looping
		-- through all possible custom options
		f:destroy()
	end;

	return true
end

Trace("[CustomProfiles] Loaded functions.")
