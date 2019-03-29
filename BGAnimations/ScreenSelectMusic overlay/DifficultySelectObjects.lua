--This file handles the positioning of foreground objects when you're selecting a difficulty.
local pn,infx,infy = ...;
local txytune =		-25					--Text info altitude (Y axis) finetuning
local txxtune =		0.015625*_screen.w	--Text info separation from center (X axis) finetuning (must be always a positive value)	--20 equivalent is 0.03125*_screen.w (when using 4:3)
local saz =			0.75				--Chart info Step Artist Zoom ("saz! en toda la boca!")
local diffy =		40					--Object Y axis difference
local maxwidar =	_screen.cx*0.7	--Chart info Step Artist maxwidth value
local maxwidinf =	_screen.cx*1.1	--Chart info Text maxwidth value
local alignment = (pn == PLAYER_1) and right or left;
local negativeOffset = (pn == PLAYER_1) and 1 or -1;
local start = (pn == PLAYER_1) and SCREEN_LEFT or SCREEN_RIGHT;

return Def.ActorFrame{
		InitCommand=cmd(x,start;y,_screen.cy+110;vertalign,middle,horizalign,alignment);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,SCREEN_CENTER_X);
		SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,start;);
		
		LoadActor(pname(pn).."_info")..{		--PLAYER INFO
			InitCommand=cmd(horizalign,alignment;zoomto,250,45;x,-SCREEN_CENTER_X*negativeOffset;y,-235;);
			OnCommand=function(self)
				if pn == PLAYER_1 then
					self:faderight(1):horizalign(left);
				else
					self:fadeleft(1):horizalign(right);
				end;
			end;
			PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
		};
		
		
		LoadActor("ready")..{		--PLAYER READY
			InitCommand=cmd(visible,false;horizalign,center;x,-260;y,-150);
			StepsChosenMessageCommand=function(self,param)
				if param.Player == pn and GAMESTATE:GetNumSidesJoined() == 2 then
					self:visible(GAMESTATE:IsHumanPlayer(pn));
				end;
			end;
			StepsUnchosenMessageCommand=cmd(visible,false);
			SongUnchosenMessageCommand=cmd(visible,false);
			["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(visible,false);
		};
		Def.ActorFrame{		--Chart Info and more for P1
			InitCommand=cmd(y,-diffy);
			--Artist text
			LoadFont("monsterrat/_montserrat semi bold 60px")..{	
				InitCommand=cmd(x,-120*negativeOffset;y,-175;zoom,0.215;uppercase,true;maxwidth,900);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);queuecommand,"CurrentSteps"..pname(pn).."ChangedMessage");
				["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=function(self)
				--	local author = GAMESTATE:GetCurrentSteps(pn):GetAuthorCredit()	--this is the Thor that is the auThor... lol get it? yes but... ah ok...
																							--lolXD  - road
					-- TODO: there's a special error only when reloading the screen, should i avoid or fix ??
					if GAMESTATE:IsCourseMode() and GetCourseDescription(GAMESTATE:GetCurrentCourse():GetCourseDir(),"DESCRIPTION") ~= "" then
						author = GAMESTATE:GetCurrentCourse():GetScripter();
						if author == "" then
								artist = "Not available"
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
							self:visible(GAMESTATE:IsHumanPlayer(pn));
							self:settext(artist);
					else
						if GAMESTATE:GetCurrentSteps(pn) then
							author = GAMESTATE:GetCurrentSteps(pn):GetAuthorCredit();		--Cortes got lazy and opt to use Description tag lol
							if GAMESTATE:GetCurrentSong() then		--set text display
								if author == "" then
									artist = "Not available"
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
								self:visible(GAMESTATE:IsHumanPlayer(pn));
								self:settext(artist);
							else
								self:visible(false);
							end;
						end;
					end;
				end;
			};
			LoadFont("monsterrat/_montserrat semi bold 60px")..{	
				InitCommand=cmd(x,-120*negativeOffset;y,-160;zoom,0.215;uppercase,true;maxwidth,900);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);queuecommand,"CurrentSteps"..pname(pn).."ChangedMessage");
				["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=function(self)
					if GAMESTATE:IsCourseMode() and GetCourseDescription(GAMESTATE:GetCurrentCourse():GetCourseDir(),"DESCRIPTION") ~= "" then
						self:settext("TODO: Implement this");
					else
						if GAMESTATE:GetCurrentSteps(pn) then
							self:settext(StepsTypeToString(GAMESTATE:GetCurrentSteps(pn)));
							--self:settext("123456789012345678901234567890");
							self:visible(true);
						else
							self:visible(false);
						end;
					end;
				end;
			};

			LoadFont("Common normal")..{
				Text="Song List:";
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);x,-infx-txxtune;y,-infy+txytune+25;zoom,0.5;skewx,-0.25;horizalign,right;vertalign,top;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
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
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);x,-infx-txxtune;y,-infy+txytune+70;zoom,0.4;horizalign,right;vertalign,middle;);
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn));
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
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);x,(infx+txxtune-120)*negativeOffset;y,-infy+txytune+10+3+20;addy,26.25;zoom,0.185;vertalign,top;maxwidth,900);
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
						local xmod = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():XMod();
						local cmod = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():CMod();
						local mmod = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():MMod();
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
							curmod = mmod.." AV"
							speedvalue = mmod
						else
							curmod = xmod.."x"
							if lobpm == hibpm then
								speedvalue = lobpm*xmod
							else
								speedvalue = lobpm*xmod.." - "..hibpm*xmod
							end;
						end;
						self:visible(GAMESTATE:IsHumanPlayer(pn));
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
				InitCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);x,(-infx-txxtune)*negativeOffset;y,-infy+txytune+123;addy,5;zoom,0.25;skewx,-0.25;horizalign,alignment;vertalign,top;queuecommand,"Set";);
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");

				["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);queuecommand,"Set");
				SetCommand=function(self)
					-- ROAD24: and more checks
					-- TODO: decide what to do when no song is selected
					local cursong =	GAMESTATE:GetCurrentSong()
					if cursong and GAMESTATE:IsPlayerEnabled(pn) then
						if cursong:IsLong() then
							stagemaxscore = 200000000
						elseif cursong:IsMarathon() then
							stagemaxscore = 300000000
						else
							stagemaxscore = 100000000
						end;
						profile = PROFILEMAN:GetMachineProfile();
						scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(pn));
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
				InitCommand=cmd(x,(-infx-txxtune)*negativeOffset;y,-infy+txytune+10+3+20+75+12+15;addy,5;zoom,0.25;skewx,-0.25;horizalign,alignment;vertalign,top;queuecommand,"Set";);
				CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
				["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(queuecommand,"Set");
				PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);queuecommand,"Set");
				SetCommand=function(self)
					if GAMESTATE:GetCurrentSong() and GAMESTATE:IsPlayerEnabled(pn) then
						profile = PROFILEMAN:GetMachineProfile();
						scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(pn));
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
							self:settext("Score holder: "..PROFILEMAN:GetProfile(pn):GetDisplayName());
						else
							self:settext(text);
						end
						--TEMP:
						self:settext("BEST GRADE:");
					end;
				end;
			};
			
			Def.Sprite {
	InitCommand=cmd(x,(-infx-txxtune)*negativeOffset;y,-infy+txytune+10+3+20+75+12+15+15;addy,10;zoom,0.15;horizalign,alignment;vertalign,top;queuecommand,"Set";);
	CurrentSongChangedMessageCommand=cmd(queuecommand,"Set");
	["CurrentSteps"..pname(pn).."ChangedMessageCommand"]=cmd(queuecommand,"Set");
	PlayerJoinedMessageCommand=cmd(visible,GAMESTATE:IsHumanPlayer(pn);queuecommand,"Set");
	SetCommand=function(self)
	local song = GAMESTATE:GetCurrentSong();
		if song then
			self:diffusealpha(1);
			profile = PROFILEMAN:GetMachineProfile();
			scorelist = profile:GetHighScoreList(GAMESTATE:GetCurrentSong(),GAMESTATE:GetCurrentSteps(pn));
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
	};