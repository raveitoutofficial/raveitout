	local curstage = GAMESTATE:GetCurrentStage();

	local gfxNames = {
		Stage_Extra1=	"ScreenGameplay stage extra1";
		Stage_Extra2=	"ScreenGameplay stage extra1";
		Stage_Demo=	"ScreenGameplay stage Demo";
		Stage_Event="ScreenGameplay stage event";
		Stage_1st=	"ScreenGameplay stage 1";
		Stage_2nd=	"ScreenGameplay stage 2";
		Stage_3rd=	"ScreenGameplay stage 3";
		Stage_4th=	"ScreenGameplay stage 4";
		Stage_5th=	"ScreenGameplay stage 5";
		Stage_6th=	"ScreenGameplay stage 6";
		StageFinal=	"ScreenGameplay stage final";
	};

	local stage = gfxNames[curstage];
local style = GAMESTATE:GetCurrentStyle()		--get style
local ptbrotz = -90		--protiming bar rotationz

local c;
local player = Var "Player";
local function ShowProtiming()
if stage == "ScreenGameplay stage Demo" then
    return false
  else
    return GetUserPrefB("UserPrefProtiming" .. ToEnumShortString(player));
  end
end;
local bShowProtiming = ShowProtiming();
local graphset = bShowProtiming;		--graph setting
local ProtimingWidth = 480*0.4;	--default is "240"
local function MakeAverage( t )
	local sum = 0;
	for i=1,#t do
		sum = sum + t[i];
	end
	return sum / #t
end

local tTotalJudgments = {};

local judani = Comboanijudge;	--\Scripts\Themefunctions.lua

local JudgeCmds = {
	TapNoteScore_W1 = 	judani;
	TapNoteScore_W2 =	judani;
	TapNoteScore_W3 = 	judani;
	TapNoteScore_W4 = 	judani;
	TapNoteScore_W5 = 	judani;
	TapNoteScore_Miss =	judani;
};
--[[ latest working ok
local JudgeCmds = {
	TapNoteScore_W1 = 	cmd(finishtweening;shadowlength,0;y,0;diffusealpha,1;zoom,1.3;linear,0.05;zoom,1;sleep,0.8;linear,0.1;zoomy,0.5;zoomx,2;diffusealpha,0;glowblink;effectperiod,0.05;effectcolor1,color("1,1,1,0");effectcolor2,color("1,1,1,0.25"));
	TapNoteScore_W2 = 	cmd(finishtweening;y,0;shadowlength,0;diffusealpha,1;zoom,1.3;linear,0.05;zoom,1;sleep,0.5;linear,0.1;zoomy,0.5;zoomx,2;diffusealpha,0);
	TapNoteScore_W3 = 	cmd(finishtweening;y,0;shadowlength,0;diffusealpha,1;zoom,1.2;linear,0.05;zoom,1;sleep,0.5;linear,0.1;zoomy,0.5;zoomx,2;diffusealpha,0);
	TapNoteScore_W4 = 	cmd(finishtweening;y,0;shadowlength,0;diffusealpha,1;zoom,1.1;linear,0.05;zoom,1;sleep,0.5;linear,0.1;zoomy,0.5;zoomx,2;diffusealpha,0);
	TapNoteScore_W5 = 	cmd(finishtweening;y,0;shadowlength,0;diffusealpha,1;zoom,1.0;vibrate;effectmagnitude,1,2,2;sleep,0.5;linear,0.1;zoomy,0.5;zoomx,2;diffusealpha,0);
	TapNoteScore_Miss =	cmd(finishtweening;y,0;shadowlength,0;diffusealpha,1;zoom,1;y,-20;linear,0.8;y,20;sleep,0.5;linear,0.1;zoomy,0.5;zoomx,2;diffusealpha,0);
};
--]]

