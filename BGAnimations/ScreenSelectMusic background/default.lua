local npsxz = _screen.cx*0.5	--next/previous song X zoom

local t = Def.ActorFrame {

	LoadActor("sounds");	--lel sounds
	};
if IsExtraStagePIU() then
	t[#t+1] = Def.Sprite{
		Texture=THEME:GetPathG("","_BGMovies/BGAOFF");
		InitCommand=function(self)
			self:Cover();
			self:diffusealpha(0):linear(0.5):diffusealpha(1);
		end;
	};
	--[[t[#t+1] = Def.Quad{
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;blend,"BlendMode_WeightedMultiply";Center);
	
	}]]
else

	t[#t+1] = LoadActor(THEME:GetPathG("","background/common_bg"))..{
		InitCommand=function(self)
			self:diffusealpha(0):linear(0.5):diffusealpha(1);
		end;
	};
end;
	
t[#t+1] = Def.ActorFrame{
	LoadActor("songwheel")..{
		InitCommand=cmd(horizalign,center;zoomto,SCREEN_WIDTH,183;x,_screen.cx;y,_screen.cy-30);
	};
		

	LoadActor("particle.lua")..{ --snow effect, triggers only in December
		InitCommand=function(self)
			if MonthOfYear() == 11 then self:visible(true); else self:visible(false); end;
		end;
	};

};

if DoDebug then
	local player = PLAYER_1;
	t[#t+1] = Def.ActorFrame{
		InitCommand=cmd(x,200;y,SCREEN_BOTTOM-110;zoom,.5);
		--Must be OnCommand because hearts have to be subtracted first in default.lua
		LoadFont("Common Normal")..{
			OnCommand=cmd(settext,pname(player).." hearts left: "..NumHeartsLeft[player];);
		};
		LoadFont("Common Normal")..{
			OnCommand=cmd(settext,pname(player).." hearts removed: "..NumHeartsRemoved[player].. "(excluding bonus hearts)";addy,20);
		};
		LoadFont("Common Normal")..{
			OnCommand=cmd(settext,pname(player).." bonus hearts: "..BonusHeartsAdded[player];addy,40);
		};
		LoadFont("Common Normal")..{
			OnCommand=cmd(settext,"Extra Stage? "..boolToString(IsExtraStagePIU());addy,60);
		};
		LoadFont("Common Normal")..{
			OnCommand=cmd(settext,"Cur Stage: "..(GAMESTATE:GetCurrentStageIndex()+1).."/"..PREFSMAN:GetPreference("SongsPerPlay");addy,80);
		};
	
	};
end;

return t;
