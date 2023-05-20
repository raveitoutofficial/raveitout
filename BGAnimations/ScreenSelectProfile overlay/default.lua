--[[
This script was taken from KENp's DDR X2 theme
and was recoded by FlameyBoy and Inorizushi
...And then adapted to IIDX by ARC.
...And then adapted AGAIN to Rave It Out by Accelerator.

Does the code make no sense? I can't understand it either!

Undocumneted features of ScreenSelectProfile:SetProfileIndex(pn, iProfileIndex)
-1 as second argument calls JoinPlayer() on the player argument and returns false
-2 as second argument Unjoins the player, unlocks their memory card, unmounts their memory card, and returns true
values less than -2 will just return false
]]--
local PROFILE_FRAME_WIDTH,PROFILE_FRAME_HEIGHT = 400,490

local ProfileInfoCache = {}
setmetatable(ProfileInfoCache, {__index =
function(table, ind)
    local out = {}
    local prof = PROFILEMAN:GetLocalProfileFromIndex(ind-1)
    out.SongsAndCoursesPercentCompleteAllDifficultiesSingle = prof:GetSongsAndCoursesPercentCompleteAllDifficulties('StepsType_Dance_Single')
    out.SongsAndCoursesPercentCompleteAllDifficultiesDouble = prof:GetSongsAndCoursesPercentCompleteAllDifficulties('StepsType_Dance_Double')
    out.TotalCaloriesBurned = prof:GetTotalCaloriesBurned()
    out.CaloriesBurnedToday = prof:GetCaloriesBurnedToday()
    out.LastPlayedSong = prof:GetLastPlayedSong()
    out.DisplayName = prof:GetDisplayName()
    out.NumTotalSongsPlayed = prof:GetNumTotalSongsPlayed()
    out.UserTable = prof:GetUserTable()
	out.DancePoints = prof:GetTotalDancePoints()
	--out.NumSP_A = prof:GetTotalStepsWithTopGrade('StepsType_Pump_Single',0,)
    rawset(table, ind, out)
    return out
end
})

local function AreAnyProfilesAvailable()
	return USING_RFID or IsMemcardEnabled() or PROFILEMAN:GetNumLocalProfiles() > 0
end;


