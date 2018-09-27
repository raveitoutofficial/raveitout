local t = Def.ActorFrame {
	InitCommand=function(self)
		state = 1;
	end
};
local function MsgScroll()
	local index = 1
	return LoadActor("help_info/msg_1")..{
		SetCommand=function(self)
			index = index+1
			path = "/Themes/RioTI/Bganimations/ScreenSelectMusic overlay/help_info/";
			total = #FILEMAN:GetDirListing(path)-3
			if getenv("PlayMode") == "Easy" then
				path = "/Themes/RioTI/Bganimations/ScreenSelectMusic overlay/help_info/easy/";
				total = #FILEMAN:GetDirListing(path)
			end
			if index > total then index = 1 end
			
			self:Load(path.."msg_"..index..".png");
			self:linear(0.2);
			self:diffusealpha(1);
			self:sleep(2);
			self:linear(0.2)
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
	}		
end;

--HAS THIS GUY EVER HEARD OF METRICS???
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
local bpmalt = 	_screen.cy+55			--Y value for BPM Display below banner

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
t[#t+1] = LoadActor("songPreview");


---DECORATIONS IN GENERAL
t[#t+1] = Def.ActorFrame {
	--MSG INFO
	LoadActor("help_info/txt_box")..{
		InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-50;zoomx,0.9;zoomy,0.65);
	};
	
	MsgScroll()..{
		InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-50;zoom,0.6;queuecommand,"Set");
	};
	
	--TIME
	LoadFont("monsterrat/_montserrat light 60px")..{
			Text="TIME";
			InitCommand=cmd(x,SCREEN_CENTER_X-25;y,SCREEN_BOTTOM-92;zoom,0.6;skewx,-0.2);
		};

	
	--Current Group/Playlist
	LoadActor("current_group")..{
		InitCommand=cmd(x,SCREEN_LEFT;y,SCREEN_TOP+5;horizalign,left;vertalign,top;zoomx,1;cropbottom,0.3);
	};
	
	LoadFont("monsterrat/_montserrat light 60px")..{	
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+18;y,SCREEN_TOP+10;zoom,0.185;skewx,-0.1);
		CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
			if song then
				self:uppercase(true);
				self:settext("Current songlist");
			end
		end;
	};
	
	LoadFont("monsterrat/_montserrat semi bold 60px")..{	
		InitCommand=cmd(horizalign,left;x,SCREEN_LEFT+16;y,SCREEN_TOP+30;zoom,0.6;skewx,-0.25);
		CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
			if song then
				self:uppercase(true);
				cur_group = GAMESTATE:GetCurrentSong():GetGroupName();
				
				if string.find(cur_group,"Rave It Out") then
					self:settext(string.sub(cur_group, 17, string.len(cur_group)-1));
				else
					self:settext(string.sub(cur_group, 4, string.len(cur_group)));
				end;
			end
		end;
	};
 };
 
