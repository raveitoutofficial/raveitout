--[[
For title screen. Will show InternalName:Version
Ex:
RIO:2018-10-04
DISPLAY TYPE: HD
]]
SysInfo = {
	InternalName = "RIOS2",
	Version = "2023-01-20",
}

RIO_FOLDER_NAMES = {
	EasyFolder = "99-Easy",
	--SpecialFolder = "99-Special",
	SnapTracksFolder = "00-Snap Tracks",
	FullTracksFolder = "80-Full Tracks",
	--[[
	If this is set the game will use it for arcade mode. If not, it will pick a random folder,
	but ONLY if you aren't playing with a profile. Profiles will resume from their last played song
	as StepMania intended.
	Also the code for picking a random song is somewhere in ScreenSelectPlayMode.
	]]
	DefaultArcadeFolder,
	--The groups that are shown in the group select in the order you want them displayed.
	--If this is empty all groups will be shown.
	PREDEFINED_GROUP_LIST = false;
	--[[PREDEFINED_GROUP_LIST = {
		"00-Snap Tracks",
		"01-Country",
		"02-EDM",
		"03-Hip Hop",
		"04-Latin",
		"05-K-Pop",
		"06-Pop",
		"07-Rock",
		"09-Season 2 FINAL",
		"80-Full Tracks",
		"81-Rave"
	}]]
}

--[[
What course folders will show in mixtapes mode.
It's necessary because we have mission mode folders
and we don't want them to pollute the mixtapes folders...

Style is not needed unless you specifically want to pull the trails of that stepstype. If it isn't specified
it will default to whatever StepMania generates first, which can be good or bad depending on how you look at it.

SM generates trails for every stepstype regardless of what you put in the course (#STYLE:DOUBLE does not affect trail generation).
In fact, the only thing #STYLE does is determine what style to set when you select that course...

Class types: Normal, Pro, Gauntlet
]]
RIO_COURSE_FOLDERS = {
	["Class (Singles)"] = {
		Lifebar="Pro",
		Style='StepsType_Pump_Single'
	},
	["Class (Doubles)"] = {
		Lifebar="Pro",
		Style='StepsType_Pump_Double'
	},
	["Nonstop"] = {
	}
	--[["PIU Class (Singles)",
	"PIU Class (Doubles)",
	["Leggendaria"] = {
	},
	["Default"] = {
	}]]
}

--Take a wild guess. #SONGTYPE:shortcut will override this.
MAX_SECONDS_FOR_SHORTCUT = 95

--Number of hearts a mission will take in quest mode.
HEARTS_PER_MISSION = 3

--Extra stage song.
--If true, uses the song below, if false, uses extra1.crs.
--TODO: Remove this since lua is truthy
USE_ES_SONG = true
ES_SONG = "08-Season 2/Faded"
--The song that gets picked for the One More Extra Stage.
OMES_SONG = "08-Season 2/Stay Awake (OVERTIME STAGE)"

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
	--S2 names
	"A.Sora",
	"Accelerator",
	"S. Ferri",
	"G.Shawn"
}
