local t = Def.ActorFrame {
};

t[#t+1] = LoadActor("top") .. {
	InitCommand = cmd(valign,0;x,SCREEN_CENTER_X;y,SCREEN_TOP);
};

t[#t+1] = LoadActor("bottom") .. {
	InitCommand = cmd(valign,1;x,SCREEN_CENTER_X;y,SCREEN_BOTTOM+8);
};

local DifficultyText = LoadFont("_venacti 26px bold diffuse");
if Var "LoadingScreen" == "ScreenRanking" then
	t[#t+1] = LoadActor("difficulty frame normal") .. {
		InitCommand = cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+56);
	};
--[[
	local Difficulties = {
		{ "Difficulty_Medium",	"StepsType_Pump_Single" },
		{ "Difficulty_Hard",	"StepsType_Pump_Single" },
		{ "Difficulty_Medium",	"StepsType_Pump_Halfdouble" },
		{ "Difficulty_Medium",	"StepsType_Pump_Double" },
		{ "Difficulty_Hard",	"StepsType_Pump_Double" },
	};
	
	for idx, dc in ipairs(Difficulties) do
		t[#t+1] = DifficultyText .. {
			-- TODO: string.upper doesn't work correctly for French
			Text = string.upper( DifficultyAndStepsTypeToLocalizedString( dc[1], dc[2] ) );
			InitCommand=cmd(x,SCREEN_CENTER_X+scale(idx,1,4,120*-2,120*1);y,56;
				diffuse,color("#000000");shadowlength,0;zoom,0.55);
		};
	end
	--]]
else
	t[#t+1] = LoadActor("difficulty frame course") .. {
		InitCommand = cmd(x,SCREEN_CENTER_X;y,SCREEN_TOP+56);
	};

	t[#t+1] = DifficultyText .. {
		-- TODO: string.upper doesn't work correctly for French
		Text = string.upper( "PROGRESSIVE" );
		InitCommand=cmd(x,SCREEN_CENTER_X+scale(3,1,4,120*-2,120*1);y,56;
			diffuse,color("#000000");shadowlength,0;zoom,0.55);
	};
end

t[#t+1] = LoadFont("_regra 30px") .. {
	InitCommand=cmd(shadowlength,0;x,SCREEN_CENTER_X;y,SCREEN_TOP+22;settext,ScreenString("HeaderText"));
};

return t;
