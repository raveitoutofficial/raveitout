state = 1;
fastscroll = 0;

return Def.ActorFrame{

	-- MUSIC --nikkmod
	LoadActor(THEME:GetPathS("","SongChosen"))..{
		SongChosenMessageCommand=cmd(playcommand,"Check1";);
		StartSelectingSongMessageCommand=cmd(playcommand,"Check2";);
		SongUnchosenMessageCommand=function(self)
			state = 1;
		end;
		Check1Command=function(self)
			self:stoptweening(); self:play(); state = 2;--SelectSong 
		end;
		Check2Command=function(self)
			self:stoptweening(); self:play(); state = 1;--SelectGroup 
		end;
	};
	
	--STEP --nikkmod
	LoadActor(THEME:GetPathS("","ConfirmSteps"))..{
		WaitingConfirmMessageCommand=cmd(play);
	};
	
	--SCROLL GROUP WHEEL
	LoadActor(THEME:GetPathS("","MusicWheel change"))..{
		PreviousGroupChangeMessageCommand=cmd(playcommand,"Check";);
		NextGroupChangeMessageCommand=cmd(playcommand,"Check";);
		CheckCommand=function(self)
			if state == 0 then self:stoptweening(); self:play(); end;
		end;
	};
	
	--SCROLL STEP LIST
	LoadActor(THEME:GetPathS("","nikk_fx/clink.mp3"))..{
		CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Check1";);
		CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Check1";);
		Check1Command=function(self)
			if state == 2 then
				self:stoptweening(); self:play(); 
			elseif state == 3 then
				state = 2;
				self:stoptweening(); self:play(); 
			end;
		end;
	};
	
	--READY COMMAND
	LoadActor(THEME:GetPathS("","ready/select.mp3"))..{
		StepsChosenMessageCommand=cmd(playcommand,"Check2";);
		Check2Command=function(self)
			if state == 2 then state = 3; self:stoptweening(); self:play(); end;
		end;
	};
	--]]
	
	--UPRIGHT/UPLEFT
	LoadActor(THEME:GetPathS("","SongUnchosen"))..{
		StepsUnchosenMessageCommand=cmd(playcommand,"Check";);
		SongUnchosenMessageCommand=cmd(playcommand,"Check";);
		TwoPartConfirmCanceledMessageCommand=cmd(playcommand,"Check");
		StartSelectingGroupMessageCommand=cmd(playcommand,"Check");
		CheckCommand=function(self)
			if state == 1 then--StartGroupSelection
				self:stoptweening(); self:play();
				state = 0;
			elseif state == 2 then--SelectSongSelectingAgain
				self:stoptweening(); self:play();
				state = 1;
			elseif state == 3 then--SelectSongSelectingAgain
				self:stoptweening(); self:play();
				state = 2;
			end;
		end;
	};
	LoadActor(THEME:GetPathS("","ready/offcommand"))..{
		OffCommand=cmd(play);
	};

	-- CODEBOX/OPTIONLIST
	LoadActor(THEME:GetPathS("","Codebox Move"))..{
		OptionsListOpenedMessageCommand=cmd(play);
		OptionsListRightMessageCommand=cmd(play);
		OptionsListLeftMessageCommand=cmd(play);
		OptionsListQuickChangeMessageCommand=cmd(play);
	};
	LoadActor(THEME:GetPathS("","Codebox Select"))..{
		OptionsListStartMessageCommand=cmd(play);
		OptionsListResetMessageCommand=cmd(play);	
	};
	LoadActor(THEME:GetPathS("","Codebox Enter"))..{
		OptionsListPopMessageCommand=cmd(play);
		OptionsListPushMessageCommand=cmd(play);
	};
	LoadActor(THEME:GetPathS("","Codebox Close"))..{
		OptionsListClosedMessageCommand=cmd(play);	
	};
};
