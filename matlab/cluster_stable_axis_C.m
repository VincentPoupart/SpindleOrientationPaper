Angle_Stable_Axis_C_points = nan(length(Celloutput),1);
Angle_Un_Stable_Axis_C_points = nan(length(Celloutput),1);
Angle_Rachis_Stable_Axis_C_points = nan(length(Celloutput),1);
Angle_projected_Stable_Axis_C_projected_Spindle = nan(length(Celloutput),1);
Angle_projected_Un_Stable_Axis_projected_Spindle = nan(length(Celloutput),1);
Angle_spindle = nan(length(Celloutput),1);
Range_long_axis = nan(length(Celloutput),1);
Range_spindle = nan(length(Celloutput),1);
Prolate_Index = nan(length(Celloutput),1);
Oblate_Index = nan(length(Celloutput),1);
Long_Axis_Length = nan(length(Celloutput),1);
Medium_Axis_Length = nan(length(Celloutput),1);
Cell_Volume = nan(length(Celloutput),1);
Short_Axis_Length = nan(length(Celloutput),1);
for i = 1:1:length(Celloutput)
    Celloutput(i).stable_axis_C = [NaN NaN NaN];
    Celloutput(i).meas(:,56) = nan;
    Celloutput(i).meas(:,57) = nan;
    Celloutput(i).meas(:,58) = nan;
    Celloutput(i).meas(:,59) = nan;
    Celloutput(i).meas(:,63) = nan;
    Celloutput(i).meas(:,64) = nan;
    Celloutput(i).meas(:,65) = nan;
    Celloutput(i).sumfooot = [];
    foa = Celloutput(i).scoring(1,2);
    ioa = find ((Celloutput(i).meas(:,1))== foa);
    foaa = Celloutput(i).scoring(1,3);
    ioaa = find ((Celloutput(i).meas(:,1))== foaa);
    foaaa = Celloutput(i).scoring(1,1);
    ioaaa = find ((Celloutput(i).meas(:,1))== foaaa);
    if ~isnan(foa)
        x = Celloutput(i).meas(1:ioa,10);
        if length(x(~isnan(x))) >= 5 %& Range_long_axis(i,1) <=25 %& Variation_Long_Axis_Projected(i,1) <= 8
            y = Celloutput(i).meas(ioa:end,10);
            if length(y(~isnan(y))) >= 3
                NumberOfPatches = nan(length(Celloutput(i).sp_centroids(3,:)), 1);
                for y = 1:1:length(NumberOfPatches)
                    NumberOfPatches(y,1) = Celloutput(i).sp_centroids{3,y};
                end
                if nanmax(NumberOfPatches) == 1
                    %     if ~isnan(foaa)
                    %         x = Celloutput(i).meas(1:ioaa,10);
                    %     if length(x(~isnan(x))) >= 5
                    MeanLongAxis = nanmean(Celloutput(i).meas(ioa-4:ioa,27:29));
                    points = Celloutput(i).meas(ioa-4:ioa,27:29);
                    for v = 1:1:length(points)
                        vector = points(v,:);
                        angle = (acos(dot(MeanLongAxis,vector)/(norm(MeanLongAxis)*norm(vector))))*180/pi();
                        if angle > 90
                            points(v,:) =  vector * -1;
                        end
                    end
                    if ~isnan(points) && length(points(:,1)) >= 2
                        Ya = pdist(points);
                        Za = linkage(Ya);
                        C = 0.3;
                        Ta = cluster(Za,'Cutoff',C,'Criterion','distance');
                        Celloutput(i).points{1,1} = points;
                        Celloutput(i).points{2,1} = Ta;
                        Celloutput(i).points{3,1} = nanmax(real(Ta));
                        Celloutput(i).points{4,1} = mode(real(Ta));
                        fooot = Celloutput(i).points{4,1} == Ta;
                        if sum(fooot)>1
                            Celloutput(i).stable_axis_C = nanmean(points(fooot,1:3));
                            Celloutput(i).sumfooot = sum(fooot);
                        else
                            Celloutput(i).stable_axis_C = points(fooot,1:3);
                        end
                        %%%%%check if the cluster of long axis includes 4 or more points
                        if  Celloutput(i).sumfooot >= 4
                            if nanmin(Celloutput(i).meas(ioa-4:ioa,31))>125 %volume minimum
                                if nanmax(Celloutput(i).meas(ioa-4:ioa,31))<250 %volume max
                                    if range(Celloutput(i).meas(ioa-4:ioa,31))<40
                                        axis = Celloutput(i).stable_axis_C;
                                        for j = 1:1:length(Celloutput(i).meas(:,1))
                                            axis2= Celloutput(i).meas(j,52:54);
                                            spin = Celloutput(i).meas(j,7:9);
                                            rach = Celloutput(i).meas(j,14:16);
                                            unit_rach = rach/norm(rach);
                                            dist_axis = dot(axis, unit_rach);
                                            dist_spin = dot(spin, unit_rach);
                                            dist_axis2 = dot(axis2, unit_rach);
                                            projected_axis_on_rachis = axis - (dist_axis*unit_rach);
                                            projected_spin_on_rachis = spin - (dist_spin*unit_rach);
                                            projected_axis2_on_rachis = axis2 - (dist_axis2*unit_rach);
                                            angle = (acos(dot(axis,spin)/(norm(axis)*norm(spin))))*180/pi();
                                            if angle > 90
                                                angle = 180 - angle;
                                            end
                                            angle2 = (acos(dot(axis2,spin)/(norm(axis2)*norm(spin))))*180/pi();
                                            if angle2 > 90
                                                angle2 = 180 - angle2;
                                            end
                                            angle3 = (acos(dot(axis,rach)/(norm(axis)*norm(rach))))*180/pi();
                                            if angle3 > 90
                                                angle3 = 180 - angle3;
                                            end
                                            angle3 = 90-angle3;
                                            angle4 = (acos(dot(projected_axis_on_rachis,projected_spin_on_rachis)/(norm(projected_axis_on_rachis)*norm(projected_spin_on_rachis))))*180/pi();
                                            if angle4 > 90
                                                angle4 = 180 - angle4;
                                            end
                                            angle5 = (acos(dot(projected_axis2_on_rachis,projected_spin_on_rachis)/(norm(projected_axis2_on_rachis)*norm(projected_spin_on_rachis))))*180/pi();
                                            if angle5 > 90
                                                angle5 = 180 - angle5;
                                            end
                                            angle6 = (acos(dot(rach,spin)/(norm(rach)*norm(spin))))*180/pi();
                                            if angle6 > 90
                                                angle6 = 180 - angle6;
                                            end
                                            angle7 = (acos(dot(axis,axis2)/(norm(axis)*norm(axis2))))*180/pi();
                                            if angle7 > 90
                                                angle7 = 180 - angle7;
                                            end
                                            Celloutput(i).meas(j,56) = angle;
                                            Celloutput(i).meas(j,57) = angle2;
                                            Celloutput(i).meas(j,58) = angle3;
                                            Celloutput(i).meas(j,59) = angle4;
                                            Celloutput(i).meas(j,63) = angle5;
                                            Celloutput(i).meas(j,64) = angle6;
                                            Celloutput(i).meas(j,65) = angle7;
                                        end
                                        if range(Celloutput(i).meas(ioa-4:ioa,65))<30 %%%range angle between stable long axis and long axis
                                            Angle_Stable_Axis_C_points(i,1) = nanmean(Celloutput(i).meas(ioa:ioa+2,56));
                                            Angle_Un_Stable_Axis_C_points(i,1) = nanmean(Celloutput(i).meas(ioa:ioa+2,57));
                                            Angle_Rachis_Stable_Axis_C_points(i,1) = nanmean(Celloutput(i).meas(ioa:ioa+2,58));
                                            Angle_projected_Stable_Axis_C_projected_Spindle(i,1) = nanmean(Celloutput(i).meas(ioa:ioa+2,59));
                                            Angle_projected_Un_Stable_Axis_projected_Spindle(i,1) = nanmean(Celloutput(i).meas(ioa:ioa+2,63));
                                            Angle_spindle(i,1) = nanmean(Celloutput(i).meas(ioa:ioa+2,64));
                                            Prolate_Index(i,1) = nanmean(Celloutput(i).meas(ioa-4:ioa,47));
                                            Oblate_Index(i,1) = nanmean(Celloutput(i).meas(ioa-4:ioa,46));
                                            Long_Axis_Length(i,1) = nanmean(Celloutput(i).meas(ioa-4:ioa,39));
                                            Medium_Axis_Length(i,1) = nanmean(Celloutput(i).meas(ioa-4:ioa,38));
                                            Short_Axis_Length(i,1) = nanmean(Celloutput(i).meas(ioa-4:ioa,37));
                                            Cell_Volume(i,1) = nanmean(Celloutput(i).meas(ioa-4:ioa,31));
                                            plot(Celloutput(i).meas(:,30),Celloutput(i).meas(:,31));
                                            hold on
                                        end
                                    end
                                end
                            end
                            if isnan(Angle_spindle(i,1))
                                Prolate_Index(i,1) = NaN;
                                Oblate_Index(i,1) = NaN;
                                Long_Axis_Length(i,1) = NaN;
                                Medium_Axis_Length(i,1) = NaN;
                                Short_Axis_Length(i,1) = NaN;
                            end
                            ComparisonAllVector = nan(4,4);
                            for d = 1:1:length(ComparisonAllVector)
                                for e = 1:1:length(ComparisonAllVector)
                                    axisI = Celloutput(i).meas(ioa+1-d,52:54);
                                    axisII = Celloutput(i).meas(ioa+1-e,52:54);
                                    angle = (acos(dot(axisI,axisII)/(norm(axisI)*norm(axisII))))*180/pi();
                                    if angle > 90
                                        angle = 180 - angle;
                                    end
                                    ComparisonAllVector(d,e) = angle;
                                end
                            end
                            Range_long_axis(i,1) = max(ComparisonAllVector(:));
                            
                            if isnan(Angle_spindle(i,1))
                                Range_long_axis(i,1) = NaN;
                            end
                            ComparisonAllVector = nan(4,4);
                            for d = 1:1:length(ComparisonAllVector)
                                for e = 1:1:length(ComparisonAllVector)
                                    axisI = Celloutput(i).meas(ioa+1-d,7:9);
                                    axisII = Celloutput(i).meas(ioa+1-e,7:9);
                                    angle = (acos(dot(axisI,axisII)/(norm(axisI)*norm(axisII))))*180/pi();
                                    if angle > 90
                                        angle = 180 - angle;
                                    end
                                    ComparisonAllVector(d,e) = angle;
                                end
                            end
                            Range_spindle(i,1) = max(ComparisonAllVector(:));
                            if isnan(Angle_spindle(i,1))
                                Range_spindle(i,1) = NaN;
                            end
                        end
                    end
                end
            end
        end
    end
