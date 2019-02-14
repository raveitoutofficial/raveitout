local t = Def.ActorFrame{

	LoadFont("Common Normal")..{
		InitCommand=cmd(Center);
		Text="Is locked? "..UNLOCKMAN:IsSongLocked(SONGMAN:FindSong("Test Song"));
	};
}

return t;