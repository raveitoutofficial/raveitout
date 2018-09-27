

--[[FIXED FONTS]]
DebugFont =		"Common normal"

--[[ALIASES]]
DoDebug =				THEME:GetMetric("CustomRIO","DoDebug")				--
Enjoy1stStage = 		THEME:GetMetric("CustomRIO","Enjoy1stStage")		--
Enjoy1stStagePMode = 	THEME:GetMetric("CustomRIO","Enjoy1stStagePMode")	--
--[[GLOBAL VALUES]]
WallpaperSleepTime =	THEME:GetMetric("CustomRIO","WallpaperSleepTime")	--
FadeInRatio =			THEME:GetMetric("CustomRIO","FadeInRatio")	--
FadeInTween =			THEME:GetMetric("CustomRIO","FadeInTween")	--
FadeOutRatio =			THEME:GetMetric("CustomRIO","FadeOutRatio")	--
FadeOutTween =			THEME:GetMetric("CustomRIO","FadeOutTween")	--

--[[Judgement/Combo animation]]
--Note: Anything involving Combo Numbers also affects "Combo/Miss" label
local zf	= 0.35		--combo zoom finetuning	
local skb	= -0.25		--skewx value, both
local skj	= skb		--skewx judgement value 
local skc	= skb		--skewx combo value
local iab	= 1			--initial alpha both
local iaj	= iab		--initial alpha judgement
local iac	= iab		--initial alpha combo
local izmb	= 1			--initial zoom both
local izmj	= izmb+0.3		--initial zoom judgement
local izmc	= izmj-zf	--initial zoom combo
local ixb	= 0			--initial X (horizontal) position both
local ixj	= ixb		--initial X (horizontal) position judgement
local ixc	= ixb		--initial X (horizontal) position combo
local iyb	= 0			--initial Y (vertical) position both
local iyj	= 0			--initial Y (vertical) position judgement
local iyc	= 5		--initial Y (vertical) position combo
	 --note: in and still/resting time animations must be the always same for both items
local cbin	= 0.15		--combo in time
--
local rxb	= 0			--resting X (horizontal) value, both
local rxj	= rxb		--resting X (horizontal) value, judgement
local rxc	= rxb		--resting X (horizontal) value, combo
local ryb	= 5			--resting Y (vertical) value, both
local ryj	= 0			--resting Y (vertical) value, both
local ryc	= -5		--resting Y (vertical) value, both
local rmzb	= 1.2		--resting zoom value, both
local rzmj	= rmzb+0.4		--resting zoom value, judgement
local rzmc	= rmzb-zf	--resting zoom value, combo
local cbwt	= 0.25		--combo wait time (sleep, if any)
--
local cbot1	= 0.25		--combo out animation time 1
--local xof1b = 0		--X axis value offset from center 1, both items
local xof1j = 30		--X axis value offset from center 1, judgement
local xof1c = -30		--X axis value offset from center 1, combo
local aot1b = 0.5		--Alpha value during out 1 animation, both items
local aot1j = aot1b		--Alpha value during out 1 animation, judgement
local aot1c = aot1b		--Alpha value during out 1 animation, combo
--
local cbot2	= 0.5		--combo out animation time 2
--local xof2b = 0		--X axis value offset from center 1, both items
local xof2j = 75		--X axis value offset from center 1, judgement
local xof2c = -75		--X axis value offset from center 1, combo
local aot2b = 0			--Alpha value during out 2 animation, both items
local aot2j = aot2b		--Alpha value during out 2 animation, judgement
local aot2c = aot2b		--Alpha value during out 2 animation, combo

Comboanijudge = cmd(finishtweening;skewx,skj;x,ixj;y,iyj;diffusealpha,iaj;
				   zoom,izmj;decelerate,cbin;x,rxj;y,ryj;zoom,rzmj;sleep,cbwt;
				   decelerate,cbot1;x,xof1j;diffusealpha,aot1j;
				   accelerate,cbot2;x,xof2j;diffusealpha,aot2j);
Comboanicombo = cmd(finishtweening;skewx,skc;x,ixc;y,iyc;diffusealpha,iac;
				  zoom,izmc;decelerate,cbin;x,rxc;y,ryc;zoom,rzmc;sleep,cbwt;
				  decelerate,cbot1;x,xof1c;diffusealpha,aot1c;
				  accelerate,cbot2;x,xof2c;diffusealpha,aot2c;);

