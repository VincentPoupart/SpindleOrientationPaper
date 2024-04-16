Double_stable_axis_C = nan(length(Angle_Stable_Axis_A_points),1);
Double_stable_axis_A = nan(length(Angle_Stable_Axis_A_points),1);
Double_stable_rachis_axis_C = nan(length(Angle_Stable_Axis_A_points),1);
Double_stable_rachis_axis_A = nan(length(Angle_Stable_Axis_A_points),1);
Double_stable_Projection_axis_C = nan(length(Angle_Stable_Axis_A_points),1);
Double_stable_Projection_axis_A = nan(length(Angle_Stable_Axis_A_points),1);
Range = nan(length(Angle_Stable_Axis_A_points),2);
Double_stable_prolate =  nan(length(Angle_Stable_Axis_A_points),1);
Double_stable_long_axis_length =  nan(length(Angle_Stable_Axis_A_points),1);
Double_stable_medium_axis_length =  nan(length(Angle_Stable_Axis_A_points),1);
Double_stable_short_axis_length =  nan(length(Angle_Stable_Axis_A_points),1);

for x = 1:1:length(Angle_Stable_Axis_A_points)
    if ~isnan(Angle_Stable_Axis_A_points(x,1)) && ~isnan(Angle_Stable_Axis_C_points(x,1))
      Double_stable_axis_C(x,1) =  Angle_Stable_Axis_C_points(x,1);
      Double_stable_axis_A(x,1) =  Angle_Stable_Axis_A_points(x,1);
      Double_stable_rachis_axis_C(x,1) = Angle_Rachis_Stable_Axis_C_points(x,1);
      Double_stable_rachis_axis_A(x,1)= Angle_Rachis_Stable_Axis_A_points(x,1);
      Double_stable_Projection_axis_C(x,1) = Angle_projected_Stable_Axis_C_projected_Spindle(x,1);
      Double_stable_Projection_axis_A(x,1) = Angle_projected_Stable_Axis_A_projected_Spindle(x,1);
      Range(x,1) = Range_long_axis(x,1);
      Range(x,2) = Range_short_axis(x,1);
      Double_stable_prolate(x,1) = Prolate_Index(x,1);
      Double_stable_long_axis_length(x,1) = Long_Axis_Length(x,1);
      Double_stable_medium_axis_length(x,1) = Medium_Axis_Length(x,1);
      Double_stable_short_axis_length(x,1) = Short_Axis_Length(x,1);
    end
end


% Double_stable_axis_C=(Double_stable_axis_C(~isnan(Double_stable_axis_C)));
% Double_stable_axis_A=(Double_stable_axis_A(~isnan(Double_stable_axis_A)));
% Double_stable_rachis_axis_C = (Double_stable_rachis_axis_C(~isnan(Double_stable_rachis_axis_C)));
% Double_stable_rachis_axis_A = (Double_stable_rachis_axis_A(~isnan(Double_stable_rachis_axis_A)));
% Double_stable_Projection_axis_C = (Double_stable_Projection_axis_C(~isnan(Double_stable_Projection_axis_C)));
% Double_stable_Projection_axis_A = (Double_stable_Projection_axis_A(~isnan(Double_stable_Projection_axis_A)));