local t = Def.ActorFrame{}
local toLoad;
local likeSnow = false
if MonthOfYear() == 11 then --Christmas
	toLoad = "snowflake (doubleres)"
	likeSnow = true
elseif MonthOfYear() == 1 and DayOfMonth() >= 11 and DayOfMonth() <= 15 then --Near Valentine's Day
	toLoad = "heart (doubleres)"
end;

if toLoad then --Only process if there is something we should be displaying.
	local orb = LoadActor(toLoad)..{
		InitCommand=cmd(diffusealpha,0.6;playcommand,"MakeNew");
		MakeNewCommand=function(self)
			-- first, set the position.
			local xPos = math.random(SCREEN_LEFT,SCREEN_WIDTH);
			self:x( xPos );
			self:y(SCREEN_TOP-64);

			-- then, set the zoom.
			local zoom = clamp( math.random(), 0.15, 0.5 );	--
			self:zoom( zoom );

			-- using the zoom, get the "weight" of the particle
			local weight = self:GetZoom();

			-- then make it move
			self:linear( weight * 10 );
			if likeSnow then --If it's like snow, it will stay at the bottom for a bit before disappearing. Else it will continue off the screen and disappear
				self:addy(SCREEN_HEIGHT+64);
				-- random only returns integer values in a range you should do something like this
				-- if you want to have values between 0 and 0.5
				self:sleep( math.random(0,5)*0.1 );	--stuck
			else
				self:addy(SCREEN_HEIGHT+100);
			end;

		--	self:sleep( math.random(0,2) );		--renew
			self:queuecommand("MakeNew");
		end;
	};

	for i=1,50 do table.insert(t, Def.ActorFrame{ orb }); end;
end; 
return t;