t[#t+1] = Def.ActorFrame{

	--[[
	LoadFont("Common normal")..{	--formatted stage display
		InitCommand=cmd(xy,_screen.cx,_screen.cy-190;zoomx,0.75;zoomy,0.65);
		OnCommand=function(self)
			local stageNum=GAMESTATE:GetCurrentStageIndex()
			if stageNum < 10 then stg = "0"..stageNum+1 else stg = stageNum+1 end;
			
			if DevMode() then curstage = "DevMode - Stage: "..stg
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
		
		LoadActor("p1_info")..{		--P1 INFO
			InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);horizalign,left;zoomto,250,45;x,-320;y,-235;faderight,1;);
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1));
		};
		
		
		LoadActor("ready")..{		--P1 READY
			InitCommand=cmd(visible,false;horizalign,center;x,-260;y,-150);
			StepsChosenMessageCommand=function(self,param)
				if param.Player == PLAYER_1 and GAMESTATE:GetNumSidesJoined() == 2 then
					self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
				end;
			end;
			StepsUnchosenMessageCommand=cmd(visible,false);
			SongUnchosenMessageCommand=cmd(visible,false);
			CurrentStepsP1ChangedMessageCommand=cmd(visible,false);
		};
		
		LoadFont("bebas/_bebas neue bold 90px")..{		--"NOT PRESENT" text
			Text="NOT PRESENT";
			InitCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_1);x,-_screen.cx*0.7;y,-infy;zoom,0.3;skewx,-0.2);
			PlayerJoinedMessageCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_1));
		};
		Def.ActorFrame{		--Chart Info and more for P1
			InitCommand=cmd(y,-diffy);
			LoadFont("monsterrat/_montserrat semi bold 60px")..{	--Artist text
				InitCommand=cmd(x,-120;y,-170;zoom,0.215;uppercase,true;maxwidth,400);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"CurrentStepsP1ChangedMessage");
				CurrentStepsP1ChangedMessageCommand=function(self)
				--	local author = GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit()	--this is the Thor that is the auThor... lol get it? yes but... ah ok...
																							--lolXD  - road
					-- TODO: there's a special error only when reloading the screen, should i avoid or fix ??
					if GAMESTATE:IsCourseMode() and GetCourseDescription(GAMESTATE:GetCurrentCourse():GetCourseDir(),"DESCRIPTION") ~= "" then
						author = GAMESTATE:GetCurrentCourse():GetScripter();
						if author == "" then
								artist = "Not available\n...wait what? Are you freaking serious?"
								self:maxwidth(1000);
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

					if GAMESTATE:GetCurrentSteps(PLAYER_1) then
					author = GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit();		--Cortes got lazy and opt to use Description tag lol
						if GAMESTATE:GetCurrentSong() then		--set text display
							if author == "" then
								artist = "Not available\n...wait what? Are you freaking serious?"
								self:maxwidth(1000);
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
							self:visible(false);
						end;
					end;
					end;
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
				OnCommand=function(self)
					list = GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG1").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG2").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG3").."\n"..GetCourseDescription(THEME:GetCurrentThemeDirectory().."BGAnimations/ScreenSelectCourse decorations/courses_list.txt","SONG4");
					if GAMESTATE:IsCourseMode() then
						self:settext(list)
					else
						self:settext("");
					end;
				end;
			};

			LoadFont("monsterrat/_montserrat semi bold 60px")..{								--SPEEDMOD Display
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);x,infx+txxtune;addx,-120;y,-infy+txytune+10+3+20;addy,26.25;zoom,0.185;vertalign,top;maxwidth,900);
				OnCommand=function(self)
					local profilep = PROFILEMAN:GetProfileDir("ProfileSlot_Player1")
					local song = GAMESTATE:GetCurrentSong();
					if song then
						local songpath = song:GetSongDir();
						local pathlastsmod = File.Read(profilep.."RIO_SongData"..songpath.."LastSpeedModUsed.txt")
						local lastspeedmod = pathlastsmod
						if lastspeedmod == nil then		--account for nil value
							lastspeedmod = "N/A"
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
						self:settext("PREVIOUS SPEEDMOD: "..lastspeedmod.."\nCURRENT SPEEDMOD: "..curmod.."\nSPEED DISPLAY (BPM*MOD): "..speedvalue);
					end;
				end;
				PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"On";);
				CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"On";);
				CodeMessageCommand=cmd(finishtweening;playcommand,"On";);
				OptionsListClosedMessageCommand=cmd(finishtweening;playcommand,"On";);
				SongChosenMessageCommand=cmd(finishtweening;playcommand,"On";);
			};
			LoadFont("monsterrat/_montserrat semi bold 60px")..{							--Machine Top Score (numbers)
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);x,-infx-txxtune;y,-infy+txytune+123;addy,5;zoom,0.25;skewx,-0.25;horizalign,right;vertalign,top;queuecommand,"Set";);
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");

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
							--self:settext(pscore.." - "..percen.."%");
							self:settext(pscore);
						else
							self:settext("0");
						end;
					end;
				end;
			};
			LoadFont("monsterrat/_montserrat semi bold 60px")..{	--Machine Top Score HOLDER (name)
				InitCommand=cmd(x,-infx-txxtune;y,-infy+txytune+10+3+20+75+12+15;addy,5;zoom,0.25;skewx,-0.25;horizalign,right;vertalign,top;queuecommand,"Set";);
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
				CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
				SetCommand=function(self)
					if GAMESTATE:GetCurrentSong() and GAMESTATE:IsPlayerEnabled(PLAYER_1) then
						profile = PROFILEMAN:GetMachineProfile();
						scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_1));
						local scores = scorelist:GetHighScores();
						local topscore = scores[1];
						
						if topscore then
							text = topscore:GetName();
						else
							text = "No Score";
						end
			
						self:diffusealpha(1);
						if text=="EVNT" then
							self:settext("Score holder: MACHINE BEST");
						elseif text == "#P1#" or text == "" then
							self:settext("Score holder: "..PROFILEMAN:GetProfile(PLAYER_1):GetDisplayName());
						else
							self:settext(text);
						end
						--TEMP:
						self:settext("BEST GRADE:");
					end;
				end;
			};
			
			Def.Sprite {
	InitCommand=cmd(x,-infx-txxtune;y,-infy+txytune+10+3+20+75+12+15+15;addy,10;zoom,0.15;horizalign,right;vertalign,top;queuecommand,"Set";);
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_1);queuecommand,"Set");
	SetCommand=function(self)
	local song = GAMESTATE:GetCurrentSong();
		if song then
			self:diffusealpha(1);
			profile = PROFILEMAN:GetMachineProfile();
			scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_1));
			assert(scorelist);
			local scores = scorelist:GetHighScores();
			local topscore = scores[1];
			
				if topscore then 
							
							local dancepoints = topscore:GetPercentDP()*100
							local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
							local grade;

					if dancepoints >= 50 then
						grade = "D";
						if dancepoints >= 60 then
							grade = "C";
							if dancepoints >= 70 then
								grade = "B";
								if dancepoints >= 80 then
									grade = "A";
									if misses==0 then
										grade = "S_normal";
										if dancepoints >= 99 then
											grade = "S_plus";
											if dancepoints == 100 then
												grade = "S_S";
											end
										end
									end
								end	
							end
						end
					else 
						grade = "F";
					end

				self:Load(THEME:GetPathG("","GradeDisplayEval/"..grade));
			else
				--if no score
				self:diffusealpha(0);
			end
		else
			--if no song
			self:diffusealpha(0);
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
		
		LoadActor("p2_info")..{		--P2 INFO
			InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);horizalign,right;zoomto,250,45;x,320;y,-235;fadeleft,1;);
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2));
		};
		
		LoadActor("ready")..{		--P2 READY
			InitCommand=cmd(visible,false;horizalign,center;x,260;y,-150);
			StepsChosenMessageCommand=function(self,param)
				if param.Player == PLAYER_2 and GAMESTATE:GetNumSidesJoined() == 2 then
					self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2));
				end;
			end;
			StepsUnchosenMessageCommand=cmd(visible,false);
			SongUnchosenMessageCommand=cmd(visible,false);
			CurrentStepsP2ChangedMessageCommand=cmd(visible,false);
		};
		
		LoadFont("bebas/_bebas neue bold 90px")..{		--"NOT PRESENT" text
			Text="NOT PRESENT";
			InitCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_2);x,_screen.cx*0.7;y,-infy;zoom,0.3;skewx,-0.2);
			PlayerJoinedMessageCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_2););
		};
		Def.ActorFrame{		--Chart Info and more for P2
		InitCommand=cmd(y,-diffy);
			LoadFont("monsterrat/_montserrat semi bold 60px")..{	--Artist text
				InitCommand=cmd(x,120;y,-170;zoom,0.215;uppercase,true;maxwidth,400);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"CurrentStepsP2ChangedMessage");
				CurrentStepsP2ChangedMessageCommand=function(self)
				--	local author = GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit()	--this is the Thor that is the auThor... lol get it? yes but... ah ok...
					if GAMESTATE:IsCourseMode() and GetCourseDescription(GAMESTATE:GetCurrentCourse():GetCourseDir(),"DESCRIPTION") ~= "" then
						author = GAMESTATE:GetCurrentCourse():GetScripter();
						if author == "" then
								artist = "Come on, how irresponsible could you be\nto not include the step artist name?"
								self:maxwidth(1000);
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
								artist = "Come on, how irresponsible could you be\nto not include the step artist name?"
								self:maxwidth(1000);
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

			LoadFont("monsterrat/_montserrat semi bold 60px")..{								--SPEEDMOD Display
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);x,infx+txxtune;addx,100;y,-infy+txytune+10+3+20;zoom,0.185;addy,26.25;vertalign,top;maxwidth,900);
				OnCommand=function(self)
					local profilep = PROFILEMAN:GetProfileDir("ProfileSlot_Player2")
					local song = GAMESTATE:GetCurrentSong();
					-- ROAD24: more checks
					if song then
						local songpath = song:GetSongDir()
						local pathlastsmod = File.Read(profilep.."RIO_SongData"..songpath.."LastSpeedModUsed.txt")
						local lastspeedmod = pathlastsmod
						if lastspeedmod == nil then		--account for nil value
							lastspeedmod = "N/A"
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
						self:settext("PREVIOUS SPEEDMOD: "..lastspeedmod.."\nCURRENT SPEEDMOD: "..curmod.."\nSPEED DISPLAY (BPM*MOD): "..speedvalue);
						--	self:settext("Speed Modifier:\n"..curmod.."\nSpeed display (BPM X Mod):\n"..speedvalue);
					end;
				end;
				PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"On";);
				CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"On";);
				CodeMessageCommand=cmd(finishtweening;playcommand,"On";);
				OptionsListClosedMessageCommand=cmd(finishtweening;playcommand,"On";);
				SongChosenMessageCommand=cmd(finishtweening;playcommand,"On";);
			};
			LoadFont("monsterrat/_montserrat semi bold 60px")..{							--Machine Top Score (numbers)
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);x,infx+txxtune;y,-infy+txytune+123;addy,5;zoom,0.25;skewx,-0.25;horizalign,left;vertalign,top;queuecommand,"Set";);
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
								--self:settext(pscore.." - "..percen.."%");
								self:settext(pscore);
							else
								self:settext("0");
							end;
						else
							self:settext("0");
						end;
					end;
				end
			};
			LoadFont("monsterrat/_montserrat semi bold 60px")..{	--Machine Top Score HOLDER (name)
				InitCommand=cmd(x,infx+txxtune;y,-infy+txytune+10+3+20+75+12+15;addy,5;zoom,0.25;skewx,-0.25;horizalign,left;vertalign,top;queuecommand,"Set";);
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
							text = topscore:GetName();
						else
							text = "No Score";
						end
			
						self:diffusealpha(1);
						if text=="EVNT" then
							self:settext("Score holder: MACHINE BEST");
						elseif text == "#P2#" or text == "" then
							self:settext("Score holder: "..PROFILEMAN:GetProfile(PLAYER_2):GetDisplayName());
						else
							self:settext(text);
						end
						--TEMP:
						self:settext("BEST GRADE:");
					end;
					end;
				end;
			};
			
					Def.Sprite {
	InitCommand=cmd(x,infx+txxtune;y,-infy+txytune+10+3+20+75+12+15+15;addy,10;zoom,0.15;horizalign,left;vertalign,top;queuecommand,"Set";);
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	CurrentStepsP2ChangedMessageCommand=cmd(queuecommand,"Set");
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(PLAYER_2);queuecommand,"Set");
	SetCommand=function(self)
	local song = GAMESTATE:GetCurrentSong();
		if song then
			self:diffusealpha(1);
			profile = PROFILEMAN:GetMachineProfile();
			scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(PLAYER_2));
			assert(scorelist);
			local scores = scorelist:GetHighScores();
			local topscore = scores[1];
			
				if topscore then 
							
							local dancepoints = topscore:GetPercentDP()*100
							local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
							local grade;

					if dancepoints >= 50 then
						grade = "D";
						if dancepoints >= 60 then
							grade = "C";
							if dancepoints >= 70 then
								grade = "B";
								if dancepoints >= 80 then
									grade = "A";
									if misses==0 then
										grade = "S_normal";
										if dancepoints >= 99 then
											grade = "S_plus";
											if dancepoints == 100 then
												grade = "S_S";
											end
										end
									end
								end	
							end
						end
					else 
						grade = "F";
					end

				self:Load(THEME:GetPathG("","GradeDisplayEval/"..grade));
			else
				--if no score
				self:diffusealpha(0);
			end
		else
			--if no song
			self:diffusealpha(0);
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

};



