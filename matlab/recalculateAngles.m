for i = 1:1:length(Germlineoutput)
    Germlines{i,1} = Germlineoutput(i).gonad;
end

for j = 1:1:length(Celloutput)
    gonad = Celloutput(j).gonad;
    specific_gonad = matches(Germlines,gonad);
    specific_gonad = num2cell(specific_gonad);
    for op=1:1:length(specific_gonad)
        if isequal(specific_gonad{op,1},0)
            specific_gonad{op,1}=[];
        end
    end
    ffoo = find(~cellfun('isempty', specific_gonad));
    frms = Celloutput(j).meas(:, 1);
    out = NaN(length(frms),8);
    for k = 1:1:length(frms)
        sm = Celloutput(j).meas(k,4:6);
        if length(Germlineoutput(ffoo).centroids)>= Celloutput(j).meas(k, 1)
            centroids = Germlineoutput(ffoo).centroids{Celloutput(j).meas(k, 1)};
            F_areas = Germlineoutput(ffoo).area{Celloutput(j).meas(k, 1)};
            rach_vecs = Germlineoutput(ffoo).rach_vecs{Celloutput(j).meas(k, 1)};
            V1 = Germlineoutput(ffoo).V1{Celloutput(j).meas(k, 1)};
            V2 = Germlineoutput(ffoo).V2{Celloutput(j).meas(k, 1)};
            V3 = Germlineoutput(ffoo).V3{Celloutput(j).meas(k, 1)};
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
            if SA<min_area
                
                out(k,1) = NaN;
                out(k,2) = NaN;
                out(k,3) = NaN; % number of faces
                out(k,4) = NaN;
                out(k,5:7) = NaN;
                out(k,8) = NaN;
            else
                
                %Calculate the normal vector of the Area
                rach = sum(rach_vecs(foo,1:3));
                spin = Celloutput(j).meas(k,7:9);%spindle vector
                
                %Calculate the angle between the spindle vector
                %and the normal vector
                angle = (acos(dot(rach,spin)/(norm(rach)*norm(spin))))*180/pi();
                
                %Calculate le mean distance between Spindle
                %midpoint and centroids
                meandist = mean(dists(foo,1));
                
                %Save the data into the array out
                out(k,1) = angle;
                out(k,2) = SA;
                out(k,3) = sum(foo); % number of faces
                out(k,4) = meandist;
                out(k,5:7) = rach;
                out(k,8) = r;
            end
            
            %Save the coordinates of the specific triangles
            %into Celloutput
            
            Celloutput(j).sp_centroids{1,k}(:,1:3) = centroids(foo,1:3);%centroids of triangles specific to the dividing cell
            Celloutput(j).sp_rach_vecs{1,k}(:,1:3) = rach_vecs(foo,1:3);%normal vectors of triangles specific to the dividing cell
            Celloutput(j).sp_V1{1,k}(:,1:3) = V1(foo,1:3);%xyz coordinates of the first vertex of triangles specific to the dividing cell
            Celloutput(j).sp_V2{1,k}(:,1:3) = V2(foo,1:3);%xyz coordinates of the second vertex of triangles specific to the dividing cell
            Celloutput(j).sp_V3{1,k}(:,1:3) = V3(foo,1:3);%xyz coordinates of the third vertex of triangles specific to the dividing cell
            Celloutput(j).meas(1:length(frms),10:17)=out;
        end
    end
end



