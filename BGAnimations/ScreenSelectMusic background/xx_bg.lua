return Def.ActorFrame{
	Def.Sprite{
		InitCommand=cmd(x,_screen.cx;y,_screen.cy;diffusealpha,0);
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening():diffusealpha(0);
			if GAMESTATE:GetCurrentSong() then
				if true then
					self:sleep(.4):queuecommand("Load2");
				end;
			end;
		end;
		Load2Command=function(self)
			local bg = GetSongBackground(true)
			if bg then
				--SCREENMAN:SystemMessage(bg)
				self:Load(bg):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
			else
				local randomBGAs = FILEMAN:GetDirListing("/RandomMovies/SD/")
				if #randomBGAs > 1 then
					local bga = randomBGAs[math.random(1,#randomBGAs)]
					--SCREENMAN:SystemMessage(bga);
					self:Load("/RandomMovies/SD/"..bga);
				else
					--SCREENMAN:SystemMessage("/RandomMovies/SD/"..randomBGAs[1]);
					self:Load("/RandomMovies/SD/"..randomBGAs[1])
				end;
			end;
			self:scaletocover(0,0,SCREEN_RIGHT,SCREEN_BOTTOM):linear(.2):diffusealpha(.2);
		end;
	};
}