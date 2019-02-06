local t = Def.ActorFrame {};
local function MsgScroll()
	local index = 1
	return LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/help_info/msg_1"))..{
		SetCommand=function(self)
			index = index+1
			total = FILEMAN:GetDirListing(THEME:GetCurrentThemeDirectory().."Bganimations/ScreenSelectMusic overlay/help_info/");
			if index > #total-3 then index = 1 end
			
			self:Load(THEME:GetPathB("","ScreenSelectMusic overlay/help_info/msg_"..index));
			self:linear(0.2);
			self:diffusealpha(1);
			self:sleep(2);
			self:linear(0.2)
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
	}		
end;


local stage =		GAMESTATE:GetCurrentStage()
--optionlist controls
local olwid =		THEME:GetMetric("CustomRIO","OpQuadWidth")		--option list quad width
local olania =		0.1			--optionlist animation time in
local olanib =		0.2			--optionlist animation time out
local olhei	=		SCREEN_HEIGHT*0.75	--optionlist quadheight
local oltfad =		0.125		--optionlist top fade value (0..1)
local olbfad =		0.5			--optionlist bottom fade value
local ollfad =		0			--optionlist left  fade value
local olrfad =		0			--optionlist right fade value
-- Chart info helpers
local infy =		160					--Chart info Y axis position (both players, includes black quad alt)
local infx =		0					--Chart info X DIFFERENCE FROM DISC
local txytune =		-25					--Text info altitude (Y axis) finetuning
local txxtune =		0.015625*_screen.w	--Text info separation from center (X axis) finetuning (must be always a positive value)	--20 equivalent is 0.03125*_screen.w (when using 4:3)
local saz =			0.75				--Chart info Step Artist Zoom ("saz! en toda la boca!")
local diffy =		40					--Object Y axis difference
local maxwidar =	_screen.cx*0.7	--Chart info Step Artist maxwidth value
local maxwidinf =	_screen.cx*1.1	--Chart info Text maxwidth value
local infft =		0.125*0.75			--Chart info quad fade top
local inffb =		infft				--Chart info quad fade bottom
local redu =		0					--Chart info vertical reduction value for black quad (pixels)
--local bqwid =		(_screen.cx*0.625)+40	--Chart info quad width
local bqwid =		_screen.cx			--Chart info quad width
local bqalt =		244-20				--Chart info black quad height
local bqalph =		0.9					--Chart info black quad diffusealpha value
local wqwid =		_screen.cx			--
--
local npsxz =	_screen.cx*0.5		--next/previous song X zoom
local npsyz =	_screen.cy --*0.75	--next/previous song Y zoom
--
--local css1 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
--local css2 = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
local newranktext = "NEW CHALLENGER"	--text replacing #P1# when someone does a new record
local bpmalt = 	_screen.cy+75			--Y value for BPM Display below banner

	if IsUsingWideScreen() then
		defaultzoom = 0.8;
		else
		defaultzoom = 0.65;
	end;

t[#t+1] = Def.ActorFrame{
	PlayerJoinedMessageCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenSelectProfile");
	end;
};

--PREVIEW BOX
t[#t+1] = Def.ActorFrame{
	
		
	
		Def.Sprite{
			--Name = "BGAPreview";
			InitCommand=cmd(x,_screen.cx;y,_screen.cy-30);
			CurrentCourseChangedMessageCommand=cmd(stoptweening;queuecommand,"PlayVid");
			MenuLeftP1MessageCommand=cmd(playcommand,"PlayVid");
			MenuLeftP2MessageCommand=cmd(playcommand,"PlayVid");
			MenuUpP1MessageCommand=cmd(playcommand,"PlayVid");
			MenuUpP2MessageCommand=cmd(playcommand,"PlayVid");
			MenuRightP1MessageCommand=cmd(playcommand,"PlayVid");
			MenuRightP2MessageCommand=cmd(playcommand,"PlayVid");
			MenuDownP1MessageCommand=cmd(playcommand,"PlayVid");
			MenuDownP2MessageCommand=cmd(playcommand,"PlayVid");
			PlayVidCommand=function(self)
				self:Load(nil);
				local song = GAMESTATE:GetCurrentSong()
				path = GetBGAPreviewPath("PREVIEWVID");
				--path = song:GetBannerPath();
				self:Load(path);
				self:diffusealpha(0);
				self:zoomto(384,232);
				self:sleep(0.5);
				self:linear(0.2);
				if path == "/Backgrounds/Title.mp4" then
					self:diffusealpha(0.5);
				else
					self:diffusealpha(1);
				end
			end;
		};
	
				
};

