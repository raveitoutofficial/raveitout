-- ... means an argument that was passed in
local fileName = ...;
local path = "/"..THEME:GetCurrentThemeDirectory().."Graphics/_BGMovies/"..fileName;

if FILEMAN:DoesFileExist(path) then
	return Def.ActorFrame{
		LoadActor(...);
	};
else
	return Def.ActorFrame{

		Def.Quad{
			InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;diffuse,Color("Black"));
		};
		LoadFont("Common Normal")..{
			Text="Missing file "..fileName.." :(";
			InitCommand=cmd(diffuse,Color("White"));
		};
	}
end;