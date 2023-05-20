return Def.ActorFrame{
	OnCommand=function(self)
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			SCREENMAN:GetTopScreen():GetChild('Player'..pname(pn)):visible(false);
		end;
	end;
};
