local c;
local cf;
local ShowComboAt = 2;

local Pulse = Comboanicombo;	--\Scripts\Themefunctions.lua

--local PulseLabel = Pulse;

local t = Def.ActorFrame {
	InitCommand=cmd();
	-- normal combo elements:
	Def.ActorFrame {
		Name="ComboFrame";
		LoadFont( "Combo", "numbers" ) .. {
			Name="Number";
			OnCommand = cmd(vertalign,bottom);
		};
		LoadActor("_combo")..{
			Name="ComboLabel";
			OnCommand = cmd(vertalign,top);
		};
		LoadActor("_misses")..{
			Name="MissLabel";
			OnCommand = cmd(vertalign,top);
		};
	};
	InitCommand = function(self)
		c = self:GetChildren();
		cf = c.ComboFrame:GetChildren();
		cf.Number:visible(false);
		cf.ComboLabel:visible(false)
		cf.MissLabel:visible(false)
	end;
	ComboCommand=function(self, param)
		local iCombo = param.Misses or param.Combo;
		if not iCombo or iCombo < ShowComboAt then
			cf.Number:visible(false);
			cf.ComboLabel:visible(false)
			cf.MissLabel:visible(false)
			return;
		end

		cf.ComboLabel:visible(false)
		cf.MissLabel:visible(false)

		if param.Combo then
			cf.ComboLabel:visible(true)
			cf.MissLabel:visible(false)
		else
			cf.ComboLabel:visible(false)
			cf.MissLabel:visible(true)
		end

		cf.Number:visible(true);
		cf.Number:settext( string.format("%i", iCombo) );
		if param.Combo then
			--back to white if combo
			cf.Number:diffuse(Color("White"));
			cf.Number:stopeffect();
		else
			--turn red if missing
			cf.Number:diffuse(color("#ff0000"));
			cf.Number:stopeffect();
		end
		-- Pulse
		Pulse( cf.Number, param );
		if param.Combo then
			Pulse( cf.ComboLabel, param );
		else
			Pulse( cf.MissLabel, param );
		end
	end;
};

return t;
