local t = Def.ActorFrame {};
local sepx = 20

t[#t+1] = Def.ActorFrame{
	Def.Actor{		--reset Limit Break / "BreakCombo" env value	--temporary workaround
		OnCommand=function(self)
			Combo = THEME:GetMetric("CustomRIO","MissToBreak");
			PrevCombo = getenv("BreakCombo");
			setenv("BreakCombo",Combo);
		end;
	};
	
};
return t