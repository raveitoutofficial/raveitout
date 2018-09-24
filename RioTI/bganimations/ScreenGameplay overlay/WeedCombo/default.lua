return Def.ActorFrame {

	Def.ActorFrame {
		InitCommand=cmd(x,notefxp1;y,SCREEN_CENTER_Y;visible,GAMESTATE:IsSideJoined(PLAYER_1));
			ComboChangedMessageCommand=function (self, params)
				local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1);
	
				if stats:GetCurrentCombo() == 420 and EasterEggs then
					MESSAGEMAN:Broadcast("WeedP1");
				end
			end;

			LoadActor(THEME:GetPathG("","WeedCombo/explosion")) .. {
				InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';hide_if,not EasterEggs);
				WeedP1MessageCommand=cmd(rotationz,0;zoom,2;diffusealpha,0.5;linear,0.5;rotationz,90;zoom,1.75;diffusealpha,0);
			};
			LoadActor(THEME:GetPathG("","WeedCombo/explosion")) .. {
				InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';hide_if,not EasterEggs);
				WeedP1MessageCommand=cmd(rotationz,0;zoom,2;diffusealpha,0.5;linear,0.5;rotationz,-90;zoom,2.5;diffusealpha,0);
			};

	};

	Def.ActorFrame {
		InitCommand=cmd(x,notefxp2;y,SCREEN_CENTER_Y;visible,GAMESTATE:IsSideJoined(PLAYER_2));
			ComboChangedMessageCommand=function (self, params)
				local stats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2);
	
				if stats:GetCurrentCombo() == 420 and EasterEggs then
					MESSAGEMAN:Broadcast("WeedP2");
				end
			end;

			LoadActor(THEME:GetPathG("","WeedCombo/explosion")) .. {
				InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';hide_if,not EasterEggs);
				WeedP2MessageCommand=cmd(rotationz,0;zoom,2;diffusealpha,0.5;linear,0.5;rotationz,90;zoom,1.75;diffusealpha,0);
			};
			LoadActor(THEME:GetPathG("","WeedCombo/explosion")) .. {
				InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';hide_if,not EasterEggs);
				WeedP2MessageCommand=cmd(rotationz,0;zoom,2;diffusealpha,0.5;linear,0.5;rotationz,-90;zoom,2.5;diffusealpha,0);
			};
			
		
	};