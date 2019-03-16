--[[
Drop in OptionsList replacement by Rhythm Lunatic
Setup:
- Add item_scroller.lua to the Scripts folder of your theme
- Turn off the normal OptionsList
- Add an OptionList code to CodeNames
No placement options to configure, I don't have time to be doing that.
Figure out how to modify it yourself.
]]
--optionlist controls
local OPLIST_WIDTH =		THEME:GetMetric("CustomRIO","OpQuadWidth")		--option list quad width
local LIST_Y_OFFSET = -100 --The offset of the items and cursor. The OptionsList itself is Y centered, so this will add to that.
local MAX_ITEMS_BEFORE_SCROLL = THEME:GetMetric("OptionsList","MaxItemsBeforeSplit") --
local olania =		0.1			--optionlist animation time in
local olanib =		0.2			--optionlist animation time out
local olhei	=		SCREEN_HEIGHT*0.75	--optionlist quadheight
local oltfad =		0.125		--optionlist top fade value (0..1)
local olbfad =		0.5			--optionlist bottom fade value
local ollfad =		0			--optionlist left  fade value
local olrfad =		0			--optionlist right fade value
--[[ Number of text actors to be loaded. You only need as many as the screen height,
because the scroller will start taking items off the top and putting them at the bottom
as you scroll towards the end of the pool. Just like how MusicWheel and item_scroller works. ]]
local POOL_ITEMS = 15;

local textActorFrame = Def.ActorFrame{}

for i = 0,POOL_ITEMS-1 do
	textActorFrame[#textActorFrame+1] = Def.BitmapText{
		Name= "text",
		Font= "Common Normal",
		Text="Hello World!",
		--Taken from OptionsList TextOnCommand
		InitCommand=cmd(zoom,0.425;shadowlength,0.75;diffusebottomedge,color("0.95,0.95,0.95,1");shadowcolor,color("0,0,0,1");y,i*THEME:GetMetric("OptionsList","ItemsSpacingY"));
	};
end

local musicwheel; --Need a handle on the MusicWheel to work around a StepMania bug. Again.

local t = Def.ActorFrame{
	CodeMessageCommand = function(self, params)
		if params.Name == 'OptionList' then
			--SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
			MESSAGEMAN:Broadcast("OptionsListOpened", {Player=params.PlayerNumber});
			SCREENMAN:SystemMessage("Opened!");
		end;
	end;
}

--[[local item_mt= {
  __index= {
	-- create_actors must return an actor.  The name field is a convenience.
	create_actors= function(self, params)
	  self.name= params.name
		return Def.ActorFrame{		
			InitCommand= function(subself)
				-- Setting self.container to point to the actor gives a convenient
				-- handle for manipulating the actor.
		  		self.container= subself
		  		--subself:SetDrawByZPosition(true);
		  		--subself:zoom(.75);
			end;
				
			Def.BitmapText{
				Name= "text",
				Font= "Common Normal",
				--Text="Hello World!",
				--Taken from OptionsList TextOnCommand
				InitCommand=cmd(zoom,0.425;shadowlength,0.75;diffusebottomedge,color("0.95,0.95,0.95,1");shadowcolor,color("0,0,0,1"););
			};
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		self.container:y((item_index-1)*THEME:GetMetric("OptionsList","ItemsSpacingY"))
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, info)
		if info then
			self.container:GetChild("text"):settext(info);
		else
			self.container:GetChild("text"):settext("nil!");
		end;
	end,
}}

local set = {"Item 1", "Item 2", "Item 3", "Item 4", "Item 5"}
local scroller = setmetatable({disable_wrapping= true}, item_scroller_mt)]]



