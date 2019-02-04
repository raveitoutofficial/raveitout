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


--List of songs that will get your recording blocked worldwide
STREAM_UNSAFE_AUDIO = {
	"Breaking The Habit",
	"She Wolf (Falling to Pieces)",
	"Face My Fears"
};

--List of BGAs that will get your recording blocked worldwide
STREAM_UNSAFE_VIDEO = {
	"Good Feeling",
	"I Wanna Go"
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
			--Never display the internal group folder
			elseif v == "00-Internal" then
				table.remove(groups, k)
			--TODO: This should be done on startup.
			elseif (#SONGMAN:GetSongsInGroup(v))-1 < 1 then
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

function Resize(width,height,setwidth,sethight)
    if height >= sethight and width >= setwidth then
        if height*(setwidth/sethight) >= width then
            return sethight/height
        else
            return setwidth/width
        end
    elseif height >= sethight then
        return sethight/height
    elseif width >= setwidth then
        return setwidth/width
    else 
        return 1
    end
end

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

--NO IT DOESN'T FUCKING WORK GO FUCK YOURSELF
--[[function Actor:ScaleToHeight(height)
	if height >= self:GetHeight() then
		self:SetWidth(self:GetWidth()*(height/self:GetHeight()))
	else
		self:SetWidth(self:GetWidth()*(self:GetHeight()/height))
	end;
	self:SetHeight(height)
end;

function Actor:ScaleToWidth(width)
	if width/self:GetWidth() > 1 then
		self:SetHeight(self:GetHeight()*(width/self:GetWidth()))
	else
		self:SetHeight(self:GetHeight()*(self:GetWidth()/width))
	end;
	self:SetWidth(width)
end;

function testScaleToHeight(origWidth, origHeight, height)
	if height/origHeight > origHeight/height then
		return origWidth*(height/origHeight)
	else
		return origWidth*(origHeight/height)
	end;

end;

function testScaleToWidth(origWidth, origHeight, width)
	if width > origWidth then
		return origHeight*(width/origWidth)
	else
		return origHeight*(origWidth/width)
	end;

end;]]

function returnLastElement(arr)
	return arr[#arr]
end

function ListActorChildren(frame)
	if frame:GetNumChildren() == 0 then
		return "No children in frame.";
	end
	local list = frame:GetNumChildren().." children: ";
	local children = frame:GetChildren()
	for key,value in pairs(children) do
		list = list..key..", ";
	end
	return list;
end