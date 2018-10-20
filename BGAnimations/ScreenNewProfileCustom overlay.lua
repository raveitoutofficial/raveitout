--THIS DOES NOT WORK IN DECORATIONS! ONLY OVERLAY!!!

function rectGen(width, height, lineSize, fgColor, bgColor)
    return Def.ActorFrame{
    
        --Background transparency
        Def.Quad{
            InitCommand=cmd(setsize,width, height;diffuse,bgColor);
            
        };
        --Bottom line
        Def.Quad{
            InitCommand=cmd(setsize,width + lineSize, lineSize;addy,height/2;diffuse,fgColor;--[[horizalign,0;vertalign,2]]);
            
        };
        --Top line
        Def.Quad{
            InitCommand=cmd(setsize,width + lineSize, lineSize;addy,-height/2;diffuse,fgColor;--[[horizalign,2;vertalign,0]]); --2 = right aligned
            
        };
        --Left line
        Def.Quad{
            InitCommand=cmd(setsize,lineSize, height + lineSize;addx,-width/2;diffuse,fgColor;--[[vertalign,0;horizalign,2]]); --2 = right aligned
            
        };
        --Right line
        Def.Quad{
            InitCommand=cmd(setsize,lineSize, height + lineSize;addx,width/2;diffuse,fgColor;--[[vertalign,2;horizalign,0]]); --2 = bottom aligned
            
        };

    };
end;

local RECT_WIDTH,RECT_HEIGHT = SCREEN_WIDTH/2-10,SCREEN_HEIGHT*.8

local f = Def.ActorFrame{
	InitCommand=cmd(Center);
	rectGen(RECT_WIDTH,RECT_HEIGHT,2,color("1,1,1,1"),color("0,0,0,0"))..{
	};
}
--Settings you can change
local SSC_BORDER_SIZE = 4;
local SSC_ROWS = 1;
local SSC_COLUMNS = 9;
local bWidth, bHeight = 40,80;
--Various precalculated variables to make things easy to position
local sqWidth = bWidth*SSC_COLUMNS+SSC_BORDER_SIZE*SSC_COLUMNS;
local sqHeight = bHeight*SSC_ROWS+SSC_BORDER_SIZE*SSC_ROWS;
local xPosition = SCREEN_CENTER_X-sqWidth/2+bWidth/2+SSC_BORDER_SIZE/2;
local yPosition = SCREEN_CENTER_Y-100;

local boxFrameActor;
local boxFrame = Def.ActorFrame{
	InitCommand=function(self)
		self:x(xPosition);
		self:y(yPosition);
	end;
	
	OnCommand=function(self)
		boxFrameActor = self;
	end;
};

for i = 0, SSC_ROWS-1 do
	for j = 0, SSC_COLUMNS-1 do
		local chrID = tonumber(j..i)
		boxFrame[#boxFrame+1] = Def.ActorFrame{
			InitCommand=cmd(xy,j*(bWidth+SSC_BORDER_SIZE),i*(bHeight+SSC_BORDER_SIZE));
			Name=j;
			
			Def.Quad{
				InitCommand=cmd(setsize,bWidth,bHeight);
				OnCommand=function(self)
					if j%2 == 0 then
						if i%2 == 0 then
							self:diffuse(Color("HoloBlue"));
						else
							self:diffuse(Color("White"));
						end;
					else
						if i%2 ~= 0 then
							self:diffuse(Color("HoloBlue"));
						else
							self:diffuse(Color("White"));
						end;
					end;
				end;
			};
			
			LoadFont("monsterrat/_montserrat semi bold 60px")..{
				Name="TextQuad";
				InitCommand=cmd(diffuse,color("0,0,0,1");zoom,0.6;skewx,-0.255;maxwidth,bWidth+20);
				NewTextCommand=cmd(zoom,1.6;decelerate,.5;zoom,.6);
				--Text=j;
			};
		};
	end
end

local str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
local strTable = {}
for i = 1, #str do
    strTable[i] = str:sub(i, i)
end
strTable[#strTable+1] = "DEL"
strTable[#strTable+1] = "END"
-- ITEM SCROLLER
-- /////////////////////////////////
local scroller = setmetatable({disable_wrapping= false}, item_scroller_mt)
local numWheelItems = 15

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
				
			rectGen(bWidth,bHeight,2,Color("White"),color(".5,.5,.5,1"));
			
			LoadFont("monsterrat/_montserrat semi bold 60px")..{
				Name="Text";
				--Text="asdadsadasdasd";
				InitCommand=cmd(diffuse,color("0,0,0,1");zoom,0.6;skewx,-0.255;maxwidth,bWidth+20);
			};

		};
	end,
	-- item_index is the index in the list, ranging from 1 to num_items.
	-- is_focus is only useful if the disable_wrapping flag in the scroller is
	-- set to false.
	transform= function(self, item_index, num_items, is_focus)
		local offsetFromCenter = item_index-math.floor(numWheelItems/2)
		self.container:stoptweening();
		if offsetFromCenter > numWheelItems/2-2 or offsetFromCenter < -numWheelItems/2+2 then
			self.container:visible(false);
		else
			self.container:visible(true);
		end;
		self.container:decelerate(.2);
		if math.abs(offsetFromCenter) < 1 then
			self.container:y(math.cos(offsetFromCenter*math.pi/1)-15);
		else
			self.container:y(0);
		end;
		self.container:x(offsetFromCenter*45);
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, text)
		self.container:GetChild("Text"):settext(text);
	end,
}}

local curName = "";
local t = Def.ActorFrame{
	OnCommand=function(self)
		scroller:set_info_set(strTable, 1);
	end;
	--Input handler
	CodeMessageCommand=function(self, params)
		if params.Name == "Left" then
			--SCREENMAN:SystemMessage("aasdas");
			scroller:scroll_by_amount(-1);
			SOUND:PlayOnce(THEME:GetPathS("Codebox", "Move"))
		elseif params.Name == "Right" then
			scroller:scroll_by_amount(1);
			SOUND:PlayOnce(THEME:GetPathS("Codebox", "Move"))
		elseif params.Name == "Center" then
			local txt = scroller:get_info_at_focus_pos();
			--SCREENMAN:SystemMessage(txt)
			if txt == "DEL" then
				curName = string.sub(curName,1,-2);
				boxFrameActor:GetChild(tostring(#curName)):GetChild("TextQuad"):settext("");
				SOUND:PlayOnce(THEME:GetPathS("Codebox", "Enter"))
			elseif txt == "END" then
			
			elseif #curName < SSC_COLUMNS then
				curName = curName..txt;
				boxFrameActor:GetChild(tostring(#curName-1)):GetChild("TextQuad"):settext(txt):playcommand("NewText");
				SOUND:PlayOnce(THEME:GetPathS("Codebox", "Select"))
				if #curName == SSC_COLUMNS then
					--END is the last element
					scroller:scroll_to_pos(#strTable);
				end;
			else
				
			end;
		else
			SCREENMAN:SystemMessage("unknown input: "..params.Name);
		end;
	end;
};
t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, SCREEN_CENTER_X, SCREEN_CENTER_Y+100);

t[#t+1] = f;
t[#t+1] = boxFrame;
t[#t+1] = boxFrame2;
return t;