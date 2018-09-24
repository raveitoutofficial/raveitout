-- pls dont forget sanity checks !!!
local curSong = GAMESTATE:GetCurrentSong();
local curGenre = "";
if curSong then
	curGenre = GAMESTATE:GetCurrentSong():GetGenre();
end;

return Def.ActorFrame{
	CurrentSongChangedMessageCommand=function(self)
		--[[]
		if GAMESTATE:GetCurrentSong():GetGenre() ~= curGenre and curGenre ~= "" then
			curGenre = GAMESTATE:GetCurrentSong():GetGenre();
			if FILEMAN:DoesFileExist(THEME:GetPathS("","Genre/"..curGenre)) then
				SOUND:PlayOnce(THEME:GetPathS("","Genre/"..curGenre));
			else
				SOUND:PlayOnce(THEME:GetPathS("","nosound.ogg"));
			end
		end
		--]]
	end;
};