--Cortes has a weird bug regarding how his setup returns Widescreen values, this is part
--of a workaround for him (and anyone having the same problem) to use. -NeobeatIKK
if FILEMAN:DoesFileExist(THEME:GetCurrentThemeDirectory().."corteswidefix.patch") then
	CortesWideFix = true
else
	CortesWideFix = false
end

--[[FUNCTIONS]]

--OptionList functions
function PerfectionistMode()		--PerfectionistMode (requested by Cortes)		by NeobeatIKK, based on BGAMode by Alisson A2 (Alisson de Oliveira)
	local t = {
		Name = "PerfectionistMode";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;		--ojo
		ExportOnChange = true;
		Choices = { "Off", "On"};										--a ver si entendí... :
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("PerfectionistMode") == nil then		--si la lectura falla (no existe el archivo) entonces
				list[1] = true;											--a "list[1]" se le asigna el valor "true"
				WritePrefToFile("PerfectionistMode",false);				--escribir valor "falso" (ya que es el valor por defecto, queremos que PerfectionistMode esté apagado por defecto)
			else														--si existe un valor entonces...
				if GetUserPrefB("PerfectionistMode") == true then		--si la preferencia es verdadera (en el archivo) entonces
					list[2] = true;										--a "list[2]" se le asigna el valor "true"
				end;													--
				if GetUserPrefB("PerfectionistMode") == false then		--si la preferencia es falsa (en el archivo) entonces
					list[1] = true;										--a "list[1]" se le asigna el valor "true"
				end;
			end;
		end;
		SaveSelections = function(self, list, pn)						--al guardar:
			local val;													--setear local (aka guardarle el espacio)
				if list[1] then											--si (es verdadero) "list[1]" entonces
					val = false											--val equivale a "false" (Off, en choices)
				end;													--
				if list[2] then											--si (es verdadero) "list[2]" entonces
					val = true											--val equivale a "true" (On, en choices)
				end;													--
			WritePrefToFile("PerfectionistMode",val);					--Obtener el valor de "val" y escribirlo al archivo de preferencias
		end;
	};																	--si estoy equivocado en la explicacion POR FAVOR corregir, así aprendo mejor xd		-NeobeatIKK
	setmetatable( t, t );
	return t;
end;
function ScreenFilter()		--ScreenFilter (requested by Cortes)		by NeobeatIKK, based on BGAMode by Alisson A2 (Alisson de Oliveira)
	--TO DO: Save to PlayerProfile folder
	local t = {
		Name = "ScreenFilter";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = false;		--ojo
		ExportOnChange = true;
		Choices = { "Off", "20", "40", "60", "80", "100" };
		LoadSelections = function(self, list, pn)
			if ReadPrefFromFile("ScreenFilter"..ToEnumShortString(pn)) == nil then
				list[1] = true
				WritePrefToFile("ScreenFilter"..ToEnumShortString(pn),"0");
			else
				if GetUserPref("ScreenFilter"..ToEnumShortString(pn)) == "0" then
					list[1] = true;
				end;
				if GetUserPref("ScreenFilter"..ToEnumShortString(pn)) == "20" then
					list[2] = true;
				end;
				if GetUserPref("ScreenFilter"..ToEnumShortString(pn)) == "40" then
					list[3] = true;
				end;
				if GetUserPref("ScreenFilter"..ToEnumShortString(pn)) == "60" then
					list[4] = true;
				end;
				if GetUserPref("ScreenFilter"..ToEnumShortString(pn)) == "80" then
					list[5] = true;
				end;
				if GetUserPref("ScreenFilter"..ToEnumShortString(pn)) == "100" then
					list[6] = true;
				end;
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val;
				if list[1] then
					val = 0
				end;
				if list[2] then
					val = 20
				end;
				if list[3] then
					val = 40
				end;
				if list[4] then
					val = 60
				end;
				if list[5] then
					val = 80
				end;
				if list[6] then
					val = 100
				end;
			WritePrefToFile("ScreenFilter"..ToEnumShortString(pn),val);
		end;
	};
	setmetatable( t, t );
	return t;
