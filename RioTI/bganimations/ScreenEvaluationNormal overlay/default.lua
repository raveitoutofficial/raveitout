local t = Def.ActorFrame {
	OffCommand=function()
		setenv("StageFailed",false);
	end;
};

t[#t+1] = LoadActor("DanceGrade.lua");

return t;