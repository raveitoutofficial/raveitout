--[[
For title screen. Will show InternalName:Version
Ex:
RIO:2018-10-04
DISPLAY TYPE: HD
]]
SysInfo = {
	InternalName = "RIOS2",
	Version = "Alpha",
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
	--S2 names
	"A.Sora",
	"Accelerator",
	"G.Shawn"
};


--List of songs that will get your recording blocked worldwide
STREAM_UNSAFE_AUDIO = {
	"Breaking The Habit",
	"She Wolf (Falling to Pieces)",
	"Face My Fears" --Test song
};

--List of BGAs that will get your recording blocked worldwide
STREAM_UNSAFE_VIDEO = {
	"Good Feeling",
	"I Wanna Go",
	"Jaleo",
	"Breakin' A Sweat"
};

--Tentative, implementation is not finished.
--[[UNLOCKABLE_TITLES = {
	--Name, unlock type, requirement, parameters
	["SANGVIS FERRI","ChartAuthor", 10, "Accelerator"],
	["Team 404", "ChartAuthor", 20, "Accelerator"],
	["Dance Beginner", "Level", 5],
	["Dance Trainee", "Level", 10],
	["Dance Pro", "Level", 20],
	["Dance Master","Level",50],
	["Dance Legend", "Level", 75],
	["Ultimate Rave Legend", "Level", 100],
	--["Snap Crackle Rave", "Artist", 7, "District 78"], --This is too complicated just forget it
	["Nice", "SongsPlayed", 69],
	["Song name?", "SongRank", 1, "Sandstorm"], --This is tentative but I think 1 = W1 or something
	["RadiOut", "SongsPlayedInGroup", 10, "Pop"],
	["Straight Gangsta", "RanksInGroup", 5, "Hip-Hop"],
	["Dale!", "Artist", 3, "Pitbull"],
	["Smooth Criminal", "Artist", 999, "Michael Jackson"], --Replace with however many Michael Jackson songs we have I guess
	["RIO Needs More K-Pop", "SongsPlayedInGroup", 3, "K-Pop"],
	["Thank You For Playing!", "SongRank", 1, "World Go Boom (USoP 2011)"],
	["It's the MF'n D.O.Double-G", "SongsPlayed", 420],
	["What the fuck?", "SongRank", 2, "Loca People"],
	["AAAAYYYY SEXY LADY", "SongRank", 2, "Gangnam Style"]
}]]
--[[
SANGVIS FERRI - Play 10 charts by Accelerator
Team 404 - Play 20 charts by Accelerator
Dance Beginner - Become lv5
Dance Trainee - Become lv10
Dance Pro - Become lv20
Dance Master - Become lv50
Dance Legend - Become lv75
Ultimate Rave Legend - Become lv100
Snap Crackle Rave - Play 7 Snap Tracks by District 78
Nice - Play 69 songs
Song name? - Get an S on Sandstorm.
RadiOut - Play 10 songs in the Pop setlist
Straight Gangsta - Earn 5 S ranks in the hip-hop setlist
Dale! - Play 3 songs by Pitbull.
Smooth Criminal - Play all Michael Jackson songs.
RIO Needs More K-Pop - Play all songs in the K-Pop setlist. All 3 of them.
Thank you for playing! - Earn an S on the Encore Extra Stage "World Go Boom" (USoP 2011).
Big Fat Ass Bitch - Earn an S on Anaconda
It's the MF'n D.O.Double-G - Play 420 charts.
What the fuck? - Earn an A on Loca People
AAAAYYYY SEXY LADY - Earn an A on Gangnam Style
]]