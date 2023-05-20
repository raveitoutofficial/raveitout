local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame{
	LoadActor("hexagon")..{
		OnCommand=function(self,param)
			self:sleep(1);
			self:zoom(0.45);
			self:pulse();
			self:effectmagnitude(1,1.05,1);
			self:effectperiod(2);
		end;
	};
		
	Def.Sprite{
		Texture="polygon_shine 3x2";
		InitCommand=cmd(zoom,0.54;animate,false);
		StepsChosenMessageCommand=function(self)
			self:stoptweening();
			self:animate(true);
			self:sleep(0.2);
			self:diffusealpha(1);
			self:setstate(4);
			self:sleep(0.05);
			self:setstate(3);
			self:sleep(0.05);
			self:setstate(2);
			self:sleep(0.05);
			self:setstate(1);
			self:sleep(0.05);
			self:setstate(0);
			self:sleep(0.05);
			self:linear(0.5);
			self:diffusealpha(0);
		end
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
