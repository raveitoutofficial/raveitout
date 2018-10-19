local player = ...
--AVATAR
return Def.ActorFrame{

	InitCommand=cmd(zoom,1.1;);
	
	LoadActor("mask")..{
		InitCommand=cmd(zoomto,45,45;MaskSource);
	};

	LoadActor(THEME:GetPathG("","USB_stuff/avatars/blank")) .. {
		InitCommand=cmd(zoomto,40,40;MaskDest);
		OnCommand=function(self)
			self:Load(getenv("profile_icon_"..pname(player)));
			self:setsize(60,60);
		end;
		--[[ScreenChangedMessageCommand=cmd(playcommand,"On");
		PlayerJoinedMessageCommand=cmd(playcommand,"On");
		CoinInsertedMessageCommand=cmd(playcommand,"On");
		CoinModeChangedMessageCommand=cmd(playcommand,"On");
		ScreenChangedMessageCommand=cmd(playcommand,"On");
		StorageDevicesChangedMessageCommand=cmd(playcommand,"On");]]

	};
	
	LoadActor("avatar_frame")..{
		InitCommand=cmd(zoomto,45,45;);
	};
	--[[LoadFont("Common Normal")..{
		InitCommand=cmd(addy,30;DiffuseAndStroke,Color("White"),Color("Black"));
		Text=getenv("BarPosX");
	}]]
};