local ProtimingCmds = {
	TapNoteScore_W1 = 	cmd(finishtweening;diffuse,Color("White");zoom,1.15;glow,Color("White");linear,0.05;zoom,1;glow,Color("Invisible");diffuse,GameColor.Judgment["JudgmentLine_W1"];sleep,2;linear,0.5;diffuse,Color("Invisible"));
	TapNoteScore_W2 = 	cmd(finishtweening;diffuse,Color("White");zoom,1.15;glow,Color("White");linear,0.05;zoom,1;glow,Color("Invisible");diffuse,GameColor.Judgment["JudgmentLine_W2"];sleep,2;linear,0.5;diffuse,Color("Invisible"));
	TapNoteScore_W3 = 	cmd(finishtweening;diffuse,Color("White");zoom,1.15;glow,Color("White");linear,0.05;zoom,1;glow,Color("Invisible");diffuse,GameColor.Judgment["JudgmentLine_W3"];sleep,2;linear,0.5;diffuse,Color("Invisible"));
	TapNoteScore_W4 = 	cmd(finishtweening;diffuse,Color("White");zoom,1.15;glow,Color("White");linear,0.05;zoom,1;glow,Color("Invisible");diffuse,GameColor.Judgment["JudgmentLine_W4"];sleep,2;linear,0.5;diffuse,Color("Invisible"));
	TapNoteScore_W5 =	cmd(finishtweening;diffuse,Color("White");zoom,1.15;glow,Color("White");linear,0.05;zoom,1;glow,Color("Invisible");diffuse,GameColor.Judgment["JudgmentLine_W5"];sleep,2;linear,0.5;diffuse,Color("Invisible"));
	TapNoteScore_Miss =	cmd(finishtweening;diffusealpha,1;zoom,1.15;glow,GameColor.Judgment["JudgmentLine_Miss"];linear,0.05;zoom,1;glow,Color("Invisible");diffuse,GameColor.Judgment["JudgmentLine_Miss"];sleep,2;linear,0.5;diffuse,Color("Invisible"));
};

local AverageCmds = {
	Pulse = cmd(finishtweening;diffusealpha,1;zoom,0.75*1.025;decelerate,0.05;zoom,0.75;sleep,2;linear,0.5;diffusealpha,0;)
};
local TextCmds = {
	Pulse = cmd(finishtweening;diffusealpha,1;zoom,0.5*1.025;decelerate,0.05;zoom,0.5;sleep,2;linear,0.5;diffusealpha,0;)
};

local TNSFrames = {
	TapNoteScore_W1 = 0;
	TapNoteScore_W2 = 1;
	TapNoteScore_W3 = 2;
	TapNoteScore_W4 = 3;
	TapNoteScore_W5 = 4;
	TapNoteScore_Miss = 5;
};

if style:GetStyleType() == "StyleType_OnePlayerTwoSides" or style:GetStepsType() == "StepsType_Pump_Routine" then
--if style:GetStyleType() == "StyleType_OnePlayerTwoSides" then
	sepx = 270
else
	sepx = 140
end

--local infdiff = 30
if ToEnumShortString(player) == "P1" then
	ptsepax = -sepx;
elseif ToEnumShortString(player) == "P2" then
	ptsepax = sepx;
else
	ptsepax = 0;
end;

local ptinfdy = 30		--protiming information difference Y axis
local ptbposy = 32		--protiming bar position Y axis

