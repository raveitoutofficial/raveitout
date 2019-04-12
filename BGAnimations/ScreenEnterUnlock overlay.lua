local t = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:AddNewScreenToTop("ScreenTextEntry");
		local serverSettings = {
			Question = "Enter a cheat code.",
			MaxInputLength = 255,
			OnOK = function(answer)
				if answer == "DebugOn" then
					DoDebug = true;
					SCREENMAN:SystemMessage("Debug enabled.");
				elseif answer == "DebugOff" then
					DoDebug = false;
					SCREENMAN:SystemMessage("Debug disabled.");
				end;
				--SCREENMAN:SystemMessage(answer)
				--SCREENMAN:SetNewScreen("ScreenOptionsTH")
				MESSAGEMAN:Broadcast("ScreenOver");
				--SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
			end,
		};
		SCREENMAN:GetTopScreen():Load(serverSettings);
	end;
	
	CodeMessageCommand=function(self,param)
		if param.Name == "Back" then
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
		end;
	end;
	
	LoadFont("Common Normal")..{
		--Text="Just press back, ScreenTextEntry is hard to use";
		InitCommand=cmd(Center;);
		ScreenOverMessageCommand=function(self, param)
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
			local unlockmsg = param
			if unlockmsg then
				self:settextf("%s unlocked!",unlockmsg)
				--self:settext("awdad");
			else
				self:settext("Invalid cheat code.");
			end;
		end;
	};
	LoadFont("Common Normal")..{
		Text="Press back to exit.";
		InitCommand=cmd(Center;visible,false;addy,20);
		ScreenOverMessageCommand=function(self, params)
			self:visible(true);
		end;
	};

};

return t;
