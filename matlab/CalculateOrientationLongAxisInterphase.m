% folder = uigetdir;
% filenameA = char([folder,'\InterphaseCellsDF.csv']);
% InterphaseCellsDF = readtable(filenameA);

LongAxeToRachis = NaN(height(InterphaseCellsDF),1);
RachisVectX = NaN(height(InterphaseCellsDF),1);
RachisVectY = NaN(height(InterphaseCellsDF),1);
RachisVectZ = NaN(height(InterphaseCellsDF),1);


for j = 1:1:height(InterphaseCellsDF)
    gonad = InterphaseCellsDF{j,1};
    disp(gonad)
    specific_gonad = matches(Germlines,gonad);
    specific_gonad = num2cell(specific_gonad);
    for op=1:1:length(specific_gonad)
        if isequal(specific_gonad{op,1},0)
            specific_gonad{op,1}=[];
        end
    end
    ffoo = find(~cellfun('isempty', specific_gonad));
    k = InterphaseCellsDF{j,4};
    sm = [InterphaseCellsDF{j,6} InterphaseCellsDF{j,7} InterphaseCellsDF{j,8}];
    if length(Germlineoutput(ffoo).centroids)>= k
        centroids = Germlineoutput(ffoo).centroids{k};
        F_areas = Germlineoutput(ffoo).area{k};
        rach_vecs = Germlineoutput(ffoo).rach_vecs{k};
        V1 = Germlineoutput(ffoo).V1{k};
        V2 = Germlineoutput(ffoo).V2{k};
        V3 = Germlineoutput(ffoo).V3{k};
        sm = repmat(sm, max(size(centroids)),1);
        % calculate the distance between the spindle midpoint and
        % each face centroid
        dists = sqrt(sum(((centroids-sm).^2),2));
        % Define the radius of the sphere
        r = 1;
        % logical array with 1 for every centroid that is within r
        % microns of spindle midpoint
        
        foo = dists<=r;
        % calculate the surface area of the rachis that falls
        % within r microns of spindle midpoint
        SA = sum(F_areas(foo,1));
        % define a minimum rachis surface area for analysis.
        min_area = 50;
        
        
        % if the combined area of all the faces within r microns of
        % spindle midpoint is greater than this minimum, sum
        % the surface normal position vectors for all included
        % faces and calculate the angle between this sum and the
        % spindle vector.
        
        
        
        % if the combined area is smaller than the minimum, sort the
        % face areas by their distance to the spindle midpoint,
        % calculate the cumulative sum and find the row index for
        % where the combined area exceed the minimum value
        
        %  Increase de sphere radius by 0.1 um until the Surface
        %  Area (SA) inside reach min_area
        while SA < min_area &&  r < 8
            foo = dists<=r;
            SA = sum(F_areas(foo,1));
            r = r+0.1;
        end
        if SA>=min_area
            
            
            %Calculate the normal vector of the Area
            rach = sum(rach_vecs(foo,1:3));
            spin = [InterphaseCellsDF{j,9} InterphaseCellsDF{j,10} InterphaseCellsDF{j,11}];      %long axe
            
            %Calculate the angle between the spindle vector
            %and the normal vector
            angle = (acos(dot(rach,spin)/(norm(rach)*norm(spin))))*180/pi();
            if angle>90
                angle = 180-angle;
            end
                
            
            %Calculate le mean distance between Spindle
            %midpoint and centroids
            meandist = mean(dists(foo,1));
            
            %Save the data into the array out
            LongAxeToRachis(j) = angle;
            RachisVectX(j) = rach(1);
            RachisVectY(j) = rach(2);
            RachisVectZ(j) = rach(3);
            
        end
        
        %Save the coordinates of the specific triangles
        %into Celloutput
    end
end

InterphaseCellsDF = addvars(InterphaseCellsDF, RachisVectX);
InterphaseCellsDF = addvars(InterphaseCellsDF, RachisVectY);
InterphaseCellsDF = addvars(InterphaseCellsDF, RachisVectZ);
InterphaseCellsDF = addvars(InterphaseCellsDF, LongAxeToRachis);

writetable(InterphaseCellsDF,'M:\Labbe\Vincent Poupart\Cell_shape\InterphaseCellsDF.csv')
