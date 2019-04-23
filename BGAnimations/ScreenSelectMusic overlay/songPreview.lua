local isWheelCustom = ...
local shine_index = 0;
local streamSafeMode = (ReadPrefFromFile("StreamSafeEnabled") == "true");

return Def.ActorFrame{
	
		Def.Sprite{
			Texture="preview_shine";
			InitCommand=cmd(horizalign,center;zoomx,0.65;zoomy,0.7;x,_screen.cx;y,_screen.cy;SetAllStateDelays,0.03;animate,false;setstate,0;);
			CurrentSongChangedMessageCommand=cmd(stoptweening;diffusealpha,1;animate,true;setstate,0;);
			AnimationFinishedCommand=cmd(animate,false;setstate,0;diffusealpha,0);
		};

		LoadActor("preview_frame")..{
			InitCommand=cmd(horizalign,center;zoomto,400,250;x,_screen.cx;y,_screen.cy-30);
		};
		--Song background. ONLY IF THERE IS NO BGA!
		Def.Sprite{
			InitCommand=cmd(x,_screen.cx;y,_screen.cy-30;diffusealpha,0);
			CurrentSongChangedMessageCommand=function(self)
				self:stoptweening():diffusealpha(0);
				if GAMESTATE:GetCurrentSong() then
					if GAMESTATE:GetCurrentSong():GetPreviewVidPath() == nil then
						self:sleep(.4):queuecommand("Load2");
					end;
				end;
			end;
			Load2Command=function(self)
				local bg = GetSongBackground(true)
				if bg then
					--SCREENMAN:SystemMessage(bg)
					self:Load(bg):zoomto(384,232);
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
				self:zoomto(384,232):linear(.2):diffusealpha(1);
			end;
		};
		Def.Sprite{
			--Name = "BGAPreview";
			InitCommand=cmd(x,_screen.cx;y,_screen.cy-30);
			CurrentSongChangedMessageCommand=cmd(stoptweening;Load,nil;sleep,.4;queuecommand,"PlayVid2");
			PlayVid2Command=function(self)
				--self:Load(nil);
				if streamSafeMode and has_value(STREAM_UNSAFE_AUDIO, GAMESTATE:GetCurrentSong():GetDisplayFullTitle()) then
					self:diffusealpha(0);
					self:Load(nil);
					return;
				else
					local song = GAMESTATE:GetCurrentSong()
					path = GetBGAPreviewPath("PREVIEWVID");
					--path = song:GetBannerPath();
					self:Load(path);
				end;
				self:diffusealpha(0);
				self:zoomto(384,232);
				self:linear(0.2);
				if path == "/Backgrounds/Title.mp4" then
					self:diffusealpha(0.5);
				else
					self:diffusealpha(1);
				end
			end;
		};
		--TODO: Remove this when hiding songs works correctly!
		Def.ActorFrame{
			InitCommand=cmd(x,_screen.cx;y,_screen.cy-30;visible,false);
			CurrentSongChangedMessageCommand=function(self)
				if streamSafeMode and has_value(STREAM_UNSAFE_AUDIO, GAMESTATE:GetCurrentSong():GetDisplayFullTitle()) then
					self:visible(true);
					self:sleep(.8):queuecommand("MuteAudio");
				else
					self:visible(false);
				end;
			end;
			MuteAudioCommand=function(self)
				--SOUND:DimMusic(0,65536);
				SOUND:StopMusic();
			end;
			LoadActor(THEME:GetPathG("","noise"))..{
				InitCommand=cmd(texcoordvelocity,0,8;customtexturerect,0,0,1,1;cropto,384,232;diffuse,color(".5,.5,.5,1"));
			};
			LoadActor("temp_contentid")..{
				InitCommand=cmd(zoom,.5;diffuse,color(".5,.5,.5,1"));
			
			};
			LoadFont("Common Normal")..{
				Text=THEME:GetString("ScreenSelectMusic","StreamUnsafe");
				InitCommand=cmd(wrapwidthpixels,300;);
			};
		};
	
		LoadActor("preview_songinfo")..{
			InitCommand=cmd(horizalign,center;zoomto,385,75;x,_screen.cx;y,_screen.cy+50;diffusealpha,1);
		};
	
		--Song jacket/album art
		Def.Sprite {
			InitCommand=cmd(Load,nil;diffusealpha,0;zoomto,70,70;horizalign,left;x,_screen.cx-190;y,_screen.cy+50);
			CurrentSongChangedMessageCommand=function(self)
				(cmd(stoptweening;Load,nil;diffusealpha,0;))(self);
				if GAMESTATE:GetCurrentSong():HasJacket() then
					self:Load(GAMESTATE:GetCurrentSong():GetJacketPath());
				else
					self:LoadFromSongBanner(GAMESTATE:GetCurrentSong());
				end;
				--Change to zoomto,100,100 for big to small animation
				(cmd(zoomto,30,30;linear,0.05;decelerate,0.25;diffusealpha,1;zoomto,70,70))(self);
			end;
		};

		--Genre display
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-115;y,_screen.cy+25.75;zoom,0.6;skewx,-0.2);
			CurrentSongChangedMessageCommand=function(self)
				self:settext("GENRE:");
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
			end;
		};
		LoadFont("monsterrat/_montserrat light 60px")..{
			InitCommand=cmd(horizalign,left;uppercase,true;x,_screen.cx-67.5;y,_screen.cy+25.5);
			CurrentSongChangedMessageCommand=function(self)
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
				local origin = GAMESTATE:GetCurrentSong():GetOrigin()
				if origin == "" then
					origin = "????"
				end
				self:settext(origin);
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;skewx,-0.2)) (self)
			end;
		};
		
		--BPM DISPLAY
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-115;y,_screen.cy+55.75;zoom,0.6;skewx,-0.2);
			CurrentSongChangedMessageCommand=function(self)
				self:settext("BPM:");
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
			end;
		};
		
		LoadFont("monsterrat/_montserrat light 60px")..{
			InitCommand=cmd(horizalign,left;uppercase,true;x,_screen.cx-83;y,_screen.cy+55.5;zoom,0.22;skewx,-0.2);
			CurrentSongChangedMessageCommand=function(self)

				local song = GAMESTATE:GetCurrentSong();
				-- ROAD24: more checks,
				-- TODO: decide what to do if no song is chosen, ignore or hide ??
				if song then
					local speedvalue;
					if song:IsDisplayBpmRandom() then
						speedvalue = "???";
					else
						local rawbpm = GAMESTATE:GetCurrentSong():GetDisplayBpms();
						local lobpm = math.ceil(rawbpm[1]);
						local hibpm = math.ceil(rawbpm[2]);
						if lobpm == hibpm then
							speedvalue = hibpm
						else
							speedvalue = lobpm.." - "..hibpm
						end;
					end;
					self:settext(speedvalue);
					(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;)) (self)
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;
		};
		
		
		--HEART
		LoadActor(THEME:GetPathG("","USB_stuff/heart_foreground.png"))..{
		InitCommand=cmd(x,_screen.cx-105;y,_screen.cy+85;zoom,0.6;);
		OnCommand=cmd(playcommand,"Refresh";);
		CurrentSongChangedMessageCommand=cmd(finishtweening;diffusealpha,0;sleep,0.01;queuecommand,"Refresh";);
		RefreshCommand=function(self)
			(cmd(diffusealpha,0;sleep,0.3;y,_screen.cy+85;linear,0.3;diffusealpha,1;y,_screen.cy+75))(self);
		end;
		};
		
		LoadFont("monsterrat/_montserrat semi bold 60px")..{
			InitCommand=cmd(horizalign,left;x,_screen.cx-95;y,_screen.cy+74;zoom,0.3;);
			CurrentSongChangedMessageCommand=function(self)
				self:settext("X"..GetNumHeartsForSong());
				(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.2;skewx,-0.2)) (self)
			end;
		};
		
		--SONG COUNTER
		LoadFont("monsterrat/_montserrat light 60px")..{
			InitCommand=cmd(horizalign,right;uppercase,true;x,_screen.cx+190;y,_screen.cy+75;zoom,0.8;skewx,-0.2);
			CurrentSongChangedMessageCommand=function(self,params)
				local song = GAMESTATE:GetCurrentSong();
				if song then
					self:stoptweening();
					--It's probably not very efficient
					local num = 0
					local total = 0
					if isWheelCustom == true then
						--assert(params.index, "CurSongChanged is missing custom params!");
						num = scroller:get_index()
						total = 999
					else
						num = SCREENMAN:GetTopScreen():GetChild('MusicWheel'):GetCurrentIndex()+1;
						total = SCREENMAN:GetTopScreen():GetChild('MusicWheel'):GetNumItems();
					end
					self:settext( string.format("%.3i", num).."/"..string.format("%.3i", total) );
					(cmd(finishtweening;zoomy,0;zoomx,0.5;decelerate,0.33;zoom,0.275;)) (self)
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;
		};
		
		
		--SONG/ARTIST BACKGROUND
		LoadActor("songartist_name")..{
			InitCommand=cmd(x,_screen.cx;y,SCREEN_CENTER_Y-170;zoomto,547,46);
		};
	
		-- CURRENT SONG NAME
		LoadFont("bebas/_bebas neue bold 90px")..{	
			InitCommand=cmd(uppercase,true;x,_screen.cx;y,_screen.cy-171;zoom,0.45;maxwidth,(_screen.w/0.9);skewx,-0.1);
			CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
				if song then
					self:settext(song:GetDisplayFullTitle());
					self:finishtweening();self:diffusealpha(0);
					self:x(_screen.cx+75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;

		};
		-- CURRENT SONG ARTIST
		LoadFont("monsterrat/_montserrat semi bold 60px")..{	
			InitCommand=cmd(uppercase,true;x,_screen.cx;y,_screen.cy-187;zoom,0.2;maxwidth,(_screen.w*2);skewx,-0.1);
			CurrentSongChangedMessageCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
				if song then
					self:settext(song:GetDisplayArtist());
					self:finishtweening();self:diffusealpha(0);
					self:x(_screen.cx-75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;


		};
};
