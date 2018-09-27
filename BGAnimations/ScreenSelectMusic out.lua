--3 seconds
return Def.Quad{
	OnCommand=cmd(FullScreen;diffuse,color("0,0,0,0");linear,1.5;diffuse,color("0,0,0,1");sleep,0.75;);
	OffCommand=function(self)
		if GAMESTATE:IsCourseMode() then
			setenv("BreakCombo",GetCourseDescription(GAMESTATE:GetCurrentCourse():GetCourseDir(),"LIMITBREAK"));
		end;
		
		if GAMESTATE:GetNumSidesJoined() == 2 and (GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType() == "StepsType_Pump_Routine" or GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType() == "StepsType_Pump_Routine") then
			GAMESTATE:SetCurrentStyle("routine");
			setenv("routine_switch","off");
		elseif GAMESTATE:GetNumSidesJoined() == 2 then
			GAMESTATE:SetCurrentStyle("versus");
		end;
	end;
};