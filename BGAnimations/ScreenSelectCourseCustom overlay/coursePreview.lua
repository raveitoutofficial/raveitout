local isWheelCustom = true


--state of the preview vid in the music train
local curPreviewVid = 1
return Def.ActorFrame{
	
		Def.Sprite{
			Texture=THEME:GetPathB("ScreenSelectMusic","overlay/preview_shine");
			InitCommand=cmd(horizalign,center;zoomx,0.65;zoomy,0.7;x,_screen.cx;y,_screen.cy;SetAllStateDelays,0.03;animate,false;setstate,0;);
			CurrentCourseChangedMessageCommand=cmd(stoptweening;diffusealpha,1;animate,true;setstate,0;);
			AnimationFinishedCommand=cmd(animate,false;setstate,0;diffusealpha,0);
		};

		LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/preview_frame"))..{
			InitCommand=cmd(horizalign,center;zoomto,400,250;x,_screen.cx;y,_screen.cy-30);
		};
		--Song background. ONLY IF THERE IS NO BGA!
		Def.Sprite{
			InitCommand=cmd(x,_screen.cx;y,_screen.cy-30;diffusealpha,0);
			CurrentCourseChangedMessageCommand=function(self)
				self:stoptweening():diffusealpha(0);
				if GAMESTATE:GetCurrentCourse() then
					self:sleep(.4):queuecommand("Load2");
				end;
			end;
			Load2Command=function(self)
				local bg = GAMESTATE:GetCurrentCourse():GetBackgroundPath();
				if bg then
					--SCREENMAN:SystemMessage(bg)
					self:Load(bg):zoomto(384,232);
				else
					local randomBGAs = FILEMAN:GetDirListing("/RandomMovies/SD/")
					if #randomBGAs > 1 then
						local bga = randomBGAs[math.random(1,#randomBGAs)]
						--SCREENMAN:SystemMessage(bga);
						self:Load("/RandomMovies/SD/"..bga);
					elseif randomBGAs[1] ~= nil then
						--SCREENMAN:SystemMessage("/RandomMovies/SD/"..randomBGAs[1]);
						self:Load("/RandomMovies/SD/"..randomBGAs[1])
					end;
				end;
				self:zoomto(384,232):linear(.2):diffusealpha(1);
			end;
		};
		Def.Sprite{
			--Name = "BGAPreview";
			InitCommand=cmd(x,_screen.cx;y,_screen.cy-30);
			CurrentCourseChangedMessageCommand=function(self)
				self:stoptweening():Load(nil);
				curPreviewVid = 1;
				self:sleep(.4):queuecommand("PlayVid2");
			end;
			PlayVid2Command=function(self)
				local song = getenv("TrailCache"):GetTrailEntries()[curPreviewVid]:GetSong();
				path = GetSongExtraData(song, "PreviewVid")
				--path = song:GetBannerPath();
				self:Load(path);
				self:diffusealpha(0);
				self:zoomto(384,232);
				self:linear(0.2);
				self:diffusealpha(1);
				self:sleep(5);
				if curPreviewVid+1 > #getenv("TrailCache"):GetTrailEntries() then
					curPreviewVid = 1
				else
					curPreviewVid = curPreviewVid + 1;
				end;
				self:queuecommand("PlayVid2");
				--[[if path == "/Backgrounds/Title.mp4" then
					self:diffusealpha(0.5);
				else
					self:diffusealpha(1);
				end]]
				
			end;
		};
	
		LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/preview_songinfo"))..{
			InitCommand=cmd(horizalign,center;zoomto,385,75;x,_screen.cx;y,_screen.cy+50;diffusealpha,1);
		};
	
		--Song jacket/album art
		Def.Sprite {
			InitCommand=cmd(Load,nil;diffusealpha,0;zoomto,70,70;horizalign,left;x,_screen.cx-190;y,_screen.cy+50);
			CurrentCourseChangedMessageCommand=function(self)
				(cmd(stoptweening;Load,nil;diffusealpha,0;))(self);
				if GAMESTATE:GetCurrentCourse() then
					self:Load(GAMESTATE:GetCurrentCourse():GetBannerPath() or "");
				end;
				--Change to zoomto,100,100 for big to small animation
				(cmd(zoomto,30,30;linear,0.05;decelerate,0.25;diffusealpha,1;zoomto,70,70))(self);
			end;
		};

		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-115;y,_screen.cy+25.75;zoom,0.6;skewx,-0.2;maxwidth,700);
			CurrentCourseChangedMessageCommand=function(self)
				--self:settext("1.");
				local trailEntries = getenv("TrailCache"):GetTrailEntries();
				if #trailEntries > 0 then
					self:settext("1. "..trailEntries[1]:GetSong():GetDisplayFullTitle());
					(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
				else
					self:settext("");
				end;
			end;
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-115;y,_screen.cy+25.75+15;zoom,0.6;skewx,-0.2;maxwidth,700);
			CurrentCourseChangedMessageCommand=function(self)
				local trailEntries = getenv("TrailCache"):GetTrailEntries();
				if #trailEntries > 1 then
					self:settext("2. "..trailEntries[2]:GetSong():GetDisplayFullTitle());
					(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
				else
					self:settext("");
				end;
			end;
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx+40;y,_screen.cy+25.75;zoom,0.6;skewx,-0.2;maxwidth,700);
			CurrentCourseChangedMessageCommand=function(self)
				--self:settext("1.");
				local trailEntries = getenv("TrailCache"):GetTrailEntries();
				if #trailEntries > 2 then
					self:settext("3. "..trailEntries[3]:GetSong():GetDisplayFullTitle());
					(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
				else
					self:settext("");
				end;
			end;
		};
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx+40;y,_screen.cy+25.75+15;zoom,0.6;skewx,-0.2;maxwidth,700);
			CurrentCourseChangedMessageCommand=function(self)
				local trailEntries = getenv("TrailCache"):GetTrailEntries();
				if #trailEntries > 3 then
					self:settext("4. "..trailEntries[4]:GetSong():GetDisplayFullTitle());
					(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
				else
					self:settext("");
				end;
			end;
		};
		--Genre display
		--[[LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-115;y,_screen.cy+25.75;zoom,0.6;skewx,-0.2);
			CurrentSongChangedMessageCommand=function(self)
				self:settext("GENRE:");
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
			end;
		};
		LoadFont("monsterrat/_montserrat light 60px")..{
			InitCommand=cmd(horizalign,left;uppercase,true;x,_screen.cx-67.5;y,_screen.cy+25.5);
			CurrentSongChangedMessageCommand=function(self)
				if not GAMESTATE:GetCurrentSong() then return end;
				self:settext(GAMESTATE:GetCurrentSong():GetGenre());
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;skewx,-0.2)) (self)
			end;
		};
	
		--Year display
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-115;y,_screen.cy+40.75;zoom,0.6;skewx,-0.2);
			CurrentSongChangedMessageCommand=function(self)
				self:settext("YEAR:");
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
			end;
		};
		LoadFont("monsterrat/_montserrat light 60px")..{
			InitCommand=cmd(horizalign,left;uppercase,true;x,_screen.cx-76;y,_screen.cy+40.5);
			OnCommand=cmd(playcommand,"YearTag");
			CurrentSongChangedMessageCommand=cmd(playcommand,"YearTag");
			YearTagCommand=function(self)
				if not GAMESTATE:GetCurrentSong() then return end;
				local origin = GAMESTATE:GetCurrentSong():GetOrigin()
				if origin == "" then
					origin = "????"
				end
				self:settext(origin);
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;skewx,-0.2)) (self)
			end;
		};]]
		
		
		--HEART
		LoadActor(THEME:GetPathB("","ProfileBanner/heart_foreground.png"))..{
		InitCommand=cmd(x,_screen.cx-105;y,_screen.cy+85;zoom,0.6;);
		OnCommand=cmd(playcommand,"Refresh";);
		CurrentCourseChangedMessageCommand=cmd(finishtweening;diffusealpha,0;sleep,0.01;queuecommand,"Refresh";);
		RefreshCommand=function(self)
			(cmd(diffusealpha,0;sleep,0.3;y,_screen.cy+85;linear,0.3;diffusealpha,1;y,_screen.cy+75))(self);
		end;
		};
		
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-95;y,_screen.cy+74;zoom,0.3;);
			Text="X"..HeartsPerPlay; --Courses will always take up all stages.
			CurrentCourseChangedMessageCommand=function(self)
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;skewx,-0.2)) (self)
			end;
		};
		
		--SONG COUNTER
		LoadFont("monsterrat/_montserrat light 60px")..{
			InitCommand=cmd(horizalign,right;uppercase,true;x,_screen.cx+190;y,_screen.cy+75;zoom,0.8;skewx,-0.2);
			CurrentCourseChangedMessageCommand=function(self,params)
				self:stoptweening();
				local num = params.Selection or 0
				local total = params.Total or 0
				self:settext( string.format("%.3i", num).."/"..string.format("%.3i", total) );
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.275;)) (self)
			end;
		};
		
		
		--SONG/ARTIST BACKGROUND
		LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/songartist_name"))..{
			InitCommand=cmd(x,_screen.cx;y,SCREEN_CENTER_Y-170;zoomto,547,46);
		};
	
		-- CURRENT SONG NAME
		LoadFont("bebas/_bebas neue bold 90px")..{	
			InitCommand=cmd(uppercase,true;x,_screen.cx;y,_screen.cy-171;zoom,0.45;maxwidth,(_screen.w/0.9);skewx,-0.1);
			CurrentCourseChangedMessageCommand=function(self)
				local song = GAMESTATE:GetCurrentCourse()
				if song then
					self:settext(string.gsub(song:GetDisplayFullTitle(),"^%d%d? ?%- ?", ""));
					self:finishtweening();
					
					self:diffusealpha(0);
					self:x(_screen.cx+75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;
		};
		-- CURRENT SONG ARTIST
		LoadFont("monsterrat/_montserrat semi bold 60px")..{	
			InitCommand=cmd(uppercase,true;x,_screen.cx;y,_screen.cy-187;zoom,0.2;maxwidth,(_screen.w*2);skewx,-0.1);
			CurrentCourseChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentCourse();
				if song then
					self:settext(song:GetScripter());
					self:finishtweening();self:diffusealpha(0);
					self:x(_screen.cx-75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;


		};
};
