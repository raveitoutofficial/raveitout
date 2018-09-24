local t =	Def.ActorFrame {};
local sString;

t[#t+1] = Def.ActorFrame{
--	InitCommand=cmd(draworder,190);
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
			if param.StepsType then
				sString = THEME:GetString("StepsDisplay StepsType",ToEnumShortString(param.StepsType));
				if sString == "Single" then
					if param.Steps:IsAnEdit() then
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
		end;
	};
	LoadFont("monsterrat/_montserrat semi bold 60px")..{
		InitCommand=cmd(zoom,0.45;skewx,-0.15;x,-9.5;y,0.5);--draworder,150;);
		SetMessageCommand=function(self,param)
			local meter = param.Meter;
			if meter > 99 then
				self:settextf("%s","99+");
			elseif meter >= 10 then
				self:settextf("%d",meter);
			else
				self:settextf("0%d",meter);
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
			if steps then
				local stepdiff = steps:GetDifficulty();
			end;
			local label = ""
			local blacklist = {
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

			local IsStepMakerName = false;

			for i=1,#blacklist do
 				if string.find(descrp, blacklist[i]) ~= nil then
  					IsStepMakerName = true;
        			break;
				end;
			end;

			if IsStepMakerName then
  				label = ""
			else
  				label = descrp;
			end
			
			if param.Steps:IsAnEdit() then label = "DANGER!"; end;
			
			self:settext(label);
			
		end;
	};

};



return t
