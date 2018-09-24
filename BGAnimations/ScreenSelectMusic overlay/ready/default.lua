local t = Def.ActorFrame {};

local shine_index = 1;

t[#t+1] = Def.ActorFrame{
	LoadActor("hexagon")..{
		OnCommand=function(self,param)
			self:sleep(1);
			self:zoom(0.3);
			self:pulse();
			self:effectmagnitude(1,1.05,1);
			self:effectperiod(2);
		end;
	};
		
	LoadActor("polygon_shine/effect (1)")..{
		StepsChosenMessageCommand=cmd(playcommand,"On";);
		OnCommand=function(self,param)
			self:stoptweening();
			self:Load(nil);
			self:zoom(0.55);
			self:diffusealpha(1);
			self:sleep(0.03);
			self:Load(THEME:GetCurrentThemeDirectory().."Bganimations/ScreenSelectMusic overlay/ready/polygon_shine/effect ("..shine_index..").png");
			if shine_index > 6 then
				self:stoptweening();
				shine_index = 1;
				self:diffusealpha(0);
			else
				shine_index = shine_index+1
				self:queuecommand("On");
			end;
		end;
		};
	
	LoadActor("label")..{
		OnCommand=function(self,param)
			self:zoom(0.45);
			self:pulse();
			self:effectmagnitude(1,1.1,1);
			self:effectperiod(2);
		end;
	};
	
	LoadActor("arrow")..{
		OnCommand=function(self,param)
			self:y(30);
			self:zoom(0.15);
			self:bob();
			self:effectmagnitude(0,2.5,0);
			self:effectperiod(1.2);
		end;
	};

};

return t;