function GetLocalProfiles()
	local t = {};

	for p = 0,PROFILEMAN:GetNumLocalProfiles()-1 do
		local profile=PROFILEMAN:GetLocalProfileFromIndex(p);
		local ProfileCard = Def.ActorFrame {
--[[ 			Def.Quad {
				InitCommand=cmd(zoomto,200,1;y,40/2);
				OnCommand=cmd(diffuse,Color('Outline'););
			}; --]]
			LoadFont("Common Normal") .. {
				Text=profile:GetDisplayName();
				InitCommand=cmd(shadowlength,1;y,-10;zoom,1;ztest,true);
			};
			LoadFont("Common Normal") .. {
				InitCommand=cmd(shadowlength,1;y,8;zoom,0.5;vertspacing,-8;ztest,true);
				BeginCommand=function(self)
					local numSongsPlayed = profile:GetNumTotalSongsPlayed();
					if numSongsPlayed == 1 then
						self:settext(THEME:GetString("ScreenSelectProfile","1 Song Played"))
					else
						self:settextf(THEME:GetString("ScreenSelectProfile","%i Songs Played"),numSongsPlayed)
					end;
				end;
			};
		};
		t[#t+1]=ProfileCard;
	end;

	return t;
end;

function LoadPlayerStuff(Player)

	local pn = (Player == PLAYER_1) and 1 or 2;
	
	--This is the card. It's pretty much always shown.
	local t = Def.ActorFrame {
		--DO NOT USE COMMANDS ON THIS ACTORFRAME! Modify it where LoadPlayerStuff() is called, at P1Frame and P2Frame.
		--[[LoadActor("glow")..{
			InitCommand=cmd(zoomtowidth,PROFILE_FRAME_WIDTH+80;zoomtoheight,PROFILE_FRAME_HEIGHT+50);
		
		};]]
		LoadActor(THEME:GetPathG("Common","PlayerBox"))..{
			InitCommand=cmd(diffuse,PlayerColor(Player);zoomtowidth,PROFILE_FRAME_WIDTH+50;zoomtoheight,PROFILE_FRAME_HEIGHT);
			OnCommand=function(self)
				if pn == 2 then
					self:rotationy(180);
				end;
			end;
		};
		--[[LoadActor(THEME:GetPathG("Common","Masked_PlayerBox"))..{
			InitCommand=cmd(zoomtowidth,PROFILE_FRAME_WIDTH+50;zoomtoheight,PROFILE_FRAME_HEIGHT+250;MaskSource);
			OnCommand=function(self)
				if pn == 2 then
					self:rotationy(180);
				end;
			end;
		};]]
		
		--[[LoadActor("frame_"..pname(Player))..{
			InitCommand=cmd(y,-PROFILE_FRAME_HEIGHT/2+15;);
		};]]
	};
	


	--Only displayed if player is not joined.
	t[#t+1] = Def.ActorFrame {
		Name = 'JoinFrame';
		
		--[[LoadActor("cab_join_overlay_"..pname(Player))..{
			InitCommand=function(self)
				self:y(10);
				self:cropbottom(.004);
				self:diffusealpha(.5);
				if Player == PLAYER_1 then
					self:x(280*1.5);
					self:horizalign(right);
					self:cropright(.5);
				else
					self:x(-280*1.5);
					self:horizalign(left);
					self:cropleft(.5);
				end;
			end;
			OnCommand=function(self)
				self:decelerate(1);
				self:diffusealpha(1);
				if Player == PLAYER_2 then
					self:x(-280);
					self:cropleft(0);
				else
					self:x(280);
					self:cropright(0);
				end;
			end;
					
		};]]
		
		--[[LoadActor( THEME:GetPathG("ScreenSelectProfile","Graphics/Press Start") ) .. {
			OnCommand=cmd(diffuseshift;effectperiod,2;effectcolor1,color("1,1,1,1");effectcolor2,color("1,1,1,0"));
		};]]
		Def.ActorFrame {
			Name = 'JoinFrame';
			--OnCommand=cmd(diffuseshift;effectperiod,2;effectcolor1,color("1,1,1,1");effectcolor2,color("1,1,1,0"));
			InitCommand=cmd(zoom,.75;addx,5);
			LoadFont("monsterrat/_montserrat semi bold 60px") .. {
				Text=THEME:GetString("ScreenSelectProfile","PRESS %s OR %s TO JOIN THE RAVE");
				InitCommand=cmd(uppercase,true;skewx,-0.2;zoom,.9;maxwidth,575);
				OnCommand=cmd(diffuse,Color('White');strokecolor,Color("Black"));
			};
				LoadActor("Center Tap Note 3x2")..{
				InitCommand=cmd(x,200;y,-33;);
			};
				LoadActor("start")..{
				InitCommand=cmd(x,10;y,-33;);
			};
		};


	};
	
	--Displayed if the player is joined, but they haven't inserted a USB stick.
	t[#t+1] = Def.ActorFrame{
		Name = "LoginFrame";
		
		LoadFont("Common Normal")..{
			Condition=(PROFILEMAN:GetNumLocalProfiles() > 0 and not USING_RFID);
			Text=THEME:GetString("ScreenSelectProfile","Or select a local profile below");
			InitCommand=cmd(vertalign,top;horizalign,left;xy,-PROFILE_FRAME_WIDTH/2,-40;);
		};
		
		--Scroller selection graphic.
		Def.ActorFrame{
			Condition=(PROFILEMAN:GetNumLocalProfiles() > 0 and not USING_RFID);
			InitCommand=cmd(y,25-2;);
			Def.Quad {
				InitCommand=cmd(zoomto,PROFILE_FRAME_WIDTH,40+2);
				OnCommand=cmd(diffuse,Color('Black');diffusealpha,0.5);
			};
			Def.Quad {
				InitCommand=cmd(zoomto,PROFILE_FRAME_WIDTH,40);
				OnCommand=cmd(diffuse,Color("White");fadeleft,0.25;faderight,0.25;glow,color("1,1,1,0.25"));
			};
			Def.Quad {
				InitCommand=cmd(zoomto,PROFILE_FRAME_WIDTH,40;y,-40/2+20);
				OnCommand=cmd(diffuse,Color("Black");fadebottom,1;diffusealpha,0.35);
			};
			Def.Quad {
				InitCommand=cmd(zoomto,PROFILE_FRAME_WIDTH,1;y,-40/2+1);
				OnCommand=cmd(diffuse,PlayerColor(Player);glow,color("1,1,1,0.25"));
			};	
		};
		--We embed a scroller frame here for them to select local profiles.
		Def.ActorScroller{
			--Condition=(PROFILEMAN:GetNumLocalProfiles() > 0 and not USING_RFID);
			Name = 'Scroller';
			NumItemsToDraw=8;
			
	 		--InitCommand=cmd(y,-230/2+20;);
			OnCommand=cmd(y,1;SetFastCatchup,true;SetSecondsPerItem,0.15;visible,(not USING_RFID));
			TransformFunction=function(self, offset, itemIndex, numItems)
				local focus = scale(math.abs(offset),0,2,1,0);
				self:visible(false);
				self:y(25+math.floor( offset*40 ));
	-- 			self:zoomy( focus );
	-- 			self:z(-math.abs(offset));
	-- 			self:zoom(focus);
			end;
			children = GetLocalProfiles();
		};
		--This is the "grey" card unit BG that will show up if you have no card, no card checking, etc.
		LoadActor("card_unit")..{
			InitCommand=cmd(vertalign,top;y,-PROFILE_FRAME_HEIGHT/2+17;zoomtowidth,PROFILE_FRAME_WIDTH+15;zoomtoheight,185;);
			--[[StorageDevicesChangedMessageCommand=function(self)
				self:linear(.3):zoomy(0):sleep(0):linear(.3):zoomy(1);
				local st = ToEnumShortString(MEMCARDMAN:GetCardState(Player))
				if st == "checking" then
					self:diffuse(Color("Yellow"))
				elseif st == "late" or st == "error" or st == "removed" then
					self:diffuse(Color("Red"));
				elseif st == "ready" then
					self:diffuse(Color("Green"));
				else
					self:diffuse(Color("White"));
				end
			
			end;]]
		};
		
		LoadActor(THEME:GetPathG("USB", "icon"))..{
			InitCommand=cmd(vertalign,top;zoom,.4;y,-PROFILE_FRAME_HEIGHT/2+40;);
		};
		
		--Mask for the circle
		LoadActor("card_unit")..{
			Condition=IsMemcardEnabled();
			InitCommand=cmd(vertalign,top;y,-PROFILE_FRAME_HEIGHT/2+17;zoomtowidth,PROFILE_FRAME_WIDTH+15;zoomtoheight,180;MaskSource);
		};
		
		LoadActor("circle")..{
			Condition=IsMemcardEnabled();
			InitCommand=cmd(diffusealpha,0;zoom,3.5;y,-PROFILE_FRAME_HEIGHT/2+100;MaskDest;ztestmode,"ZTestMode_WriteOnFail");
			OnCommand=cmd(queuecommand,"Loop");
			LoopCommand=cmd(decelerate,1;diffusealpha,1;zoom,1.5;sleep,.5;linear,.5;diffusealpha,0;sleep,0;zoom,3.5;queuecommand,"Loop");
		};
		LoadActor("x")..{
			Condition=(not IsMemcardEnabled());
			InitCommand=cmd(y,-PROFILE_FRAME_HEIGHT/2+100;diffusealpha,.5);
		};
		LoadFont("Common Normal")..{
			InitCommand=cmd(y,-PROFILE_FRAME_HEIGHT/2+25;vertalign,top;maxwidth,375);
			OnCommand=function(self)
				if USING_RFID == true then
					self:settext(THEME:GetString("ScreenSelectProfile","Place your Rave It Out Pass near the reader to login"));
				elseif IsMemcardEnabled() then
					self:settext(THEME:GetString("ScreenSelectProfile","Insert your USB stick to login"));
				else
					if PROFILEMAN:GetNumLocalProfiles() > 0 then
						self:settext(THEME:GetString("ScreenSelectProfile","Memory cards are disabled"));
					else
						self:settext(THEME:GetString("ScreenSelectProfile","Memory cards are disabled no profiles"));
					end;
				end;
			end;
			--OnCommand=cmd(diffuseshift;effectperiod,2;effectcolor1,color("1,1,1,1");effectcolor2,color("1,1,1,0"));
		
		};
		
		LoadFont("Common Normal")..{
			Condition=(((PROFILEMAN:GetNumLocalProfiles() == 0) and IsMemcardEnabled()) or USING_RFID == true);
			Text=THEME:GetString("ScreenSelectProfile","Or press start to continue without a profile");
			InitCommand=cmd(y,-PROFILE_FRAME_HEIGHT/2+210;vertalign,top;wrapwidthpixels,PROFILE_FRAME_WIDTH-100);
		
		};
		--This one shows up on top of the other one because it looks cool when you card in.
		--[[Def.ActorFrame{
			InitCommand=cmd(y,-PROFILE_FRAME_HEIGHT/4-12);
			LoadActor("checking_card_unit")..{
				InitCommand=function(self)
					self:zoomtowidth(PROFILE_FRAME_WIDTH+15);
					local st = ToEnumShortString(MEMCARDMAN:GetCardState(Player))
					if ToEnumShortString(MEMCARDMAN:GetCardState(Player)) == "none" then
						self:zoomy(0);
					else
						self:zoomtoheight(185);
					end;
				end;
					
				OnCommand=function(self)
					self:linear(.3):zoomtoheight(185);
					self:diffuse(Color("Yellow"));
				end;
				StorageDevicesChangedMessageCommand=function(self)
					self:linear(.3):zoomy(0):sleep(0):linear(.3):zoomy(1);
					local st = ToEnumShortString(MEMCARDMAN:GetCardState(Player))
					if st == "checking" then
						self:diffuse(Color("Yellow"))
					elseif st == "late" or st == "error" or st == "removed" then
						self:diffuse(Color("Red"));
					elseif st == "ready" then
						self:diffuse(Color("Green"));
					else
						self:diffuse(Color("White"));
					end
				
				end;
			};
			Def.Sprite{
				Texture="Checking_USB 12x10";
				InitCommand=cmd(SetAllStateDelays,.03;zoom,.75);
			};
			Def.Sprite{
				Texture="Verified_USB 7x5";
				InitCommand=cmd(SetAllStateDelays,.03;zoom,.75);
				AnimationFinishedCommand=function(self)
					self:setstate(self:GetNumStates()-5):animate(false);
				end;
			};
			LoadActor("Validating")..{
				InitCommand=cmd(addy,60;diffuseshift;effectcolor1,color("#FFFFFFFF");effectcolor2,color("#FFFFFF55");effectperiod,1);
			
			};
		};]]
		

		
	
	}

	--Displayed after the player has selected a profile (whether by USB or picking a local one in LoginFrame)
	t[#t+1] = Def.ActorFrame {
		Name = 'BigFrame';
		
		--Banner thingy
		--[[Def.ActorFrame{
			LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/top banner/banner"))..{
				InitCommand=cmd(y,-210;);
			};
		
		};]]
		
		Def.ActorScroller{
			Name="playdata_pages";
			-- (float) Number of items to have visible at one time.
			-- ScrollThroughAllItems divides this value by 2.
			NumItemsToDraw=2, -- Default value is 7 if this parameter is omitted.

			-- (float) The number of seconds to show each item.
			SecondsPerItem=.3, -- Default value is 1 if this parameter is omitted.

			-- Transforms the ActorScroller's children. Usually used for scrolling.
			-- The most important part of an ActorScroller.

			-- "offset" represents the offset from the center of the scroller.
			TransformFunction=function(self,offset,itemIndex,numItems)
				self:xy(550*offset,20);
				--Sadly, doesn't work
				self:cropleft(math.abs(1));
				self:cropright(math.abs(1));
				--SCREENMAN:SystemMessage(ListActorChildren(self));
				--self:GetChild('pd_graphic'):cropleft(math.abs(offset));
				
				if math.abs(offset) < 1 then
					self:diffusealpha(math.cos(offset*math.pi));
				else
					self:diffusealpha(0);
				end;
			end,

			-- children (items to scroll)
			-- CAVEAT: BitmapTexts have to be wrapped in ActorFrames in order to be colored.
			-- This is a long standing issue (ITG? ITG2?)
			Def.ActorFrame{
				Name="page1";
				
				--[[
				This is the important profile information.
				It gets loaded here, but it gets set at/from UpdateInternal3.
				]]
				
				--Delta NEX Rebirth copypaste
		
				Def.ActorFrame{
					InitCommand=cmd(y,-PROFILE_FRAME_HEIGHT/2+30);
					Name="NameFrame";
					Def.Quad{
						InitCommand=function(self)
							self:setsize(PROFILE_FRAME_WIDTH+15,70):diffuse(PlayerColor(Player));
							if pn == 1 then
								self:faderight(1);
							else
								self:fadeleft(1);
							end;
						end;
					};
					Def.Quad{
						InitCommand=function(self)
							(cmd(setsize,PROFILE_FRAME_WIDTH/2,1;diffuse,color("#AAAAAAFF");y,8;fadeleft,.3;faderight,.3))(self);
							if pn == 1 then
								self:x(40);
							else
								self:x(-40);
							end;
						end;
					};
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=function(self)
							(cmd(uppercase,true;zoom,0.85;skewx,-0.2;addy,-12))(self);
							if pn == 1 then
								self:x(-PROFILE_FRAME_WIDTH/2.1):horizalign(left)
							else
								self:x(PROFILE_FRAME_WIDTH/2.1):horizalign(right)
							end;
						end;
						Text=pname(Player);
					};
					
					LoadFont("monsterrat/_montserrat semi bold 60px")..{
						Name="PlayerName";
						InitCommand=function(self)
							self:y(-10):zoom(0.5):uppercase(true);
							if pn == 1 then
								self:x(40);
							else
								self:x(-40);
							end;
						end;
						--Text=profile:GetTotalDancePoints();
					};
					LoadFont("monsterrat/_montserrat light 60px")..{
						Name="PlayerTitle";
						InitCommand=cmd(y,10;zoom,0.4;vertalign,top;maxwidth,650);
						OnCommand=function(self)
							if pn == 1 then
								self:x(40);
							else
								self:x(-40);
							end;
						end;
						Text=THEME:GetString("ScreenSelectProfile","WELCOME TO RAVE IT OUT");
					};
					
				};
				
				Def.ActorFrame{
					InitCommand=cmd(y,-140);
					Name="LevelFrame";
				
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(horizalign,left;zoom,0.52;skewx,-0.15;x,-PROFILE_FRAME_WIDTH/2.1;diffusebottomedge,color("#ffc300"));
						Text="Rave Level";
					};
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(horizalign,right;zoom,0.52;skewx,-0.15;x,PROFILE_FRAME_WIDTH/2.1);
						Name="Level";
						--Text=profile:GetTotalDancePoints();
					};
					Def.Quad{
						InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,30);
					};
					
				};
				Def.ActorFrame{
					InitCommand=cmd(y,-94);
					Name="DPFrame";
					Def.Quad{
						InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,30);
					};
				
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(horizalign,left;zoom,0.52;skewx,-0.15;x,-PROFILE_FRAME_WIDTH/2.1;diffusebottomedge,color("#ffc300"));
						Text="Rave Points";
					};
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(horizalign,right;zoom,0.52;skewx,-0.15;x,PROFILE_FRAME_WIDTH/2.1);
						Name="DP";
						--Text=profile:GetTotalDancePoints();
					};
					
				};
				--[[Def.ActorFrame{
					InitCommand=cmd(y,-20);
				
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(horizalign,left;zoom,0.52;skewx,-0.15;addy,-16;x,-PROFILE_FRAME_WIDTH/2.1);
						Text="Grades";
					};
					Def.Quad{
						InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,13);
					};
					
					LoadActor(THEME:GetPathG("","GradeDisplayEval/A"))..{
						InitCommand=cmd(zoom,.2;valign,.67;);
					};
					LoadActor(THEME:GetPathG("","GradeDisplayEval/S_normal"))..{
						InitCommand=cmd(zoom,.2;valign,.67;x,PROFILE_FRAME_WIDTH*.2);
					};
					LoadActor(THEME:GetPathG("","GradeDisplayEval/S_S"))..{
						InitCommand=cmd(zoom,.2;valign,.67;x,PROFILE_FRAME_WIDTH*.4);
					};
					
				};
				Def.ActorFrame{
					InitCommand=cmd(y,24);
				
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(horizalign,left;zoom,0.52;skewx,-0.15;addy,-16;x,-PROFILE_FRAME_WIDTH/2.1;diffusebottomedge,color("#00d3ff"));
						Text="Single";
					};
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(zoom,0.52;addy,-16;skewx,-0.15;);
						Text="123";
					};
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(zoom,0.52;addy,-16;skewx,-0.15;x,PROFILE_FRAME_WIDTH*.2);
						Text="456";
					};
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(zoom,0.52;addy,-16;skewx,-0.15;x,PROFILE_FRAME_WIDTH*.4);
						Text="789";
					};
					Def.Quad{
						InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,13);
					};
					
				};
				Def.ActorFrame{
					InitCommand=cmd(y,64);
				
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(horizalign,left;zoom,0.52;skewx,-0.15;addy,-12;x,-PROFILE_FRAME_WIDTH/2.1;diffusebottomedge,color("#3cbf00"));
						Text="Double";
					};
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(zoom,0.52;addy,-12;skewx,-0.15;);
						Text="123";
					};
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(zoom,0.52;addy,-12;skewx,-0.15;x,PROFILE_FRAME_WIDTH*.2);
						Text="456";
					};
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(zoom,0.52;addy,-12;skewx,-0.15;x,PROFILE_FRAME_WIDTH*.4);
						Text="789";
					};
					Def.Quad{
						InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,18);
					};
				};]]
				Def.ActorFrame{
					Name="PlayCountFrame";
					InitCommand=cmd(y,170);
				
					LoadFont("bebas/_bebas neue bold 90px")..{
						InitCommand=cmd(horizalign,left;zoom,0.52;skewx,-0.15;addy,-13;x,-PROFILE_FRAME_WIDTH/2.1;diffusebottomedge,color("#ff007f"));
						Text="Play Count";
					};
					LoadFont("bebas/_bebas neue bold 90px")..{
						Name="PlayerNumSongs";
						InitCommand=cmd(horizalign,right;zoom,0.52;skewx,-0.15;addy,-14;x,PROFILE_FRAME_WIDTH/2.1);
						--Text=profile:GetNumTotalSongsPlayed();
					};
					Def.Quad{
						InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH,1;diffuse,color("#AAAAAAFF");y,16);
					};
					
					
					LoadFont("monsterrat/_montserrat semi bold 60px")..{
					Text="PRESS START TO CONTINUE";
						--Name="PlayerName";
						InitCommand=function(self)
							self:y(60):zoom(0.4):uppercase(true);
						end;
						OnCommand=function(self)
							self:diffuseshift():effectcolor1(color("#FFFFFFFF")):effectcolor2(color("#00000000")):effectperiod(2);
						end;
					};
					
				};
			
			};
			Def.ActorFrame{
				Name="page2";
				--LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/playdata_page2"))..{};
			
			};
			--Single rival
			Def.ActorFrame{
				Name="page3";
				--LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/playdata_page3"))..{};
			
			};
			--Double rival
			Def.ActorFrame{
				Name="page4";
				--LoadActor(THEME:GetPathG("ScreenSelectProfile", "Graphics/playdata_page3"))..{};
			
			};


			-- Scroller commands
			--InitCommand=cmd(Center),
			--InitCommand=cmd(SetMask,0,0);
			OnCommand=function(self)
				--difficultyScroller = self;
				--self:SetMask(-99,-99);
			end;
			--Turns out nobody will ever use this, so... It's not gonna be used.
			--[[CodeMessageCommand=
				function(self, param)
					if param.Name == "Left" then
						if self:GetDestinationItem() > 0 then
							self:SetDestinationItem(self:GetDestinationItem()-1);
						end;
					elseif param.Name == "Right" then
						if self:GetDestinationItem() < self:GetNumItems()-1 then
							self:SetDestinationItem(self:GetDestinationItem()+1);
						end;
					elseif param.Name == "Up" then
						--SCREENMAN:SystemMessage(self:GetCurrentItem());
						--SCREENMAN:SystemMessage(ListActorChildren(self))
						
					end;
					SOUND:PlayOnce(THEME:GetPathS("Common", "value"), true);
					--SCREENMAN:SystemMessage(param.Name);
				end;]]
				
		};
		
		
		--[[LoadActor("operate_game_start")..{
			InitCommand=cmd(y,290);
		};]]
				
		--[[LoadActor(THEME:GetPathS("ScreenSelectProfile","CardReady"))..{
			OnCommand=cmd(sleep,1;queuecommand,"PlaySound");
			PlayerJoinedMessageCommand=cmd(sleep,1;queuecommand,"PlaySound");
			PlaySoundCommand=cmd(play)
		};]]
	
	};


	--???
	t[#t+1] = Def.ActorFrame {
		Name = "EffectFrame";
	};
	t[#t+1] = Def.ActorFrame{
		LoadActor("playdata_cover_"..pname(Player))..{
			InitCommand=cmd(setsize,PROFILE_FRAME_WIDTH+25,PROFILE_FRAME_HEIGHT-35;zoomy,0);
			AnimCommand=cmd(decelerate,.3;zoomy,1;diffusealpha,1;sleep,.4;decelerate,.3;zoomy,0;diffusealpha,0);
			AnimNoProfile==cmd(decelerate,.3;zoomy,1;diffusealpha,1;);
			--OffCommand=cmd(zoomy,1);
			ProfileChosenMessageCommand=function(self, param)
				if param.Player == Player then
					--self:finishtweening();
					if true then --AreAnyProfilesAvailable()
						self:queuecommand("Anim");
					else
						self:queuecommand("AnimNoProfile");
					end;
				end;
			end;
			
		};
	
		LoadActor(THEME:GetPathG("Common", "Mask"))..{
			InitCommand=cmd(diffuse,PlayerColor(Player);zoomtowidth,PROFILE_FRAME_WIDTH+50;zoomtoheight,PROFILE_FRAME_HEIGHT);
			OnCommand=function(self)
				if pn == 2 then
					self:rotationy(180);
				end;
			end;
		};
	};



	return t;
