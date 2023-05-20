local isWheelCustom = ...
local shine_index = 0;
--local streamSafeMode = (ReadPrefFromFile("StreamSafeEnabled") == "true");
local streamSafeMode = false;


--This is a global variable so other screens can check it
extraStageSong = nil;
local isExtraStage = IsExtraStagePIU()
if isExtraStage then
	if USE_ES_SONG then
		local song = SONGMAN:FindSong(ES_SONG)
		if song then
			extraStageSong = song
			GAMESTATE:SetPreferredSong(song);
		end;
	else
		local sDir = GAMESTATE:GetCurrentSong():GetSongDir()
		local arr = split("/",sDir)
		--SCREENMAN:SystemMessage(strArrayToString(arr));
		sDir = arr[2].."/"..arr[3].."/extra1.crs"
		--SCREENMAN:SystemMessage(sDir);
		--sDir = arr[1].."/"
		if FILEMAN:DoesFileExist(sDir) then
			local songName = split(":",GetTagValue(sDir,"SONG"))[1];
			--SCREENMAN:SystemMessage(songName);
			local songsInGroup = SONGMAN:GetSongsInGroup(arr[3])
			for i,song in ipairs(songsInGroup) do
				if song:GetMainTitle() == songName then
					extraStageSong = song
					GAMESTATE:SetPreferredSong(song);
					break
				end;
			end;
		end;
	end;
	if not extraStageSong then
		SCREENMAN:SystemMessage("Couldn't find the extra stage song!");
	end;
end;

--Test
--[[extraStageSong = SONGMAN:FindSong("A")
GAMESTATE:SetPreferredSong(extraStageSong)
isExtraStage = true]]

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
					if not GAMESTATE:GetCurrentSong():HasPreviewVid() then
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
				if GAMESTATE:GetCurrentSong():HasPreviewVid() then
					self:Load(GAMESTATE:GetCurrentSong():GetPreviewVidPath());
					self:diffusealpha(0);
					self:zoomto(384,232);
					self:linear(0.2);
					--[[
					This worked when we were reading the #PREVIEWVID directly,
					but I think specifying /Backgrounds/Title.mp4 is not possible
					when using the C++ function GetPreviewVidPath(). (Though I haven't tried it.)
					Either way, no RIO simfiles ever had this in their tag so it was a mystery why
					this was being checked in the first place.
					Nor did we ever have a Backgrounds folder.
					]]
					--[[if GAMESTATE:GetCurrentSong():GetPreviewVidPath() == "/Backgrounds/Title.mp4" then
						self:diffusealpha(0.5);
					else
						self:diffusealpha(1);
					end]]
					self:diffusealpha(1);
				end;
			end;
		};
		--TODO: Remove this when hiding songs works correctly!
		--[[Def.ActorFrame{
			Condition=false;
			InitCommand=cmd(x,_screen.cx;y,_screen.cy-30;visible,false);
			CurrentSongChangedMessageCommand=function(self)
				if streamSafeMode and has_value(STREAM_UNSAFE_AUDIO, GAMESTATE:GetCurrentSong():GetDisplayFullTitle() .. "||" .. GAMESTATE:GetCurrentSong():GetDisplayArtist()) then
					self:visible(true);
					self:sleep(.8):queuecommand("MuteAudio");
				else
					self:visible(false);
				end;
			end;
			MuteAudioCommand=function(self)
				--SOUND:DimMusic(0,65536);
				SOUND:StopMusic();
				--SOUND:PlayOnce(THEME:GetPathS("","ScreenSelectMusic StreamWarning"));
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
		};]]
	
		LoadActor("preview_songinfo")..{
			InitCommand=cmd(horizalign,center;zoomto,385,75;x,_screen.cx;y,_screen.cy+50;diffusealpha,1);
		};
	
		--Song jacket/album art
		Def.Sprite {
			InitCommand=cmd(Load,nil;diffusealpha,0;zoomto,70,70;horizalign,left;x,_screen.cx-190;y,_screen.cy+50);
			CurrentSongChangedMessageCommand=function(self)
				(cmd(stoptweening;Load,nil;diffusealpha,0;))(self);
				if GAMESTATE:GetCurrentSong() then
					if GAMESTATE:GetCurrentSong():HasJacket() then
						self:Load(GAMESTATE:GetCurrentSong():GetJacketPath());
					else
						self:LoadFromSongBanner(GAMESTATE:GetCurrentSong());
					end;
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
					self:stoptweening():linear(0.25):diffusealpha(0);
				end;
			end;
		};
		
		
		--HEART
		LoadActor(THEME:GetPathB("","ProfileBanner/heart_foreground.png"))..{
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
					self:finishtweening();
					
					self:diffusealpha(0);
					if isExtraStage then
						if extraStageSong == song then
							self:diffuseshift():effectcolor1(Color("Red")):effectcolor2(Color("White")):effectperiod(1);
						else
							self:effectcolor1(Color("White"))
							--self:diffusebottomedge(color("1,1,1,0"))
						end;
					end;
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
