local sections = {
	{ "Rave It Out (project lead)", {
		"Christopher Cortes",
	}},
	{ "The RIO crew", {
		"(by join date)",
		"Christopher Cortes",
		"Ben Speirs",
		"Adrian Bruno",
		"Pedro Cardoso da Silva",
		"Aldo M. DiPasqua",
		"Eric Smith",
		"Rick Redviper Huber",
		"Marcus Vinícius Oliveira",
		"Felipe Rodríguez Del Valle",
		"Vincent Kim",
		"Daniel Mumbert",
		"Sean Hanson",
		"Anthony Vitug",
		"Sam Cruz",
		"Nirvash Doesntlikeyou",
		"Phillip Shanklin",
		"Christopher Sacco",
		"Sean Sullivan",
		"Sergio Madrid \"NeobeatIKK\"",
		"Cristopher Guzman Zamorano",
		"Alisson de Oliveira \"AlissonA2\"",
		"A.j. Howard",
		"Wes Fitts",
		"Omar Scofield",
		"Hassan 'Has' K'lil",
		"Cristian Rivera",
		"Bill Shillito",
		"Jose Jesus Rodriguez \"ROAD24\"",
		"Steven Darchiville",
		"Erick Muciño",
		"Alan James",
		"Kahru Serizawa",
		"Derek Silva",
		"Tomás Zubicueta Rodriguez",
		"Aruba Marcelo Antopia Navarro",
		"Melanie Walker",
		"Xavi Fran",
		"Angel Vasquez",
		"Karl Chavarria",
	}},
	{ "Season 2 Team", {
		"Step Artist - Gio Shawn",
		"Step Artist - Akira Sora (HaleyHalcyon)",
		"Programming - Accelerator",
		"Programming - José Varela"
	}},
	{ "Special Thanks", {
		"Everyone who liked our Facebook page",
		"And YOU!"
	}}
}

-- To add people or sections modify the above.

local lineOn = cmd(zoom,0.75;strokecolor,color("#444444");shadowcolor,color("#444444");shadowlength,3;horizalign,left)
local sectionOn = cmd(diffuse,color("#88DDFF");strokecolor,color("#446688");shadowcolor,color("#446688");shadowlength,3;horizalign,left)
local item_padding_start = 4;

local creditScroller = Def.ActorScroller {
	SecondsPerItem = 1.5;
	NumItemsToDraw = 40;	--dont disable this line
	TransformFunction = function( self, offset, itemIndex, numItems)
		self:y(30*offset)
	end;
	OnCommand = cmd(scrollwithpadding,item_padding_start,15);
}

local function AddLine( text, command )
	local text = Def.ActorFrame{
		LoadFont("venacti/_venacti_outline 26px bold diffuse")..{
			Text = text or "";
			OnCommand = command or lineOn;
		}
	}
	table.insert( creditScroller, text )
end

-- Add sections with padding.
for section in ivalues(sections) do
	AddLine( section[1], sectionOn )
	for name in ivalues(section[2]) do
		AddLine( name )
	end
	AddLine()
	AddLine()
end

creditScroller.BeginCommand=function(self)
	SCREENMAN:GetTopScreen():PostScreenMessage( 'SM_MenuTimer', (creditScroller.SecondsPerItem * (#creditScroller + item_padding_start) + 20) );
end;

return Def.ActorFrame{

	LoadActor(THEME:GetPathS("","Credits Music (loop)"))..{OnCommand=cmd(play)};
	creditScroller..{
		InitCommand=cmd(x,_screen.cx-(_screen.cx*0.5);y,SCREEN_BOTTOM-64),
	},
	LoadFont("Common normal")..{	--DEBUG: Animation time and Metric set time.
		InitCommand=cmd(visible,DoDebug;xy,SCREEN_RIGHT,SCREEN_TOP;horizalign,right;vertalign,top;zoom,0.5;
		settext,"Timer Seconds: "..(creditScroller.SecondsPerItem * (#creditScroller + item_padding_start) + 20));	--sumar solo los tiempos del ultimo actor
	};
--[[	LoadActor(THEME:GetPathB("ScreenWithMenuElements","background/_bg top"))..{
		InitCommand=cmd(Center),
	},--]]
};
