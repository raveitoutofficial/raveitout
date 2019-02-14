local function getCardPath(player)
	if player == PLAYER_1 then
		return "/@mc1/"
	else
		return "/@mc2/"
	end;
end;

local curStep = {
	PLAYER_1 = 0,
	PLAYER_2 = 0
}

function genStuff(side)
	local f = Def.ActorFrame{
		CodeMessageCommand=function(self, params)
			if params.PlayerNumber ~= side then return end;
			if curStep[side] == 0 and MEMCARDMAN:GetCardState(side) == "MemoryCardState_ready" then
				--Because they can exit the screen at any time, it's better to use new handles each time.
				local Handle = RageFileUtil.CreateRageFile();
				local pass = Handle:Open(getCardPath(side).."SMtemp.txt", 2);
				if pass then
					Handle:Write("Hello World!");
					Handle:Flush();
					self:GetParent():GetChild("Text"):settext(THEME:GetString("ScreenMemoryCardTest", "WriteTestSuccess"))
					self:sleep(1);
					curStep[side] = 1
				else
					self:GetParent():GetChild("Text"):settext(THEME:GetString("ScreenMemoryCardTest","OpenFailed"))
					curStep[side] = -1;
				end;
				Handle:Close();
			elseif curStep[side] == 1 then
			
			end;
		end;
	
		LoadFont("Common Normal")..{
			Name="Text";
			--Text=string.format(THEME:GetString("ScreenMemoryCardTest","InsertCard"),pname(side));
			InitCommand=cmd(y,SCREEN_CENTER_Y);
			OnCommand=function(self)
				local status = ToEnumShortString(MEMCARDMAN:GetCardState(side))
				if status == "none" or status == "removed" then
					self:settextf(THEME:GetString("ScreenMemoryCardTest","InsertCard"),pname(side));
				elseif status == "ready" then
					self:settext(THEME:GetString("ScreenMemoryCardTest","BeginTest"))
				else
					self:settextf(THEME:GetString("ScreenMemoryCardTest","UnknownState"),status);
				end;
			end;
			StorageDevicesChangedMessageCommand=cmd(playcommand,"On");
		}
	};
	
	return f;

end;

local t = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(setsize,2,SCREEN_HEIGHT;Center;diffuse,Color("White"));
	}
}

t[#t+1] = genStuff(PLAYER_1)..{
	InitCommand=cmd(xy,SCREEN_CENTER_X/2,0);
};

t[#t+1] = genStuff(PLAYER_2)..{
	InitCommand=cmd(xy,SCREEN_WIDTH*.75,0);
};

return t;