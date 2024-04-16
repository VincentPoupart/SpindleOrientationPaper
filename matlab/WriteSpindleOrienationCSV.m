SpindleOrientationMatlabSphereii = NaN(height(ScoringJuliaDebianMainson),1);
for i = 1:1:length(Celloutput)
    gonad = Celloutput(i).gonad;
    cell = Celloutput(i).cell;
    cellule = [gonad, ' ', cell];
    ind = find(ismember( ScoringJuliaDebianMainson{:,1}, cellule));
    anaphaseonset = ScoringJuliaDebianMainson{ind,4};
    if ~isnan(anaphaseonset)
        ioa = find ((Celloutput(i).meas(:,1))== anaphaseonset);
        angle = Celloutput(i).meas(ioa,10);
        if angle > 90
            angle = 180 - angle;
        end
        SpindleOrientationMatlabSphereii(ind,1) = angle;
    end
end

ScoringJuliaDebianMainson = addvars(ScoringJuliaDebianMainson,SpindleOrientationMatlabSphereii);
writetable(ScoringJuliaDebianMainson,'M:\Labbe\Vincent Poupart\Cell_shape\/scoring_df_add_matlab.csv')

  

