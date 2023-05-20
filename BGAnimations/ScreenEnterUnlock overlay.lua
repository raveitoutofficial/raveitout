local t = Def.ActorFrame{
	OnCommand=function(self)
		SCREENMAN:AddNewScreenToTop("ScreenTextEntry");
		local serverSettings = {
			Question = THEME:GetString("ScreenEnterUnlock","Enter an unlock code."),
			MaxInputLength = 255,
			OnOK = function(answer)
				--[[if answer == "DebugOn" then
					DoDebug = true;
					SCREENMAN:SystemMessage("Debug enabled.");
				elseif answer == "DebugOff" then
					DoDebug = false;
					SCREENMAN:SystemMessage("Debug disabled.");
				end;]]
				--unlockAnswer = answer
				--SCREENMAN:SystemMessage(answer)
				--SCREENMAN:SetNewScreen("ScreenOptionsTH")
				MESSAGEMAN:Broadcast("ScreenOver",{answer=answer});
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
			local unlockmsg = param.answer
			if unlockmsg == "DebugOn" then
				DoDebug = true;
				self:settext("Debug Enabled.")
			elseif unlockmsg == "DebugOff" then
				DoDebug = false
				self:settext("Debug Disabled.")
			elseif unlockmsg == "HiddenMenu" then
				GAMESTATE:ApplyGameCommand("screen,ScreenDebugOptions")
			elseif unlockmsg == "ExportData" then
				parseData();
			elseif unlockmsg == "Assemble" then
				--AssembleDefaultGroups();
				AssembleCoopGroup();
				AssembleShortcutGroup();
				self:settext("Groups generated.");
			--All this does is write a blank quest mode file.
			elseif unlockmsg == "QuestModeDebug" then
				local strToWrite = json.encode(QUESTMODE:GenerateNewFile())
				local file= RageFileUtil.CreateRageFile()
				local path = THEME:GetCurrentThemeDirectory().."Other/QuestMode_Debug.json";
				if not file:Open(path, 2) then
					error("Could not open '" .. path .. "' to write quest mode save file.")
				else
					file:Write(strToWrite)
					file:Close()
					file:destroy()
				end
				--QUESTMODE[PLAYER_1] = a;
				self:settext("Saved file to "..path)
			else
				self:settext("Invalid unlock code.");
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
