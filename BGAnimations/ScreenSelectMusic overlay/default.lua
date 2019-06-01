local t = Def.ActorFrame {
	InitCommand=function(self)
		state = 1;
	end
};

--HAS THIS GUY EVER HEARD OF METRICS???
local stage =		GAMESTATE:GetCurrentStage()
--optionlist controls
local OPLIST_WIDTH =		THEME:GetMetric("CustomRIO","OpQuadWidth")		--option list quad width
local olania =		0.1			--optionlist animation time in
local olanib =		0.2			--optionlist animation time out
local olhei	=		SCREEN_HEIGHT*0.75	--optionlist quadheight
local oltfad =		0.125		--optionlist top fade value (0..1)
local olbfad =		0.5			--optionlist bottom fade value
local ollfad =		0			--optionlist left  fade value
local olrfad =		0			--optionlist right fade value
local OPLIST_splitAt = THEME:GetMetric("OptionsList","MaxItemsBeforeSplit")
--Start to shift the optionsList up at this row
local OPLIST_ScrollAt = 16
-- Chart info helpers
local infy =		160					--Chart info Y axis position (both players, includes black quad alt)
local infx =		0					--Chart info X DIFFERENCE FROM DISC
--quad stuff
local infft =		0.125*0.75			--Chart info quad fade top
local inffb =		infft				--Chart info quad fade bottom
local redu =		0					--Chart info vertical reduction value for black quad (pixels)
local bqwid =		_screen.cx			--Chart info quad width
local bqalt =		244-20				--Chart info black quad height
local bqalph =		0.9					--Chart info black quad diffusealpha value
local wqwid =		_screen.cx			--

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
	
	Def.Sprite{
		--Yeah I dunno why I have to specify the full path
		Texture=THEME:GetPathB("ScreenSelectMusic","overlay/help_info/messages 1x4.png");
		InitCommand=function(self)
			(cmd(x,_screen.cx;y,SCREEN_BOTTOM-50;zoom,.6;animate,false;setstate,0))(self);
			if getenv("PlayMode") == "Easy" then
				self:Load(THEME:GetPathB("ScreenSelectMusic","overlay/help_info/easymessages 1x4.png"));
			end;
		end;
		OnCommand=cmd(queuecommand,"Set");
		SetCommand=function(self)
			--I know hard coding stuff is bad, but there will only ever be 4 states...
			--And also, hide the setlist prompt if we're in Special mode, since there are no folders
			--in special mode.
			if self:GetState()+1 >= 4 or (getenv("PlayMode") == "Special" and self:GetState() == 2) then
				self:setstate(0);
			else
				self:setstate(self:GetState()+1);
			end;
			self:linear(0.2);
			self:diffusealpha(1);
			self:sleep(2);
			self:linear(0.2)
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
		
		TwoPartConfirmCanceledMessageCommand=cmd(playcommand,"PickingSong");
		SongUnchosenMessageCommand=cmd(playcommand,"PickingSong");
		PickingSongCommand=cmd(stoptweening;linear,.2;diffusealpha,1;sleep,2;linear,.2;diffusealpha,0;queuecommand,"Set");
		SongChosenMessageCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
	};
	
	Def.Sprite{
		Texture=THEME:GetPathB("ScreenSelectMusic","overlay/help_info/difficulty_messages 1x4.png");
		InitCommand=cmd(x,_screen.cx;y,SCREEN_BOTTOM-50;zoom,.6;animate,false;setstate,0;diffusealpha,0);
		SetCommand=function(self)
			--I know hard coding stuff is bad, but there will only ever be 4 states...
			--And also, hide the command window info if we're in Easy mode.
			if self:GetState()+1 >= 4 or (getenv("PlayMode") == "Easy" and self:GetState() == 2) then
				self:setstate(0);
			else
				self:setstate(self:GetState()+1);
			end;
			self:linear(0.2);
			self:diffusealpha(1);
			self:sleep(2);
			self:linear(0.2)
			self:diffusealpha(0);
			self:queuecommand("Set");
		end;
		TwoPartConfirmCanceledMessageCommand=cmd(playcommand,"PickingSong");
		SongUnchosenMessageCommand=cmd(playcommand,"PickingSong");
		PickingSongCommand=cmd(stoptweening;linear,.2;diffusealpha,0);
		SongChosenMessageCommand=cmd(stoptweening;linear,.2;diffusealpha,1;sleep,2;linear,.2;diffusealpha,0;queuecommand,"Set");
	
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
				self:settext(string.gsub(cur_group,"^%d%d? ?%- ?", ""));
				--[[if string.find(cur_group,"Rave It Out") then
					self:settext(string.sub(cur_group, 17, string.len(cur_group)-1));
				else
					self:settext(string.sub(cur_group, 4, string.len(cur_group)));
				end;]]
			end
		end;
	};
 };
 