end;		--]]
--[[function ScreenFilter()		--ScreenFilter (requested by Cortes) (PROFILE Folder version)		by NeobeatIKK, based on BGAMode by Alisson A2 (Alisson de Oliveira)
	--This function DOESN'T WORK (yet), it Lua panics
	local t = {
		Name = "ScreenFilter";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = false;		--ojo
		ExportOnChange = true;
		Choices = { "Off", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100" };
		LoadSelections = function(self, list, pn)
			if pn == "PlayerNumber_P1" then
				playn = "Player1"
			end
			if pn == "PlayerNumber_P1" then
				playn = "Player2"
			end
			local profilep = PROFILEMAN:GetProfileDir("ProfileSlot_"..playn)
			local sfile = "ScreenFilter.txt"
			local spath = profilep.."/RIO_PlayerPrefs/"..sfile
			local pref = File.Read(spath)
			if FILEMAN:DoesFileExist(spath) == false then
				list[1] = true
				File.Write(spath,"0");
			else
				if pref == "0" then
					list[1] = true;
				end;
				if pref == "10" then
					list[2] = true;
				end;
				if pref == "20" then
					list[3] = true;
				end;
				if pref == "30" then
					list[4] = true;
				end;
				if pref == "40" then
					list[5] = true;
				end;
				if pref == "50" then
					list[6] = true;
				end;
				if pref == "60" then
					list[7] = true;
				end;
				if pref == "70" then
					list[8] = true;
				end;
				if pref == "80" then
					list[9] = true;
				end;
				if pref == "90" then
					list[10] = true;
				end;
				if pref == "100" then
					list[11] = true;
				end;
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val;
				if list[1] then
					val = 0
				end;
				if list[2] then
					val = 10
				end;
				if list[3] then
					val = 20
				end;
				if list[4] then
					val = 30
				end;
				if list[5] then
					val = 40
				end;
				if list[6] then
					val = 50
				end;
				if list[7] then
					val = 60
				end;
				if list[8] then
					val = 70
				end;
				if list[9] then
					val = 80
				end;
				if list[10] then
					val = 90
				end;
				if list[11] then
					val = 100
				end;
			File.Write(spath,val);
		end;
	};
	setmetatable( t, t );
	return t;
end;--]]
function BGAMode()		--BGAMode		by Alisson A2 (Alisson de Oliveira)
	local t = {
		Name = "UserPrefBGAMode";
		LayoutType = "ShowAllInRow";
		SelectType = "SelectOne";
		OneChoiceForAllPlayers = true;
		ExportOnChange = true;
		Choices = { "BGA Off", "BGA On", "Black Screen"};
		LoadSelections = function(self, list, pn)
			if GetUserPref("UserPrefBGAMode") == nil or GetUserPref("UserPrefBGAMode") == "" then
				list[2] = true;
				WritePrefToFile("UserPrefBGAMode",true);
			else
				if GetUserPrefB("UserPrefBGAMode") == false then -- BGAOFF
					list[1] = true;
				end;
				if GetUserPrefB("UserPrefBGAMode") == true then -- BGAON
					list[2] = true;
				end;
				if GetUserPref("UserPrefBGAMode") == "black" then -- BLACK SCREEN
					list[3] = true;
				end;
			end;
		end;
		SaveSelections = function(self, list, pn)
			local val;
				if list[1] then
					val = false
				end;
				if list[2] then
					val = true
				end;
				if list[3] then
					val = "black"
				end;
			WritePrefToFile("UserPrefBGAMode",val);
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

--Unlock functions
function GetUnlockIndex( sEntryID )		--GetUnlockIndex	 by ROAD24 (Jose Jesus)		--HUGE thanks to him -NeobeatIKK
local iNumLocks = UNLOCKMAN:GetNumUnlocks();
lua.Trace("ROAD24 GetUnlockIndex: iNumLocks = " .. iNumLocks);
	for idx = 0, iNumLocks-1 do
			local sIDtoCompare = UNLOCKMAN:GetUnlockEntry(idx):GetCode();
			lua.Trace("ROAD24 GetUnlockIndex: idx = " .. idx .. " sIDtoCompare = " .. sIDtoCompare );
			if sIDtoCompare == sEntryID then
				lua.Trace("ROAD24 GetUnlockIndex: se encontro el code, index = " .. idx);
				return idx;
			end;
	end;
	lua.Trace("ROAD24 GetUnlockIndex: No se encontro regresando -1");	-- Si no lo encuentra ;
	return -1;
end;
function IsEntryIDLocked( sEntryID )	--IsEntryIDLocked	 by ROAD24
	if sEntryID then
		lua.Trace("ROAD24 IsEntryIDLocked: Intentando obtener index de " .. sEntryID);
		lua.Trace("ROAD24 IsEntryIDLocked: Invocando GetUnlockIndex");
		local iEntryIndex = GetUnlockIndex( sEntryID );
		lua.Trace("ROAD24 IsEntryIDLocked: GetUnlockIndex regreso " .. iEntryIndex );
		if iEntryIndex >= 0 then
     		local tUnlockEntry = UNLOCKMAN:GetUnlockEntry( iEntryIndex );
			if tUnlockEntry then
				local IsLocked = tUnlockEntry:IsLocked();
				if IsLocked ~= nil then
					lua.Trace("ROAD24 IsEntryIDLocked: regresa true");
					return IsLocked;
				else
					lua.Trace("ROAD24 IsEntryIDLocked: IsLocked regreso nil");
					return -1;
				end;
			end;
		else
			lua.Trace("ROAD24 IsEntryIDLocked: No se encontro index para " .. sEntryID);
		end;
	end;
		lua.Trace("ROAD24 IsEntryIDLocked: Se esperaba un string pero se recibio nil");
	return -1;
end;
function getNumberOfElements(t)
	local count = 0;
	if t then
		for index in pairs(t) do
			count = count + 1;
		end;
	end;
	return count;
end

function setScores(PlayerScores)
	setenv("PlayerScores",PlayerScores);
end;

function getScores()
	return getenv("PlayerScores");
end;

function soundext(filename)
	if FILEMAN:DoesFileExist(filename..".wav") then
		file_path = filename..".wav";
	elseif FILEMAN:DoesFileExist(filename..".mp3") then
		file_path = filename..".mp3";
	elseif FILEMAN:DoesFileExist(filename..".ogg") then
		file_path = filename..".ogg";
	else
		file_path = THEME:GetPathS("","nosound.ogg");
	end
	
	return file_path
end

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

function SpeedMods()
        local t = {
                Name = "UserPrefSpeedMods";
                LayoutType = "ShowAllInRow";
                SelectType = "SelectOne";
                OneChoiceForAllPlayers = false;
                ExportOnChange = true;
                Choices = { "Off","+0.25", "+0.5","+0.75"};
                LoadSelections = function(self, list, pn)
                        if ReadPrefFromFile("UserPrefSpeedMods") == nil then
                                list[1] = true;
                                WritePrefToFile("UserPrefSpeedMods","Off");
                        else
                               
                                if GetUserPref("UserPrefSpeedMods") == "Off" then
                                        list[1] = true;
                                end
                       
                                if GetUserPref("UserPrefSpeedMods") == "+0.25" then
                                        list[2] = true;
                                end
                               
                                if GetUserPref("UserPrefSpeedMods") == "+0.5" then
                                        list[3] = true;
                                end
								
								if GetUserPref("UserPrefSpeedMods") == "+0.75" then
                                        list[4] = true;
                                end
                               
                        end;
                end;
                SaveSelections = function(self, list, pn)
				
                                if list[1] then
                                    WritePrefToFile("UserPrefSpeedMods","Off");
                                    speedsplit = 0;
                                end
 
                                if list[2] then
                                    WritePrefToFile("UserPrefSpeedMods","+0.25");
                                    speedsplit = 0.5;
                                end
                               
                                if list[3] then
                                    WritePrefToFile("UserPrefSpeedMods","+0.5");
                                    speedsplit = 0.75;
                                end
								
								if list[4] then
                                    WritePrefToFile("UserPrefSpeedMods","+0.75");
                                    speedsplit = 0.75;
                                end
								
								GAMESTATE:ApplyGameCommand("mod,"..(GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():XMod()+speedsplit).."x",pn);
                                MESSAGEMAN:Broadcast("SpeedModChange");
                end    
        };
        setmetatable( t, t );
        return t;
end