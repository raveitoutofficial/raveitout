local t =	Def.ActorFrame {};
local sString;

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
	--InitCommand=cmd(draworder,190);
	OnCommand=function(self)
		if GAMESTATE:IsCourseMode() then
			self:visible(false);
		end
	end;
	CurrentSongChangedMessageCommand=function(self)
		if GAMESTATE:GetCurrentSong() then self:visible(true); else self:visible(false); end;
	end;
	LoadActor("_icon")..{
		InitCommand=cmd(visible,true;zoom,0.7;animate,false);--draworder,140;);
		SetMessageCommand=function(self,param)
			customx = -12
			self:x(customx);
			if isPumpMode then
				if param.StepsType then
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
		InitCommand=cmd(zoom,0.45;skewx,-0.15;x,-9.5;y,0.5);--draworder,150;);
		SetMessageCommand=function(self,param)
			local meter = param.Meter;
			if meter >= 99 then
				--self:settextf("%s","99+");
				self:settext("??");
			else
				self:settextf("%02d",meter);
			end;
		end;
	};

	-- NEW LABEL
	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		Text="";
		InitCommand=cmd(zoom,0.4; maxwidth,120;skewx,-0.05;x,-8;y,-17);--draworder,151;);
		SetMessageCommand=function(self,param)
			profile = PROFILEMAN:GetMachineProfile();
			scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),param.Steps);
			scores = scorelist:GetHighScores();
			topscore = scores[1];
			
			if #scores < 1 then
				self:settext("NEW!");
			else
				self:settext("");
			end;
		
		end;
	};
	
	-- DESC LABEL	
	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		Text="";
		InitCommand=cmd(zoom,0.4; maxwidth,120;skewx,-0.05;x,-8;y,22);--draworder,151;);
		SetMessageCommand=function(self,param)

			local descrp = param.Steps:GetDescription();
			-- always check if for nil
			local steps = GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber());
			if not steps then return end;
			local label = ""
			
			--Check for "DANGER!" before checking blacklist
			if descrp == "DANGER!" then
				label = descrp
			--If string in description is in the STEPMAKER_NAMES_BLACKLIST table
			elseif has_value(STEPMAKER_NAMES_BLACKLIST, descrp) then
				--Do nothing, string is already empty.
				--label = ""
			else
				label = descrp;
			end
			
			self:settext(label);
			
		end;
	};

};



return t
