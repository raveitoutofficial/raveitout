local t = Def.ActorFrame { };

local clipScaleX = 385
local clipScaleY = 235
local previewtime = THEME:GetMetric("ScreenSelectCourse","PreviewTime");

local aindex = 0;
local numsngs = 0;

--[ preview audio [Cortes ask to disable that]
t[#t+1] = Def.ActorFrame{
		InitCommand=function(self)
			aindex=0;
		end;
		SetCommand=function(self)
			local ndx = aindex
				if aindex == 0 then
					ndx = 1;
				end
			local song = GAMESTATE:GetCurrentCourse();
			local numsngs = song:GetEstimatedNumStages();
				self:sleep(0.1);
			local sng = song:GetCourseEntries()[ndx]:GetSong();
			local msc = sng:GetMusicPath();
			local start = sng:GetSampleStart();
			local duration = sng:GetSampleLength();
			local slp = previewtime;
			local sl2 = 0.2;
				if aindex == 0 then
					slp = 0.1;
					sl2 = 0;
				else
					if numsngs == 1 then
					slp = duration
					end
				end
				SOUND:PlayMusicPart(msc,start,slp,1,1);
			self:sleep(slp+sl2);
			aindex = aindex+1;
				if aindex > numsngs then return end
				self:queuecommand("Set");
		end;

		CurrentCourseChangedMessageCommand=function(self)
			self:stoptweening();
			self:sleep(0.4+.18);
			song = GAMESTATE:GetCurrentCourse();
			aindex = 0;
			self:queuecommand("Set");
		end;
		OffCommand=cmd(stoptweening);
};

--]]	
--preview banner
t[#t+1] = Def.ActorFrame {
		OnCommand=cmd(draworder,999;fov,90;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-30;zoomx,0.1*aspx;linear,0.3;zoomx,1*aspx;rotationx,7;);
		OffCommand=cmd(sleep,0.15;linear,0.2;zoomy,0.1*aspy;linear,0.1;zoomx,1.5*aspy;zoomy,0);
		SongChosenMessageCommand=cmd(visible,false);
		TwoPartConfirmCanceledMessageCommand=cmd(visible,true);
		SongUnchosenMessageCommand=cmd(visible,true);
	
	--[
	
	LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/preview_frame"))..{
		InitCommand=cmd(horizalign,center;zoomto,400,250;x,0;y,0);
	};
		
	
	Def.Sprite {
	OnCommand=function(self)
		local index = 0;
	end;
	SetCommand=function(self)
			self:stoptweening();
			local ndx = index == 0 and 1 or index
			local song = GAMESTATE:GetCurrentCourse();
			local numsngs = song:GetEstimatedNumStages();
				self:sleep(0.1);
			local sng = song:GetCourseEntries()[ndx]:GetSong();
			local slp = previewtime;
			local sl2 = 0.2;
				if index == 0 then
					slp = 0.1;
					sl2 = 0;
				end
		if sng then
			local Path = sng:GetBannerPath();
			self:LoadBackground( Path );
				if ActorUtil.GetFileType( Path ) == 'FileType_Bitmap' then
					(cmd(scaletoclipped,clipScaleX,clipScaleY;cropbottom,0))(self)
				else
					(cmd(scaletoclipped,clipScaleX,clipScaleY;croptop,0.14575;cropbottom,0.14575))(self)
				end
				if index == 0 then
					self:diffusealpha(0);
				else
					self:diffusealpha(1);
				end
			if numsngs == 1 and index == 1 then
					self:diffusealpha(1);
			else
			self:sleep(slp+sl2);
			index = index+1;
				if index > numsngs then index = 1; end
			self:diffusealpha(0);
			self:queuecommand("Set");
			end
		else
			self:LoadFromCourseBanner(song);
			(cmd(scaletoclipped,clipScaleX,clipScaleY;croptop,0.14575;cropbottom,0.14575;diffusealpha,1))(self)
		end
		end;
		CurrentCourseChangedMessageCommand=function(self)
			self:stoptweening();
			self:sleep(0.3);
			index = 0;
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
	OffCommand=cmd(diffusealpha,0;);
	}; 
	
	--LoadActor("blank")..{ InitCommand=cmd(zoomto,220,220;diffuse,color("#030100");diffusealpha,0.5;y,0;); };
	LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/preview_songinfo"))..{
			InitCommand=cmd(horizalign,center;zoomto,385,75;x,0;y,80;diffusealpha,1);
		};
	
		Def.Sprite {
			InitCommand=cmd(Load,nil;diffusealpha,0;zoomto,70,70;horizalign,left;x,-190;y,80);
			CurrentCourseChangedMessageCommand=cmd(stoptweening;zoomto,70,70;Load,nil;diffusealpha,0;linear,0.5;decelerate,0.25;Load,GAMESTATE:GetCurrentCourse():GetBannerPath();diffusealpha,1;zoomto,70,70;);
		};
	
		--Song display
		LoadFont("facu/_zona pro bold 20px")..{
			InitCommand=cmd(horizalign,left;x,-115;y,55;zoom,0.6;);
			CurrentSongChangedMessageCommand=function(self)
				self:settext("Song:");
				(cmd(finishtweening;zoomy,0;zoomx,2;decelerate,0.33;zoom,0.6;)) (self)
			end;
		};
		
		LoadFont("facu/_zona pro thin 20px")..{
			InitCommand=cmd(horizalign,left;uppercase,false;x,-75;y,55;maxwidth,200;zoom,0.7;);
			OnCommand=function(self)
			local tindex = 0;
			self:stoptweening();
			self:sleep(0.3);
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
		SetCommand=function(self)
			self:stoptweening();
			local ndx = tindex == 0 and 1 or tindex
			local song = GAMESTATE:GetCurrentCourse();
			local numsngs = song:GetEstimatedNumStages();
				self:sleep(0.1);
			local sng = song:GetCourseEntries()[ndx]:GetSong();
			local rawbpm = song:GetCourseEntries()[ndx]:GetSong():GetDisplayBpms();
			setenv("rawbpm",rawbpm);
			local slp = previewtime;
			local sl2 = 0.2;
				if tindex == 0 then
					slp = 0.1;
					sl2 = 0;
				end
		if sng then
			local songtitle = sng:GetDisplayFullTitle();
			self:settext( songtitle );
				if tindex == 0 then
					self:diffusealpha(0);
				else
					self:diffusealpha(1);
				end
			if numsngs == 1 and tindex == 1 then
					self:diffusealpha(1);
			else
			self:sleep(slp+sl2);
			tindex = tindex+1;
				if tindex > numsngs then tindex = 1 end
			self:diffusealpha(0);
			self:queuecommand("Set");
			end
		else
			self:settext(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle());
		end
		MESSAGEMAN:Broadcast("Update");
		end;
		CurrentCourseChangedMessageCommand=function(self)
			self:stoptweening();
			self:sleep(0.3);
			tindex = 0;
			self:diffusealpha(0);
			self:queuecommand("Set");
			--DEBUG
			--SCREENMAN:SystemMessage();
		end;
		OffCommand=cmd(finishtweening;linear,1;diffusealpha,0;);
		};
	
		--Year display
		LoadFont("facu/_zona pro bold 20px")..{
			InitCommand=cmd(horizalign,left;x,-115;y,70;zoom,0.6;);
			CurrentSongChangedMessageCommand=function(self)
				self:settext("YEAR:");
				(cmd(finishtweening;zoomy,0;zoomx,2;decelerate,0.33;zoom,0.6;)) (self)
			end;
		};
		LoadFont("facu/_zona pro thin 20px")..{
			InitCommand=cmd(playcommand,"YearTag";horizalign,left;uppercase,true;x,-76;y,70);
			CurrentCourseChangedMessageCommand=cmd(playcommand,"YearTag");
			YearTagCommand=function(self)
				ssc_year = GetTagValue(GAMESTATE:GetCurrentSteps(GAMESTATE:GetMasterPlayerNumber()):GetFilename(),"YEAR")
				if ssc_year == nil or ssc_year == "" then ssc_year = "????" end
				self:settext(ssc_year);
				(cmd(finishtweening;zoomy,0;zoomx,2;decelerate,0.33;zoom,0.6;)) (self)
			end;
		};
		
		--BPM DISPLAY
		LoadFont("facu/_zona pro bold 20px")..{
			InitCommand=cmd(horizalign,left;x,-115;y,85;zoom,0.6;);
			CurrentCourseChangedMessageCommand=function(self)
				self:settext("BPM:");
				(cmd(finishtweening;zoomy,0;zoomx,2;decelerate,0.33;zoom,0.6;)) (self)
			end;
		};
		LoadFont("facu/_zona pro thin 20px")..{
			InitCommand=cmd(horizalign,left;uppercase,true;x,-83;y,85;zoom,0.6;);
			CurrentCourseChangedMessageCommand=cmd(playcommand,"UpdateMessage";);
			UpdateMessageCommand=function(self)
				local song = GAMESTATE:GetCurrentCourse();
				-- ROAD24: more checks,
				-- TODO: decide what to do if no song is chosen, ignore or hide ??
				if song then
					local rawbpm = getenv("rawbpm");
					local lobpm = math.ceil(rawbpm[1]);
					local hibpm = math.ceil(rawbpm[2]);
					if lobpm == hibpm then
						speedvalue = hibpm
					else
						speedvalue = lobpm.." - "..hibpm
					end;
					self:settext(speedvalue);
					--(cmd(finishtweening;zoomy,0;zoomx,2;decelerate,0.33;zoom,0.6;)) (self)
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;
		};	

