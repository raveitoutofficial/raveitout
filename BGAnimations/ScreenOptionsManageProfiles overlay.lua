local t =		Def.ActorFrame{}
local sepx = 	20		--separation from screenedge

t[#t+1] = Def.ActorFrame{
	LoadFont("Common normal")..{
		InitCommand=cmd(xy,SCREEN_LEFT+sepx,SCREEN_BOTTOM-sepx*2;horizalign,left;vertalign,bottom;zoom,0.5;);
		StorageDevicesChangedMessageCommand=function(self)
			local slot1 = MEMCARDMAN:GetCardState(PLAYER_1)
			local slot2 = MEMCARDMAN:GetCardState(PLAYER_2)
		--[[	if slot1 == "MemoryCardState_none" then
				mem1 = "No card inserted"
			else
				mem1 = slot1
			end;
			if slot2 == "MemoryCardState_none" then
				mem2 = "No card inserted"
			else
				mem2 = slot2
			end;
		--	self:settext("Status slot 1: "..mem1.."\nStatus slot 2: "..mem2);	--]]
			self:settext("Status slot 1: "..slot1.."\nStatus slot 2: "..slot2);
		end
	};
};
return t;