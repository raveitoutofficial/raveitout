local function inputs(event)
	
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	--Also we only want it to activate when they're NOT selecting the difficulty.
	--if not pn or not SCREENMAN:get_input_redirected(pn) then return end

	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	if button == "Select" then
		SCREENMAN:SystemMessage("Debug: Card inserted...");
		MESSAGEMAN:Broadcast("CardScanned",{card="DEADBEEF",Player=PLAYER_1});
	else
		--SCREENMAN:SystemMessage("Unknown button:"..button);
	end;
	
end;

return Def.ActorFrame{
	
	--[[OnCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(inputs);
	end;]]
	

	
	Def.Quad{
		InitCommand=cmd(setsize,SCREEN_WIDTH,50;diffuse,Color("Black");zoomy,0);
		CardScannedMessageCommand=cmd(decelerate,.3;zoomy,1);
	};
	LoadFont("monsterrat/_montserrat semi bold 60px")..{
		InitCommand=cmd(skewx,-0.255;zoom,.6;diffusealpha,0;addy,-8);
		CardScannedMessageCommand=cmd(decelerate,.3;diffusealpha,1);
		Text="SESSION STARTING...";
	};
	LoadFont("facu/_zona pro thin 20px")..{
		Text="PLEASE WAIT";
		InitCommand=cmd(zoom,.6;addy,15;diffusealpha,0);
		CardScannedMessageCommand=cmd(decelerate,.3;diffusealpha,1);
	};
	
	Def.Quad{
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,Color("Black");diffusealpha,0);
		CardScannedMessageCommand=function(self,params)
			LAST_SCANNED_CARD = params
			--SOUND
			GAMESTATE:JoinPlayer(params.Player):ApplyGameCommand("applydefaultoptions",params.Player);
			SOUND:PlayOnce(THEME:GetPathS("","iidx/decide_lincle"));
			self:sleep(.5):linear(.3):diffusealpha(1):sleep(1):queuecommand("EnterProfileSelect");
		end;
		EnterProfileSelectCommand=function(self)
			--Jumping straight from ScreenDemonstration to ScreenSelectProfile causes it to not behave correctly. So here's a 'fix' of sorts...
			SCREENMAN:SetNewScreen("ScreenSetupProfile");
			--SCREENMAN:SetNewScreen("ScreenSelectProfile");
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
		end;
	};

};

