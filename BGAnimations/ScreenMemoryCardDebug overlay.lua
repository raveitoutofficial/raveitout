local function parseFile2(filename)
  local file = RageFileUtil.CreateRageFile()
  file:Open(filename, 1)
  local xmlP = newParser()
  xmlP:ParseXmlText(file:Read())
  file:Close()
  file:destroy()
  return xmlP;
end


local p = GetMemcardProfileDir(PLAYER_2).."Stats.xml"
assert(FILEMAN:DoesFileExist("/@mc2/dumper.cfg"),p.." does not exist!");
--local xml = parseFile(p);
local xml = parseFile2(p)
SCREENMAN:SystemMessage(xml:children()[1]:name())
--SCREENMAN:SystemMessage(xml.children[1].children);
--[[for k,v in ipairs(xml.children[1].children) do
	Trace(v.name)
end;
lua.Flush()
]]

local Player = PLAYER_2;
local PROFILE_FRAME_WIDTH,PROFILE_FRAME_HEIGHT = 400,490
local t = Def.ActorFrame{
	InitCommand=cmd(Center);
	Def.ActorFrame{
		InitCommand=cmd(y,-PROFILE_FRAME_HEIGHT/2+30);
		Name="NameFrame";
		Def.Quad{
			InitCommand=function(self)
				self:setsize(PROFILE_FRAME_WIDTH+15,70):diffuse(PlayerColor(Player));
				if pn == 1 then
					self:faderight(1);
				else
					self:fadeleft(1);
				end;
			end;
		};
		Def.Quad{
			InitCommand=function(self)
				(cmd(setsize,PROFILE_FRAME_WIDTH/2,1;diffuse,color("#AAAAAAFF");y,8;fadeleft,.3;faderight,.3))(self);
				if pn == 1 then
					self:x(40);
				else
					self:x(-40);
				end;
			end;
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=function(self)
				(cmd(uppercase,true;skewx,-0.255))(self);
				if pn == 1 then
					self:x(-PROFILE_FRAME_WIDTH/2):horizalign(left)
				else
					self:x(PROFILE_FRAME_WIDTH/2):horizalign(right)
				end;
			end;
			Text=pname(Player);
		};
		
		LoadFont("ScreenSelectProfile text")..{
			Name="PlayerName";
			InitCommand=function(self)
				self:y(-5):uppercase(true);
				if pn == 1 then
					self:x(40);
				else
					self:x(-40);
				end;
			end;
			--Text=profile:GetTotalDancePoints();
		};
		LoadFont("ScreenSelectProfile subtext")..{
			Name="PlayerTitle";
			InitCommand=cmd(y,18;vertalign,top);
			OnCommand=function(self)
				if pn == 1 then
					self:x(40);
				else
					self:x(-40);
				end;
			end;
			Text="Insert subtitle here";
		};
		
	};
	
	Def.ActorFrame{
		InitCommand=cmd(y,-120);
		Name="LevelFrame";
	
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,left;x,-PROFILE_FRAME_WIDTH/2;diffusebottomedge,Color("Red"));
			Text="Rave Level";
		};
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,right;x,PROFILE_FRAME_WIDTH/2);
			Name="Level";
			--Text=profile:GetTotalDancePoints();
		};
		Def.Quad{
			InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,13);
		};
		
	};
	Def.ActorFrame{
		InitCommand=cmd(y,-80);
		Name="DPFrame";
		Def.Quad{
			InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,13);
		};
	
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,left;x,-PROFILE_FRAME_WIDTH/2;diffusebottomedge,Color("Red"));
			Text="Dance Points";
		};
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,right;x,PROFILE_FRAME_WIDTH/2);
			Name="DP";
			--Text=profile:GetTotalDancePoints();
		};
		
	};
	
	Def.ActorFrame{
		InitCommand=cmd(y,-20);
	
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,left;x,-PROFILE_FRAME_WIDTH/2;diffusebottomedge,Color("Orange"));
			Text="Single S+ Grades";
		};
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,right;x,PROFILE_FRAME_WIDTH/2);
			--Text=profile:GetTotalStepsWithTopGrade("StepsType_Pump_Single");
		};
		Def.Quad{
			InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,13);
		};
		
	};
	Def.ActorFrame{
		InitCommand=cmd(y,20);
	
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,left;x,-PROFILE_FRAME_WIDTH/2;diffusebottomedge,Color("Green"));
			Text="Double S+ Grades";
		};
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,right;x,PROFILE_FRAME_WIDTH/2);
			--Text=profile:GetTotalStepsWithTopGrade("StepsType_Pump_Single");
		};
		Def.Quad{
			InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,13);
		};
	};
	
	Def.ActorFrame{
		InitCommand=cmd(y,80);
	
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,left;x,-PROFILE_FRAME_WIDTH/2;diffusebottomedge,Color("HoloBlue"));
			Text="Steps Taken";
		};
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,right;x,PROFILE_FRAME_WIDTH/2);
			--Text=profile:GetTotalTapsAndHolds();
		};
		Def.Quad{
			InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,13);
		};
		
	};
	Def.ActorFrame{
		Name="PlayCountFrame";
		InitCommand=cmd(y,120);
	
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,left;x,-PROFILE_FRAME_WIDTH/2;diffusebottomedge,Color("HoloBlue"));
			Text="Play Count";
		};
		LoadFont("ScreenSelectProfile text")..{
			Name="PlayerNumSongs";
			InitCommand=cmd(horizalign,right;x,PROFILE_FRAME_WIDTH/2);
			--Text=profile:GetNumTotalSongsPlayed();
		};
		Def.Quad{
			InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,13);
		};
		
	};
	Def.ActorFrame{
		InitCommand=cmd(y,160);
	
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,left;x,-PROFILE_FRAME_WIDTH/2;diffusebottomedge,Color("HoloBlue"));
			Text="Calories Burned";
		};
		LoadFont("ScreenSelectProfile text")..{
			InitCommand=cmd(horizalign,right;x,PROFILE_FRAME_WIDTH/2;maxwidth,140);
			OnCommand=function(self)
				--self:settextf("%.3f", profile:GetTotalCaloriesBurned());
			end;
		};
		Def.Quad{
			InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,13);
		};
		
	};

};
return t;