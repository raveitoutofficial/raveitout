local t = Def.ActorFrame{};

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local alreadyFailed = false;
	t[#t+1] = Def.ActorFrame{
	
		InitCommand=function(self)
			--You'll only ever see the failed message in multiplayer versus
			self:x(THEME:GetMetric("ScreenGameplay","Player"..pname(pn).."OnePlayerOneSideX"));
			self:y(SCREEN_CENTER_Y+50);
		end;
		ComboChangedMessageCommand=function(self,params)
			local failed = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetFailed();
			if failed and not alreadyFailed then
				alreadyFailed = true;
				self:GetChild("FailedG"):playcommand("Play");
				self:GetChild("TryAgainG"):playcommand("Play");
				
				--Make the entire note field invisible when tweened
				--PlayerP1 and PlayerP2 cannot be tweened
				SCREENMAN:GetTopScreen():GetChild('Player'..pname(pn)):visible(false);
				
				--Just make the notes invisible. No point in doing this, really
				--[[local ps = GAMESTATE:GetPlayerState(pn);
				local playerOptions = ps:GetPlayerOptions('ModsLevel_Song');
				--:StealthPastReceptors(true); is probably a 5.1 thing but I'm still using 5.0.12 on Windows :V
				playerOptions:Stealth(1,1, true);]]
			end;
		end;
	
		LoadActor("Failed")..{
			Name="FailedG";
			InitCommand=cmd(vertalign,bottom;diffusealpha,0;addx,100;);
			PlayCommand=cmd(decelerate,.5;diffusealpha,1;addx,-100);
		};
		
		LoadActor("try_again")..{
			Name="TryAgainG";
			InitCommand=cmd(vertalign,top;diffusealpha,0;addx,-100);
			PlayCommand=cmd(decelerate,.5;diffusealpha,1;addx,100);
		};
	};
end;

return t;