end;

--Keep track of if they're on the LoginFrame or the BigFrame
--Need to use '[]' because PLAYER_1 resolves to a string...
local PLAYER_NOT_JOINED_NOT_SELECTED = 0
local PLAYER_JOINED_NOT_SELECTED = 1
local PLAYER_JOINED_SELECTED = 2
local curProfileScreen = {
	["PlayerNumber_P1"] = 0,
	["PlayerNumber_P2"] = 0
};

--This monstrous command updates everything when a player joins or leaves or switches profiles
function UpdateInternal3(self, Player)

	local pn = (Player == PLAYER_1) and 1 or 2;
	--Frames
	local frame = self:GetChild(string.format('P%uFrame', pn));
	local scroller = frame:GetChild('LoginFrame'):GetChild('Scroller');
	local joinframe = frame:GetChild('JoinFrame');
	local loginframe = frame:GetChild("LoginFrame");
	local bigframe = frame:GetChild('BigFrame');
	--Profile stuff
	local playdata_pages = bigframe:GetChild('playdata_pages');
	local playerName = playdata_pages:GetChild('page1'):GetChild("NameFrame"):GetChild("PlayerName");
	local playerTitle = playdata_pages:GetChild('page1'):GetChild("NameFrame"):GetChild("PlayerTitle");
	--local playerID = playdata_pages:GetChild('page1'):GetChild("PlayerID");
	local playerLv = playdata_pages:GetChild("page1"):GetChild("LevelFrame"):GetChild("Level");
	local playerNumSongs = playdata_pages:GetChild('page1'):GetChild("PlayCountFrame"):GetChild("PlayerNumSongs");
	local playerDP = playdata_pages:GetChild('page1'):GetChild("DPFrame"):GetChild("DP");
	if GAMESTATE:IsHumanPlayer(Player) then
		frame:visible(true);
		if MEMCARDMAN:GetCardState(Player) == 'MemoryCardState_none' then
			--using profile if any
			joinframe:visible(false);
			bigframe:visible(false);
			loginframe:visible(false);
			--seltext:visible(true);

			local ind = SCREENMAN:GetTopScreen():GetProfileIndex(Player);


			if ind > 0 then --If profile
			
				local profile = PROFILEMAN:GetLocalProfileFromIndex(ind-1);
				scroller:SetDestinationItem(ind-1);
				if curProfileScreen[Player] == 1 then
					bigframe:visible(true);
					playerName:settext(ProfileInfoCache[ind].DisplayName);
					--selPlayerUID = PROFILEMAN:GetLocalProfileFromIndex(ind-1):GetGUID();
					--playerID:settext(string.upper(string.sub(selPlayerUID,1,4).."-"..string.sub(selPlayerUID,5,8)));
					playerLv:settext(calcPlayerLevel(ProfileInfoCache[ind].NumTotalSongsPlayed));
					playerNumSongs:settext(tostring(math.ceil(ProfileInfoCache[ind].NumTotalSongsPlayed)));
					playerDP:settext(ProfileInfoCache[ind].DancePoints);
				else
					loginframe:visible(true);
				end;
			--If there are no profiles
			else
				if not USING_RFID and SCREENMAN:GetTopScreen():SetProfileIndex(Player, 1) then
					bigframe:visible(false);
					scroller:SetDestinationItem(0);
					self:queuecommand('UpdateInternal2');
				else
					playerName:settext('No profile');
					joinframe:visible(false);
					scroller:visible(false);
					if curProfileScreen[Player] == 0 then
						loginframe:visible(true);
					else
						loginframe:visible(false);
						bigframe:visible(true);
					end;
					--selectPlayerUID:settext('------------');
          
				end;
			end;
		else
			--using card
			joinframe:visible(false);
			loginframe:visible(false);
			bigframe:visible(true);
			if MEMCARDMAN:GetName(Player) == "" then
				playerName:settext("NEW PLAYER");
			else
				playerName:settext(MEMCARDMAN:GetName(Player));
			end
			SCREENMAN:GetTopScreen():SetProfileIndex(Player, 0);
		end;
	else
		joinframe:visible(true);
		loginframe:visible(false);
		bigframe:visible(false);
		
	end;
