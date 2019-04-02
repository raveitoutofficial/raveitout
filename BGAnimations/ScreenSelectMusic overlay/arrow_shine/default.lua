local t = Def.ActorFrame{}	
local playmode = getenv("PlayMode");
if playmode == "Special" then
	playmode = "Pro"
end;
if not playmode then
	SCREENMAN:SystemMessage("Error: playmode environment not set!");
	playmode = "Arcade";
end;
--PREV/NEXT Song indicator effects
t[#t+1] = Def.ActorFrame{

		--Flipped horizontally, left arrow
		LoadActor(playmode.."/next_song")..{
			InitCommand=cmd(zoom,0.8;x,SCREEN_LEFT-4;y,SCREEN_CENTER_Y-30;horizalign,right;vertalign,middle;rotationy,180);
			--PrevCommand=cmd(stoptweening;sleep,0.01;linear,0.2;x,SCREEN_LEFT-7;linear,0.2;x,SCREEN_LEFT-4;diffusealpha,1;);
			PreviousSongMessageCommand=cmd(playcommand,"Prev");
			PreviousGroupMessageCommand=cmd(playcommand,"Prev");
			SongChosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,1;linear,0.2;diffusealpha,0;);
			SongUnchosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;linear,0.2;diffusealpha,1;);
			
		};
		
		--Left arrow animation (the texture is pointing to the left because idk)
		Def.Sprite{
			Texture=playmode.."/animation 5x4";
			InitCommand=cmd(diffusealpha,0;zoom,0.8;x,SCREEN_LEFT-4-(170);y,SCREEN_CENTER_Y-30;horizalign,left;vertalign,middle;SetAllStateDelays,0.01;animate,false;setstate,0);
			MenuLeftP1MessageCommand=cmd(playcommand,"Prev");
			MenuLeftP2MessageCommand=cmd(playcommand,"Prev");
			PreviousSongMessageCommand=cmd(playcommand,"Prev");
			PreviousGroupMessageCommand=cmd(playcommand,"Prev");
			--[[SongChosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,1;linear,0.2;diffusealpha,0;);
			SongUnchosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;linear,0.2;diffusealpha,1;);]]
			PrevCommand=function(self)	
				self:stoptweening();
				self:setstate(0);
				self:diffusealpha(1);
				self:animate(true);
			end;
			AnimationFinishedCommand=cmd(animate,false;setstate,0;linear,.2;diffusealpha,0);
		};
		
		--Right arrow
		LoadActor(playmode.."/next_song")..{
			InitCommand=cmd(zoom,0.8;x,SCREEN_RIGHT+2;y,SCREEN_CENTER_Y-30;horizalign,right;vertalign,middle);
			--NexCommand=cmd(stoptweening;linear,0.2;x,SCREEN_RIGHT+5;linear,0.2;x,SCREEN_RIGHT+2;diffusealpha,1;);
			NextSongMessageCommand=cmd(playcommand,"Nex");
			NextGroupMessageCommand=cmd(playcommand,"Nex");
			SongChosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,1;linear,0.2;diffusealpha,0;);
			SongUnchosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;linear,0.2;diffusealpha,1;);
		};
		
		--Left arrow animation, it's basically the same thing except flipped horizontally and the messagecommands say next
		Def.Sprite{
			Texture=playmode.."/animation 5x4";
			InitCommand=cmd(diffusealpha,0;zoom,0.8;x,SCREEN_RIGHT+2+(170);y,SCREEN_CENTER_Y-30;horizalign,left;vertalign,middle;rotationy,180;SetAllStateDelays,0.01;animate,false;setstate,0);
			MenuRightP1MessageCommand=cmd(playcommand,"Prev");
			MenuRightP2MessageCommand=cmd(playcommand,"Prev");
			NextSongMessageCommand=cmd(playcommand,"Prev");
			NextGroupMessageCommand=cmd(playcommand,"Prev");
			--[[SongChosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,1;linear,0.2;diffusealpha,0;);
			SongUnchosenMessageCommand=cmd(stoptweening;linear,0.2;diffusealpha,0;linear,0.2;diffusealpha,1;);]]
			PrevCommand=function(self)	
				self:stoptweening();
				self:setstate(0);
				self:diffusealpha(1);
				self:animate(true);
			end;
			AnimationFinishedCommand=cmd(animate,false;setstate,0;linear,.2;diffusealpha,0);
		};
	};

return t;	