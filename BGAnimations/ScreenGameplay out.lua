-- NIKK's ratio fade system
-- Ratio values must be set from 0 to 1
local ratio = 0.25		--screen width ratio
local animt = 0.25		--animation time

local curstage = GAMESTATE:GetCurrentStage()
local stages_names = {
	Stage_Extra1 = "bonusstage";
	Stage_Event = "nextstage"..math.random(1,5);
	Stage_1st = "nextstage1";
	Stage_2nd = "nextstage2";
	Stage_3rd = "nextstage3";
	Stage_4th = "nextstage4";
	Stage_5th = "bonusstage";
};

return Def.ActorFrame{

	Def.Quad{
		OnCommand=function(self)
			self:FullScreen();self:zoomx(_screen.w+(_screen.w*ratio));self:diffuse(color("0,0,0,1"));self:fadeleft(ratio);
			self:x(_screen.cx*3+(_screen.w*ratio/2));
			self:sleep(3-animt);
			self:decelerate(animt);
			self:x(_screen.cx-(_screen.w*ratio/2));
			if GAMESTATE:IsEventMode() or DevMode() then ResetLife(); end;
		end;
		
		OffCommand=function(self)
			if GAMESTATE:IsEventMode() or DevMode() then ResetLife(); end;
			setenv("nextstage_name",stages_names[curstage]);
		end;
	};

};