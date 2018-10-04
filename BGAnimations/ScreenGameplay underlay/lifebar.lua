local player = ...

--note: for animation time we use local vittim
--Why is this a variable in the first place there's no need to recolor it
local tipColor =	color(1,1,1,1);
--bar controls
local vittim =		0.2			--vitality (life) change/variation animation time
local spawid =		320			--spacebar graphic width
local andiff =		0			--animation effect magnitude, also difference
local debgz1 =		0.75		--debug zoom category 1 value (Player name)
local bralph =		0.25		--life bar alpha diffuse value
local maxwid =		spawid*0.5	--Player name maxwidth (1/2 of the graphic width)	--varies depeding on font used
local namesp =		10			--additional name spacing
local lfbpsy =	175 --life bar position Y			--local lfbpsy =	200			--life bar position Y
local PSS1 =		STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

--This is the width and height of the lifebar graphic. Simple right? So don't fuck it up
LIFEBAR_WIDTH, LIFEBAR_HEIGHT = 320,26;

local t = Def.ActorFrame{
		--lifebar black border
		Def.Quad{
			InitCommand=cmd(diffuse,Color("Black");setsize,LIFEBAR_WIDTH+5,LIFEBAR_HEIGHT+5;);
		};
		
		LoadActor("spacebarInner")..{			--back meter graphic
			InitCommand=cmd(zoomtowidth,LIFEBAR_WIDTH;zoomtoheight,LIFEBAR_HEIGHT);
		};
		
		LoadActor("spacebarInner")..{		--lifebar mask
			InitCommand=cmd(MaskSource;zoomtowidth,LIFEBAR_WIDTH;zoomtoheight,LIFEBAR_HEIGHT);
			OnCommand=cmd(bounce;effectmagnitude,0,andiff,0;effectclock,"bgm";effecttiming,1,0,0,0;);
			LifeChangedMessageCommand=function(self)
				self:stoptweening();
				self:bounceend(vittim);
				if ((PSS1:GetCurrentMissCombo()/GetBreakCombo())-1) >= 0 then
					self:cropleft(0);
				else
					self:cropleft(math.abs((PSS1:GetCurrentMissCombo()/GetBreakCombo())-1));
				end;
			end;
		};
		LoadActor(pname(player).."_lifebar")..{			--meter graphic
			InitCommand=cmd(MaskDest;);};
		--Def.Quad{						--meter tip indicator
		LoadActor("tip")..{
			--We IIDX now
			InitCommand=cmd(zoomx,1.5;valign,0.4;rotationz,90;glowshift;effectclock,"beat";diffuseramp;effectcolor1,color(".8,.8,.8,1");effectcolor2,color("1,1,1,1"));
			LifeChangedMessageCommand=function(self)
				self:stoptweening();
				self:bounceend(vittim);
				if ((PSS1:GetCurrentMissCombo()/GetBreakCombo())-1) >= 0 then
					self:x(barPosY);
				else
					--So how the life calculation works is that full life is zero, and empty life is 1
					--(PSS1:GetCurrentMissCombo()/GetBreakCombo()) is the command that gives you the (reversed) life percentage
					self:x(LIFEBAR_WIDTH/2-(PSS1:GetCurrentMissCombo()/GetBreakCombo()*LIFEBAR_WIDTH));
				end;
			end;
		};
		LoadFont("Common normal")..{	--Player name
			InitCommand=function(self)
				(cmd(x,-LIFEBAR_WIDTH/2+namesp;horizalign,left;zoom,debgz1;maxwidth,maxwid;))(self)		--notice, has no "zoom,bzom;"
				if PROFILEMAN:GetPlayerName(player) == "" then
					if player == PLAYER_1 then
						self:settext("PLAYER 1");
					else
						self:settext("PLAYER_2");
					end;
				else
					self:settext(PROFILEMAN:GetPlayerName(player));
				end;
			end;
			--debug
			--[[LifeChangedMessageCommand=function(self)
				self:settext(PSS1:GetCurrentMissCombo()/GetBreakCombo());
			end;]]
		};
	};

return t;
