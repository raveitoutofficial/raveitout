local function getWavyText(s,x,y)
	local letters = Def.ActorFrame{}
	local spacing = 16
	for i = 1, #s do
		local c = s:sub(i,i)
		--local c = "a"
		letters[i] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			Text=c;
			InitCommand=cmd(x,x-(#s)*spacing/2+i*spacing;y,y;effectoffset,i*.1;bob;);
		};
	end;
	return letters;
end;

local function updateFunction(self,delta)
	for n,child in pairs(self:GetChildren()) do
		local x = child:GetX()-(delta*175)
		if x < -1000 then
			x=x+SCREEN_WIDTH+1200
		end;
		local y = math.sin(x*math.pi/(SCREEN_WIDTH/4))*30
		child:xy(x,y)
	end;
end;

local function getWavyTextSin(s,x,y)
	local letters = Def.ActorFrame{
		OnCommand=function(self)
			self:SetUpdateFunction(updateFunction)
			self:y(y);
		end;
	};
	local spacing = 16;
	for i=1,#s do
		local c = s:sub(i,i)
		letters[i] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			Name=i;
			Text=c;
			InitCommand=cmd(x,x-(#s)*spacing/2+i*spacing;);
		};
	end;
	return letters;
end;

local function getWavyTextPlusRainbow(s,x,y)
	local letters = Def.ActorFrame{
		OnCommand=function(self)
			self:SetUpdateFunction(updateFunction)
			self:y(y);
		end;
	};
	local spacing = 16;
	for i=1,#s do
		local c = s:sub(i,i)
		letters[i] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			Name=i;
			Text=c;
			InitCommand=cmd(x,x-(#s)*spacing/2+i*spacing;rainbow;effectoffset,i*.1;);
		};
	end;
	return letters;
end;

local xVelocity = 0
local t = Def.ActorFrame{
	Def.ActorFrame{
		FOV=90;
		LoadActor(THEME:GetPathG("RhythmLunatic","icon"))..{
			InitCommand=cmd(rainbow;customtexturerect,0,0,10,5;setsize,SCREEN_WIDTH*2,750;Center;texcoordvelocity,-1,1.5;rotationx,-90/4*3.5;fadetop,1);
			CodeMessageCommand=function(self, params)
				if params.Name == "Start" or params.Name == "Center" then
					SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
				elseif params.Name == "Left" then
					xVelocity=xVelocity+.5;
				elseif params.Name == "Right" then
					xVelocity=xVelocity-.5;
				else
					--SCREENMAN:SystemMessage("Unknown button: "..params.Name);
				end;
				self:texcoordvelocity(xVelocity,1.5);
			end;
		};
	}
};
t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
	Text="Rave It Out: Season 2";
	InitCommand=cmd(xy,SCREEN_CENTER_X,50);
};
--t[#t+1] = getWavyText("Rave It Out: Season 2",SCREEN_CENTER_X,SCREEN_CENTER_Y-120);
t[#t+1] = getWavyText("\40\82\101\41\112\114\111\103\114\97\109\109\101\100\32\98\121\32\65\99\99\101\108\101\114\97\116\111\114",SCREEN_CENTER_X,SCREEN_CENTER_Y-100);
t[#t+1] = getWavyText("Original code by NeobeatIKK (Sergio Madrid), Jose Jesus, Alisson de Oliveira",SCREEN_CENTER_X,SCREEN_CENTER_Y)..{
	OnCommand=cmd(x,1200;linear,10.4;x,-1200;queuecommand,"On";);
};
t[#t+1] = getWavyText("Greetz to StepPrime, StepF2, STARLiGHT Team",SCREEN_CENTER_X,SCREEN_CENTER_Y+80);
t[#t+1] = getWavyTextPlusRainbow("Thank you for playing RAVE IT OUT! We hope you enjoyed it!",SCREEN_CENTER_X,SCREEN_BOTTOM-80);
return t;
