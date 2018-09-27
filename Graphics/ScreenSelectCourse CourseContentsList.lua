return Def.CourseContentsList {
	--MaxSongs = 8;
	--NumItemsToDraw = 8; 
	SetCommand=function(self)
		self:SetFromGameState();
		self:PositionItems();
		self:SetTransformFromHeight(48);
		self:SetCurrentAndDestinationItem(0);
		self:SetLoop(false);
		self:SetMask(270,0);
	end;
	CurrentTrailP1ChangedMessageCommand=cmd(playcommand,"Set");
	CurrentTrailP2ChangedMessageCommand=cmd(playcommand,"Set");

	Display = Def.ActorFrame { 
		InitCommand=cmd(setsize,50,50);

		LoadActor(THEME:GetPathG("","StepsDisplayListRow frame/cdiffcourse")) .. {
 			InitCommand=cmd(rotationz,90;zoom,0.385;);
		};
--[[
		LoadActor(THEME:GetPathG("","StepsDisplayListRow frame/cursorhalf"))..{
			InitCommand=cmd(zoom,0.41;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);diffuse,0.3,0.5,0.85,0.8;blend,Blend.Add;rotationz,90;);
			PlayerJoinedMessageCommand=cmd(playcommand,"Init");
		};
		LoadActor(THEME:GetPathG("","StepsDisplayListRow frame/cursorhalf"))..{
			InitCommand=cmd(zoom,0.41;visible,GAMESTATE:IsHumanPlayer(PLAYER_1);diffuse,0.3,0.5,0.85,0.8;blend,Blend.Add;rotationz,90;);
			PlayerJoinedMessageCommand=cmd(playcommand,"Init");
		};
		LoadActor(THEME:GetPathG("","StepsDisplayListRow frame/cursorhalf"))..{
			InitCommand=cmd(zoom,0.41;visible,GAMESTATE:IsHumanPlayer(PLAYER_2);diffuse,0.85,0.5,0.3,0.8;blend,Blend.Add;rotationz,-90;);
			PlayerJoinedMessageCommand=cmd(playcommand,"Init");
		};
		LoadActor(THEME:GetPathG("","StepsDisplayListRow frame/cursorhalf"))..{
			InitCommand=cmd(zoom,0.41;visible,GAMESTATE:IsHumanPlayer(PLAYER_2);diffuse,0.85,0.5,0.3,0.8;blend,Blend.Add;rotationz,-90;);
			PlayerJoinedMessageCommand=cmd(playcommand,"Init");
		};
--]]
 		LoadFont("CourseEntryDisplay","difficulty") .. {
			Text="?";
			InitCommand=cmd(zoom,0.45;shadowlength,1;rotationz,90;);
			SetSongCommand=function(self, params)
				if params.PlayerNumber ~= GAMESTATE:GetMasterPlayerNumber() then return end
				self:settext( params.Meter );
				(cmd(finishtweening;zoomy,0;sleep,0.125;linear,0.125;zoomy,1.1;linear,0.05;zoomx,1.1;decelerate,0.1;zoom,1))(self);
			end;
		}; 


	};
};