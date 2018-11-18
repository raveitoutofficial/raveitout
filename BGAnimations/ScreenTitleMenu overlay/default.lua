return Def.ActorFrame{
	LoadFont("common normal")..{
		Text=SysInfo["InternalName"].."-"..SysInfo["Version"];
		InitCommand=cmd(xy,5,5;horizalign,left;vertalign,top;zoom,.5;Stroke,Color("Black"));
	};
	LoadFont("common normal")..{
		InitCommand=cmd(xy,5,15;horizalign,left;vertalign,top;zoom,.5;Stroke,Color("Black"));
		OnCommand=function(self)
			local aspectRatio = round(GetScreenAspectRatio(),2);
			if aspectRatio == 1.78 then
				self:settext("DISPLAY TYPE: HD");
			elseif aspectRatio == 1.33 then
				self:settext("DISPLAY TYPE: SD");
			else
				self:settext("DISPLAY TYPE: ???");
			end;
		end;
	};


	LoadFont("Common normal")..{	--Unlock status data
		InitCommand=cmd(visible,DoDebug;x,SCREEN_LEFT+10;y,SCREEN_TOP+10+30;vertalign,top;horizalign,left;zoom,0.5;);
		OnCommand=function(self)
			self:settext("Total unlocks: "..UNLOCKMAN:GetNumUnlocks().."\nUnlocked items: "..UNLOCKMAN:GetNumUnlocked());
		end;
	};
	LoadFont("Common normal")..{	--Checkear unlock status de EntryID TT002
		InitCommand=cmd(visible,DoDebug;x,_screen.cx;y,_screen.cy+220;zoom,0.5;);
		OnCommand=function(self)
			local IsLocked = IsEntryIDLocked("TT002");
			if IsLocked ~= -1 then
				if IsLocked then
					self:settext("OMG THIS ACTUALLY WORKED? CALL KOTAKU! (EntryID TT002 is locked)");
				else
					self:settext("WHY ARE GORILLAS HERE? (EntryID TT002 is unlocked)");
				end;
			else
				self:settext("EntryID not valid");
			end;
		end;
	};
	--[[
	LoadFont("Common normal")..{	--Make sure of the EntryID
		InitCommand=cmd(visible,DoDebug;x,SCREEN_RIGHT-10;y,_screen.cy+180;zoom,0.5;horizalign,right;);
		OnCommand=function(self)
			if UNLOCKMAN:FindEntryID("All Around the World") then
				self:settext("EntryID for All Around the World is: ".. UNLOCKMAN:FindEntryID("All Around the World"));
			end;
		end;
	};
	]]
	LoadFont("Common normal")..{	--Songs played (machine profile)
		InitCommand=cmd(visible,DoDebug;x,SCREEN_LEFT+10;y,_screen.cy+180;zoom,0.5;horizalign,left;settext,"Songs played (machine profile): "..PROFILEMAN:GetMachineProfile():GetNumTotalSongsPlayed(););
	};

};