--SONG/ARTIST INFO
t[#t+1] = Def.ActorFrame {
--SONG/ARTIST BACKGROUND
		LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/songartist_name"))..{
			InitCommand=cmd(x,_screen.cx;y,SCREEN_CENTER_Y-170;zoomto,547,46);
		};
	
		-- CURRENT SONG NAME
		LoadFont("facu/_zona pro thin 40px")..{	
			InitCommand=cmd(uppercase,true;x,_screen.cx;y,_screen.cy-168;zoom,0.8;maxwidth,(_screen.w/1.2);skewx,-0.1);
			CurrentCourseChangedMessageCommand=function(self)
			local course = GAMESTATE:GetCurrentCourse()
				if course then
					self:settext(course:GetDisplayFullTitle());
					self:finishtweening();self:diffusealpha(0);
					self:x(_screen.cx+75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;

		};
		-- CURRENT SONG ARTIST
		LoadFont("facu/_zona pro bold 20px")..{	
			InitCommand=cmd(uppercase,true;x,_screen.cx;y,_screen.cy-187;zoom,0.6;maxwidth,(_screen.w*1););
			CurrentCourseChangedMessageCommand=function(self)
			local course = GAMESTATE:GetCurrentCourse()
				if course then
					self:settext(course:GetDisplayArtist());
					self:finishtweening();self:diffusealpha(0);
					self:x(_screen.cx-75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;


		};
};
	
---DECORATIONS IN GENERAL
t[#t+1] = Def.ActorFrame {
	--MSG INFO
	LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/help_info/txt_box"))..{
		InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-50;zoomx,0.9;zoomy,0.65);
	};
	
	MsgScroll()..{
		InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-50;zoom,1;queuecommand,"Set");
	};
	
	--TIME LABEL
	LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/time"))..{
		InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-90;zoom,1);
	};
	
	--Current Group/Playlist
	LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/current_group"))..{
		InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP+5;horizalign,left;vertalign,top;zoomx,1;cropbottom,0.3);
	};
	
	LoadFont("facu/_zona pro thin 10px")..{	
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+18;y,SCREEN_TOP+10;zoom,0.85;skewx,-0.15);
		CurrentCourseChangedMessageCommand=function(self)
			self:uppercase(true);
			self:settext("Current songlist");
		end;
	};
	
	LoadFont("facu/_zona pro bold 40px")..{	
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+16;y,SCREEN_TOP+30;zoom,0.8;skewx,-0.25);
		CurrentCourseChangedMessageCommand=function(self)
			self:uppercase(true);
			self:settext("MIXTAPES");
		end;
	};
	
	--PREV/NEXT Song indicator effects
	Def.ActorFrame{		
		LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/previous_song"))..{
			InitCommand=cmd(zoom,0.8;x,SCREEN_LEFT-2;y,SCREEN_CENTER_Y-30;horizalign,left;vertalign,middle);
			PreviousSongMessageCommand=cmd(stoptweening;linear,0.2;x,SCREEN_LEFT-5;linear,0.2;x,SCREEN_LEFT-2;);
		};
		LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/prev_song_switch"))..{
			InitCommand=cmd(diffusealpha,0;zoom,0.8;x,SCREEN_LEFT-2;y,SCREEN_CENTER_Y-30;horizalign,left;vertalign,middle);
			PreviousSongMessageCommand=cmd(stoptweening;linear,0.2;x,SCREEN_LEFT-5;diffusealpha,1;linear,0.2;x,SCREEN_LEFT-2;diffusealpha,0;);
		};
		
		LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/next_song"))..{
			InitCommand=cmd(zoom,0.8;x,SCREEN_RIGHT+2;y,SCREEN_CENTER_Y-30;horizalign,right;vertalign,middle);
			NextSongMessageCommand=cmd(stoptweening;linear,0.2;x,SCREEN_RIGHT+5;linear,0.2;x,SCREEN_RIGHT+2;);
		};
		LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/nex_song_switch"))..{
			InitCommand=cmd(diffusealpha,0;zoom,0.8;x,SCREEN_RIGHT+2;y,SCREEN_CENTER_Y-30;horizalign,right;vertalign,middle);
			NextSongMessageCommand=cmd(stoptweening;linear,0.2;x,SCREEN_RIGHT+5;diffusealpha,1;linear,0.2;x,SCREEN_RIGHT+2;diffusealpha,0;);
		};
	};
 };
 
