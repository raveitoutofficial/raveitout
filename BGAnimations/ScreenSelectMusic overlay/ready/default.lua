local t = Def.ActorFrame {};

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
		
	Def.Sprite{
		Texture="polygon_shine 3x2";
		InitCommand=cmd(animate,false;SetAllStateDelays,0.05);
		StepsChosenMessageCommand=cmd(animate,true);
		AnimationFinishedCommand=cmd(animate,false);
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
