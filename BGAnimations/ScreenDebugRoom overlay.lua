--local p;

--The thing you want to be displayed in the ActorScroller. It has to be a table because I said so.
local scrollerItemTable = {"Item 1", "Item 2", "Item 3", "Item 4"}


local function inputs(event)
	if event.type == "InputEventType_Release" then return end

	local button = event.button
	local realButton = ToEnumShortString(event.DeviceInput.button)

	if realButton == "left mouse button" or realButton == "right mouse button" or realButton == "middle mouse button" then
		local xpos = INPUTFILTER:GetMouseX();
		local ypos = INPUTFILTER:GetMouseY();
		SCREENMAN:SystemMessage(realButton.. " x: "..xpos..", y: "..ypos);
	elseif button == "Start" then
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
	elseif button == "Back" then
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
	else
		SCREENMAN:SystemMessage(button.. " " .. realButton);
	end;
end;


local t = Def.ActorFrame{
	OnCommand=function(self)
		--SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;
	--[[Def.Quad{
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;Center);
	};]]
	--[[Def.Sprite{
		--Texture=THEME:GetPathG("","_BGMovies/Arcade.mpg");
		Texture=THEME:GetPathG("Banner","SortOrder_Title");
		InitCommand=cmd(Center;zoom,.5;SetEffectMode,"EffectMode_Saturation");
		Name="Proxy";
	};]]
	Def.Sprite{
		Texture=THEME:GetPathG("","_BGMovies/Arcade.mpg");
		--Texture=THEME:GetPathG("Banner","SOrtOrder_Title");
		InitCommand=cmd(xy,SCREEN_CENTER_X/2,SCREEN_CENTER_Y;zoom,.5;);
		CodeMessageCommand=function(self,param)
			if param.Name == "MenuRight" then
				self:stoptweening():linear(1):diffusealpha(0):linear(1):diffusealpha(1);
			end;
		end;
		Name="Proxy";
	};
	
	Def.ActorProxy{
		InitCommand=cmd(x,SCREEN_WIDTH/2;);
		OnCommand=function(self)
			self:SetTarget(self:GetParent():GetChild("Proxy"));
		end;
	};
	Def.ActorProxy{
		InitCommand=cmd(xy,SCREEN_WIDTH/2,SCREEN_HEIGHT/2;);
		OnCommand=function(self)
			self:SetTarget(self:GetParent():GetChild("Proxy"));
		end;
	};
	Def.ActorProxy{
		InitCommand=cmd(x,SCREEN_WIDTH;);
		OnCommand=function(self)
			self:SetTarget(self:GetParent():GetChild("Proxy"));
		end;
	};
	
	Def.SpriteAsync{
		Texture=THEME:GetPathG("Common","Arrow");
		InitCommand=cmd(Center);
	};
	

};

local function updateFunction(self,delta)
	local i = 1
	for n,child in pairs(self:GetChildren()) do
		i=i+1
		local x = child:GetX()-(delta*150)
		if x < -10 then
			x=x+SCREEN_WIDTH+20
		end;
		local y = math.sin(x*math.pi/(SCREEN_WIDTH/4))*100+SCREEN_CENTER_Y
		--MESSAGEMAN:Broadcast("SystemMessage",{Message=x..","..y,NoAnimate=true})

		child:xy(x,y)
	end;
	--MESSAGEMAN:Broadcast("SystemMessage",{Message=i,NoAnimate=true})
end;

local function getWavyText(s,x,y)
	local letters = Def.ActorFrame{
		OnCommand=function(self)
			self:SetUpdateFunction(updateFunction)
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

local function getZoomInText(s,x,y)
	local letters = Def.ActorFrame{
		OnCommand=function(self)
			self:y(y)
		end;
	};
	local spacing = 16;
	for i=1,#s do
		local c = s:sub(i,i)
		letters[i] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			Name=i;
			Text=c;
			InitCommand=function(self)
				self:x(x-(#s)*spacing/2+i*spacing+math.random(-10,10))
				self:y(math.random(-10,10))
				self:zoom(0);
			end;
			OnCommand=cmd(sleep,i*.2;linear,.2;zoom,1;xy,x-(#s)*spacing/2+i*spacing,0);
		};
	end;
	return letters;
end;

local function getWeirdText(s,x,y)
	local letters = Def.ActorFrame{
		OnCommand=function(self)
			self:y(y)
		end;
	};
	local spacing = 16;
	for i=1,#s do
		local c = s:sub(i,i)
		letters[i] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			Name=i;
			Text=c;
			InitCommand=function(self)
				self:x(x-(#s)*spacing/2+i*spacing+math.random(-100,100))
				self:y(math.random(-100,100))
				self:diffusealpha(0);
			end;
			OnCommand=cmd(sleep,i*.2;decelerate,.2;diffusealpha,1;xy,x-(#s)*spacing/2+i*spacing,0);
		};
	end;
	return letters;
end;


--[[t[#t+1] = Def.ActorFrame{
	OnCommand=function(self)
		self:SetUpdateFunction(updateFunction)
	end;
	Def.BitmapText{
		Name="a";
		Font="venacti/_venacti_outline 26px bold diffuse";
		InitCommand=cmd(Center);
		--OnCommand=cmd(x,SCREEN_WIDTH;linear,5;x,0;queuecommand,"On";);
		Text="A"
	}
}]]
t[#t+1] = getWavyText("WAVY TEXT TEST",SCREEN_CENTER_X,SCREEN_CENTER_Y);
t[#t+1] = getZoomInText("ZOOM IN TEST",SCREEN_CENTER_X,SCREEN_CENTER_Y);
t[#t+1] = getWeirdText("Weird text",SCREEN_CENTER_X,SCREEN_CENTER_Y+100);




--[[local function bTos(b) return b and "true" or "false" end;

t[#t+1] = Def.ActorFrame{
	Def.BitmapText{
		Font="Common Normal";
		InitCommand=cmd(Center);
		Text=bTos(UNLOCKMAN:IsSongLocked(SONGMAN:FindSong("99-Easy/Gangnam Style")));
	}
}]]


return t;
