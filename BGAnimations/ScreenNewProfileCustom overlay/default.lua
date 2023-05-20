local function isPlayerDone(pn)
	if GAMESTATE:IsSideJoined(pn) then
		--If using a profile and they've played more than one song OR they're not using a profile
		return (PROFILEMAN:IsPersistentProfile(pn) and PROFILEMAN:GetProfile(pn):GetTotalNumSongsPlayed() ~= 0) or not PROFILEMAN:IsPersistentProfile(pn)
	else
		return true;
	end;
end;

local isDone = {
	["PlayerNumber_P1"] = isPlayerDone("PlayerNumber_P1"),
	["PlayerNumber_P2"] = isPlayerDone("PlayerNumber_P2")
}

return Def.ActorFrame{
	LoadActor("EnterNameBox", PLAYER_1)..{
		Condition=(GAMESTATE:IsSideJoined(PLAYER_1) and PROFILEMAN:IsPersistentProfile(PLAYER_1) and PROFILEMAN:GetProfile(PLAYER_1):GetTotalNumSongsPlayed() == 0);
		InitCommand=cmd(xy,SCREEN_WIDTH*.25,SCREEN_CENTER_Y+20);
	};
	LoadActor("EnterNameBox", PLAYER_2)..{
		Condition=(GAMESTATE:IsSideJoined(PLAYER_2) and PROFILEMAN:IsPersistentProfile(PLAYER_2) and PROFILEMAN:GetProfile(PLAYER_2):GetTotalNumSongsPlayed() == 0);
		InitCommand=cmd(xy,SCREEN_WIDTH*.75,SCREEN_CENTER_Y+20);
	};
	
	DoneSelectingMessageCommand=function(self,params)
		isDone[params.Player] = true;
		PROFILEMAN:GetProfile(params.Player):SetDisplayName(params.Name);
		if GAMESTATE:IsSideJoined(PLAYER_1) and GAMESTATE:IsSideJoined(PLAYER_2) then
			if isDone[PLAYER_1] and isDone[PLAYER_2] then
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
			end;
		else
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
		end
	end;
	--[[LoadActor("circle")..{
		OnCommand=function(self)
			--local z = Resize(self:GetWidth(), self:GetHeight(), SCREEN_WIDTH, SCREEN_HEIGHT);
			--self:zoom(z):Center();
			self:ScaleToHeight(SCREEN_HEIGHT);
			self:Center();
		end;
	};]]
};
