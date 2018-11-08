return Def.ActorFrame{
	LoadActor("NewProfileBox", PLAYER_1)..{
		InitCommand=cmd(xy,SCREEN_WIDTH*.25,SCREEN_CENTER_Y+20);
	};
	LoadActor("NewProfileBox", PLAYER_2)..{
		InitCommand=cmd(xy,SCREEN_WIDTH*.75,SCREEN_CENTER_Y+20);
	};

};