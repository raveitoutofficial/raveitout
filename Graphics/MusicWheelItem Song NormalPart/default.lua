local scaw = 304		--banner scale width
local scah = 200		--banner scale height
--reflect effect controls
local ftop = 1	--fadetop
local ctop = 0.25	--croptop
local alph = 0.5	--diffusealpha

return Def.ActorFrame{

	LoadActor(THEME:GetPathG("MusicWheelItem Song","OverPart"))..{
		InitCommand=cmd(addy,(scah/2)+8;rotationx,180;diffusealpha,0.5;croptop,ctop;fadetop,ftop);
	};

	Def.Banner{		--Normal song banner item
		Name="SongBanner";
		InitCommand=cmd(scaletoclipped,scaw,scah);
		SetMessageCommand=function(self,param)
			local song = param.Song
			if song then
				self:LoadFromSong(song) --// load the song banner
			else
				self:Load(THEME:GetPathG("Common fallback","banner")) --// load the fallback banner if we panic
			end;
		end;
	};



};
--]]
