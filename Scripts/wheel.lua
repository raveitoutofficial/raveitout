function RioWheel(self,offsetFromCenter,itemIndex,numItems)
    local spacing = 210;
    if math.abs(offsetFromCenter) < .5 then
        --self:zoom(.75+math.cos(offsetFromCenter*math.pi));
        self:x(offsetFromCenter*spacing);
    else
        if offsetFromCenter >= .5 then
            self:x(offsetFromCenter*spacing+135);
        elseif offsetFromCenter <= -.5 then
            self:x(offsetFromCenter*spacing-135);
        end;
            --self:zoom(.75);
    end;
end;