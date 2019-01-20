local t = Def.ActorFrame {};
local sepx = 20

t[#t+1] = Def.ActorFrame{
	Def.Actor{		--reset Limit Break / "BreakCombo" env value	--temporary workaround
		OnCommand=function(self)
			Combo = THEME:GetMetric("CustomRIO","MissToBreak");
			PrevCombo = getenv("BreakCombo");
			setenv("BreakCombo",Combo);
			
			--Fix for people stuck in the group select since set_input_redirected doesn't turn off
			SCREENMAN:set_input_redirected(PLAYER_1, false)
			SCREENMAN:set_input_redirected(PLAYER_2, false)
		end;
	};
	
};
return t