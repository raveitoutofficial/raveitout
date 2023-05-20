local player = ...


local NumSongsToLevelUp = 4
local MaxLevel=100
local function calcPlayerLevel()
	local numSongsPlayed = PROFILEMAN:GetProfile(player):GetTotalNumSongsPlayed()
	if numSongsPlayed > MaxLevel*NumSongsToLevelUp then
		return MaxLevel;
	else
		return numSongsPlayed/NumSongsToLevelUp
	end;
end

local function levelPercent()
	return (PROFILEMAN:GetProfile(player):GetTotalNumSongsPlayed()%NumSongsToLevelUp)/NumSongsToLevelUp
end;

local function rectGen(width, height, lineSize, lineColor, bgColor)
    return Def.ActorFrame{
    
        --Background transparency
        Def.Quad{
            InitCommand=cmd(setsize,width, height;diffuse,bgColor);
            
        };
        --Bottom line
        Def.Quad{
            InitCommand=cmd(setsize,width + lineSize, lineSize;addy,height/2;diffuse,lineColor--[[horizalign,0;vertalign,2]]);
            
        };
        --Top line
        Def.Quad{
            InitCommand=cmd(setsize,width + lineSize, lineSize;addy,-height/2;diffuse,lineColor--[[horizalign,2;vertalign,0]]); --2 = right aligned
            
        };
        --Left line
        Def.Quad{
            InitCommand=cmd(setsize,lineSize, height + lineSize;addx,-width/2;diffuse,lineColor--[[vertalign,0;horizalign,2]]); --2 = right aligned
            
        };
        --Right line
        Def.Quad{
            InitCommand=cmd(setsize,lineSize, height + lineSize;addx,width/2;diffuse,lineColor--[[vertalign,2;horizalign,0]]); --2 = bottom aligned
            
        };
        

    };
end;

return Def.ActorFrame{
	Def.Sprite{
		Texture="altBanner";
	};
	
	Def.Quad{
		InitCommand=cmd(diffuse,color("#000000BB");horizalign,left;vertalign,bottom;setsize,200,5;xy,-250/2+50,25);
	};
	Def.Quad{
		--setsize(200*percent)
		InitCommand=cmd(diffuse,color("#FFFFFF");horizalign,left;vertalign,bottom;setsize,111,5;xy,-250/2+50,25);
	};

	Def.Sprite{
		Texture=getenv("profile_icon_P1");
		InitCommand=cmd(zoomto,50,50;x,-250/2+.5;horizalign,left);
	};
	rectGen(250,50,1.5,color("#000000FF"),color("#00000000"));
	    --The vertical alignment on this font is beyond stupid
    LoadFont("facu/_bebas neue 40px")..{
        InitCommand=cmd(zoom,.5;horizalign,left;vertalign,top;xy,-70,-20;skewx,-.2);
		OnCommand=function(self)
			--self:settext("bla");
			local profile = PROFILEMAN:GetProfile(player)
			local name = profile:GetDisplayName()
			--SCREENMAN:SystemMessage(name)
			
			if MEMCARDMAN:GetCardState(player) == 'MemoryCardState_none' then
				--If name is blank, it's probably the machine profile... After all, the name entry screen doesn't allow blank names.
				if name == "" then		
					if player == PLAYER_1 then
						self:settext("PLAYER 1");
					else
						self:settext("PLAYER 2");
					end;
				else
					--TODO: Adjust maxwidth based on the number of hearts per play.
					self:settext(string.upper(name)):maxwidth(160);
				end
			else
				self:settext(string.upper(name)):maxwidth(160);
			end
			
		end;
	};
	LoadFont("facu/_bebas neue 40px")..{
		Text="Lv.";
		InitCommand=cmd(zoom,.3;horizalign,left;vertalign,bottom;xy,-70,15;);
	};
	--[[Def.Sprite{
		Texture="level";
		InitCommand=cmd(zoom,.6;horizalign,left;vertalign,bottom;xy,-70,15);
	};]]
	LoadFont("facu/_zona pro thin 40px")..{
		Text=string.format("%02d",calcPlayerLevel());
		InitCommand=cmd(zoom,.6;horizalign,left;vertalign,bottom;xy,-58,15;);
	};
	
	LoadFont("venacti/_venacti_outline 26px bold monospace numbers")..{
		Text=(levelPercent()*100).."%";
		InitCommand=cmd(zoom,.5;horizalign,right;vertalign,bottom;xy,250/2-2,17);
	};

};