end
% end
% end
A=(Angle_Stable_Axis_C_points(~isnan(Angle_Stable_Axis_C_points)));
A2=(Angle_Un_Stable_Axis_C_points(~isnan(Angle_Un_Stable_Axis_C_points)));
A3=(Angle_Rachis_Stable_Axis_C_points(~isnan(Angle_Rachis_Stable_Axis_C_points)));
A4=(Angle_projected_Stable_Axis_C_projected_Spindle(~isnan(Angle_projected_Stable_Axis_C_projected_Spindle)));
A5=(Angle_projected_Un_Stable_Axis_projected_Spindle(~isnan(Angle_projected_Un_Stable_Axis_projected_Spindle)));
A6=(Angle_spindle(~isnan(Angle_spindle)));
% Prolate_Index=(Prolate_Index(~isnan(Prolate_Index)));
% Range_long_axis = (Range_long_axis(~isnan(Range_long_axis)));
% Range_spindle = (Range_spindle(~isnan(Range_spindle)));
% Oblate_Index=(Oblate_Index(~isnan(Oblate_Index)));
% Long_Axis_Length=(Long_Axis_Length(~isnan(Long_Axis_Length)));
% Medium_Axis_Length=(Medium_Axis_Length(~isnan(Medium_Axis_Length)));
% Short_Axis_Length=(Short_Axis_Length(~isnan(Short_Axis_Length)));
% Cell_Volume=(Cell_Volume(~isnan(Cell_Volume)));

