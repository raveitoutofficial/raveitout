local clipScaleX = 200
local clipScaleY = 200

return Def.ActorFrame{

	Def.Banner{
		Name="CourseBanner";
		InitCommand=cmd(scaletoclipped,clipScaleX,clipScaleY);
		SetMessageCommand=function(self,param)
			local course = param.Course
			if course then
				self:LoadFromCourse(course) --// load the course banner
			else
				self:Load(THEME:GetPathG("Common fallback","banner")) --// load the fallback banner if we panic
			end
		end;
	};
}