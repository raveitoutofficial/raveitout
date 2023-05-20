--THIS DOES NOT WORK IN DECORATIONS! ONLY OVERLAY!!!

--Function for... Drawing a rectangle.
function rectGen(width, height, lineSize, fgColor, bgColor)
    return Def.ActorFrame{
    
		GlowCommand=function(self)
			self:GetChild("Background"):stoptweening():glow(Color("White")):decelerate(.5):glow(color("1,1,1,0"));
		end;
        --Background transparency
        Def.Quad{
			Name="Background";
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

local player = ...;

--Settings you can change
--local RECT_WIDTH,RECT_HEIGHT = SCREEN_WIDTH/2-10,SCREEN_HEIGHT*.7
local SSC_BORDER_SIZE = 4;
local SSC_ROWS = 1;
local SSC_COLUMNS = 9;
local bWidth, bHeight = 40,50;
--The bWidth for the top.
local topbWidth = bWidth - 12;
--Various precalculated variables to make things easy to position
local sqWidth = topbWidth*SSC_COLUMNS+SSC_BORDER_SIZE*SSC_COLUMNS;
local sqHeight = bHeight*SSC_ROWS+SSC_BORDER_SIZE*SSC_ROWS;
local xPosition = -sqWidth/2+topbWidth/2+SSC_BORDER_SIZE/2;
local yPosition = -100;


local f = Def.ActorFrame{
	
	--rectGen(RECT_WIDTH,RECT_HEIGHT,2,color("1,1,1,1"),color("0,0,0,0"))..{};
	LoadActor(THEME:GetPathG("Common","PlayerBox"))..{
		InitCommand=cmd(zoom,.6;diffuse,PlayerColor(player););
	};
	--[[rectGen(bWidth,bHeight,2,Color("White"),color(".3,.3,.3,.5"))..{
		Name="BGQuad";
		InitCommand=cmd(y,100);
	};]]
	--[[LoadActor("arrow")..{
		InitCommand=cmd(zoom,.5);
	};]]
}

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

--I got sick of draw issues, so draw the background box first
for i = 0, SSC_ROWS-1 do
	for j = 0, SSC_COLUMNS-1 do
		boxFrame[#boxFrame+1] = Def.Quad{
			InitCommand=cmd(setsize,topbWidth,bHeight;z,1;xy,j*(topbWidth+SSC_BORDER_SIZE),i*(bHeight+SSC_BORDER_SIZE);zoomy,0);
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
				self:sleep(.03*j):decelerate(.1):zoomy(1);
			end;
		};
		--[[boxFrame[#boxFrame+1] = rectGen(topbWidth,bHeight,1,Color("White"),color("1,1,1,.5"))..{
				InitCommand=cmd(setsize,topbWidth,bHeight;z,1;xy,j*(topbWidth+SSC_BORDER_SIZE),i*(bHeight+SSC_BORDER_SIZE););
			};]]
	end
end
--Then draw the letters.
for i = 0, SSC_ROWS-1 do
	for j = 0, SSC_COLUMNS-1 do
		local chrID = tonumber(j..i)
		boxFrame[#boxFrame+1] = Def.ActorFrame{
			InitCommand=cmd(xy,j*(topbWidth+SSC_BORDER_SIZE),i*(bHeight+SSC_BORDER_SIZE);SetDrawByZPosition,true);
			Name=j;
			

			
			LoadFont("monsterrat/_montserrat semi bold 60px")..{
				Name="TextActor";
				InitCommand=cmd(diffuse,color("0,0,0,1");zoom,0.6;skewx,-0.255;maxwidth,topbWidth+20;z,100;);
				NewTextCommand=cmd(zoom,1.6;decelerate,.5;zoom,.6);
				--Text=j;
			};
		};
	end
end

local str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890"
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
				
			rectGen(bWidth,bHeight,2,Color("White"),color(".2,.2,.2,.5"))..{
				Name="BGQuad";
			};
			
			LoadFont("monsterrat/_montserrat semi bold 60px")..{
				Name="Text";
				--Text="asdadsadasdasd";
				InitCommand=cmd(diffuse,color("1,1,1,1");zoom,0.6;skewx,-0.255;maxwidth,bWidth+20);
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
		--[[if math.abs(offsetFromCenter) > 3 then
			self.container:diffusealpha(0);
		else
			self.container:diffusealpha(1);
		end;]]
		self.container:diffusealpha(math.cos(offsetFromCenter*math.pi/6.5))
		self.container:x(offsetFromCenter*45);
	end,
	-- info is one entry in the info set that is passed to the scroller.
	set= function(self, text)
		self.container:GetChild("Text"):settext(text);
	end,
}}

local curName = "";
local isDone = false;
local t = Def.ActorFrame{
	--[[InitCommand=function(self)
		--self:SetTextureName( "asdfghjkl" )
		self:SetWidth( RECT_WIDTH );
		self:SetHeight( RECT_HEIGHT );
		self:EnableAlphaBuffer( false ); 
		self:Create();

		-- The ActorFrameTexture only needs to draw once, so hide it after the first draw.
		self:Draw()
		self:hibernate(math.huge)
		self:Center();
	end;
	Def.ActorFrame{
		Name = "Draw";
		-- three random quads, two of them strattling the edge of the texture.
		Def.Quad{ InitCommand=cmd(zoom,50;diffuse,1,0,0,0.5) };
		Def.Quad{ InitCommand=cmd(zoom,50;diffuse,0,1,0,0.5;x,64;y,64) };
		Def.Quad{ InitCommand=cmd(zoom,50;diffuse,0,0,1,0.5;x,120;y,100) };
	};]]
	OnCommand=function(self)
		scroller:set_info_set(strTable, 1);
	end;
	--Input handler
	CodeMessageCommand=function(self, params)
		--SCREENMAN:SystemMessage(params.Name);
		if params.PlayerNumber ~= player then return end;
		if isDone then return end;
	
		if params.Name == "Left" or params.Name == "MenuLeft" or params.Name == "DownLeft" then
			--SCREENMAN:SystemMessage("aasdas");
			scroller:scroll_by_amount(-1);
			SOUND:PlayOnce(THEME:GetPathS("OptionsList", "Move"))
		elseif params.Name == "Right" or params.Name == "MenuRight" or params.Name == "DownRight" then
			scroller:scroll_by_amount(1);
			SOUND:PlayOnce(THEME:GetPathS("OptionsList", "Move"))
		elseif params.Name == "Center" or params.Name == "Start" then
			local txt = scroller:get_info_at_focus_pos();
			scroller:get_actor_item_at_focus_pos().container:GetChild("BGQuad"):playcommand("Glow");
			--SCREENMAN:SystemMessage(txt)
			if txt == "DEL" then
				curName = string.sub(curName,1,-2);
				boxFrameActor:GetChild(tostring(#curName)):GetChild("TextActor"):settext("");
				SOUND:PlayOnce(THEME:GetPathS("OptionsList", "Enter"))
			elseif txt == "END" then
			
				--Don't allow blank names.
				if curName == "" then curName = "RAVEITOUT" end;
				
				--Pass the new name to DoneSelectingMessageCommand because the handler might be using it for a machine high score or a new profile name. We don't need to know which one.
				MESSAGEMAN:Broadcast("DoneSelecting",{Player=player,Name=curName});
				isDone = true;
				self:decelerate(.5):zoomy(0);
			elseif #curName < SSC_COLUMNS then
				curName = curName..txt;
				boxFrameActor:GetChild(tostring(#curName-1)):GetChild("TextActor"):settext(txt):playcommand("NewText");
				SOUND:PlayOnce(THEME:GetPathS("OptionsList", "Select"))
				if #curName == SSC_COLUMNS then
					--END is the last element
					scroller:scroll_to_pos(#strTable);
				end;
			else
				
			end;
		elseif params.Name == "Back" then
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
		else
			SCREENMAN:SystemMessage("unknown input: "..params.Name);
		end;
	end;
};
t[#t+1] = f;
t[#t+1] = scroller:create_actors("foo", numWheelItems, item_mt, 0, 100);

t[#t+1] = boxFrame;
t[#t+1] = boxFrame2;
t[#t+1] = 	LoadActor(THEME:GetPathG("common",'arrow'))..{
		InitCommand=cmd(rotationz,90;y,-20;bounce)
		--OnCommand=cmd(self:GetTexture
	};
t[#t+1] = LoadActor(THEME:GetPathG("Common","Mask"))..{
		InitCommand=cmd(zoom,.6;diffuse,PlayerColor(player););
	};
	
--[[t[#t+1] = LoadFont("Common Normal")..{
	Text=THEME:GetString(Var("LoadingScreen"),"NameBoxText");
};]]

return t;