--]]

--[[LOOP
	LoadFont("common normal")..{
		InitCommand=cmd(x,-100;y,-70;maxwidth,485;zoomx,.65;zoomy,.65;diffuse,color("#f7f3ca");diffusebottomedge,color("#fadfb4");diffusetopedge,color("#e4b059");horizalign,left;);
		OnCommand=function(self)
			local tindex = 0;
			self:stoptweening();
			self:sleep(0.3);
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
		SetCommand=function(self)
			self:stoptweening();
			local ndx = tindex == 0 and 1 or tindex
			local song = GAMESTATE:GetCurrentCourse();
			local numsngs = song:GetEstimatedNumStages();
				self:sleep(0.1);
			local sng = song:GetCourseEntries()[ndx]:GetSong();
			local slp = previewtime;
			local sl2 = 0.2;
				if tindex == 0 then
					slp = 0.1;
					sl2 = 0;
				end
		if sng then
			local songtitle = sng:GetDisplayFullTitle();
			self:settext( "Song: "..songtitle );
				if tindex == 0 then
					self:diffusealpha(0);
				else
					self:diffusealpha(1);
				end
			if numsngs == 1 and tindex == 1 then
					self:diffusealpha(1);
			else
			self:sleep(slp+sl2);
			tindex = tindex+1;
				if tindex > numsngs then tindex = 1 end
			self:diffusealpha(0);
			self:queuecommand("Set");
			end
		else
			self:settext(GAMESTATE:GetCurrentCourse():GetDisplayFullTitle());
		end
		end;
		CurrentCourseChangedMessageCommand=function(self)
			self:stoptweening();
			self:sleep(0.3);
			tindex = 0;
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
		OffCommand=cmd(finishtweening;linear,1;diffusealpha,0;);
	};

--]]


