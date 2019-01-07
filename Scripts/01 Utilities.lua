--[[
For title screen. Will show InternalName:Version
Ex:
RIO:2018-10-04
DISPLAY TYPE: HD
]]
SysInfo = {
	InternalName = "RIOS2",
	Version = "Internal Alpha",
}

RIO_FOLDER_NAMES = {
	EasyFolder = "99-Easy",
	SpecialFolder = "99-Special",
	--[[
	If this is set the game will use it for arcade mode. If not, it will pick a random folder,
	but ONLY if you aren't playing with a profile. Profiles will resume from their last played song
	as StepMania intended.
	Also the code for picking a random song is somewhere in ScreenSelectPlayMode.
	]]
	DefaultArcadeFolder,
	--The groups that are shown in the group select in the order you want them displayed.
	--If this is empty all groups will be shown.
	PREDEFINED_GROUP_LIST = {
	
	
	}
}

-- These names will not show up over the difficulty icons.
STEPMAKER_NAMES_BLACKLIST = {
	"C.Cortes",
	"A.Vitug",
	"C.Rivera",
	"J.España",
	"Anbia",
	"C.Guzman",
	"C.Sacco",
	"A.DiPasqua",
	"A.Bruno",
	"P.Silva",
	"P. Silva",
	"M.Oliveira",
	"M.Oliveria",
	"W.Fitts",
	"Z.Elyuk",
	"P.Cardoso",
	"A.Perfetti",
	"S.Hanson",
	"D.Juarez",
	"P.Shanklin",
	"P. Shanklin",
	"S.Cruz",
	"C.Valdez",
	"E.Muciño",
	"V.Kim",
	"V. Kim",
	"V.Rusfandy",
	"T.Lee",
	"M.Badilla",
	"P.Agam",
	"P. Agam",
	"B.Speirs",
	"N.Codesal",
	"F.Keint",
	"F.Rodriguez",
	"T.Rodriguez",
	"B.Mahardika",
	"A.Sofikitis",
	"Furqon",
	"Blank",
};

--Called from ScreenSelectPlayMode to pick a random group and the GroupWheel to show available groups
function getAvailableGroups()
	local groups = SONGMAN:GetSongGroupNames();

	if not DevMode() then
		--Remove easy and special folder from the group select
		for k,v in pairs(groups) do
			if v == RIO_FOLDER_NAMES["EasyFolder"] then
				table.remove(groups, k)
			elseif v == RIO_FOLDER_NAMES["SpecialFolder"] then
				table.remove(groups, k)
			end;
		end
	end;
	return groups;
end;

--Because it's useful
function Actor:Cover()
	self:scaletocover(0,0,SCREEN_RIGHT,SCREEN_BOTTOM);
end;

function returnLastElement(arr)
	return arr[#arr]
end