
AngleLongAxisDPaxis = NaN(length(Celloutput),1);
for i = 1:1:length(Celloutput)
    foa = Celloutput(i).scoring(1,2);
    ioa = find ((Celloutput(i).meas(:,1))== foa);
    if ~isnan(foa)
        gonad = Celloutput(i).gonad;
        specific_gonad = matches(Germlines,gonad);
        specific_gonad=num2cell(specific_gonad);
        for op=1:1:length(specific_gonad)
            if isequal(specific_gonad{op,1},0)
                specific_gonad{op,1}=[];
            end
        end
        ffoo = find(~cellfun('isempty', specific_gonad));
        
        SpinVect = Celloutput(i).meas(ioa,7:9);
        DPVect = Germlineoutput(ffoo).DPaxisVector;
        angle = (acos(dot(SpinVect,DPVect)/(norm(SpinVect)*norm(DPVect))))*180/pi();
        if angle> 90
            angle = 180 - angle;
        end
        AngleLongAxisDPaxis(i) = angle;
    end
end