t[#t+1] = LoadActor("arrow_shine");
t[#t+1] = Def.ActorFrame{

	--[[
	LoadFont("Common normal")..{	--formatted stage display
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

	--Left side background
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_LEFT;y,_screen.cy+110;vertalign,middle,horizalign,right);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,SCREEN_CENTER_X);
		SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,SCREEN_LEFT;);
		Def.Quad{		--white quad for Difficulties
			InitCommand=cmd(horizalign,right;zoomto,_screen.cx,35;diffuse,1,1,1,0.75;x,0;y,-3;fadeleft,1;);
		};
		
		Def.Quad{		--Black quad for Chart info P1
			InitCommand=cmd(horizalign,right;fadetop,infft;fadebottom,inffb;xy,-infx,-infy+20;zoomto,bqwid*2,bqalt+50;diffuse,0,0,0,bqalph;);
			--InitCommand=cmd(diffuse,color("0,0,0,"..bqalph);xy,0,SCREEN_CENTER_Y;horizalign,right;setsize,bqwid*2,bqalt+50;);
		};
		LoadFont("bebas/_bebas neue bold 90px")..{
			Text="NOT PRESENT";
			InitCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_1);x,-_screen.cx*0.7;y,-infy;zoom,0.3;skewx,-0.2);
			PlayerJoinedMessageCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_1));
		};
	};
	--Right side background
	Def.ActorFrame{
		InitCommand=cmd(x,SCREEN_RIGHT;y,_screen.cy+110;vertalign,middle,horizalign,left);
		SongChosenMessageCommand=cmd(stoptweening;decelerate,0.125;x,SCREEN_CENTER_X);
		SongUnchosenMessageCommand=cmd(stoptweening;accelerate,0.125*1.5;x,SCREEN_RIGHT;);
		Def.Quad{		--white quad for Difficulties
			InitCommand=cmd(horizalign,left;zoomto,_screen.cx,35;diffuse,1,1,1,0.75;x,0;y,-3;faderight,1;);
		};
		
		Def.Quad{		--Black quad for Chart info P1
			InitCommand=cmd(horizalign,left;fadetop,infft;fadebottom,inffb;xy,-infx,-infy+20;zoomto,bqwid*2,bqalt+50;diffuse,0,0,0,bqalph;);
			--InitCommand=cmd(diffuse,color("0,0,0,"..bqalph);xy,0,SCREEN_CENTER_Y;horizalign,right;setsize,bqwid*2,bqalt+50;);
		};
		LoadFont("bebas/_bebas neue bold 90px")..{
			Text="NOT PRESENT";
			InitCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_2);x,_screen.cx*0.7;y,-infy;zoom,0.3;skewx,-0.2);
			PlayerJoinedMessageCommand=cmd(visible,not GAMESTATE:IsHumanPlayer(PLAYER_2));
		};
	};
	Def.Quad{		--White for Chart info P1 EFFECT JOINED
		InitCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(PLAYER_2));
			(cmd(horizalign,right;fadetop,infft;fadebottom,inffb;x,-infx;y,-infy;
				 zoomto,bqwid,bqalt-redu;diffuse,1,1,1,0;blend,'BlendMode_Add';))(self)
		end;
		PlayerJoinedMessageCommand=function(self)
			(cmd(zoomy,(bqalt-redu)*1.25;diffuse,1,1,1,1;decelerate,0.75;zoomy,(bqalt-redu)*0.925;diffuse,1,1,1,0))(self)
		end;
	};
	Def.Quad{	--White for Chart info P2 EFFECT JOINED
		InitCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(PLAYER_1));
			(cmd(horizalign,left;fadetop,infft;fadebottom,inffb;x,infx;y,-infy;
				 zoomto,bqwid,bqalt-redu;diffuse,1,1,1,0;blend,'BlendMode_Add';))(self)
		end;
		PlayerJoinedMessageCommand=function(self)
			(cmd(zoomy,(bqalt-redu)*1.25;diffuse,1,1,1,1;decelerate,0.75;zoomy,(bqalt-redu)*0.925;diffuse,1,1,1,0))(self)
		end;
	};
};

