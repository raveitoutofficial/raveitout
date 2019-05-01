local SortTypes = {
	["BPM"]   = "SortOrder_BPM",
	["Title"] = "SortOrder_Title",
	["Group"] = "SortOrder_Group",
	["Popularity"] = "Popularity",
	["Top Grades"] = 'SortOrder_TopGrades',
	["Artist"] = 'SortOrder_Artist',
	["Genre"] = 'SortOrder_Genre',
	--"Level (Singles)",
	--"Level (Doubles)",
	--"Heart Count"
}

local sortNames = {}
local n=0
for k,v in pairs(SortTypes) do
  n=n+1
  sortNames[n]=k
end
--==========================
--Item Scroller. Must be defined at the top to have 'scroller' var accessible to the rest of the lua.
--==========================
local scroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local numWheelItems = 17

--Item scroller starts at 0, duh.
local currentItemIndex = 0;

-- Scroller function thingy
local item_mt= {
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
				InitCommand=cmd();
			};
		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		--PrimeWheel(self.container,offsetFromCenter,item_index,numWheelItems)
		self.container:stoptweening();
		if math.abs(offsetFromCenter) < 7 then
			self.container:decelerate(.5);
			self.container:visible(true);
		else
			self.container:visible(false);
		end;
		self.container:xy(offsetFromCenter*50,-offsetFromCenter*50)
		--self.container:rotationy(offsetFromCenter*-45);
		--self.container:zoom(math.cos(offsetFromCenter*math.pi/6)*.8)
		
		--[[if offsetFromCenter == 0 then
			self.container:diffuse(Color("Red"));
		else
			self.container:diffuse(Color("White"));
		end;]]
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, info)
		self.container:GetChild("text"):settext(info)	
	end,
	gettext=function(self)
		return self.container:GetChild("text"):gettext()
	end,
}}


local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	if not pn or not SCREENMAN:get_input_redirected(pn) then return end

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	if button == "Center" or button == "Start" then
		MESSAGEMAN:Broadcast("SortChanged",{newSort=SortTypes[scroller:get_info_at_focus_pos()]});
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
	elseif button == "DownLeft" or button == "Left" then
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		scroller:scroll_by_amount(-1);
		
	elseif button == "DownRight" or button == "Right" then
		SOUND:PlayOnce(THEME:GetPathS("MusicWheel", "change"), true);
		scroller:scroll_by_amount(1);
	
	elseif button == "Back" then
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
	elseif button == "MenuDown" then
		--[[local curItem = scroller:get_actor_item_at_focus_pos().container:GetChild("banner");
		local scaledHeight = testScaleToWidth(curItem:GetWidth(), curItem:GetHeight(), 500);
		SCREENMAN:SystemMessage(curItem:GetWidth().."x"..curItem:GetHeight().." -> 500x"..scaledHeight);]]
		
		--local curItem = scroller:get_actor_item_at_focus_pos();
		--SCREENMAN:SystemMessage(ListActorChildren(curItem.container));
	else
	
	end;
	
end;

local t = Def.ActorFrame{

	Def.Quad{
		InitCommand=cmd(setsize,SCREEN_CENTER_X,SCREEN_HEIGHT;diffuse,color("0,0,0,.5");horizalign,right;xy,0,SCREEN_CENTER_Y;);
		OnCommand=cmd(decelerate,.2;x,SCREEN_CENTER_X);
	};
	Def.Quad{
		InitCommand=cmd(setsize,SCREEN_CENTER_X,SCREEN_HEIGHT;diffuse,color("0,0,0,.5");horizalign,left;xy,SCREEN_WIDTH,SCREEN_CENTER_Y;);
		OnCommand=cmd(decelerate,.2;x,SCREEN_CENTER_X);
	};
	Def.Quad{
		InitCommand=cmd(setsize,200,30;diffuse,Color("HoloBlue");faderight,1;fadeleft,1;Center);
	};
	
	OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
		--musicwheel = SCREENMAN:GetTopScreen():GetChild('MusicWheel');
		scroller:set_info_set(sortNames, 1);
		--scroller:scroll_by_amount(selection-1)
	end;
	
};
t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, SCREEN_CENTER_X, SCREEN_CENTER_Y);


return t;
