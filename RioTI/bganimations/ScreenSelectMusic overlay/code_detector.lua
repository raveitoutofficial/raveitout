local t =			Def.ActorFrame {};

t[#t+1] = Def.Actor{													--Code Detector
	--code by Shakesoda and AJ, published in SM forums
	--Nota: ni este actor ni el loadfont son causantes de la interrupcion de los pad codes.
	Name="CodeController",
	CodeMessageCommand=function(self,param)
		Trace("CodeMessageCommand received.")
		local codeName = param.Name		-- code name, matches the one in metrics
		local pn = param.PlayerNumber	-- which player entered the code
	end;
};

t[#t+1] = LoadFont("venacti/_venacti_outline 26px bold diffuse")..{	--code entered display
	InitCommand=cmd(x,_screen.cx;y,_screen.cy;);
	CodeMessageCommand=function(self,param)
		if getenv("PlayMode") == "Arcade" or getenv("PlayMode") == "Pro" then
			self:settext("Code entered by "..ToEnumShortString(param.PlayerNumber)..": "..param.Name);
			(cmd(finishtweening;diffusealpha,1;zoomy,5;zoomx,-0.5;bounceend,0.2;zoomy,0.5;zoomx,1.5;linear,0.1;zoom,1;sleep,0.5;accelerate,0.5;zoom,1.5;diffusealpha,0)) (self)
		else
			self:settext("");
		end;
	end;
};



t[#t+1] = LoadActor(THEME:GetPathS("","nikk_fx/zip2"))..{
CodeMessageCommand = function(self, params)

	if params.Name == 'SpeedUp' then
		self:play()
		GAMESTATE:ApplyGameCommand("mod,"..(GAMESTATE:GetPlayerState(params.PlayerNumber):GetCurrentPlayerOptions():XMod()+0.5).."x",params.PlayerNumber);
			
	elseif params.Name == 'SpeedDown' then
		self:play()
		GAMESTATE:ApplyGameCommand("mod,"..(GAMESTATE:GetPlayerState(params.PlayerNumber):GetCurrentPlayerOptions():XMod()-0.5).."x",params.PlayerNumber);	
	end;
end;
};



return t;