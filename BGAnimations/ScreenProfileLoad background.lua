-- Cortes quiere random wallpaper, este script cargara de forma aleatoria
-- una imagen dentro del folder _RandomWalls en graphics
--[[
function getRandomWall()
	local sImagesPath = THEME:GetPathB("","_RandomWalls");
	local sRandomWalls = FILEMAN:GetDirListing(sImagesPath.."/",false,true);
	-- El random seed
	 math.randomseed(Hour()*3600+Second());
	return sRandomWalls[math.random(#sRandomWalls)];
end;

return Def.ActorFrame{
	LoadActor(getRandomWall())..{
		-- Algunas imagenes pierden calidad enormemente con FullScreen, por que?
		--OnCommand=cmd(FullScreen);
		OnCommand=cmd(Center);
	};
};--]]

return Def.ActorFrame{
	};