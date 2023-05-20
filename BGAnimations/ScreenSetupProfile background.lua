return Def.ActorFrame{
	OnCommand=function(self)
		--SCREENMAN:SystemMessage("hello world!");
		GAMESTATE:Reset();
		GAMESTATE:JoinPlayer(LAST_SCANNED_CARD.Player);
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
	end;
};