for pn in ivalues(GAMESTATE:GetHumanPlayers()) do

	local cursorPosition = 0;
	local cursorActor;
	local function inputs(event)
		local pn= event.PlayerNumber
		local button = event.button
		-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
		--Also we only want it to activate when they're NOT selecting the difficulty.
		--if not pn or not SCREENMAN:get_input_redirected(pn) then return end

		-- If it's a release, ignore it.
		if event.type == "InputEventType_Release" then return end
		
		if button == "Center" or button == "Start" then
		
		elseif button == "DownLeft" or button == "Left" then
			if cursorPosition > 0 then
				cursorPosition = cursorPosition-1;
				cursorActor:y(LIST_Y_OFFSET+cursorPosition*THEME:GetMetric("OptionsList","ItemsSpacingY"))
			end;
			
		elseif button == "DownRight" or button == "Right" then
				cursorPosition = cursorPosition+1;
				cursorActor:y(LIST_Y_OFFSET+cursorPosition*THEME:GetMetric("OptionsList","ItemsSpacingY"))
		elseif button == "Back" then
		
		elseif button == "MenuDown" then
			--[[local curItem = scroller:get_actor_item_at_focus_pos().container:GetChild("banner");
			local scaledHeight = testScaleToWidth(curItem:GetWidth(), curItem:GetHeight(), 500);
			SCREENMAN:SystemMessage(curItem:GetWidth().."x"..curItem:GetHeight().." -> 500x"..scaledHeight);]]
			
			--local curItem = scroller:get_actor_item_at_focus_pos();
			--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
		else
		
		end;
		
	end;

	t[#t+1] = Def.ActorFrame{		--PLAYER 1 OpList
		InitCommand=cmd(xy,SCREEN_LEFT-OPLIST_WIDTH/2,_screen.cy;);
		OptionsListOpenedMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					currentOpListP1 = THEME:GetMetric("OptionsList","TopMenu")
					cursorPosition = 0
					
					self:decelerate(olania);
					self:x(SCREEN_LEFT+OPLIST_WIDTH/2);
				end
			end;
		OptionsListClosedMessageCommand=function(self,params)
			if params.Player == PLAYER_1 then
				self:stoptweening();
				self:accelerate(olanib);
				self:x(SCREEN_LEFT-OPLIST_WIDTH/2);
			end;
		end;
		Def.Quad{			--Fondo difuminado
			InitCommand=cmd(draworder,998;zoomto,OPLIST_WIDTH,olhei;fadetop,oltfad;fadebottom,olbfad;diffuse,0,0,0,0.75;);

		};
		LoadFont("bebas/_bebas neue bold 90px")..{	--Texto "OPTION LIST"
			Text="OPTION LIST";
			InitCommand=cmd(draworder,999;y,-(olhei/2.25)vertalign,bottom;zoom,0.35;);
		};
		
		--Uncomment if you want descriptions for options, but it's not finished anyway
		LoadFont("Common Normal")..{
			--Text="Hello World!";
			InitCommand=function(self)
				self:draworder(999):y(-(olhei/2.25)+10):vertalign(top):zoom(.5):wrapwidthpixels(350);
				--local m = 
				--SCREENMAN:SystemMessage(m)
				--This batshit code finds the value of [ScreenOptionsMaster] SongMenu,1
				self:settext(THEME:GetString("OptionExplanations",string.gsub(THEME:GetMetric("ScreenOptionsMaster",THEME:GetMetric("OptionsList","TopMenu")..",1"):split(";")[1],"name,","")))
				--self:settext()
			end;
			OptionsListRightMessageCommand=function(self,params)
				--SCREENMAN:SystemMessage(currentOpList..", "..params.Selection.." "..THEME:GetMetric("ScreenOptionsMaster",currentOpList..","..params.Selection+1))
				if params.Player == PLAYER_1 then
					if currentOpListP1 == "SongMenu" or currentOpListP1 == "System" then
						local limit = tonumber(THEME:GetMetric("ScreenOptionsMaster",currentOpListP1))
						if params.Selection+1 <= limit then
							local itemName = string.gsub(THEME:GetMetric("ScreenOptionsMaster",currentOpListP1..","..params.Selection+1):split(";")[1],"name,","")
							self:settext(THEME:GetString("OptionExplanations",itemName))
						else
							self:settext("Exit.");
						end;
					end;
				end;
				--SCREENMAN:SystemMessage(itemName)
			end;
			--No I don't know why playcommand isn't working
			OptionsListLeftMessageCommand=function(self,params)
				if params.Player == PLAYER_1 then
					if currentOpListP1 == "SongMenu" or currentOpListP1 == "System" then
						local limit = tonumber(THEME:GetMetric("ScreenOptionsMaster",currentOpListP1))
						if params.Selection+1 <= limit then
							local itemName = string.gsub(THEME:GetMetric("ScreenOptionsMaster",currentOpListP1..","..params.Selection+1):split(";")[1],"name,","")
							self:settext(THEME:GetString("OptionExplanations",itemName))
						else
							self:settext("Exit.");
						end;
					end;
				end;
			end;
			OptionsMenuChangedMessageCommand=function(self,params)
				--SCREENMAN:SystemMessage("MenuChanged: Menu="..params.Menu);
				currentOpListP1=params.Menu
				if params.Menu ~= "SongMenu" and params.Menu ~= "System" then
					self:settext(THEME:GetString("OptionExplanations",params.Menu))
				end;
			end;
		};
		textActorFrame..{
			InitCommand=cmd(draworder,999;y,LIST_Y_OFFSET);
		};
		--[[scroller:create_actors("foo", POOL_ITEMS, item_mt, 0,0)..{
			InitCommand=cmd(draworder,999);
			OnCommand=function(self)
				SCREENMAN:GetTopScreen():AddInputCallback(inputs);
				scroller:set_info_set(set,1);
			end;
		};]]
		LoadActor(THEME:GetPathG("OptionsList","cursor"))..{
			Name="Cursor";
			InitCommand=cmd(draworder,999;y,LIST_Y_OFFSET;);
			OnCommand=function(self)
				cursorActor = self;
				SCREENMAN:GetTopScreen():AddInputCallback(inputs);
			end;
		};
	};
	--t[#t+1] = 
	
end;
return t;
