local stepsArray;

function SortCharts(a,b)
    local bST = StepsType:Compare(a:GetStepsType(),b:GetStepsType()) < 0
    if a:GetStepsType() == b:GetStepsType() then
        return a:GetMeter() < b:GetMeter()
    else
        return bST
    end;
end

function GetCurrentStepsIndex(pn)
	local playerSteps = GAMESTATE:GetCurrentSteps(pn);
	for i=1,#stepsArray do
		if playerSteps == stepsArray[i] then
			return i;
		end;
	end;
	--If it reaches this point, the selected steps doesn't equal anything.
	return -1;
end;

local t = Def.ActorFrame{
	CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
	RefreshCommand=function(self)
		local song = GAMESTATE:GetCurrentSong();
		if song then
			stepsArray = song:GetAllSteps();
			--[[
			Use this to sort the steps by level, which is probably what you want if you're in easy mode.
			By default StepMania will return the steps in the order they were created in the ssc, but
			you wouldn't want that if your steps have difficulty listings from Easy, Normal, Hard, Challenge, etc
			]]
			table.sort(stepsArray, SortCharts)
		else
			stepsArray = nil;
		end;
	end;
};

for i = 1,3 do

	t[#t+1] = Def.ActorFrame{

		InitCommand=cmd(addx,-500*2+i*500;skewx,-.10;);
		
		Def.Quad{
			InitCommand=cmd(diffuse,Color("Blue");faderight,.5;setsize,240,960/12+4;horizalign,right);
			Condition=GAMESTATE:IsSideJoined(PLAYER_1);
			CurrentStepsP1ChangedMessageCommand=function(self)
				if stepsArray then
					local st = GetCurrentStepsIndex(PLAYER_1)
					self:stoptweening()
					if st == i then
						self:linear(.15):cropright(0);
					else
						self:linear(.15):cropright(1);
					end;
				end;
			end;
		};
		Def.Quad{
			InitCommand=cmd(diffuse,Color("Red");fadeleft,.5;setsize,240,960/12+4;horizalign,left);
			Condition=GAMESTATE:IsSideJoined(PLAYER_2);
			CurrentStepsP2ChangedMessageCommand=function(self)
				if stepsArray then
					local st = GetCurrentStepsIndex(PLAYER_2)
					self:stoptweening()
					if st == i then
						self:linear(.15):cropleft(0);
					else
						self:linear(.15):cropleft(1);
					end;
				end;
			end;
		};

		Def.Sprite{
			InitCommand=cmd(animate,false);
			Texture="LevelIndicator 1x12";
			--[[CurrentStepsP1ChangedMessageCommand=cmd(playcommand,"Refresh");
			CurrentStepsP2ChangedMessageCommand=cmd(playcommand,"Refresh");]]
			CurrentSongChangedMessageCommand=cmd(playcommand,"Refresh");
			NextSongMessageCommand=cmd(playcommand,"Refresh");
			PreviousSongMessageCommand=cmd(playcommand,"Refresh");
			RefreshCommand=function(self)
				if stepsArray and stepsArray[i] then
					local meter = stepsArray[i]:GetMeter()
					if meter > 10 then
						self:setstate(11);
					else
						self:setstate(meter)
					end;
				else
					self:setstate(0);
				end;
			end;
		}
	};
end;

return t;
