--TESTE
local function ModsScroller(p)
	local index = 1
	return LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
		SetCommand=function(self)
		local metadata = {};
		local mods = GAMESTATE:GetPlayerState(p):GetPlayerOptionsArray("ModsLevel_Preferred");
		
		for i=1,#mods do
			table.insert( metadata, mods[i]); --Speed
		end
		--table.insert( metadata, mods[1] );
		--table.insert( metadata, mods[2] );

			local toset = metadata[index]
			
			index = index+1
			
			if index > #metadata then index = 1 end
			
			self:settext(string.upper(toset));
			self:linear(0.2);
			self:diffusealpha(1);
			self:visible(GAMESTATE:IsSideJoined(p));
			self:sleep(1);
			self:linear(0.2)
			self:diffusealpha(0);
			self:queuecommand("Set");
			--SCREENMAN:SystemMessage("");
			
		end;
		
		CodeMessageCommand=function(self)
			--reset index
			index = 1
			--start looping
			self:stoptweening();
			self:linear(0.2)
			self:diffusealpha(0);
			self:queuecommand("Set")
		end;
		
		OffCommand=cmd(finishtweening);
	};
end;

local t =			Def.ActorFrame {};

t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	Text="MODS->";
	InitCommand=cmd(draworder,999;x,SCREEN_LEFT+4;y,SCREEN_BOTTOM-43;zoom,0.5;shadowlength,0.8;maxwidth,150;horizalign,left;visible,GAMESTATE:IsSideJoined(PLAYER_1));
};

t[#t+1] = ModsScroller(PLAYER_1)..{
	InitCommand=cmd(draworder,999;queuecommand,"Set";x,SCREEN_LEFT+60;y,SCREEN_BOTTOM-43;zoom,0.5;shadowlength,0.8;maxwidth,635;horizalign,left;);
};



t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	Text="<-MODS";
	InitCommand=cmd(draworder,999;x,SCREEN_RIGHT-4;y,SCREEN_BOTTOM-43;zoom,0.5;shadowlength,0.8;maxwidth,150;horizalign,right;visible,GAMESTATE:IsSideJoined(PLAYER_2));
};

t[#t+1] = ModsScroller(PLAYER_2)..{
	InitCommand=cmd(draworder,999;queuecommand,"Set";x,SCREEN_RIGHT-60;y,SCREEN_BOTTOM-43;zoom,0.5;shadowlength,0.8;maxwidth,635;horizalign,right;);
};


return t;