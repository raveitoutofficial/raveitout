local t = Def.ActorFrame {}

if IsUsingWideScreen() then
	default_width = SCREEN_WIDTH+20
else
	default_width = SCREEN_WIDTH
end;


t[#t+1] = LoadActor(THEME:GetPathG("","_BGMovies/Opening"))..{
	OnCommand=cmd(Center;Cover;);
};

return t;
