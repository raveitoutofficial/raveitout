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

--Get noteskins and num noteskins from our custom noteskins function
--For everyone else: NOTESKIN:GetNoteSkinNames()
local OPTIONSLIST_NOTESKINS = OptionRowAvailableNoteskins().Choices
local OPTIONSLIST_NUMNOTESKINS = #OPTIONSLIST_NOTESKINS;

local t = Def.ActorFrame{
	-- SOUNDS
	LoadActor(THEME:GetPathS("OptionsList","Move"))..{
		OptionsListOpenedMessageCommand=cmd(play);
		OptionsListRightMessageCommand=cmd(play);
		OptionsListLeftMessageCommand=cmd(play);
		OptionsListQuickChangeMessageCommand=cmd(play);
	};
	LoadActor(THEME:GetPathS("OptionsList","Select"))..{
		OptionsListStartMessageCommand=cmd(play);
		OptionsListResetMessageCommand=cmd(play);	
	};
	LoadActor(THEME:GetPathS("OptionsList","Enter"))..{
		OptionsListPopMessageCommand=cmd(play);
		OptionsListPushMessageCommand=cmd(play);
	};
	LoadActor(THEME:GetPathS("OptionsList","Close"))..{
		OptionsListClosedMessageCommand=cmd(play);	
	};
};

--TODO: This was written before Noteskin() was a function, there is no reason to have this function still
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
			Text=THEME:GetString("OptionsList","OPTIONS LIST");
			InitCommand=cmd(draworder,999;y,_screen.cy-(olhei/2.25);vertalign,bottom;zoom,0.35;);
		};
		
		LoadFont("Common Normal")..{
			--Text="Hello World!";
			InitCommand=cmd(draworder,999;y,_screen.cy-(olhei/2.25)+10;vertalign,top;zoom,.5;wrapwidthpixels,350);
			OptionsListOpenedMessageCommand=function(self,params)
				if params.Player == pn then
					currentOpList = "SongMenu"
					--This batshit code finds the value of [ScreenOptionsMaster] SongMenu,1
					--local name = split(";",)
					--SCREENMAN:SystemMessage(split(";",string.gsub(THEME:GetMetric("ScreenOptionsMaster",THEME:GetMetric("OptionsList","TopMenu")..",1"),"name,",""))[1]);
					--[[
					1. THEME:GetMetric("OptionsList","TopMenu")..",1" -> "SongMenu,1"
					2. THEME:GetMetric("ScreenOptionsMaster",THEME:GetMetric("OptionsList","TopMenu")..",1") -> "name,Speed;screen,Speed"
					3. string.gsub(THEME:GetMetric("ScreenOptionsMaster",THEME:GetMetric("OptionsList","TopMenu")..",1"),"name,","") -> "Speed;screen,Speed"
					4. split(";",string.gsub(THEME:GetMetric("ScreenOptionsMaster",THEME:GetMetric("OptionsList","TopMenu")..",1"),"name,",""))[1] -> {"Speed", "screen,Speed"} -> "Speed"
					5. THEME:GetString("OptionExplanations","Speed")
					
					Steps 3 and 4 can be in reverse order.
					]]
					self:settext(THEME:GetString("OptionExplanations",split(";",string.gsub(THEME:GetMetric("ScreenOptionsMaster",THEME:GetMetric("OptionsList","TopMenu")..",1"),"name,",""))[1]))
				end;
			end;
			AdjustCommand=function(self,params)
				--SCREENMAN:SystemMessage(currentOpList..", "..params.Selection.." "..THEME:GetMetric("ScreenOptionsMaster",currentOpList..","..params.Selection+1))
				if params.Player == pn then
					if currentOpList == "SongMenu" or currentOpList == "System" then
						
						if params.Selection+1 <= numRows then
							local itemName = split(";",string.gsub(THEME:GetMetric("ScreenOptionsMaster",currentOpList..","..params.Selection+1),"name,",""))[1]
							self:settext(THEME:GetString("OptionExplanations",itemName))
						else
							self:settext("Exit.");
						end;
					elseif currentOpList == "NoteSkins" then
						local curRow;
						--OPTIONSLIST_NUMNOTESKINS is exported by OptionRowAvailableNoteskins()
						--What this if statement is doing is checking if the number of noteskins you have is greater than the split amount set in metrics.
						--Because if it is then the optionsList has been split, therefore making the current row halved as instead of one row it's two
						if OPLIST_splitAt < OPTIONSLIST_NUMNOTESKINS then
							curRow = math.floor((params.Selection)/2)+1 --If list is split
						else
							curRow = params.Selection+1
						end;
						--Start scrolling?
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
				self:playcommand("Adjust",params);
			end;
			OptionsMenuChangedMessageCommand=function(self,params)
				--SCREENMAN:SystemMessage("MenuChanged: Menu="..params.Menu);
				if params.Player == pn then
					currentOpList=params.Menu
					optionsListActor:stoptweening():y(SCREEN_CENTER_Y-100) --Reset the positioning
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
				self:playcommand("UpdateText");
			end;
			UpdateTextCommand=function(self)
				--[[
					More ternary shit
					If an MMod is set this will evaluate to true and will be concatenated to the string,
					but if it's false then the conditional will pick "None" and that will be concatenated instead.
				  ]]
				self:settext("Current Velocity: "..(GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):MMod() or "None"));
			end;
			SpeedModChangedMessageCommand=function(self,params)
				if params.Player == pn and currentOpList == "SpeedMods" then
					self:playcommand("UpdateText");
				end;
			end;
			AdjustCommand=function(self,params)
				if currentOpList == "SongMenu" then
					--Because hardcoding this couldn't possibly go wrong
					--(Spoiler: It went wrong when I reordered it)
					if params.Selection == 4 then
						self:playcommand("UpdateText");
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
		
		--Make sure the scroller elements don't overlap the top and bottom by using a mask.
		--Set TextOnCommand=MaskDest; in metrics.ini!
		Def.Quad{
			InitCommand=cmd(setsize,OPLIST_WIDTH,SCREEN_CENTER_Y-110;diffuse,Color.HoloBlue;vertalign,top;MaskSource;draworder,999)
		};
		Def.Quad{
			InitCommand=cmd(setsize,OPLIST_WIDTH,38;diffuse,Color.HoloBlue;vertalign,bottom;y,SCREEN_BOTTOM;MaskSource;draworder,999)
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

		--ActorFrame that holds the noteskin
		Def.ActorFrame{
			InitCommand=cmd(x,1;y,_screen.cy-(olhei/2.25)+40;draworder,999;zoom,.35);
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
				highlightedNoteSkin = CurrentNoteSkin(pn);
				self:RemoveAllChildren()
				self:AddChildFromPath(THEME:GetPathB("ScreenSelectMusic","overlay/Noteskin.lua"))
				
			end;
			AdjustCommand=function(self,params)
				if params.Player == pn and currentOpList == "NoteSkins" then
					if params.Selection < OPTIONSLIST_NUMNOTESKINS then
						--This is a global var, it's used in Noteskin.lua.
						highlightedNoteSkin = OPTIONSLIST_NOTESKINS[params.Selection+1];
						self:RemoveAllChildren()
						self:AddChildFromPath(THEME:GetPathB("ScreenSelectMusic","overlay/Noteskin.lua"))
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

--[[
Greetz from the RIO team
Credits:
Rhythm Lunatic (scrolling, descriptions, everything else)
Jousway (noteskin preview)
ROAD24 (initial coding)

Shoutouts to Midflight Digital

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <http://unlicense.org>
]]

return t;
