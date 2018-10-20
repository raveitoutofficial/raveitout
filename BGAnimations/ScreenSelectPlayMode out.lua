return Def.ActorFrame{
OnCommand=function(self)
	-- The original theme manager couldn't get the Off animation to load correctly
	-- as it was sent directly to ScreenSelectMusic. This is because the Off animation
	-- had nothing to play, so here I set a full second of something. So the actorframe
	-- has something to do, allowing for anything from the overlay to play.
	self:sleep(1)
end;
};
