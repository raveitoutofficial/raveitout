local t = Def.ActorFrame{}
local toLoad;
local likeSnow = false
if MonthOfYear() == 11 then --Christmas
	toLoad = "snowflake (doubleres)"
	likeSnow = true
elseif MonthOfYear() == 1 and DayOfMonth() >= 11 and DayOfMonth() <= 15 then --Near Valentine's Day
	toLoad = "heart (doubleres)"
elseif MonthOfYear() == 3 then
	--[[
    local C = Math.floor(Y/100);
    local N = Y - 19*Math.floor(Y/19);
    local K = Math.floor((C - 17)/25);
    local I = C - Math.floor(C/4) - Math.floor((C - K)/3) + 19*N + 15;
    I = I - 30*Math.floor((I/30));
    I = I - Math.floor(I/28)*(1 - Math.floor(I/28)*Math.floor(29/(I + 1))*Math.floor((21 - N)/11));
    local J = Y + Math.floor(Y/4) + I + 2 - C + Math.floor(C/4);
    J = J - 7*Math.floor(J/7);
    local L = I - J;
    local M = 3 + Math.floor((L + 40)/44);
    local D = L + 28 - 31*Math.floor(M/4);
	if DayOfMonth() <= D+5 and DayOfMonth() >= D-5 then
		toLoad = "easter (doubleres)"
	end;]]
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
