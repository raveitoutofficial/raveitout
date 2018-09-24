local t = Def.ActorFrame {}

if IsUsingWideScreen() then
	default_width = SCREEN_WIDTH+20
else
	default_width = SCREEN_WIDTH
end;


t[#t+1] =LoadActor("/Backgrounds/openning")..{
	OnCommand=cmd(Center;zoomto,default_width,SCREEN_HEIGHT);
};

return t;