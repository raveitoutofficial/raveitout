local scaw = 204		--banner scale width
local scah = 204		--banner scale height
--reflect effect controls
local ftop = 1	--fadetop
local ctop = 0.25	--croptop
local alph = 0.5	--diffusealpha


return Def.ActorFrame{

	--Don't load a blank file you fucking mongoloid
	--[[LoadActor(THEME:GetPathG("MusicWheelItem Song","OverPart"))..{
		InitCommand=cmd(addy,(scah/2)+8;rotationx,180;diffusealpha,0.5;croptop,ctop;fadetop,ftop);
	};]]

	Def.Sprite{		--Normal song banner item
		Name="SongBanner";
		InitCommand=cmd(scaletoclipped,scaw,scah);
		SetMessageCommand=function(self,param)
			local song = param.Song
			if song then
				local path = song:GetJacketPath();
				if path then
					self:Load(path)
					--self:LoadFromCached("Jacket",path);
				else
					path = song:GetBannerPath();
					if path then
						self:Load(path)
						--self:LoadFromCached("Banner",path);
					else
						self:Load(THEME:GetPathG("Common","fallback banner"))
					end;
				end;
			else
				self:Load(THEME:GetPathG("Common fallback","banner")) --// load the fallback banner if we panic
			end;
		end;
	};
	Def.Quad{
		--Check 99 init for variable declaration
		Condition=MUSICWHEEL_SONG_NAMES;
		InitCommand=cmd(setsize,scaw,25;y,scah/2+20;diffuse,color("0,0,0,.5");fadeleft,.1;faderight,.1);
		--[[SetMessageCommand=function(self,param)
			--self:visible(param.HasFocus == false)
			if param.HasFocus ~= nil then
				self:visible(not param.HasFocus);
			end;
		end;]]
	};
	LoadFont("facu/_zona pro bold 20px")..{
		Condition=MUSICWHEEL_SONG_NAMES;
		InitCommand=cmd(y,scah/2+18;maxwidth,scaw*.8);
		SetMessageCommand=function(self,param)
			local song = param.Song
			--[[if param.HasFocus ~= nil then
				self:visible(not param.HasFocus);
			end;]]
			if song then
				self:settext(song:GetMainTitle());
			end;
		end;
	};
	




};
--]]