t[#t+1] = Def.ActorFrame{			
	LoadActor("judge_back")..{		--This is my big surprise secret remodel lmfao -Gio
			InitCommand=cmd(zoom,0.35;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-124;diffusealpha,0);
			SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1);
			SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0);
	};
	LoadFont("facu/_zona pro bold 40px")..{
		Text="STEPS INFO";
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

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor("DifficultySelectObjects", pn, infx, infy);
end;

if getenv("PlayMode") == "Easy" then
	t[#t+1] = LoadActor("EasyDifficultyList")..{
		InitCommand=cmd(Center;addy,107;zoom,.4);
	};
else

	--Difficulty List Orbs Shadows
	for i=1,12 do
		t[#t+1] = LoadActor("DifficultyList/background_orb") .. {
			InitCommand=cmd(diffusealpha,0.85;zoom,0.375;x,_screen.cx-245+i*35;y,_screen.cy+107;horizalign,left);
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
	--Don't load if not used.
	if THEME:GetMetric("ScreenSelectMusic","UseCustomOptionsList") then
		t[#t+1] = LoadActor("CustomOptionsList");
	elseif THEME:GetMetric("ScreenSelectMusic","UseOptionsList") then
		local function CurrentNoteSkin(p)
			local state = GAMESTATE:GetPlayerState(p)
			local mods = state:GetPlayerOptionsArray( 'ModsLevel_Preferred' )
			local skins = NOTESKIN:GetNoteSkinNames()

			for i = 1, #mods do
				for j = 1, #skins do
					if string.lower( mods[i] ) == string.lower( skins[j] ) then
					   return skins[j];
					end
				end
			end
		end
		--OpList
		for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
			--This keeps the name of the current OptionsList because OptionsListLeft and OptionsListRight does not know what list this is otherwise
			local currentOpList
			--The amount of rows in the current optionsList menu.
			local numRows
			--This gets a handle on the optionsList Actor so it can be adjusted.
			local optionsListActor
			--If player 1, move towards left. If player 2, move towards right.
			local moveTowards = (pn == PLAYER_1) and SCREEN_LEFT+OPLIST_WIDTH/2 or SCREEN_RIGHT-OPLIST_WIDTH/2
			--The offscreen position.
			local startPosition = (pn==PLAYER_1) and moveTowards-OPLIST_WIDTH or moveTowards+OPLIST_WIDTH
			t[#t+1] = Def.ActorFrame{
				InitCommand=cmd(x,startPosition);
				OnCommand=function(self)
					--Named OptionsListP1 or OptionsListP2
					optionsListActor = SCREENMAN:GetTopScreen():GetChild("OptionsList"..pname(pn))
					--assert(optionsListActor,"No actor!")
				end;
				CodeMessageCommand = function(self, params)
					if params.Name == 'OptionList' then
						SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
					end;
				end;
				OptionsListOpenedMessageCommand=function(self,params)
					if params.Player == pn then
						setenv("currentplayer",pn);
						self:decelerate(olania);
						self:x(moveTowards);
					end
				end;
				OptionsListClosedMessageCommand=function(self,params)
					if params.Player == pn then
						self:stoptweening();
						self:accelerate(olanib);
						self:x(startPosition);
					end;
				end;
				Def.Quad{			--Fondo difuminado
					InitCommand=cmd(draworder,998;diffuse,0,0,0,0.75;y,_screen.cy;zoomto,OPLIST_WIDTH,olhei;fadetop,oltfad;fadebottom,olbfad);
				};
				LoadFont("bebas/_bebas neue bold 90px")..{	--Texto "OPTION LIST"
					Text="OPTION LIST";
					InitCommand=cmd(draworder,999;y,_screen.cy-(olhei/2.25);vertalign,bottom;zoom,0.35;);
				};
				
				LoadFont("Common Normal")..{
					--Text="Hello World!";
					InitCommand=cmd(draworder,999;y,_screen.cy-(olhei/2.25)+10;vertalign,top;zoom,.5;wrapwidthpixels,350);
					OptionsListOpenedMessageCommand=function(self,params)
						if params.Player == pn then
							currentOpList = "SongMenu"
							--This batshit code finds the value of [ScreenOptionsMaster] SongMenu,1
							self:settext(THEME:GetString("OptionExplanations",string.gsub(THEME:GetMetric("ScreenOptionsMaster",THEME:GetMetric("OptionsList","TopMenu")..",1"):split(";")[1],"name,","")))
						end;
					end;
					AdjustCommand=function(self,params)
						--SCREENMAN:SystemMessage(currentOpList..", "..params.Selection.." "..THEME:GetMetric("ScreenOptionsMaster",currentOpList..","..params.Selection+1))
						if params.Player == pn then
							if currentOpList == "SongMenu" or currentOpList == "System" then
								
								if params.Selection+1 <= numRows then
									local itemName = string.gsub(THEME:GetMetric("ScreenOptionsMaster",currentOpList..","..params.Selection+1):split(";")[1],"name,","")
									self:settext(THEME:GetString("OptionExplanations",itemName))
								else
									self:settext("Exit.");
								end;
							elseif currentOpList == "NoteSkins" then
								local curRow;
								--This global var is exported by OptionRowAvailableNoteskins()
								if OPLIST_splitAt < OPTIONSLIST_NUMNOTESKINS then
									curRow = math.floor((params.Selection)/2)+1
								else
									curRow = params.Selection+1
								end;
								--SCREENMAN:SystemMessage(curRow)
								if curRow>OPLIST_ScrollAt then
									optionsListActor:stoptweening():linear(.2):y((SCREEN_CENTER_Y-100)+THEME:GetMetric("OptionsList","ItemsSpacingY")*(OPLIST_ScrollAt-curRow))
								else
									optionsListActor:stoptweening():linear(.2):y(SCREEN_CENTER_Y-100)
								end;
							end;
						end;
						--SCREENMAN:SystemMessage(itemName)
					end;
					OptionsListRightMessageCommand=function(self,params)
						self:playcommand("Adjust",params);
					end;
					OptionsListLeftMessageCommand=function(self,params)
						self:playcommand("Adjust",params);
					end;
					
					OptionsListStartMessageCommand=function(self,params)
						if params.Player == pn then
							if currentOpList == "NoteSkins" then
								local curRow;
								--This global var is exported by OptionRowAvailableNoteskins()
								if OPLIST_splitAt < OPTIONSLIST_NUMNOTESKINS then
									curRow = math.floor((OPTIONSLIST_NUMNOTESKINS)/2)+1
								else
									curRow = OPTIONSLIST_NUMNOTESKINS+1
								end;
								--SCREENMAN:SystemMessage(curRow)
								if curRow>OPLIST_ScrollAt then
									optionsListActor:stoptweening():linear(.2):y((SCREEN_CENTER_Y-100)+THEME:GetMetric("OptionsList","ItemsSpacingY")*(OPLIST_ScrollAt-curRow))
								else
									optionsListActor:stoptweening():linear(.2):y(SCREEN_CENTER_Y-100)
								end;
							end;
						end;
					end;
					OptionsMenuChangedMessageCommand=function(self,params)
						--SCREENMAN:SystemMessage("MenuChanged: Menu="..params.Menu);
						if params.Player == pn then
							currentOpList=params.Menu
							optionsListActor:y(SCREEN_CENTER_Y-100) --Reset the positioning
							if params.Menu ~= "SongMenu" and params.Menu ~= "System" then
								self:settext(THEME:GetString("OptionExplanations",params.Menu))
							else
								--SCREENMAN:SystemMessage(params.Size);
								numRows = tonumber(THEME:GetMetric("ScreenOptionsMaster",currentOpList))
							end;
						end;
					end;
				};
				LoadFont("Common Normal")..{
					Text="Current Velocity:";
					InitCommand=cmd(draworder,999;y,_screen.cy-(olhei/2.25)+35;vertalign,top;zoom,.5;wrapwidthpixels,350;diffusebottomedge,Color("HoloBlue");visible,false);
					OnCommand=function(self,params)
						self:playcommand("UpdateText",{Player=pn});
					end;
					UpdateTextCommand=function(self,params)
						if params.Player == pn then
							if GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():MMod() then
								self:settext("Current Velocity: "..GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():MMod());
							else
								self:settext("Current Velocity: None");
							end;
						end;
					end;
					SpeedModChangedMessageCommand=function(self,params)
						if params.Player == pn and currentOpList == "SpeedMods" then
							self:playcommand("UpdateText",params);
						end;
					end;
					AdjustCommand=function(self,params)
						if currentOpList == "SongMenu" then
							if params.Selection == 5 then
								self:playcommand("UpdateText",params);
								self:visible(true);
							else
								self:visible(false);
							end;
						end;
					end;
					OptionsListRightMessageCommand=function(self,params)
						if params.Player == pn then
							self:playcommand("Adjust",params);
						end;
					end;
					OptionsListLeftMessageCommand=function(self,params)
						if params.Player == pn then
							self:playcommand("Adjust",params);
						end;
					end;
				};
				--For the combo judgement only
				Def.Sprite{
					InitCommand=cmd(y,SCREEN_CENTER_Y-116;draworder,999;zoom,.8);
					OptionsMenuChangedMessageCommand=function(self,params)
						if params.Player == pn then
							if params.Menu == "JudgmentType" then
								if ActiveModifiers[pname(pn)]["JudgmentGraphic"] ~= "None" then
									self:Load(THEME:GetPathG("Judgment", ActiveModifiers[pname(pn)]["JudgmentGraphic"])):SetAllStateDelays(1);
								end;
								self:stoptweening():visible(true)--[[:diffusealpha(0):linear(.2):diffusealpha(1)]];
							else
								self:visible(false)
							end;
						end;
					end;
					AdjustCommand=function(self,params)
						if params.Player == pn and currentOpList == "JudgmentType" then
							if params.Selection == #OptionRowJudgmentGraphic().Choices then
								self:Load(THEME:GetPathG("Judgment", ActiveModifiers[pname(pn)]["JudgmentGraphic"])):SetAllStateDelays(1);
							elseif OptionRowJudgmentGraphic().judgementFileNames[params.Selection+1] ~= "None" then
								self:Load(THEME:GetPathG("Judgment", OptionRowJudgmentGraphic().judgementFileNames[params.Selection+1])):SetAllStateDelays(1);
							else
								--SCREENMAN:SystemMessage(params.Selection..", "..#OptionRowJudgmentGraphic().Choices)
								self:Load(nil);
							end;
						end;
					end;
					OptionsListRightMessageCommand=function(self, params)
						self:playcommand("Adjust",params);
					end;
					OptionsListLeftMessageCommand=function(self,params)
						self:playcommand("Adjust", params);
					end;
				
				};
				--Using an ActorFrame here causes draworder issues.
				LoadActor("optionIcon")..{
					InitCommand=cmd(draworder,100;zoomy,0.34;zoomx,0.425;diffusealpha,.75;y,_screen.cy-(olhei/2.25)+40;draworder,998);
					OptionsMenuChangedMessageCommand=function(self,params)
						--SCREENMAN:SystemMessage("MenuChanged: Menu="..params.Menu);
						if params.Player == pn then
							if params.Menu == "NoteSkins" then
								self:stoptweening():linear(.3):diffusealpha(1);
							else
								self:diffusealpha(0);
							end;
						end;
					end;
				};
		
				Def.Sprite{
					InitCommand=cmd(x,1;y,_screen.cy-(olhei/2.25)+40;draworder,999);
					OptionsMenuChangedMessageCommand=function(self,params)
						if params.Player == pn then
							if params.Menu == "NoteSkins" then
								self:playcommand("On")
								self:stoptweening():linear(.3):diffusealpha(1);
							else
								self:diffusealpha(0);
							end;
						end;
					end;
					OnCommand=function(self)
						local arrow = "__RIO";
						local name = "THUMB";
						local highlightedNoteSkin = CurrentNoteSkin(pn);
						local path = NOTESKIN:GetPathForNoteSkin(arrow, name, highlightedNoteSkin);
						--SCREENMAN:SystemMessage("1Noteskin="..highlightedNoteSkin..",Path="..path);
						if not path then
							arrow = "UpLeft"; name = "Tap Note";
							if highlightedNoteSkin == "delta" then
								name = "Ready Receptor";
							elseif highlightedNoteSkin == "delta-note" or string.ends(highlightedNoteSkin, "rhythm") then
								arrow = "_UpLeft";
							end
							path = NOTESKIN:GetPathForNoteSkin(arrow, name, highlightedNoteSkin);
						end
						
						self:Load(path);
						self:croptop(0);
						self:cropright(0);
						self:zoom(0.35);
					end;
					AdjustCommand=function(self,params)
						if params.Player == pn then
							if params.Selection < OPTIONSLIST_NUMNOTESKINS then
								local highlightedNoteSkin = OPTIONSLIST_NOTESKINS[params.Selection+1];
								local arrow = "__RIO";
								local name = "THUMB";
								local path = NOTESKIN:GetPathForNoteSkin("__RIO", "THUMB", highlightedNoteSkin);
								--SCREENMAN:SystemMessage("2Noteskin="..highlightedNoteSkin..",Path="..path);
								if not path then
									arrow = "UpLeft"; name = "Tap Note";
									if highlightedNoteSkin == "delta" then
										name = "Ready Receptor";
									elseif highlightedNoteSkin == "delta-note" or string.ends(highlightedNoteSkin, "rhythm") then
										arrow = "_UpLeft";
									end
									path = NOTESKIN:GetPathForNoteSkin(arrow, name, highlightedNoteSkin);
								end
								self:Load(path);
								self:croptop(0);
								self:cropright(0);
								self:zoom(0.35);
							else
								self:playcommand("On");
							end;
						end;
					end;
					OptionsListRightMessageCommand=function(self,params)
						self:playcommand("Adjust",params);
					end;
					OptionsListLeftMessageCommand=function(self,params)
						self:playcommand("Adjust",params);
					end;
				};
			};
		end;
	end;
end;
 
t[#t+1] = LoadActor("code_detector.lua")..{};
--t[#t+1] = LoadActor("PlayerMods")..{};
t[#t+1] = LoadActor("GenreSounds.lua")..{};
if getenv("PlayMode") == "Arcade" or getenv("PlayMode") == "Pro" then 
	if GetSmallestNumHeartsLeftForAnyHumanPlayer() > 1 then
		t[#t+1] = LoadActor("channel_system")..{};
	else
		assert(SONGMAN:DoesSongGroupExist(RIO_FOLDER_NAMES["SnapTracksFolder"]),"You are missing the snap tracks folder from SYSTEM_PARAMETERS.lua which is required. The game cannot continue.");
		local folder = SONGMAN:GetSongsInGroup(RIO_FOLDER_NAMES["SnapTracksFolder"]);
		local randomSong = folder[math.random(1,#folder)]
		GAMESTATE:SetCurrentSong(randomSong);
		GAMESTATE:SetPreferredSong(randomSong);
	end;
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

--TODO: Refactor it eventually since it's a waste of code
if getenv("PlayMode") == "Easy" then
	if GAMESTATE:IsSideJoined(PLAYER_1) then
		t[#t+1] = Def.ActorFrame{

			InitCommand=cmd(x,SCREEN_WIDTH/4;y,SCREEN_CENTER_Y+150);
			--PLAYER 1
			LoadActor("DifficultyList/background_orb")..{
				InitCommand=cmd(horizalign,center;zoom,0.7;);
				OffCommand=function(self,param)
					self:linear(0.3);
					self:Load(THEME:GetPathG("","_white"));
				end;
			};
			
			LoadFont("facu/_zona pro bold 20px")..{
				InitCommand=cmd(uppercase,true;horizalign,center;zoom,0.45;);
				OnCommand = function(self, params)
					self:settext("Speed:\n"..GAMESTATE:GetPlayerState(PLAYER_1):GetCurrentPlayerOptions():XMod().."x");
				end;
				CodeMessageCommand = function(self, params)
					self:playcommand("On");
				end;
			};
			
		};
	end;
	if GAMESTATE:IsSideJoined(PLAYER_2) then
		t[#t+1] = Def.ActorFrame{
		
			InitCommand=cmd(x,SCREEN_WIDTH*.75;y,SCREEN_CENTER_Y+150);
			--PLAYER 2
			LoadActor("DifficultyList/background_orb")..{
				InitCommand=cmd(horizalign,center;zoom,0.7;);
				OffCommand=function(self,param)
					self:linear(0.3);
					self:Load(THEME:GetPathG("","_white"));
				end;
			};
			
			LoadFont("facu/_zona pro bold 20px")..{
				InitCommand=cmd(uppercase,true;horizalign,center;zoom,0.45;);
				OnCommand = function(self, params)
					self:settext("Speed:\n"..GAMESTATE:GetPlayerState(PLAYER_2):GetCurrentPlayerOptions():XMod().."x");
				end;
				CodeMessageCommand = function(self, params)
					self:playcommand("On");
				end;
			};
		};
	end;
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