t[#t+1] = Def.ActorFrame{			
	LoadActor("tab-step")..{		--This is my big surprise secret remodel lmfao -Gio
			InitCommand=cmd(zoom,0.35;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-125;diffusealpha,0);
			SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
			SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	};
	LoadActor("tab-speed")..{		--Fancy, eh?
			InitCommand=cmd(zoom,0.35;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-70;diffusealpha,0);
			SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
			SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	};
	LoadActor("tab-score")..{		--I hope people like it!
			InitCommand=cmd(zoom,0.35;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffusealpha,0);
			SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
			SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	};
}

--Difficulty List Orbs Shadows
for i=1,12 do
	t[#t+1] = LoadActor("DifficultyList/background_orb") .. {
		InitCommand=cmd(diffusealpha,0.5;zoom,0.7;x,_screen.cx-245+i*35;y,_screen.cy+107;horizalign,left);
	};
end;
--Difficulty List Orbs
t[#t+1] = Def.ActorFrame{			
	LoadActor("DifficultyList")..{
		OnCommand=cmd(finishtweening;sleep,0.1;playcommand,"Update");
		UpdateCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			if song then
				self:stoptweening();
				self:rotationz(270);
				self:linear(0.1);
				self:x(_screen.cx-187);
				self:y(_screen.cy+105);
				self:zoom(0.7);
			end;
		end;
		TwoPartConfirmCanceledMessageCommand=cmd(finishtweening;playcommand,"SongUnchosenMessage");
		SongUnchosenMessageCommand=cmd(stoptweening;decelerate,0.1;playcommand,"Update");
		PlayerJoinedMessageCommand=cmd(finishtweening;playcommand,"Update");
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Update");
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Update");
		CurrentSongChangedMessageCommand=cmd(finishtweening;playcommand,"Update");

	};
}

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
		LoadFont("bebas/_bebas neue bold 90px")..{	--Texto "OPTION LIST"
			Text="OPTION LIST";
			InitCommand=cmd(draworder,999;x,SCREEN_LEFT-olwid;y,_screen.cy-(olhei/2.25)+20;zoom,0.35;);
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
		LoadFont("bebas/_bebas neue bold 90px")..{	--Texto "OPTION LIST"
			Text="OPTION LIST";
			InitCommand=cmd(draworder,999;x,SCREEN_RIGHT+olwid;y,_screen.cy-(olhei/2.25)+20;zoom,0.35;);
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
 
t[#t+1] = LoadActor("code_detector.lua")..{};
--t[#t+1] = LoadActor("PlayerMods")..{};
t[#t+1] = LoadActor("GenreSounds.lua")..{};
if getenv("PlayMode") == "Arcade" or getenv("PlayMode") == "Pro" then 
	--TODO: SHOWSTOPPER: This causes a giant lag spike, needs investigation
	--t[#t+1] = LoadActor("channel_system")..{};
end;

t[#t+1] = LoadActor(THEME:GetPathG("","USB_stuff"))..{};

t[#t+1] = LoadActor("ready")..{		-- 1 PLAYER JOINED READY
			InitCommand=cmd(visible,false;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;zoom,2;);
			WaitingConfirmMessageCommand=cmd(playcommand,"Ready";);
			StepsChosenMessageCommand=cmd(playcommand,"Ready";);
			ReadyCommand=function(self)
				if GAMESTATE:GetNumSidesJoined() == 1 and state > 1 then
					self:stoptweening();
					self:visible(false);
					self:zoom(1);
					self:linear(0.3);
					self:zoom(2);
					self:visible(true);
				end;
			end;
			CurrentSongChangedMessageCommand=cmd(visible,false);
			StepsUnchosenMessageCommand=cmd(visible,false);
			SongUnchosenMessageCommand=cmd(visible,false);
		};

ready_index = 1;
		
t[#t+1] = LoadActor("ready/ready_shine/effect (1)")..{
	InitCommand=cmd(diffusealpha,0;horizalign,center;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;);
	OffCommand=function(self,param)
		self:stoptweening();
		self:Load(nil);
		self:zoom(1);
		self:diffusealpha(1);
		self:sleep(0.03);
		self:Load(THEME:GetCurrentThemeDirectory().."Bganimations/ScreenSelectMusic overlay/ready/ready_shine/effect ("..ready_index..").png");
		if ready_index > 12 then
			self:stoptweening();
			ready_index = 1;
			self:Load(THEME:GetPathG("","_white"));
			self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
		else
			ready_index = ready_index+1
			self:queuecommand("Off");
		end;
	end;
};

t[#t+1] = Def.ActorFrame{

	--PLAYER 1
	LoadActor("DifficultyList/background_orb")..{
		InitCommand=cmd(visible,false;horizalign,center;zoom,0.7;x,SCREEN_WIDTH/7;y,SCREEN_CENTER_Y+107);
		OnCommand = function(self, params)
			if getenv("PlayMode") == "Easy" and GAMESTATE:IsSideJoined(PLAYER_1) then self:visible(true); end;
		end;
		OffCommand=function(self,param)
			self:linear(0.3);
			self:Load(THEME:GetPathG("","_white"));
		end;
	};
	
	LoadFont("facu/_zona pro bold 20px")..{
		InitCommand=cmd(uppercase,true;visible,false;horizalign,center;zoom,0.45;x,SCREEN_WIDTH/7;y,SCREEN_CENTER_Y+107);
		OnCommand = function(self, params)
			if getenv("PlayMode") == "Easy" and GAMESTATE:IsSideJoined(PLAYER_1) then self:settext("Speed:\n"..GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():XMod().."x"); self:visible(true); end;
		end;
		CodeMessageCommand = function(self, params)
			if getenv("PlayMode") == "Easy" and GAMESTATE:IsSideJoined(PLAYER_1) then self:settext("Speed:\n"..GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():XMod().."x"); self:visible(true); end;
		end;
	};
	
	--PLAYER 2
	LoadActor("DifficultyList/background_orb")..{
		InitCommand=cmd(visible,false;horizalign,center;zoom,0.7;x,SCREEN_RIGHT-SCREEN_WIDTH/7;y,SCREEN_CENTER_Y+107);
		OnCommand = function(self, params)
			if getenv("PlayMode") == "Easy" and GAMESTATE:IsSideJoined(PLAYER_2) then self:visible(true); end;
		end;
		OffCommand=function(self,param)
			self:linear(0.3);
			self:Load(THEME:GetPathG("","_white"));
		end;
	};
	
	LoadFont("facu/_zona pro bold 20px")..{
		InitCommand=cmd(uppercase,true;visible,false;horizalign,center;zoom,0.45;x,SCREEN_RIGHT-SCREEN_WIDTH/7;y,SCREEN_CENTER_Y+107);
		OnCommand = function(self, params)
			if getenv("PlayMode") == "Easy" and GAMESTATE:IsSideJoined(PLAYER_2) then self:settext("Speed:\n"..GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():XMod().."x"); self:visible(true); end;
		end;
		CodeMessageCommand = function(self, params)
			if getenv("PlayMode") == "Easy" and GAMESTATE:IsSideJoined(PLAYER_2) then self:settext("Speed:\n"..GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():XMod().."x"); self:visible(true); end;
		end;
	};
};
if getenv("PlayMode") == "Easy" then
	t[#t+1] = 	LoadActor("channel_system/arrows")..{};	
end;

--[[

t[#t+1] = LoadActor("new_song") ..{

	InitCommand=cmd(zoom,0.1;visible,false;x,SCREEN_CENTER_X+200;y,SCREEN_CENTER_Y-150;);
	CurrentSongChangedMessageCommand=function(self)
		if PROFILEMAN:IsSongNew(GAMESTATE:GetCurrentSong()) then self:visible(true); else self:visible(false); end;
	end;
};


t[#t+1] = LoadActor("_CommandWindow") ..{

	InitCommand=cmd(draworder,999;x,SCREEN_CENTER_Y;y,0;visible,false;setevn,"CW_Active","false");

	OptionsListOpenedMessageCommand = function(self, params)
		self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
		setenv("CW_Active","true");
	end;
	OptionsListClosedMessageCommand = function(self, params)
		self:visible(false);
		setenv("CW_Active","false") ;
	end;
};

--]]
return t
