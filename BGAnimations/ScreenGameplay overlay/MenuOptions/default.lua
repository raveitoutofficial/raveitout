local lineOn = cmd(zoom,0.875;strokecolor,color("#444444");shadowcolor,color("#444444");shadowlength,3)
if IsUsingWideScreen() then
	default_width = SCREEN_WIDTH+20
else
	default_width = SCREEN_WIDTH
end;

local OptionsScroller = Def.ActorScroller {
    SecondsPerItem = 0.5;
	InitCommand=function(self)
		local items = self:GetNumChildren();
		setenv("MenuActive",false);
		self:SetNumItemsToDraw(items);
		self:SetCurrentAndDestinationItem(0);
		self:draworder(999);
		self:SetLoop(true);
		self:playcommand("On");
	end;
	
	TransformFunction = function( self, offset, itemIndex, numItems )
		self:y(-50*offset);
		if offset == 0 then
			self:zoom(1);
			self:diffuse(color(1,0,0,1));
		end
	end;
	-- que querais hacer ?? - ROAD24
	--OnCommand = cmd(scroll);
	
	CodeMessageCommand=function(self,params)
		local code = params.Name
		local player = params.PlayerNumber
		if not GAMESTATE:IsHumanPlayer(player) then return end;
		if code == "Next" and getenv("MenuActive") == true then
			if self:GetDestinationItem() == self:GetNumChildren()-1 then
				self:SetCurrentAndDestinationItem(0)
			else
				self:SetCurrentAndDestinationItem(self:GetCurrentItem()+1)
			end
		elseif code == "Prev" and getenv("MenuActive") == true then
			if self:GetDestinationItem() == 0 then
				self:SetCurrentAndDestinationItem(self:GetNumChildren()-1)
			else
				self:SetCurrentAndDestinationItem(self:GetCurrentItem()-1)
			end
		elseif code == "Toggle" and getenv("MenuActive") == true then
			item = self:GetCurrentItem();
			if item == 0 then
				--Restart Song
				SCREENMAN:SetNewScreen("ScreenGameplay");
			elseif item == 1 then
				--Select New Song
				SCREENMAN:GetTopScreen():PostScreenMessage("SM_BeginFailed",0);
			elseif item == 2 then
				--Select New Song
				SCREENMAN:SetNewScreen("ScreenSelectMusic");
			elseif item == 3 then
				--Exit to Title Menu
				SCREENMAN:SetNewScreen("ScreenTitleMenu");
			elseif item == 4 then
				--Exit Game
				SCREENMAN:SetNewScreen("ScreenExit");
			end
		end

		--SCREENMAN:SystemMessage(self:GetCurrentItem())
		MESSAGEMAN:Broadcast("PlayerOptionsChanged", { PlayerNumber = player })
	end;
}

local function AddLine( text, command )
        local icons = Def.ActorFrame{
            LoadFont("GameplayMenuOptions")..{
                OnCommand = command or lineOn;
				Text=text
            }
        }
    table.insert( OptionsScroller, icons )
end

AddLine("Restart Song");
AddLine("Continue to Evaluation");
AddLine("Select New Song");
AddLine("Exit to Title Menu");
AddLine("Exit Game");

return Def.ActorFrame{
	OptionsScroller..{
		Name="MenuOptions";
		InitCommand=cmd(draworder,999;x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;visible,false;);
	};
	
	Def.ActorFrame{
		Name="MenuObjects";
		InitCommand=cmd(draworder,100;visible,false;);
		--This is shown when the player pauses the game, probably...
		LoadActor(THEME:GetPathG("","_BGMovies/arcade"))..{
			InitCommand=cmd(draworder,1;Center;zoomto,default_width,SCREEN_HEIGHT;);
		};
		
		Def.Quad{
			InitCommand=cmd(draworder,100;blend,Blend.Add;fadeleft,1;faderight,1;Center;zoomto,300,50;diffuse,1,1,1,0.75);
		};
		
	};
	
	ComboChangedMessageCommand=function(self,params)
		local player = params.PlayerNumber;
		local stagebreak = IsBreakOn();
		local misscombo = GetBreakCombo();
		local this = self:GetChildren();
		if THEME:GetMetric("CustomRIO","GamePlayMenu") == true then
		
		if GAMESTATE:GetNumSidesJoined() == 2 and stagebreak then
		-- 2 players
			if STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetCurrentMissCombo() >= misscombo and STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetCurrentMissCombo() >= misscombo then
				SCREENMAN:GetTopScreen():PauseGame(true);
				this.MenuOptions:visible(true);
				this.MenuObjects:visible(true);
				setenv("MenuActive",true);
			end
		elseif GAMESTATE:GetNumSidesJoined() == 1 and stagebreak then
		--1 player
			if STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetCurrentMissCombo() > misscombo or STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetCurrentMissCombo() > misscombo then
				SCREENMAN:GetTopScreen():PauseGame(true);
				this.MenuOptions:visible(true);
				this.MenuObjects:visible(true);
				setenv("MenuActive",true);
			end
		end
		end;
    end;
};