--[[
WARNING: DO NOT USE CONDITION= FOR THESE!!!
STEPMANIA REQUIRES ACTORS FOR ALL PLAYERS TO BE LOADED
REGARDLESS OF THEM BEING JOINED OR NOT.
YOU WILL CRASH THE GAME!!!
]]

return Def.ActorFrame {
	InitCommand=cmd(draworder,250;);
	CurrentSongChangedMessageCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		if song then
 			--self:setaux(0);
			self:stoptweening(); --finish
			self:playcommand("TweenOn");
		elseif not song and self:GetZoomX() == 1 then
		--	self:setaux(1);
			self:stoptweening(); --finish
			self:playcommand("TweenOff");
		end;
	end;

	Def.StepsDisplayList {
		Name="StepsDisplayListRow";
		InitCommand=cmd(draworder,250;);
		
		CursorP2 = Def.ActorFrame {
			InitCommand=cmd(visible,GAMESTATE:IsSideJoined(PLAYER_2);draworder,200;);
			OnCommand=cmd(rotationz,90;);
			--[[PlayerJoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_2 then
					self:visible(true);
					(cmd(zoom,0;bounceend,0.3;zoom,1))(self);
				end;
			end;
			PlayerUnjoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_2 then
					self:visible(true);
					(cmd(bouncebegin,0.3;zoom,0))(self);
				end;
			end;]]

			LoadActor("player2cur")..{
				InitCommand=cmd(x,-9;y,10;zoom,0.425;thump,1;effectmagnitude,1,1.05,4;effectclock,'beat';visible,GAMESTATE:IsSideJoined(PLAYER_2););
				--[[OnCommand=function(self)
					if not GAMESTATE:IsSideJoined(PLAYER_2) then
						self:visible(false);
					else
						self:visible(GAMESTATE:IsSideJoined(PLAYER_2));
					end;
				end;]]
				--[[PlayerJoinedMessageCommand=function(self, params)
					if not GAMESTATE:IsSideJoined(PLAYER_2) then
						self:visible(false);
					else
						self:visible(true);
					end;
				end;]]
				CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Check");
				CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Check");
				CheckCommand=function(self)
					-- Do not index unless you're sure you have the obtject and not nil
					--local p1_id = GAMESTATE:GetCurrentSteps(PLAYER_1):GetMeter();
					--local p2_id = GAMESTATE:GetCurrentSteps(PLAYER_2):GetMeter();
					local p1_id;
					local p2_id;

					local p1_steps = GAMESTATE:GetCurrentSteps(PLAYER_1);
					local p2_steps = GAMESTATE:GetCurrentSteps(PLAYER_2);

					if p1_steps then
						p1_id = p1_steps:GetMeter();
					end;
					if p2_steps then
						p2_id = p2_steps:GetMeter();
					end;

					--Some dude out there really used THEME:GetCurrentThemeDirectory()../bganimations huh
					--For anyone else reading this, don't do that, do THEME:GetPathB() instead
					if #GAMESTATE:GetEnabledPlayers() == 2 and p1_id == p2_id then
						self:Load(THEME:GetPathB("ScreenSelectMusic","overlay/DifficultyList/2p_bothplayers.png"))
					else
						self:Load(THEME:GetPathB("ScreenSelectMusic","overlay/DifficultyList/player2cur.png"));
					end;
				end;
			};
		};
		
		--It's below the P2 cursor because the P2 cursor handles showing both players overlapping.
		CursorP1 = Def.ActorFrame {
			InitCommand=cmd(draworder,201;visible,GAMESTATE:IsSideJoined(PLAYER_1););
			OnCommand=cmd(rotationz,90;);
			PlayerJoinedMessageCommand=function(self, params)

				if params.Player == PLAYER_1 then
					self:visible(GAMESTATE:IsSideJoined(PLAYER_1));
					(cmd(zoom,0;bounceend,0.3;zoom,1))(self);
				end;
			end;
			PlayerUnjoinedMessageCommand=function(self, params)
				if params.Player == PLAYER_1 then
					self:visible(GAMESTATE:IsSideJoined(PLAYER_1));
					(cmd(bouncebegin,0.3;zoom,0))(self);
				end;
			end;
			LoadActor("player1cur")..{
			--Strange, I can't figure out why it's not changing immediately when you switch songs. Oh well.
			--CurrentSongChangedMessageCommand=cmd(stoptweening;thump,1);
			InitCommand=cmd(x,-9;y,-3;zoom,0.425;thump,1;sleep,1;effectmagnitude,1,1.05,4;effectclock,'beat';);
			};
		};

		CursorP1Frame = Def.Actor{
			OnCommand=cmd(draworder,201;diffusealpha,0;);
			ChangeCommand=cmd(draworder,201;stoptweening;decelerate,0.125;);
			SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1;);
			TwoPartConfirmCanceledMessageCommand=cmd(linear,0.2;diffusealpha,0;);
			SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0;);
			CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"SongChosenMessage");
			--CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"SongChosenMessage");
		};

		CursorP2Frame = Def.Actor{
			OnCommand=cmd(draworder,200;diffusealpha,0;);
			ChangeCommand=cmd(draworder,200;stoptweening;decelerate,0.125;);
			SongChosenMessageCommand=cmd(linear,0.1;diffusealpha,1;);
			TwoPartConfirmCanceledMessageCommand=cmd(linear,0.2;diffusealpha,0;);
			SongUnchosenMessageCommand=cmd(linear,0.1;diffusealpha,0;);
		};
		
		CursorP3 = Def.Actor{};
		CursorP4 = Def.Actor{};
		CursorP3Frame = Def.Actor{};
		CursorP4Frame = Def.Actor{};

	};
};
