local player = ...
--AVATAR
return Def.ActorFrame{

	InitCommand=cmd(zoom,1.1;);
	
	LoadActor("mask")..{
		InitCommand=cmd(zoomto,45,45;MaskSource);
	};

	LoadActor(THEME:GetPathG("ProfileBanner","avatars/blank")) .. {
		InitCommand=cmd(zoomto,40,40;MaskDest);
		OnCommand=function(self)
			self:Load(getenv("profile_icon_"..pname(player)));
			self:setsize(60,60);
		end;

	};
	
	LoadActor("avatar_frame")..{
		InitCommand=cmd(zoomto,45,45;);
	};
	--[[LoadFont("Common Normal")..{
		InitCommand=cmd(addy,30;DiffuseAndStroke,Color("White"),Color("Black"));
		Text=getenv("BarPosX");
	}]]
};
