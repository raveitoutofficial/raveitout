function RioWheel(self,offsetFromCenter,itemIndex,numItems)
	local x = offsetFromCenter * 310;
	local ry = clamp( offsetFromCenter, 0,0) * 90;
	self:x( x );
	self:z((-clamp(math.abs(offsetFromCenter),0,0)*280)-math.abs(offsetFromCenter));
	self:rotationy( ry );
end;
	
function wheelcs01(self,offsetFromCenter,itemIndex,numItems)
	if offsetFromCenter>=1 then
		self:zoomy(0.5);
		x = 62 + offsetFromCenter * 70;
		y = 20;
		self:skewy(0.2);
	elseif offsetFromCenter<=-1 then
		self:zoomy(0.5);
		x = offsetFromCenter * 70 - 62;
		y = 20;
		self:skewy(-0.2);
	else
		self:zoomy(0.5 + (0.5 - (math.abs(offsetFromCenter) * 0.5)));
		x = offsetFromCenter * 132;
		y = (math.abs(offsetFromCenter * 20));
		self:skewy(offsetFromCenter * 0.2);
	end;
	self:rotationy(clamp(offsetFromCenter,1,-1) * 65);
	self:zoomx((1.18) * (2 - clamp(math.abs(offsetFromCenter),0,1)) );
	self:x( x )
	self:y( y );
	self:z( -math.abs(offsetFromCenter * 2) );
end;

function wheel05(self,offsetFromCenter,itemIndex,numItems)
--center item zoom animation stable
	local mira = 0.9 --zoom  ~centro
	local mirb = 0.5 --zoom ==centro
	if offsetFromCenter>=1 then
		self:zoom(mira);
	elseif offsetFromCenter<=-1 then
		self:zoom(mira);
	else
		self:zoom(mira + (mirb - (math.abs(offsetFromCenter) * mirb)));
	end;
	self:rotationy(offsetFromCenter*35);
	self:x(offsetFromCenter*250);	--use other when fixed (overlapping Z values, not refreshing)
--	self:x(offsetFromCenter*175);	--JesP request.
--	self:z( math.abs(offsetFromCenter * 2) );
end;

function wheel04(self,offsetFromCenter,itemIndex,numItems)
--center item zoom animation broken
	local mira = 1
	if offsetFromCenter ~=0 then
		self:zoom(mira);
	else
		self:zoom(mira + (0.5 - (math.abs(offsetFromCenter) * 0.5)));
	end;
	self:rotationy(offsetFromCenter*30);
	self:x(offsetFromCenter*210);
end;

function wheel03(self,offsetFromCenter,itemIndex,numItems)
--center item zoom animation stable
	local mira = 0.9 --zoom  ~centro
	local mirb = 0.25 --zoom ==centro
	if offsetFromCenter>=1 then
		self:zoom(mira);
	elseif offsetFromCenter<=-1 then
		self:zoom(mira);
	else
		self:zoom(mira + (mirb - (math.abs(offsetFromCenter) * mirb)));
	end;
	self:rotationy(offsetFromCenter*35);
	self:x(offsetFromCenter*210);
	self:z( -math.abs(offsetFromCenter * 2) );
end;

function wheel02(self,offsetFromCenter,itemIndex,numItems)
--center item zoom animation broken
	if offsetFromCenter ~= 0 then
		zoom = 1
	else
		zoom = 1.125
	end;

	self:x(offsetFromCenter*210);
	self:rotationy(offsetFromCenter*30);
	self:zoom(zoom);
end;

function wheel01(self,offsetFromCenter,itemIndex,numItems)
--center item zoom animation broken
	self:x(offsetFromCenter*210);
	self:rotationy(offsetFromCenter*30);
	if offsetFromCenter == 0 then
		self:zoom(1.125);
	elseif offsetFromCenter >= 1 then
		self:zoom(1);
	elseif offsetFromCenter <= -1 then
		self:zoom(1);
	end;
end;