t[#t+1] = Def.ActorFrame{


	--[[
	LoadFont("venacti/_venacti_outline 26px bold diffuse")..{	--formatted stage display
		InitCommand=cmd(xy,_screen.cx,_screen.cy-190;zoomx,0.75;zoomy,0.65);
		OnCommand=function(self)
			local stageNum=GAMESTATE:GetCurrentStageIndex()
			if stageNum < 10 then stg = "0"..stageNum+1 else stg = stageNum+1 end;
			
			if DoDebug then curstage = "DevMode - Stage: "..stg
			elseif GAMESTATE:IsEventMode() then curstage = "Event Mode - "..stageNum.."th Stage"
			elseif 		stage == "Stage_1st"		then curstage = "1st Stage"
			elseif	stage == "Stage_2nd"		then curstage = "2nd Stage"
			elseif	stage == "Stage_3rd"		then curstage = "3rd Stage"
			elseif	stage == "Stage_4th"		then curstage = "4th Stage"
			elseif	stage == "Stage_5th"		then curstage = "5th Stage"
			elseif	stage == "Stage_Next"		then curstage = "Next Stage"
			elseif	stage == "Stage_Final"		then curstage = "Final Stage"
			elseif	stage == "Stage_Extra1"		then curstage = "Extra Stage"
			elseif	stage == "Stage_Extra2"		then curstage = "Encore Stage"
			elseif	stage == "Stage_Nonstop"	then curstage = "Nonstop Stage"
			elseif	stage == "Stage_Oni"		then curstage = "Oni Stage"
			elseif	stage == "Stage_Endless"	then curstage = "Endless"
			elseif	stage == "Stage_Event"		then curstage = "Event Mode"
			elseif	stage == "Stage_Demo"		then curstage = "Demo"
			else	curstage = stageNum.."th Stage"
			end;
			self:settext(curstage);
		end;
	};
	--]]
	
	Def.ActorFrame{		--P1 info display set
		InitCommand=cmd(x,SCREEN_LEFT;y,_screen.cy+110;vertalign,middle,horizalign,right);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,SCREEN_CENTER_X);
		SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,SCREEN_LEFT;);

		Def.Quad{		--white quad for Difficulties
			InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1) or GAMESTATE:IsHumanPlayer(PLAYER_2);horizalign,right;zoomto,_screen.cx,35;diffuse,1,1,1,0.75;x,0;y,-3;fadeleft,1;);
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1) or GAMESTATE:IsHumanPlayer(PLAYER_2));
		};
		
		Def.Quad{		--Black quad for Chart info P1
			InitCommand=cmd(horizalign,right;fadetop,infft;fadebottom,inffb;x,-infx;y,-infy+20;
							zoomto,bqwid*2,bqalt+50;diffuse,0,0,0,bqalph;);
		};
		
		LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/p1_info"))..{		--P1 INFO
			InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);horizalign,left;zoomto,250,45;x,-320;y,-235;faderight,1;);
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
		};
		
		LoadFont("Common normal")..{		--"NOT PRESENT" text
			Text="NOT PRESENT";
			InitCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_1);x,-_screen.cx*0.7;y,-infy;zoom,1;);
			PlayerJoinedMessageCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_1));
		};
		Def.ActorFrame{		--Chart Info and more for P1
			InitCommand=cmd(y,-diffy);
			LoadFont("Common normal")..{								--"Step Artist:" text
				Text="Step Artist:";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);x,-infx-txxtune;y,-infy+txytune-10-3;zoom,0.5;horizalign,right;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{	--Artist text
				InitCommand=cmd(x,-infx-txxtune;y,-infy+txytune+10-3;zoom,saz;horizalign,right;maxwidth,maxwidar;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"CurrentStepsP1ChangedMessage");
				CurrentStepsP1ChangedMessageCommand=function(self)
				--	local author = GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit()	--this is the Thor that is the auThor... lol get it? yes but... ah ok...
																							--lolXD  - road
						author = GAMESTATE:GetCurrentCourse():GetScripter();
						if author == "" then
							artist = "Not available"
						else
							if DoDebug then		--what is code and/or stepmania... without jokes? (only for p1)
								if author == "C.Cortes" then
									artist = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
								elseif author == "F.Rodriguez" then
									artist = "I LIEK TURTLES"
								else
										artist = author
								end
							else
								artist = author
							end
						end
							self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
							self:settext(artist);
				end;
			};

			LoadFont("Common normal")..{
				Text="Song List:";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);x,-infx-txxtune;y,-infy+txytune+25;zoom,0.5;skewx,-0.25;horizalign,right;vertalign,top;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
				OnCommand=function(self)
					if GAMESTATE:IsCourseMode() then
						self:settext("Song List:")
					else
						self:settext("");
					end;
				end;
			};


			LoadFont("Common normal")..{--"Song list from current course"
				Text="";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);x,-infx-txxtune;y,-infy+txytune+70;zoom,0.4;horizalign,right;vertalign,middle;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
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
				CurrentCourseChangedMessageCommand=cmd(playcommand,"Refresh");
				RefreshCommand=function(self)
					--[[
					list = GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG1").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG2").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG3").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG4");
					if GAMESTATE:IsCourseMode() then
						self:settext(list)
					else
						self:settext("");
					end;
					--]]

					--"fixex"
					--self:settext(GAMESTATE:GetCurrentCourse():GetCourseEntries()[1]:GetSong():GetDisplayFullTitle().."\n"..GAMESTATE:GetCurrentCourse():GetCourseEntries()[2]:GetSong():GetDisplayFullTitle().."\n"..GAMESTATE:GetCurrentCourse():GetCourseEntries()[3]:GetSong():GetDisplayFullTitle().."\n"..GAMESTATE:GetCurrentCourse():GetCourseEntries()[4]:GetSong():GetDisplayFullTitle());
					self:settext(GAMESTATE:GetCurrentCourse():GetCourseEntries()[1]:GetSong():GetDisplayFullTitle().."\n"..GAMESTATE:GetCurrentCourse():GetCourseEntries()[2]:GetSong():GetDisplayFullTitle().."\n"..GAMESTATE:GetCurrentCourse():GetCourseEntries()[3]:GetSong():GetDisplayFullTitle().."\n"..GAMESTATE:GetCurrentCourse():GetCourseEntries()[4]:GetSong():GetDisplayFullTitle());
					
				end;
			};
			
			LoadFont("Common normal")..{								--SPEEDMOD Display
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);x,-infx-txxtune;y,-infy+txytune+10+3+20;zoom,0.5;horizalign,right;vertalign,top;maxwidth,maxwidinf);
				OnCommand=function(self)
					local profilep = PROFILEMAN:GetProfileDir("ProfileSlot_Player1")
					local song = GAMESTATE:GetCurrentSong();
					if song then
						local songpath = song:GetSongDir();
						local pathlastsmod = File.Read(profilep.."RIO_SongData"..songpath.."LastSpeedModUsed.txt")
						local lastspeedmod = pathlastsmod
						if lastspeedmod == nil then		--account for nil value
							lastspeedmod = "Not found"
						end;
						local xmod = GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():XMod();
						local cmod = GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():CMod();
						local mmod = GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():MMod();
						local rawbpm = GAMESTATE:GetCurrentSong():GetDisplayBpms();
						--GetDisplayBpms always returns two values (lowest and highest) regardless if the song has only one BPM it repeats to both values.
						--%.1f --se cambia el numero para mas decimales
				--		local lobpm = tonumber(string.format("%.0f",rawbpm[1]));
				--		local hibpm = tonumber(string.format("%.0f",rawbpm[2]));
						local lobpm = math.ceil(rawbpm[1]);
						local hibpm = math.ceil(rawbpm[2]);
						if cmod then
							curmod = "C Mod "..cmod
							speedvalue = cmod
						elseif mmod then
							curmod = "M Mod "..mmod
							speedvalue = mmod
						else
							curmod = xmod.."x"
							if lobpm == hibpm then
								speedvalue = lobpm*xmod
							else
								speedvalue = lobpm*xmod.." - "..hibpm*xmod
							end;
						end;
						self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
						self:settext("(Last Speed Modifier: "..lastspeedmod..")\nSpeed Modifier: "..curmod.."\nSpeed display (BPM*Mod): "..speedvalue);
					end;
				end;
				PlayerJoinedMessageCommand=cmd(playcommand,"On";);
				CurrentCourseChangedMessageCommand=cmd(playcommand,"On";);
				CodeMessageCommand=cmd(playcommand,"On";);
				OptionsListClosedMessageCommand=cmd(playcommand,"On";);
				SongChosenMessageCommand=cmd(playcommand,"On";);
			};
			LoadFont("Common normal")..{								--"Machine Top Score:" text
				Text="Machine Top Score:";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);x,-infx-txxtune;y,-infy+txytune+110;zoom,0.5;skewx,-0.25;horizalign,right;vertalign,top;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
			};
			LoadFont("_roboto Bold 54px")..{							--Machine Top Score (numbers)
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);x,-infx-txxtune;y,-infy+txytune+125;zoom,1/4;skewx,-0.25;horizalign,right;vertalign,top;queuecommand,"Set";);
				CurrentCourseChangedMessageCommand=cmd(queuecommand,"Set");
				
				CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
				SetCommand=function(self)
					-- ROAD24: and more checks
					-- TODO: decide what to do when no song is selected
					local cursong =	GAMESTATE:GetCurrentSong()
					if cursong and GAMESTATE:IsPlayerEnabled(PLAYER_1) then
						if cursong:IsLong() then
							stagemaxscore = 200000000
						elseif cursong:IsMarathon() then
							stagemaxscore = 300000000
						else
							stagemaxscore = 100000000
						end;
						profile = PROFILEMAN:GetMachineProfile();
						scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_1));
						local scores = scorelist:GetHighScores();
						local topscore = scores[1];
						if topscore then
						--	if topscore >= stagemaxscore then		--temporary workaround
						--		pscore = stagemaxscore
						--	else
								pscore = topscore:GetScore();
						--	end
						else
							pscore = "0";
						end
						local percen = tonumber(string.format("%.03f",((pscore/stagemaxscore)*100)));
						if topscore then
							self:settext(pscore.." - "..percen.."%");
						else
							self:settext("0");
						end;
					end;
				end;
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{	--Machine Top Score HOLDER (name)
				InitCommand=cmd(x,-infx-txxtune;y,-infy+txytune+10+3+20+75+12+15;zoom,0.5;skewx,-0.25;horizalign,right;vertalign,top;queuecommand,"Set";);
				CurrentCourseChangedMessageCommand=cmd(queuecommand,"Set");
				CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
				SetCommand=function(self)
					if GAMESTATE:GetCurrentSong() and GAMESTATE:IsPlayerEnabled(PLAYER_1) then
						profile = PROFILEMAN:GetMachineProfile();
						scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_1));
						local scores = scorelist:GetHighScores();
						local topscore = scores[1];
						if topscore then
							if topscore == "" then
								text = "Record holder: NONAME"		--to do: fix
							else
								text = "Record holder: "..topscore:GetName();
							end
						else
							text = "No Score";
						end;
					--	if text == "#P1#" then
						if text == "EVNT" then
					--	if text == "EVNT" or "#P1#" then		--value stucks
							self:settext(newranktext);
						else
							self:settext(text);
						end--]]
					end;
				end;
			};
		};
		Def.Quad{		--White for Chart info P1 EFFECT JOINED
			InitCommand=function(self)
				if GAMESTATE:IsHumanPlayer(PLAYER_1) then
					self:visible(false);
				else
					self:visible(true);
				end;
				(cmd(horizalign,right;fadetop,infft;fadebottom,inffb;x,-infx;y,-infy;
					 zoomto,bqwid,bqalt-redu;diffuse,1,1,1,0;blend,'BlendMode_Add';))(self)
			end;
			PlayerJoinedMessageCommand=function(self)
				(cmd(zoomy,(bqalt-redu)*1.25;diffuse,1,1,1,1;decelerate,0.75;zoomy,(bqalt-redu)*0.925;diffuse,1,1,1,0))(self)
			end;
		};
	};
	
	Def.ActorFrame{		--P2 info display set
		InitCommand=cmd(x,SCREEN_RIGHT;y,_screen.cy+110);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,_screen.cx);
		SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,SCREEN_RIGHT;);
		Def.Quad{		--white quad for Difficulties
			InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2) or GAMESTATE:IsHumanPlayer(PLAYER_1);horizalign,right;zoomto,wqwid,35;diffuse,1,1,1,0.75;x,_screen.cx;y,-3;faderight,1;);
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2) or GAMESTATE:IsHumanPlayer(PLAYER_1));
		};
		Def.Quad{		--Black quad for Chart info P2
			InitCommand=cmd(horizalign,left;fadetop,infft;fadebottom,inffb;x,infx;y,-infy+20;
							zoomto,bqwid*2,bqalt+50;diffuse,0,0,0,bqalph;);
		};
		
		LoadActor(THEME:GetPathB("","ScreenSelectMusic overlay/p2_info"))..{		--P2 INFO
			InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);horizalign,right;zoomto,250,45;x,320;y,-235;fadeleft,1;);
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
		};
		
		LoadFont("Common normal")..{		--"NOT PRESENT" text
			Text="NOT PRESENT";
			InitCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_2);x,_screen.cx*0.7;y,-infy;zoom,1;);
			PlayerJoinedMessageCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_2););
		};
		Def.ActorFrame{		--Chart Info and more for P2
			InitCommand=cmd(y,-diffy);
			LoadFont("Common normal")..{								--"StepArtist" text
				Text="Step Artist:";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);x,infx+txxtune;y,-infy+txytune-10-3;zoom,0.5;horizalign,left);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2););
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{	--Artist text
				InitCommand=cmd(x,infx+txxtune;y,-infy+txytune+10-3;zoom,saz;horizalign,left;maxwidth,maxwidar;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"CurrentStepsP2ChangedMessage");
				CurrentStepsP2ChangedMessageCommand=function(self)
				--	local author = GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit()	--this is the Thor that is the auThor... lol get it? yes but... ah ok...
					if GAMESTATE:IsCourseMode() and GetCourseDescription(GAMESTATE:GetCurrentCourse():GetCourseDir(),"DESCRIPTION") ~= "" then
						author = GAMESTATE:GetCurrentCourse():GetScripter();
						if author == "" then
								artist = "Not available"
							else
								if DoDebug then		--what is code and/or stepmania... without jokes? (only for p1)
									if author == "C.Cortes" then
										artist = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
									elseif author == "F.Rodriguez" then
										artist = "I LIEK TURTLES"
									else
										artist = author
									end
								else
									artist = author
								end
							end
							self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
							self:settext(artist);
					else  

					if GAMESTATE:GetCurrentSteps(PLAYER_2) then
						local author = GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit();	--this is the Thor that is the auThor... lol get it? yes but... ah ok...
						if GAMESTATE:GetCurrentSong() then		--set text display
							if author == "" then
								artist = "Not available"
							else
								if DoDebug then		--what is code and/or stepmania... without jokes?
									if author == "C.Cortes" then
										artist = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
									elseif author == "F.Rodriguez" then
										artist = "I LIEK TURTLES"
									else
										artist = author
									end
								else
									artist = author
								end
							end
							self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2));
							self:settext(artist);
						else
							self:visible(false);
						end;
					end;
					end;
				end;
			};
			
			
			LoadFont("Common normal")..{
				Text="Song List:";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);x,infx+txxtune;y,-infy+txytune+25;zoom,0.5;skewx,-0.25;horizalign,left;vertalign,top;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
				OnCommand=function(self)
					if GAMESTATE:IsCourseMode() then
						self:settext("Song List:")
					else
						self:settext("");
					end;
				end;
			};


			LoadFont("Common normal")..{--"Song list from current course"
				Text="";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);x,infx+txxtune;y,-infy+txytune+70;zoom,0.4;horizalign,left;vertalign,middle;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
				OnCommand=function(self)
					list = GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG1").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG2").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG3").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG4");
					if GAMESTATE:IsCourseMode() then
						self:settext(list)
					else
						self:settext("");
					end;
				end;
			};
			
			LoadFont("Common normal")..{								--SPEEDMOD Display
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);x,infx+txxtune;y,-infy+txytune+10+3+20;zoom,0.5;horizalign,left;vertalign,top;maxwidth,maxwidinf;);
				OnCommand=function(self)
					local profilep = PROFILEMAN:GetProfileDir("ProfileSlot_Player2")
					local song = GAMESTATE:GetCurrentSong();
					-- ROAD24: more checks
					if song then
						local songpath = song:GetSongDir()
						local pathlastsmod = File.Read(profilep.."RIO_SongData"..songpath.."LastSpeedModUsed.txt")
						local lastspeedmod = pathlastsmod
						if lastspeedmod == nil then		--account for nil value
							lastspeedmod = "Not found"
						end;
						local xmod = GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():XMod();
						local cmod = GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():CMod();
						local mmod = GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():MMod();
						local rawbpm = GAMESTATE:GetCurrentSong():GetDisplayBpms();
						--GetDisplayBpms always returns two values (lowest and highest) regardless if the song has only one BPM it repeats to both values.
						--%.1f --se cambia el numero para mas decimales
						--local lobpm = tonumber(string.format("%.0f",rawbpm[1]));
						--local hibpm = tonumber(string.format("%.0f",rawbpm[2]));
						local lobpm = math.ceil(rawbpm[1]);
						local hibpm = math.ceil(rawbpm[2]);
						if cmod then
							curmod = "C Mod "..cmod
							speedvalue = cmod
						elseif mmod then
							curmod = "M Mod "..mmod
							speedvalue = mmod
						else
							curmod = xmod.."x"
							if lobpm == hibpm then
								speedvalue = lobpm*xmod
							else
								speedvalue = lobpm*xmod.." - "..hibpm*xmod
							end;
						end;
						self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2));
						self:settext("(Last Speed Modifier: "..lastspeedmod..")\nSpeed Modifier: "..curmod.."\nSpeed display (BPM*Mod): "..speedvalue);
						--	self:settext("Speed Modifier:\n"..curmod.."\nSpeed display (BPM X Mod):\n"..speedvalue);
					end;
				end;
				PlayerJoinedMessageCommand=cmd(playcommand,"On";);
				CurrentSongChangedMessageCommand=cmd(playcommand,"On";);
				CodeMessageCommand=cmd(playcommand,"On";);
				OptionsListClosedMessageCommand=cmd(playcommand,"On";);
				SongChosenMessageCommand=cmd(playcommand,"On";);
			};
			LoadFont("Common normal")..{								--"Machine Top Score:" text
				Text="Machine Top Score:";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);x,infx+txxtune;y,-infy+txytune+110;zoom,0.5;skewx,-0.25;horizalign,left;vertalign,top;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
			};
			LoadFont("_roboto Bold 54px")..{							--Machine Top Score (numbers)
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);x,infx+txxtune;y,-infy+txytune+125;zoom,1/4;skewx,-0.25;horizalign,left;vertalign,top;queuecommand,"Set";);
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
				CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
				SetCommand=function(self)
					local cursong =	GAMESTATE:GetCurrentSong();
					-- ROAD24: Checks
					-- TODO: decide what to do whe no son g is selected
					if cursong ~= nil then
						if cursong:IsLong() then
							stagemaxscore = 200000000
						elseif cursong:IsMarathon() then
							stagemaxscore = 300000000
						else
							stagemaxscore = 100000000
						end
						profile = PROFILEMAN:GetMachineProfile();
						-- ROAD24: agrego algunas cosas para evitar acceder un nil
						local CurSteps = GAMESTATE:GetCurrentSteps(PLAYER_2);
						local CurSong = GAMESTATE:GetCurrentSong();
						if CurSteps and CurSong then
							scorelist = profile:GetHighScoreList(CurSong,CurSteps);
							local scores = scorelist:GetHighScores();
							local topscore = scores[1];
							if topscore then
							--	if topscore >= stagemaxscore then		--temporary workaround
							--		pscore = stagemaxscore
							--	else
									pscore = topscore:GetScore();
							--	end
							else
								pscore = "0";
							end
							local percen = tonumber(string.format("%.03f",((pscore/stagemaxscore)*100)));
							if topscore then
								self:settext(pscore.." - "..percen.."%");
							else
								self:settext("0");
							end;
						else
							self:settext("0");
						end;
					end;
				end
			};
			LoadFont("venacti/_venacti_outline 26px bold diffuse")..{	--Machine Top Score HOLDER (name)
				InitCommand=cmd(x,infx+txxtune;y,-infy+txytune+10+3+20+75+12+15;zoom,0.5;skewx,-0.25;horizalign,left;vertalign,top;queuecommand,"Set";);
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
				CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
				SetCommand=function(self)
					if GAMESTATE:GetCurrentSong() then
						profile = PROFILEMAN:GetMachineProfile();
						-- ROAD24: more checks
						local CurSteps = GAMESTATE:GetCurrentSteps(PLAYER_2);
						local CurSong	= GAMESTATE:GetCurrentSong();
						if CurSteps then
							scorelist = profile:GetHighScoreList(CurSong,CurSteps);
							local scores = scorelist:GetHighScores();
							local topscore = scores[1];
							if topscore then
								if topscore == "" then
									text = "Record holder: NONAME"		--to do: fix
								else
									text = "Record holder: "..topscore:GetName();
								end
							else
								text = "No Score";
							end;
						--	if text == "#P1#" then
							if text == "EVNT" then
						--	if text == "EVNT" or "#P1#" then		--value stucks
								self:settext(newranktext);
							else
								self:settext(text);
							end--]]
						end;
					end;
				end;
			};
		};
		Def.Quad{		--White for Chart info P2 EFFECT JOINED
			InitCommand=function(self)
				if GAMESTATE:IsHumanPlayer(PLAYER_2) then
					self:visible(false);
				else
					self:visible(true);
				end;
				(cmd(horizalign,left;fadetop,infft;fadebottom,inffb;x,infx;y,-infy;
					 zoomto,bqwid,bqalt-redu;diffuse,1,1,1,0;blend,'BlendMode_Add';))(self)
			end;
			PlayerJoinedMessageCommand=function(self)
				(cmd(zoomy,(bqalt-redu)*1.25;diffuse,1,1,1,1;decelerate,0.75;zoomy,(bqalt-redu)*0.925;diffuse,1,1,1,0))(self)
			end;
		};
	};
	
	--[[
	Def.ActorFrame{		--Current Song display
	 --with some code from DDRSOLO2000HD theme		<-- internal references
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{	-- CURRENT SONG NAME
			InitCommand=cmd(x,_screen.cx;y,_screen.cy+172;zoom,0.75;maxwidth,(_screen.w*1);skewx,-0.25);
			
			CurrentCourseChangedMessageCommand=function(self)
			local course = GAMESTATE:GetCurrentCourse()
				if course then
					self:settext(course:GetDisplayFullTitle());
					self:finishtweening();self:diffusealpha(0);
					self:x(_screen.cx+75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;
		};
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{	-- CURRENT SONG ARTIST
			InitCommand=cmd(x,_screen.cx;y,_screen.cy+172+25;zoom,0.6;maxwidth,(_screen.w*1);skewx,-0.25);

			CurrentCourseChangedMessageCommand=function(self)
			local course = GAMESTATE:GetCurrentCourse();
				if course then
					self:settext(course:GetDisplayArtist());
					self:finishtweening();self:diffusealpha(0);
					self:x(_screen.cx-75);self:sleep(0.25);self:decelerate(0.75);self:x(_screen.cx);self:diffusealpha(1);
				else
					self:stoptweening();self:linear(0.25);self:diffusealpha(0);
				end;
			end;
			
		};
	};
	--]]
};

 
t[#t+1] = Def.ActorFrame{		--OpList
		CodeMessageCommand = function(self, params)
			if params.Name == 'OptionList' then
				SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
			end;
		end;
	Def.ActorFrame{		--PLAYER 1 OpList
		Def.Quad{			--Fondo difuminado
			InitCommand=cmd(draworder,998;diffuse,0,0,0,0.75;xy,SCREEN_LEFT-olwid,_screen.cy;zoomto,olwid,olhei;horizalign,left
							fadetop,oltfad;fadebottom,olbfad);
			OptionsListOpenedMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					setenv("currentplayer",PLAYER_1);
					self:decelerate(olania);
					self:x(SCREEN_LEFT);
				end
			end;
			OptionsListClosedMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
		--			setenv("currentplayer",PLAYER_1);	--I think setting it again isn't necessary -NIKK
					self:stoptweening();
					self:accelerate(olanib);
					self:x(SCREEN_LEFT-olwid);
				end;
			end;
		};
		LoadFont("venacti/_venacti 26px bold diffuse")..{	--Texto "OPTION LIST"
			Text="OPTION LIST";
			InitCommand=cmd(draworder,999;x,SCREEN_LEFT-olwid;y,_screen.cy-(olhei/2.25)+20;zoom,0.75;);
			OptionsListOpenedMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					setenv("currentplayer",PLAYER_1);
					self:decelerate(olania);
					self:x(SCREEN_LEFT+(olwid/2));
				end;
			end;
			OptionsListClosedMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
		--			setenv("currentplayer",PLAYER_1);	--I think setting it again isn't necessary -NIKK
					self:stoptweening();
					self:accelerate(olanib);
					self:x(SCREEN_LEFT-(olwid/2));
				end
			end;
		};
	};
	Def.ActorFrame{		--PLAYER 2 OpList
		Def.Quad{			--Fondo difuminado
			InitCommand=cmd(draworder,998;diffuse,0,0,0,0.75;xy,SCREEN_RIGHT+olwid,_screen.cy;zoomto,olwid,olhei;horizalign,right
							fadetop,oltfad;fadebottom,olbfad);
			OptionsListOpenedMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					setenv("currentplayer",PLAYER_2);
					self:decelerate(olania);
					self:x(SCREEN_RIGHT);
				end;
			end;
			OptionsListClosedMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
		--			setenv("currentplayer",PLAYER_2);	--I think setting it again isn't necessary -NIKK
					self:stoptweening();
					self:accelerate(olanib);
					self:x(SCREEN_RIGHT+olwid);
				end;
			end;
		};
		LoadFont("venacti/_venacti 26px bold diffuse")..{	--Texto "OPTION LIST"
			Text="OPTION LIST";
			InitCommand=cmd(draworder,999;x,SCREEN_RIGHT+olwid;y,_screen.cy-(olhei/2.25)+20;zoom,0.75;);
			OptionsListOpenedMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
					setenv("currentplayer",PLAYER_2);
					self:decelerate(olania);
					self:x(SCREEN_RIGHT-(olwid/2));
				end;
			end;
			OptionsListClosedMessageCommand=function(self,params)
				if params.Player == PLAYER_2 then
		--			setenv("currentplayer",PLAYER_2);	--I think setting it again isn't necessary -NIKK
					self:stoptweening();
					self:accelerate(olanib);
					self:x(SCREEN_RIGHT+(olwid/2));
				end;
			end;
		};
	};
};


--[[LOOP SOUND

t[#t+1] = LoadActor("fire.lua")..{
		InitCommand=cmd(visible,false);
		OffCommand=function(self)
			self:visible(true);
		end;
	};

t[#t+1] = LoadActor(THEME:GetPathS("","bgsound"))..{
	OnCommand=cmd(stop);
	CheckCoursePreviewMessageCommand=function(self)
			self:stoptweening();
			self:stop();
			self:sleep(2);
			self:play();
	end;
	CurrentCourseChangedMessageCommand=cmd(stoptweening;stop);
	OffCommand=cmd(stoptweening;stop);
};
--]]


return t
