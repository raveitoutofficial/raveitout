local cngrts1 = "Congratulations: "
local cngrts2 = " Unlocked!"
local unlposx = _screen.cx
local unlposy = _screen.cy+200
local unlzoom = 0.75

return Def.ActorFrame{
	
	LoadFont("Common normal")..{	--"All Around the World"	--test
		InitCommand=cmd(xy,unlposx,unlposy;zoom,unlzoom;);
		OnCommand=function(self)
			if PROFILEMAN:GetMachineProfile():GetNumTotalSongsPlayed() >= 1 then
				local IsLocked = IsEntryIDLocked("TT002");
				if  IsLocked ~= -1 then
					if IsLocked then
						UNLOCKMAN:UnlockEntryID("TT002");
						self:settext(cngrts1 .. "\"All Around the World\"" .. cngrts2);
					end;
				else
					self:settext("EntryID no valida");
				end;
			end;
		end;
	};

};