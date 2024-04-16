Gonad = cell(length(Celloutput),1);
Cell = cell(length(Celloutput),1);
TrackID = NaN(length(Celloutput),1);
Time = NaN(length(Celloutput),1);
CellPositionX = NaN(length(Celloutput),1);
CellPositionY = NaN(length(Celloutput),1);
CellPositionZ = NaN(length(Celloutput),1);
CellEllipsoidAxisCX = NaN(length(Celloutput),1);
CellEllipsoidAxisCY = NaN(length(Celloutput),1);
CellEllipsoidAxisCZ  = NaN(length(Celloutput),1);
DistanceDTC = NaN(length(Celloutput),1);
MeanCellVolume = NaN(length(Celloutput),1);
MeanOrientationCtoDP = NaN(length(Celloutput),1);
MeanProlateIndex = NaN(length(Celloutput),1);
LongAxisToRachis = NaN(length(Celloutput),1);

for i = 1:1:length(Celloutput)
    Gonad{i} = Celloutput(i).gonad;
    Cell{i} = Celloutput(i).cell;
    fazel = size(Celloutput(i).meas);
    if fazel(2) == 62
        foa = Celloutput(i).scoring(1,2);
        ioa = find ((Celloutput(i).meas(:,1))== foa);
        gonad = Celloutput(i).gonad;
        specific_gonad = matches(Germlines,gonad);
        specific_gonad=num2cell(specific_gonad);
        for op=1:1:length(specific_gonad)
            if isequal(specific_gonad{op,1},0)
                specific_gonad{op,1}=[];
            end
        end
        ffoo = find(~cellfun('isempty', specific_gonad));
        if ~isnan(foa)
            if length(1:ioa)>=2
                SpinVect = Celloutput(i).meas(ioa, 7:9);
                DPAxis = Germlineoutput(ffoo).DPaxisVector;
                DTC = Germlineoutput(ffoo).DTC;
                DTC = DTC(:, 2:4);
                TrackID(i) = Celloutput(i).meas(ioa, 33);
                Time(i) = foa;
                CellPosition = Celloutput(i).meas(ioa,60:62);
                CellPositionX(i) = CellPosition(1);
                CellPositionY(i) = CellPosition(2);
                CellPositionZ(i) = CellPosition(3);
                CellEllipsoidAxisC = nanmean(Celloutput(i).meas(1:ioa,21:23));
                CellEllipsoidAxisCX(i) = CellEllipsoidAxisC(1);
                CellEllipsoidAxisCY(i) = CellEllipsoidAxisC(2);
                CellEllipsoidAxisCZ(i) = CellEllipsoidAxisC(3);
                sm = CellPosition;
                DistanceDTC(i) = norm(sm - DTC);
                MeanCellVolume(i) = nanmean(Celloutput(i).meas(1:ioa,31));
                angle = (acos(dot(CellEllipsoidAxisC, DPAxis)/(norm(CellEllipsoidAxisC)*norm(DPAxis))))*180/pi();
                if angle > 90
                    angle = 180 - angle;
                end
                MeanOrientationCtoDP(i) = angle;
                MeanProlateIndex(i) = nanmean(Celloutput(i).meas(1:ioa,47));
                RachVect = nanmean(Celloutput(i).meas(1:ioa,14:16));
                angle = (acos(dot(CellEllipsoidAxisC, RachVect)/(norm(CellEllipsoidAxisC)*norm(RachVect))))*180/pi();
                if angle > 90
                    angle = 180 - angle;
                end
                LongAxisToRachis(i) = angle;
            end
        end
    end
end

% Gonad = cell2mat(Gonad);
MitoticCells_DF = table(Gonad,Cell, TrackID,Time,CellPositionX,CellPositionY,CellPositionZ,CellEllipsoidAxisCX,CellEllipsoidAxisCY, CellEllipsoidAxisCZ, DistanceDTC,MeanCellVolume,MeanOrientationCtoDP,MeanProlateIndex,LongAxisToRachis);
writetable(MitoticCells_DF,'M:\Labbe\Vincent Poupart\Cell_shape\MitoticCells_DF.csv')




