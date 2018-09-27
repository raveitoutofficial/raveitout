return Def.CourseContentsList {
	--MaxSongs = 8;
	--NumItemsToDraw = 8; 
	ShowCommand=cmd(bouncebegin,0.3;zoomy,1);
	HideCommand=cmd(linear,0.3;zoomy,0);
	SetCommand=function(self)
		self:SetFromGameState();
		self:PositionItems();
		self:SetTransformFromHeight(16);
		self:SetCurrentAndDestinationItem(0);
		self:SetLoop(false);
		self:SetMask(270,0);
	end;
	CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");

	Display = Def.ActorFrame { 
		InitCommand=cmd(setsize,164,18);

		LoadActor(THEME:GetPathG("OptionRowExit","frame")) .. {
 			InitCommand=cmd(zoomx,1.1;zoomy,0.56);
		};

		Def.TextBanner {
			InitCommand=cmd(diffusetopedge,0.65,0.65,0.65,1;diffusebottomedge,1,1,1,0.5;Load,"TextBanner";SetFromString,"", "", "", "", "", "");
			SetSongCommand=function(self, params)
				if params.Song then
					self:SetFromSong( params.Song );
					self:maxwidth(164);

				end
				
				(cmd(zoom,1))(self);
			end;
		};



	};
};