local crs = SONGMAN:FindCourse("Spaaaaaaaaaaace!");



local t = Def.ActorFrame{
	LoadFont("Common Normal")..{
		Text="P1 Card: None";
		InitCommand=cmd(Center);
		CardScannedMessageCommand=function(self,param)
			SCREENMAN:SystemMessage("aaaa");
			self:settext("P1 Card: "..param.card);
		end;
		CardScanned2MessageCommand=function(self)
			--SCREENMAN:SystemMessage("fuck u");
		end;
	};
	
	LoadFont("Common Normal")..{
		Text=crs:GetAllTrails()[1]:GetTrailEntry(2):GetSong():GetDisplayFullTitle();
		InitCommand=cmd(Center;addy,50);
	}
	

};

return t;