end;

local t = Def.ActorFrame {

	StorageDevicesChangedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	CodeMessageCommand = function(self, params)
		--SCREENMAN:SystemMessage(params.Name);
		if params.Name == 'Start' or params.Name == 'Center' then
			MESSAGEMAN:Broadcast("StartButton");
			if not GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
				SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, -1);
			else
				if curProfileScreen[params.PlayerNumber] == 0 then
					curProfileScreen[params.PlayerNumber] = 1;
					--SCREENMAN:SystemMessage(curProfileScreen[params.PlayerNumber]);
					self:sleep(.3):queuecommand("UpdateInternal2");
					self:GetChild("CardReadySound"):playforplayer(params.PlayerNumber);
					--Because SM's own messagecommands isn't consistent...
					MESSAGEMAN:Broadcast("ProfileChosen",{Player=params.PlayerNumber});
				else
					--SCREENMAN:SystemMessage(curProfileScreen[params.PlayerNumber]);
					
					SCREENMAN:GetTopScreen():Finish();
				end;
			end;
		end;
		if not USING_RFID then
			if params.Name == 'Up' or params.Name == 'Up2' or params.Name == 'Left' or params.Name == "Downleft" then
				if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
					local ind = SCREENMAN:GetTopScreen():GetProfileIndex(params.PlayerNumber);
					if ind > 1 then
						if SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, ind - 1 ) then
							MESSAGEMAN:Broadcast("DirectionButton");
							self:queuecommand('UpdateInternal2');
						end;
					end;
				end;
			end;
			if params.Name == 'Down' or params.Name == 'Down2' or params.Name == 'Right' or params.Name=="Downright" then
				if GAMESTATE:IsHumanPlayer(params.PlayerNumber) then
					local ind = SCREENMAN:GetTopScreen():GetProfileIndex(params.PlayerNumber);
					if ind > 0 then
						if SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, ind + 1 ) then
							MESSAGEMAN:Broadcast("DirectionButton");
							self:queuecommand('UpdateInternal2');
						end;
					end;
				end;
			end;
		end;
		if params.Name == 'Back' then
			--SCREENMAN:SystemMessage(curProfileScreen[params.PlayerNumber]);
			if GAMESTATE:GetNumPlayersEnabled()==0 then
				SCREENMAN:GetTopScreen():Cancel();
			else
				MESSAGEMAN:Broadcast("BackButton");
				if curProfileScreen[params.PlayerNumber] > 0 then
					curProfileScreen[params.PlayerNumber] = curProfileScreen[params.PlayerNumber] - 1;
				else
					--SCREENMAN:SystemMessage("Unjoined player. Joined players: "..GAMESTATE:GetNumPlayersEnabled());
					GAMESTATE:UnjoinPlayer(params.PlayerNumber);
				end;
				SCREENMAN:GetTopScreen():SetProfileIndex(params.PlayerNumber, -2);
			end;
		end;
	end;

	PlayerJoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	PlayerUnjoinedMessageCommand=function(self, params)
		self:queuecommand('UpdateInternal2');
	end;

	OnCommand=function(self, params)
		if LAST_SCANNED_CARD ~= nil then
			self:playcommand("CheckingCard");
		end;
		self:queuecommand('UpdateInternal2');
	end;

	UpdateInternal2Command=function(self)
		UpdateInternal3(self, PLAYER_1);
		UpdateInternal3(self, PLAYER_2);
	end;
	
	CardScannedMessageCommand=function(self,params)
		if not USING_RFID then return end;
		LAST_SCANNED_CARD = params
		GAMESTATE:JoinPlayer(params.Player);
		self:queuecommand("CheckingCard");
		--SOUND:PlayOnce(THEME:GetPathS("","iidx/decide_lincle"));
		--self:sleep(.5):linear(.3):diffusealpha(1):sleep(1):queuecommand("EnterProfileSelect");
	end;
	
	
	CheckingCardCommand=function(self)
		assert(LAST_SCANNED_CARD.card);
		assert(LAST_SCANNED_CARD.Player)
		local ind = PROFILEMAN:GetLocalProfileIndexFromID(LAST_SCANNED_CARD.card);
		assert(ind);
		if ind > 0 then
			SCREENMAN:GetTopScreen():SetProfileIndex(LAST_SCANNED_CARD.Player, ind+1 );
			curProfileScreen[LAST_SCANNED_CARD.Player] = 1;
			self:sleep(.3):queuecommand("UpdateInternal2");
			self:GetChild("CardReadySound"):playforplayer(LAST_SCANNED_CARD.Player);
			--SCREENMAN:SystemMessage(ind);
		else
			--It would make more sense to just give the ID when it's created right?
			if PROFILEMAN:CreateLocalProfileByID("New Player", LAST_SCANNED_CARD.card) then
				local ind = PROFILEMAN:GetLocalProfileIndexFromID(LAST_SCANNED_CARD.card);
				if ind then
					SCREENMAN:GetTopScreen():SetProfileIndex(LAST_SCANNED_CARD.Player, ind );
					curProfileScreen[LAST_SCANNED_CARD.Player] = 1;
					--SCREENMAN:SystemMessage(curProfileScreen[params.PlayerNumber]);
					self:sleep(.3):queuecommand("UpdateInternal2");
					self:GetChild("CardReadySound"):playforplayer(LAST_SCANNED_CARD.Player);
					--Because SM's own messagecommands isn't consistent...
					MESSAGEMAN:Broadcast("ProfileChosen",{Player=LAST_SCANNED_CARD.Player});
				else
					lua.ReportScriptError("Failed to obtain an index after creating the profile. Bailing out.");
				end;
			else
				lua.ReportScriptError("Failed to create a profile. Card ID is too long? ID: "..LAST_SCANNED_CARD.card);
			end;
		end;
		LAST_SCANNED_CARD = nil;
	end;

	children = {
		
		
		--[[Def.ActorFrame{
			LoadActor( THEME:GetPathG("ScreenSelectProfile","Graphics/CardBackground_"..ToEnumShortString(PLAYER_1)) ) .. {
				InitCommand=cmd(x,SCREEN_CENTER_X-320;y,SCREEN_CENTER_Y;);
			};
			
			LoadActor( THEME:GetPathG("ScreenSelectProfile","Graphics/CardBackground_"..ToEnumShortString(PLAYER_2)) ) .. {
				InitCommand=cmd(x,SCREEN_CENTER_X+320;y,SCREEN_CENTER_Y;);
			};
		};]]
		
		Def.ActorFrame {
		
			Name = 'P1Frame';
			InitCommand=cmd(x,SCREEN_CENTER_X/2;y,SCREEN_CENTER_Y;zoom,.7);
			OnCommand=cmd(--[[queuecommand,"Animate";]]sleep,8);
			OffCommand=cmd();
			PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_1 then
					--self:queuecommand("Animate");
				end;
			end;
			AnimateCommand=cmd(finishtweening;zoomy,0;linear,.5;zoomy,1);
			
			children = LoadPlayerStuff(PLAYER_1);
		};
		Def.ActorFrame {
			Name = 'P2Frame';
			InitCommand=cmd(x,SCREEN_WIDTH*.75;y,SCREEN_CENTER_Y;zoom,.7);
			OnCommand=cmd(sleep,8);
			OffCommand=cmd();
			--[[PlayerJoinedMessageCommand=function(self,param)
				if param.Player == PLAYER_2 then
					(cmd(zoomx,1;zoomy,0.15;linear,0.175;zoomy,1;))(self);
				end;
			end;]]
			children = LoadPlayerStuff(PLAYER_2);
		};
		
		-- sounds

		--[[LoadActor( THEME:GetPathS("Common","start") )..{
			StartButtonMessageCommand=cmd(play);
		};
		LoadActor( THEME:GetPathS("","Profile_start") )..{
			StartButtonMessageCommand=cmd(play);
		};
		LoadActor( THEME:GetPathS("Common","cancel") )..{
			BackButtonMessageCommand=cmd(play);
		};
		LoadActor( THEME:GetPathS("ScreenSelectProfile","Move") )..{
			DirectionButtonMessageCommand=cmd(play);
		};]]
		LoadActor(THEME:GetPathS("ScreenSelectProfile", "USB"))..{
			OnCommand=function(self)
				if IsMemcardEnabled() then
					self:play();
				end;
			end;
		};
		Def.Sound{
			File=THEME:GetPathS("ScreenSelectProfile","CardReady");
			Name="CardReadySound";
			SupportPan=true
		};
	};
};


return t;
