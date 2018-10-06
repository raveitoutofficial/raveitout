local t = Def.ActorFrame{};

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = LoadActor("Failed")..{
		InitCommand=function(self)
			local style = ToEnumShortString(GAMESTATE:GetCurrentStyle():GetStyleType())
			if style == "OnePlayerOneSide" and PREFSMAN:GetPreference("Center1Player") == true then
				self:x(SCREEN_CENTER_X);
			else
				self:x(THEME:GetMetric("ScreenGameplay","Player"..pname(pn).."OnePlayerOneSideX"));
			end;
			self:y(SCREEN_CENTER_Y):visible(false);
		end;
		ComboChangedMessageCommand=function(self,params)
			local failed = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetFailed();
			visible(failed);
		end;
	
	};
end;

return t;
