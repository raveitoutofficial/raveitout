return Def.ActorFrame{
	--BACKGROUND
	LoadActor(THEME:GetPathG("","_BGMovies/dancegrade"))..{
		InitCommand=cmd(diffusealpha,0;x,5;zoomx,1.02;zoomy,0.998;Center;linear,1;diffusealpha,1;);
	};

	Def.Sprite {
		OnCommand=cmd(stoptweening;playcommand,"Banner";);
		BannerCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:Load(GAMESTATE:GetCurrentCourse():GetBannerPath());
			else
				local p = GetSongBackground(true)
				if p then
					self:Load(p);
				else
					self:Load(getLargeJacket());
				end;
			end;
			(cmd(Center;Cover;diffusealpha,0;sleep,1;linear,2;diffusealpha,0.1)) (self)
		end;
	};
	
};