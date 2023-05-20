local t = Def.ActorFrame{};


--[[	--Difficulty List Orbs Shadows
	for i=1,12 do
		t[#t+1] = LoadActor("DifficultyList/background_orb") .. {
			InitCommand=cmd(diffusealpha,0.85;zoom,0.375;x,_screen.cx-245+i*35;y,_screen.cy+107;horizalign,left);
		};
	end;]]
local numOrbs = 12
for i=1,numOrbs,1 do
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(diffusealpha,0.85;zoom,0.375;x,_screen.cx+(i-numOrbs/2-1)*35+35/2;y,_screen.cy+107;horizalign,left);
		
		Def.Sprite{
			Name="CursorP1";
			Condition=GAMESTATE:IsSideJoined(PLAYER_1);
			Texture=THEME:GetPathB("ScreenSelectMusic","overlay/DifficultyList/player1cur.png");
			InitCommand=cmd(y,-10;thump,1;zoom,.85;effectmagnitude,1,1.05,4;effectclock,'beat';visible,false);
			SongChosenMessageCommand=function(self)
				self:visible(self:GetParent():GetChild("Label"):GetVisible())
			end;
			SongUnchosenMessageCommand=cmd(visible,false);
		};
		Def.Sprite{
			Name="CursorP2";
			Condition=GAMESTATE:IsSideJoined(PLAYER_2);
			InitCommand=cmd(y,15;zoom,.85;thump,1;effectmagnitude,1,1.05,4;effectclock,'beat';visible,false;);
			OnCommand=function(self)
				--Some dude out there really used THEME:GetCurrentThemeDirectory()../bganimations huh
				--For anyone else reading this, don't do that, do THEME:GetPathB() instead
				if #GAMESTATE:GetEnabledPlayers() == 2 then
					self:Load(THEME:GetPathB("ScreenSelectMusic","overlay/DifficultyList/2p_bothplayers.png"))
				else
					self:Load(THEME:GetPathB("ScreenSelectMusic","overlay/DifficultyList/player2cur.png"));
				end;
			end;
			SongChosenMessageCommand=function(self)
				self:visible(self:GetParent():GetChild("Label"):GetVisible())
			end;
			SongUnchosenMessageCommand=cmd(visible,false);
		};
		Def.Sprite{
			Texture=THEME:GetPathB("ScreenSelectMusic","overlay/DifficultyList/background_orb");
			--InitCommand=cmd(x,120*(i-numOrbs/2));
		};
		Def.Sprite{
			Name="LabelBG";
			Texture=THEME:GetPathG("StepsDisplayListRow","frame/cdiffcourse.png");
			InitCommand=cmd(zoom,.8);
		};

		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			Name="Label";
			InitCommand=cmd(skewx,-0.15;y,2);
		};
		CurrentCourseChangedMessageCommand=function(self)
			local c = GAMESTATE:GetCurrentCourse();
			if c then
				local trailEntries = getenv("TrailCache"):GetTrailEntries();
				self:GetChild("LabelBG"):visible(i <= #trailEntries)
				self:GetChild("Label"):visible(i <= #trailEntries)
				--self:GetChild("Cursor"):visible(i <= #trailEntries)
				if i <= #trailEntries then
					local steps = trailEntries[i]:GetSteps()
					local meter = steps:GetMeter();
					if meter >= 99 then
						self:GetChild("Label"):settext("??");
					else
						self:GetChild("Label"):settextf("%02d",meter);
					end;
				end;
			else
				self:visible(false);
			end;
		end;
	};
end;

return t;
