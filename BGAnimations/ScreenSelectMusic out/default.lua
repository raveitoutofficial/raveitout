--3 seconds
return Def.ActorFrame{
	Def.Sprite{
		Texture="ready_shine 7x5";
		InitCommand=cmd(diffusealpha,0;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;SetAllStateDelays,0.03;animate,false;);
		OnCommand=function(self,param)
			self:animate(true);
			self:diffusealpha(1);
			self:sleep(self:GetNumStates()*0.03);
		end;
		AnimationFinishedCommand=function(self)
			self:setstate(self:GetNumStates()-1);
			self:animate(false);
			self:GetParent():GetChild("Quad"):linear(1):diffusealpha(1):queuecommand("Play");
		end;
	};


	Def.Quad{
		OnCommand=cmd(FullScreen;diffuse,Color("Black");diffusealpha,0);
		Name="Quad";
		PlayCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				setenv("BreakCombo",GetCourseDescription(GAMESTATE:GetCurrentCourse():GetCourseDir(),"LIMITBREAK"));
			end;
			
			--AutoSetStyle is already a thing, WTF is this even doing?
			if GAMESTATE:GetNumSidesJoined() == 2 and (GAMESTATE:GetCurrentSteps(PLAYER_1):GetStepsType() == "StepsType_Pump_Routine" or GAMESTATE:GetCurrentSteps(PLAYER_2):GetStepsType() == "StepsType_Pump_Routine") then
				GAMESTATE:SetCurrentStyle("routine");
				setenv("routine_switch","off");
			elseif GAMESTATE:GetNumSidesJoined() == 2 then
				GAMESTATE:SetCurrentStyle("versus");
			end;
		end;
	};

}
