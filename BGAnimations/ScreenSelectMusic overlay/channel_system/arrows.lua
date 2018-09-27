local t = Def.ActorFrame{}	

	--PREV/NEXT Song indicator effects
t[#t+1] = 	Def.ActorFrame{		
		LoadActor("../arrow_shine/"..getenv("PlayMode").."/previous_song")..{
			InitCommand=cmd(zoom,0.8;x,SCREEN_LEFT-4;y,SCREEN_CENTER_Y-30;horizalign,left;vertalign,middle);
			--PrevCommand=cmd(stoptweening;sleep,0.01;linear,0.2;x,SCREEN_LEFT-7;linear,0.2;x,SCREEN_LEFT-4;diffusealpha,1;);
			PreviousSongMessageCommand=cmd(playcommand,"Prev");
			PreviousGroupChangeMessageCommand=cmd(playcommand,"Prev");
			SongChosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,1;linear,0.2;diffusealpha,0;);
			SongUnchosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;linear,0.2;diffusealpha,1;);
			
		};
		
		LoadActor("../arrow_shine/"..getenv("PlayMode").."/left/effect (1)")..{
			InitCommand=cmd(diffusealpha,0;zoom,0.8;x,SCREEN_LEFT-4-(170);y,SCREEN_CENTER_Y-30;horizalign,left;vertalign,middle);
			MenuLeftP1MessageCommand=cmd(playcommand,"Prev");
			MenuLeftP2MessageCommand=cmd(playcommand,"Prev");
			PreviousSongMessageCommand=cmd(playcommand,"Prev");
			PreviousGroupChangeMessageCommand=cmd(playcommand,"Prev");
			SongChosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,1;linear,0.2;diffusealpha,0;);
			SongUnchosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;linear,0.2;diffusealpha,1;);
			PrevCommand=function(self)	
				self:stoptweening();
				self:Load(nil);
				self:diffusealpha(1);
				self:sleep(0.01);
				self:Load(THEME:GetCurrentThemeDirectory().."Bganimations/ScreenSelectMusic overlay/arrow_shine/"..getenv("PlayMode").."/left/effect ("..shine_index..").png");
				if shine_index > 20 then
					self:stoptweening();
					shine_index = 1;
				else
					shine_index = shine_index+1
					self:queuecommand("Prev");
				end;
			end;
		};
		
		LoadActor("../arrow_shine/"..getenv("PlayMode").."/next_song")..{
			InitCommand=cmd(zoom,0.8;x,SCREEN_RIGHT+2;y,SCREEN_CENTER_Y-30;horizalign,right;vertalign,middle);
			--NexCommand=cmd(stoptweening;linear,0.2;x,SCREEN_RIGHT+5;linear,0.2;x,SCREEN_RIGHT+2;diffusealpha,1;);
			NextSongMessageCommand=cmd(playcommand,"Nex");
			NextGroupChangeMessageCommand=cmd(playcommand,"Nex");
			SongChosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,1;linear,0.2;diffusealpha,0;);
			SongUnchosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;linear,0.2;diffusealpha,1;);
		};
		
		LoadActor("../arrow_shine/"..getenv("PlayMode").."/right/effect (1)")..{
			InitCommand=cmd(diffusealpha,0;zoom,0.8;x,SCREEN_RIGHT+2+(170);y,SCREEN_CENTER_Y-30;horizalign,right;vertalign,middle);
			MenuRightP1MessageCommand=cmd(playcommand,"Nex");
			MenuRightP2MessageCommand=cmd(playcommand,"Nex");
			NextSongMessageCommand=cmd(playcommand,"Nex");
			NextGroupChangeMessageCommand=cmd(playcommand,"Nex");
			SongChosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,1;linear,0.2;diffusealpha,0;);
			SongUnchosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;linear,0.2;diffusealpha,1;);
			NexCommand=function(self)	
				self:stoptweening();
				self:Load(nil);
				self:diffusealpha(1);
				self:sleep(0.01);
				self:Load(THEME:GetCurrentThemeDirectory().."Bganimations/ScreenSelectMusic overlay/arrow_shine/"..getenv("PlayMode").."/right/effect ("..shine_index..").png");
				if shine_index > 20 then
					self:stoptweening();
					shine_index = 1;
				else
					shine_index = shine_index+1
					self:queuecommand("Nex");
				end;
			end;
		};	
	};

return t;	