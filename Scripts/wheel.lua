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
