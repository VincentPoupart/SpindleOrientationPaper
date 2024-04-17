
for i = 1:1:length(Celloutput)
    gonad = Celloutput(i).gonad;
    specific_gonad = matches(Germlines,gonad);
    specific_gonad=num2cell(specific_gonad);
    for op=1:1:length(specific_gonad)
        if isequal(specific_gonad{op,1},0)
            specific_gonad{op,1}=[];
        end
    end
    ffoo = find(~cellfun('isempty', specific_gonad));
    Celloutput(i).meas(1:end,21:55) = nan(length(Celloutput(i).meas(:,1)),35);
    
    foa = Celloutput(i).scoring(1,2);
    ioa = find ((Celloutput(i).meas(:,1))== foa);
    
    foaa = Celloutput(i).scoring(1,3);
    ioaa = find ((Celloutput(i).meas(:,1))== foaa);
    
    
    if ~isnan(foa)
        
        for j = 1:1:length(Celloutput(i).meas(:,1))
            
            Spin_Mid = Celloutput(i).meas(j,4:6);
            Time = Celloutput(i).meas(j,1);
            if isempty(Germlineoutput(ffoo).Cell_Position) == false
                foo = Germlineoutput(ffoo).Cell_Position.Time==Time;
                Cell_Position = Germlineoutput(ffoo).Cell_Position(foo,1:3);
                Cell_Position = Cell_Position{:,:};
                dists = sqrt(sum(((Cell_Position-Spin_Mid).^2),2));
                if ~isempty(dists)
                    [M,I] = min(dists);
                    MinimumDist(j,i) = M;
                    if M < 2
                        n = 1;
                        while sum(foo(1:n,1))<I
                            n = n+1;
                        end
                        Track_ID = Germlineoutput(ffoo).Cell_Position(n,8);
                        Cell_Position =  Germlineoutput(ffoo).Cell_Position(n,1:3);
                        Cell_Ellipsoid_Axis_A = Germlineoutput(ffoo).Cell_Ellipsoid_Axis_A(n,1:3);
                        Cell_Ellipsoid_Axis_B = Germlineoutput(ffoo).Cell_Ellipsoid_Axis_B(n,1:3);
                        Cell_Ellipsoid_Axis_C = Germlineoutput(ffoo).Cell_Ellipsoid_Axis_C(n,1:3);
                        Cell_Ellipticity_oblate = Germlineoutput(ffoo).Cell_Ellipticity_oblate(n,1);
                        Cell_Ellipticity_prolate = Germlineoutput(ffoo).Cell_Ellipticity_prolate(n,1);
                        Cell_Volume = Germlineoutput(ffoo).Cell_Volume(n,1);
                        Cell_Ellipsoid_Axis_Length_A = Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_A(n,1);
                        Cell_Ellipsoid_Axis_Length_B = Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_B(n,1);
                        Cell_Ellipsoid_Axis_Length_C = Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_C(n,1);
                        Celloutput(i).meas(j,21:23) = Cell_Ellipsoid_Axis_A{:,1:3};
                        Celloutput(i).meas(j,24:26) = Cell_Ellipsoid_Axis_B{:,1:3};
                        Celloutput(i).meas(j,27:29) = Cell_Ellipsoid_Axis_C{:,1:3};
                        Celloutput(i).meas(j,31) = Cell_Volume;
                        Celloutput(i).meas(j,60:62) = Cell_Position{:,:};
                        Celloutput(i).meas(j,33) = Track_ID{:,:};
                        Celloutput(i).meas(j,37) = Cell_Ellipsoid_Axis_Length_A;
                        Celloutput(i).meas(j,38) = Cell_Ellipsoid_Axis_Length_B;
                        Celloutput(i).meas(j,39) = Cell_Ellipsoid_Axis_Length_C;
                        Celloutput(i).meas(j,46) = Cell_Ellipticity_oblate;
                        Celloutput(i).meas(j,47) = Cell_Ellipticity_prolate;
                    end
                end
            end
        end
    end
end


































































