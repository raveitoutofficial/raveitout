--[[function rectGen(width, height, lineSize, bgColor)
    return Def.ActorFrame{
    
        --Background transparency
        Def.Quad{
            InitCommand=cmd(setsize,width, height;diffuse,bgColor);
            
        };
        --Bottom line
        Def.Quad{
            InitCommand=cmd(setsize,width + lineSize, lineSize;addy,height/2;);
            
        };
        --Top line
        Def.Quad{
            InitCommand=cmd(setsize,width + lineSize, lineSize;addy,-height/2;); --2 = right aligned
            
        };
        --Left line
        Def.Quad{
            InitCommand=cmd(setsize,lineSize, height + lineSize;addx,-width/2;); --2 = right aligned
            
        };
        --Right line
        Def.Quad{
            InitCommand=cmd(setsize,lineSize, height + lineSize;addx,width/2;); --2 = bottom aligned
            
        };
        

    };
end;]]

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
	LoadFont("common normal")..{
		InitCommand=cmd(xy,5,25;horizalign,left;vertalign,top;zoom,.5;Stroke,Color("Black"));
		OnCommand=function(self)
			if PREFSMAN:GetPreference("AllowExtraStage") then
				self:settext("HEARTS PER PLAY: "..HeartsPerPlay.."+");
			else
				self:settext("HEARTS PER PLAY: "..HeartsPerPlay);
			end;
		end;
	};
	
	--[[Def.ActorFrame{
	
		InitCommand=cmd(xy,120,100;);
		
		rectGen(220,100,2,color("0,0,0,.5"))..{
		};
		
		LoadFont("facu/_zona pro bold 40px")..{
			Text="Update Available";
			InitCommand=cmd(addy,-38;zoom,.5;skewx,-0.125);
		};
		Def.Quad{
			InitCommand=cmd(setsize,180,2;fadeleft,.2;faderight,.2;addy,-25);
		};
		
		LoadFont("facu/_zona pro bold 40px")..{
			Text="There is an update available.\nRestart the machine to apply it.";
			InitCommand=cmd(zoom,.3);
		};
	};]]


	LoadFont("Common normal")..{	--Unlock status data
		Condition=DoDebug;
		InitCommand=cmd(x,SCREEN_LEFT+10;y,SCREEN_TOP+10+30;vertalign,top;horizalign,left;zoom,0.5;);
		OnCommand=function(self)
			self:settext("Total unlocks: "..UNLOCKMAN:GetNumUnlocks().."\nUnlocked items: "..UNLOCKMAN:GetNumUnlocked());
		end;
	};
	LoadFont("Common normal")..{	--Checkear unlock status de EntryID TT002
		Condition=DoDebug;
		InitCommand=cmd(x,_screen.cx;y,_screen.cy+220;zoom,0.5;);
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
		Condition=DoDebug;
		InitCommand=cmd(x,SCREEN_LEFT+10;y,_screen.cy+180;zoom,0.5;horizalign,left;settext,"Songs played (machine profile): "..PROFILEMAN:GetMachineProfile():GetNumTotalSongsPlayed(););
	};
	
	-- Memory cards
	
	LoadActor(THEME:GetPathG("", "USB icon"))..{
		InitCommand=cmd(horizalign,left;vertalign,bottom;xy,SCREEN_LEFT+5,SCREEN_BOTTOM;zoom,.2);
		OnCommand=cmd(visible,ToEnumShortString(MEMCARDMAN:GetCardState(PLAYER_1)) == 'ready');
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};
	
	LoadActor(THEME:GetPathG("", "USB icon"))..{
		InitCommand=cmd(horizalign,right;vertalign,bottom;xy,SCREEN_RIGHT-5,SCREEN_BOTTOM;zoom,.2);
		--OnCommand=cmd(visible,true);
		OnCommand=cmd(visible,ToEnumShortString(MEMCARDMAN:GetCardState(PLAYER_2)) == 'ready');
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
	};

};
