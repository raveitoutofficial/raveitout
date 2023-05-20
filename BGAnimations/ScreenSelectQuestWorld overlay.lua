local names = {};
for crsWorldName,crsWorld in pairs(RIO_COURSE_GROUPS) do
	names[#names+1] = crsWorldName;
end;
assert(#names > 0);
local selection = 1;

local t = Def.ActorFrame{

	CodeMessageCommand=function(self,params)
		if params.Name == "DownLeft" or params.Name == "Left" then
			if selection > 1 then
				selection = selection-1;
			end;
		elseif params.Name == "DownRight" or params.Name == "Right" then
			if selection < #names then
				selection = selection + 1;
			end;
		elseif params.Name == "Center" or params.Name == "Start" then
			for i=1,#names do
				self:GetChild(i):stoptweening():decelerate(.4):x(SCREEN_CENTER_X)
			end;
			--self:sleep(.4);
			QUESTMODE.currentWorld = names[selection];
			--SCREENMAN:SystemMessage(QUESTMODE.currentWorld);
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
			return;
		elseif params.Name == "Back" then
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen")
		end;
		for i=1,#names do
			local a = self:GetChild(i)
			--assert(a,i.." is missing!");
			a:stoptweening():decelerate(.4):x(SCREEN_CENTER_X+210*(i-selection))
		end;
	end;
};

for i,v in ipairs(names) do
	t[#t+1] = Def.ActorFrame{
		Name=i;
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_CENTER_Y;zoom,.6);
		OnCommand=cmd(decelerate,.4;x,SCREEN_CENTER_X+210*(i-1));
		Def.Quad{
			InitCommand=cmd(setsize,312,720;diffuse,color("0,0,0,.8"););
		};
		LoadFont("bebas/_bebas neue bold 90px")..{	
			InitCommand=cmd(uppercase,true;wrapwidthpixels,200;maxwidth,(_screen.w/0.9);skewx,-0.1);
			Text=v;
		};
	}
end;

t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(xy,SCREEN_CENTER_X,0);
		LoadActor(THEME:GetPathB("ScreenSelectPlayMode","overlay/top"))..{ InitCommand=function(self) self:valign(0):zoom(0.6) end; };
		LoadActor(THEME:GetPathB("ScreenSelectPlayMode","overlay/layer"))..{ InitCommand=function(self) self:y(2):valign(0):zoom(0.66); end; };	
		LoadFont("monsterrat/_montserrat light 60px")..{	
			Text=THEME:GetString("ScreenSelectQuestWorld","SELECT A DIFFICULTY"),
			InitCommand=function(self) self:y(11):zoom(0.35):skewx(-.15) end;  };
}

return t;
