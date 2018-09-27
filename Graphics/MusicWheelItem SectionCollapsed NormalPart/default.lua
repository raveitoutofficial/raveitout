
return Def.ActorFrame{
	LoadActor("folder")..{
	SetMessageCommand=function(self,param)
		local group = SONGMAN:GetSongGroupBannerPath(param.Text);
		if FILEMAN:DoesFileExist(group) then
			self:Load(group);
			self:scaletoclipped(128,120);
		else
			self:Load(THEME:GetPathG("","MusicWheelItem SectionCollapsed NormalPart/folder"));
		end;
	end;
	};
	
	Def.Quad{
		InitCommand=cmd(horizalign,center;zoomto,128,120;diffuse,0,0,0,0.65;x,0;y,0;);
		SetMessageCommand=function(self,param)
			if FILEMAN:DoesFileExist(SONGMAN:GetSongGroupBannerPath(param.Text)) then
				self:visible(true);
			else
				self:visible(false);
			end;
		end;
	};
	
};