--LIST (TRY xD) 
	--[[Not necessary anymore, but still here for future code use
	LoadFont("common normal")..{
		InitCommand=cmd(diffusealpha,0);
	
			OnCommand=cmd(playcommand,"Refresh");
			MenuLeftP1MessageCommand=cmd(playcommand,"Refresh");
			MenuLeftP2MessageCommand=cmd(playcommand,"Refresh");
			MenuUpP1MessageCommand=cmd(playcommand,"Refresh");
			MenuUpP2MessageCommand=cmd(playcommand,"Refresh");
			MenuRightP1MessageCommand=cmd(playcommand,"Refresh");
			MenuRightP2MessageCommand=cmd(playcommand,"Refresh");
			MenuDownP1MessageCommand=cmd(playcommand,"Refresh");
			MenuDownP2MessageCommand=cmd(playcommand,"Refresh");
			CurrentCourseChangedMessageCommand=cmd(playcommand,"Refresh");
			RefreshCommand=function(self)
			local courselist = "";
			local totalsongs = GAMESTATE:GetCurrentCourse():GetCourseEntries();
			f = RageFileUtil.CreateRageFile();
			f:Open( THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt", 2);
			for idx = 1, #totalsongs do
				f:PutLine("#SONG"..idx..":"..GAMESTATE:GetCurrentCourse():GetCourseEntries()[idx]:GetSong():GetDisplayFullTitle()..";");
			end
			f:destroy();
			
		end;

	};
--]]
	


};

t[#t+1] = StandardDecorationFromFileOptional("CourseContentsList","CourseContentsList")..{
	InitCommand=cmd(draworder,156;zoom,0.80;horizalign,center;vertalign,middle;x,SCREEN_CENTER_X-60;y,SCREEN_CENTER_Y+107;rotationz,-90);
};



return t;