local t = Def.ActorFrame {};
t[#t+1] = Def.ActorFrame {
	LoadActor(THEME:GetPathG("Judgment","Normal")) .. {
		Name="Judgment";	--\nJudgmentOnCommand en metrics
		InitCommand=cmd(pause;visible,false);	--	OnCommand=cmd();	--originalmente apuntaba a metrics, pero en metrics tambien estaba sin anim. PS: No tiene sentido tenerlo activado, JudgeCmds controlan la animacion.
		ResetCommand=cmd(finishtweening;stopeffect;visible,false);
	};
	--ProTiming Information (Text and Numbers)
	LoadFont("Combo Numbers") .. {
		Name="ProtimingDisplay";
		Text="";
		InitCommand=cmd(visible,false);
		OnCommand=cmd(shadowlength,1;horizalign,right;x,ptsepax;y,ptinfdy;strokecolor,Color("Outline");skewx,-0.125;textglowmode,"TextGlowMode_Inner");
		ResetCommand=cmd(finishtweening;stopeffect;visible,false);
	};
	LoadFont("Common Normal") .. {
		Name="ProtimingAverage";
		Text="";
		InitCommand=cmd(visible,false);
		OnCommand=cmd(shadowlength,1;horizalign,left;x,ptsepax;y,ptinfdy+8;zoom,0.75;diffuse,ColorLightTone( Color("Green") );strokecolor,Color("Outline");skewx,-0.125;textglowmode,"TextGlowMode_Inner";);
		ResetCommand=cmd(finishtweening;stopeffect;visible,false);
	};
	LoadFont("Common Normal") .. {
		Name="TextDisplay";
		Text=THEME:GetString("Protiming","MS");
		InitCommand=cmd(visible,false);
		OnCommand=cmd(shadowlength,1;horizalign,left;x,ptsepax;y,ptinfdy-6;zoom,0.5;strokecolor,Color("Outline");skewx,-0.125;textglowmode,"TextGlowMode_Inner");
		ResetCommand=cmd(finishtweening;stopeffect;visible,false);
	};
	
	-- ProTiming Bars
	Def.Quad {
		Name="ProtimingGraphBG";
		InitCommand=cmd(visible,false;rotationz,ptbrotz;x,ptsepax;y,ptbposy;zoomto,ProtimingWidth,16);
		ResetCommand=cmd(finishtweening;diffusealpha,0.8;visible,false);
		OnCommand=cmd(diffuse,Color("Black");diffusetopedge,color("0.1,0.1,0.1,1");diffusealpha,0.8;shadowlength,2;);
	};
	Def.Quad {
		Name="ProtimingGraphWindowW3";
		InitCommand=cmd(visible,false;rotationz,ptbrotz;x,ptsepax;y,ptbposy;zoomto,ProtimingWidth-4,16-4);
		ResetCommand=cmd(finishtweening;diffusealpha,1;visible,false);
		OnCommand=cmd(diffuse,GameColor.Judgment["JudgmentLine_W3"];);
	};
	Def.Quad {
		Name="ProtimingGraphWindowW2";
		InitCommand=cmd(visible,false;rotationz,ptbrotz;x,ptsepax;y,ptbposy;zoomto,scale(PREFSMAN:GetPreference("TimingWindowSecondsW2"),0,PREFSMAN:GetPreference("TimingWindowSecondsW3"),0,ProtimingWidth-4),16-4);
		ResetCommand=cmd(finishtweening;diffusealpha,1;visible,false);
		OnCommand=cmd(diffuse,GameColor.Judgment["JudgmentLine_W2"];);
	};
	Def.Quad {
		Name="ProtimingGraphWindowW1";
		InitCommand=cmd(visible,false;rotationz,ptbrotz;x,ptsepax;y,ptbposy;zoomto,scale(PREFSMAN:GetPreference("TimingWindowSecondsW1"),0,PREFSMAN:GetPreference("TimingWindowSecondsW3"),0,ProtimingWidth-4),16-4);
		ResetCommand=cmd(finishtweening;diffusealpha,1;visible,false);
		OnCommand=cmd(diffuse,GameColor.Judgment["JudgmentLine_W1"];);
	};
	Def.Quad {
		Name="ProtimingGraphUnderlay";
		InitCommand=cmd(visible,false;rotationz,ptbrotz;x,ptsepax;y,ptbposy;zoomto,ProtimingWidth-4,16-4);
		ResetCommand=cmd(finishtweening;diffusealpha,0.25;visible,false);
		OnCommand=cmd(diffuse,Color("Black");diffusealpha,0.25);
	};
	Def.Quad {
		Name="ProtimingGraphFill";
		InitCommand=cmd(visible,false;rotationz,ptbrotz;x,ptsepax;y,ptbposy;zoomto,0,16-4;horizalign,left;);
		ResetCommand=cmd(finishtweening;diffusealpha,1;visible,false);
		OnCommand=cmd(diffuse,Color("Red"););
	};
	Def.Quad {
		Name="ProtimingGraphAverage";
		InitCommand=cmd(visible,false;rotationz,ptbrotz;x,ptsepax;y,ptbposy;zoomto,2,7;);
		ResetCommand=cmd(finishtweening;diffusealpha,0.85;visible,false);
		OnCommand=cmd(diffuse,Color("Orange");diffusealpha,0.85);
	};
	Def.Quad {
		Name="ProtimingGraphCenter";
		InitCommand=cmd(visible,false;rotationz,ptbrotz;x,ptsepax;y,ptbposy;zoomto,2,16-4;);
		ResetCommand=cmd(finishtweening;diffusealpha,1;visible,false);
		OnCommand=cmd(diffuse,Color("White");diffusealpha,1);
	};
	InitCommand = function(self)
		c = self:GetChildren();
	end;

	JudgmentMessageCommand=function(self, param)
		-- Fix Player Combo animating when player successfully avoids a mine.
		local msgParam = param;
		MESSAGEMAN:Broadcast("TestJudgment",msgParam);
		--
		if param.Player ~= player then return end;
		if param.HoldNoteScore then return end;

		local iNumStates = c.Judgment:GetNumStates();
		local iFrame = TNSFrames[param.TapNoteScore];

		if not iFrame then return end
		if iNumStates == 12 then
			iFrame = iFrame * 2;
			if not param.Early then
				iFrame = iFrame + 1;
			end
		end

		local fTapNoteOffset = param.TapNoteOffset;
		if param.HoldNoteScore then
			fTapNoteOffset = 1;
		else
			fTapNoteOffset = param.TapNoteOffset; 
		end
		
		if param.TapNoteScore == 'TapNoteScore_Miss' then
			fTapNoteOffset = 1;
			bUseNegative = true;
		else
			bUseNegative = false;
		end;
		
		if fTapNoteOffset ~= 1 then
			-- we're safe, you can push the values
			tTotalJudgments[#tTotalJudgments+1] = math.abs(fTapNoteOffset);
		end
		
		self:playcommand("Reset");

	--	c.Judgment:visible(not bShowProtiming);	--Original
		c.Judgment:visible(true);				--Forced for ProTiming Display
		c.Judgment:setstate(iFrame);
		JudgeCmds[param.TapNoteScore](c.Judgment);
		
	--	c.ProtimingDisplay:visible(bShowProtiming);					--Original
		c.ProtimingDisplay:visible(false);							--disable by Cortes request
		c.ProtimingDisplay:settextf("%i",fTapNoteOffset * 1000);	--Milisecond delay number
		ProtimingCmds[param.TapNoteScore](c.ProtimingDisplay);		--Milisecond animation
		
	--	c.ProtimingAverage:visible(bShowProtiming);					--Original
		c.ProtimingAverage:visible(false);						--disable by Cortes request
		c.ProtimingAverage:settextf("%.2f%%",clamp(100 - MakeAverage( tTotalJudgments ) * 1000 ,0,100));	--Percentage display
		AverageCmds['Pulse'](c.ProtimingAverage);
		
--		c.TextDisplay:visible(bShowProtiming);		--"Milisecond" text display
		c.TextDisplay:visible(false);				--disable by Cortes request
		TextCmds['Pulse'](c.TextDisplay);			--"Milisecond" anim cmds
		
	--	c.ProtimingGraphBG:visible( bShowProtiming );			--self explanatory start		--default
		c.ProtimingGraphBG:visible( graphset );						--
	--	c.ProtimingGraphUnderlay:visible( bShowProtiming );		--		--default
		c.ProtimingGraphUnderlay:visible( graphset );				--
	--	c.ProtimingGraphWindowW3:visible( bShowProtiming );		--		--default
		c.ProtimingGraphWindowW3:visible( graphset );				--
	--	c.ProtimingGraphWindowW2:visible( bShowProtiming );		--		--default
		c.ProtimingGraphWindowW2:visible( graphset );				--
	--	c.ProtimingGraphWindowW1:visible( bShowProtiming );		--		--default
		c.ProtimingGraphWindowW1:visible( graphset );				--
	--	c.ProtimingGraphFill:visible( bShowProtiming );			--		--default
		c.ProtimingGraphFill:visible( graphset );					--self explanatory end
		c.ProtimingGraphFill:finishtweening();
		c.ProtimingGraphFill:decelerate(1/60);
		c.ProtimingGraphFill:zoomtowidth( clamp(
				scale(
				fTapNoteOffset,
				0,PREFSMAN:GetPreference("TimingWindowSecondsW3"),
				0,(ProtimingWidth-4)/2),
			-(ProtimingWidth-4)/2,(ProtimingWidth-4)/2)
		);
	--	c.ProtimingGraphAverage:visible( bShowProtiming );		--barra damasco precision estimada		--default
		c.ProtimingGraphAverage:visible( graphset );				--barra damasco precision estimada		--forced on
		c.ProtimingGraphAverage:zoomtowidth( clamp(
				scale(
				MakeAverage( tTotalJudgments ),
				0,PREFSMAN:GetPreference("TimingWindowSecondsW3"),
				0,ProtimingWidth-4),
			0,ProtimingWidth-4)
		);
	--	c.ProtimingGraphCenter:visible( bShowProtiming );		--la linea del centro	--default
		c.ProtimingGraphCenter:visible( graphset );					--la linea del centro	--forced on
		(cmd(sleep,2;linear,0.5;diffusealpha,0))(c.ProtimingGraphBG);
		(cmd(sleep,2;linear,0.5;diffusealpha,0))(c.ProtimingGraphUnderlay);
		(cmd(sleep,2;linear,0.5;diffusealpha,0))(c.ProtimingGraphWindowW3);
		(cmd(sleep,2;linear,0.5;diffusealpha,0))(c.ProtimingGraphWindowW2);
		(cmd(sleep,2;linear,0.5;diffusealpha,0))(c.ProtimingGraphWindowW1);
		(cmd(sleep,2;linear,0.5;diffusealpha,0))(c.ProtimingGraphFill);
		(cmd(sleep,2;linear,0.5;diffusealpha,0))(c.ProtimingGraphAverage);
		(cmd(sleep,2;linear,0.5;diffusealpha,0))(c.ProtimingGraphCenter);
	end;

};

return t;
