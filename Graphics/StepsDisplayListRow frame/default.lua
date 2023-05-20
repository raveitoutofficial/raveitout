local t =	Def.ActorFrame {};
local sString;
local customx = -12 --The x offset of the orbs.

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local isPumpMode = (GAMESTATE:GetCurrentGame():GetName() == "pump")

--Lame hack because the difficulty graphic doesn't match dance colors
local danceToRIOColors = {
	["Beginner"] = 0,
	["Easy"] = 3,
	["Medium"] = 4,
	["Hard"] = 1,
	["Challenge"] = 2,
	["Edit"] = 5
}

t[#t+1] = Def.ActorFrame{
	CurrentSongChangedMessageCommand=function(self)
		if GAMESTATE:GetCurrentSong() then self:visible(true); else self:visible(false); end;
	end;
	LoadActor("_icon")..{
		InitCommand=cmd(zoom,0.55;addy,2;animate,false);
		SetMessageCommand=function(self,param)
			--self:x(customx);
			if isPumpMode then
				if param.StepsType then
					--short for "short string".
					--TODO: Using localization values for this is absurd, remove it
					sString = THEME:GetString("StepsDisplay StepsType",ToEnumShortString(param.StepsType));
					if sString == "Single" then
						if param.Steps:GetDescription() == "DANGER!" then
							self:setstate(4);
						else
							self:setstate(0);
						end
						self:x(customx+3.2);
					elseif sString == "Double" then
						self:setstate(1);
						self:x(customx+2.2);
					elseif sString == "SinglePerformance" or sString == "Half-Double" then
						self:setstate(2);
						self:x(customx+3.2);
					elseif sString == "DoublePerformance" or sString == "Routine" then
						self:setstate(3);
						self:x(customx+2.2);	
					else
						self:setstate(5);
						self:x(customx+3.2);
					end;
				end;
			else
				if param.Steps then
					local diff = ToEnumShortString(param.Steps:GetDifficulty())
					self:x(customx+3.2);
					self:setstate(danceToRIOColors[diff])
				end;
			end;
		end;
	};
	LoadFont("monsterrat/_montserrat semi bold 60px")..{
		InitCommand=cmd(zoom,0.45;skewx,-0.15;x,-9.5;y,0.5);
		SetMessageCommand=function(self,param)
			local meter = param.Meter;
			if meter >= 99 then
				self:settext("??");
			else
				--Format with 2 integers, so 6 -> 06
				self:settextf("%02d",meter);
			end;
		end;
	};

	-- NEW LABEL
	LoadActor("new")..{
		InitCommand=cmd(zoom,0.4;x,-8;y,-17);
		SetMessageCommand=function(self,param)
			local scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreList(GAMESTATE:GetCurrentSong(),param.Steps);
			--If the number of high scores is less than one, this chart is new.
			if #scorelist:GetHighScores() < 1 then
				self:visible(true);
			else
				self:visible(false);
			end;
		
		end;
	};

	-- DANGER LABEL
	LoadActor("danger")..{
		InitCommand=cmd(zoom,0.5;x,-8;y,22);
		OnCommand=cmd(diffuseshift; effectoffset,1; effectperiod, 0.5; effectcolor1, 1,1,0,1; effectcolor2, 1,1,1,1;);
		SetMessageCommand=function(self,param)
			if param.Steps:GetDescription() == "DANGER!" then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
	
	-- DESC LABEL	
	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		Text="";
		InitCommand=cmd(zoom,0.4; maxwidth,120;skewx,-0.05;x,-8;y,22);
		SetMessageCommand=function(self,param)

			local descrp = param.Steps:GetDescription();
			--Check for "DANGER!" before checking blacklist
			if descrp == "DANGER!" or has_value(STEPMAKER_NAMES_BLACKLIST, descrp) then
				self:settext("");
			else
				self:settext(descrp);
			end
			
		end;
	};

};



return t
