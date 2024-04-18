% folder of .tif files
% group tifs into folders based on whatever unifying theme makes sense (i.e. L4440, control, ani-2?) and which you want to compile data for into a single analysis
% name each tif with acquisition date, condition/genotype and ?gonadX? e.g. ?2018_04_10_L4440_gonad1.tif?
% generate TrackMate .txt file with centrosome coordinates and save in same directory with same file name but with _tracks at the end (i.e. ?2018_04_10_L4440_gonad1_tracks.txt?)
% run Imaris software to segment/3D render rachis and export .wrl file for each gonad
% save all wrl files for  gonads in a subfolder of the gonad (i.e. ?2018_04_10_L4440_gonad1?)
% for each wrl file, run the python scripts ''vrml2csv.py'' with ''normalcalc.py''  that generate the .csv files with 
% end result: folder with 1 tif, 1 _tracks.txt and 1 folder with  wrl file and its csv files, all with the same root name
% 1- Run the matlab script named''Step1_import_textfile_and_align_cent_tracks''
% 2- Run this script 


    %       col 1 = frames (corrected such that 0 = 1)   
    %       col 2 = POSITION_T
    %       col 3 = spindle length
    %       col 4-6 = x, y, z coords of spindle midpoint
    %       col 7-9 = spindle vector
    %       col 10 = Angle to rachis surface normal (degrees)   
    %       col 11 = rachis surface area measured
    %       col 12 = number of triangles in the area measured
    %       col 13 = mean distance centroids to spindle midpoint
    %       col 14-16 = rachis normal vector
    %       col 17 = radius of the sphere
    
    




prompt = 'What area size (in µm^2, we suggest 50) of the surface do you want to extract? ';
min_area = input(prompt);

%Chose the max distance from the spindle midpoint (please enter the value in the command window)
prompt = 'What is the maximal distance (in µm, we suggest 8) from the spindle midpoint do you want to extract the surface? ';
max_radius = input(prompt);


% Find all the .csv files (in the case of Mac OS, all the .xlsx files) in
% 'fileList'. We now use .txt files  % it is possible to use CSVs
%%% booboo = strtok(str,'!');
 

for i = 1:1:length(Celloutput)
    if i>1
    tf = strcmp(gonad, Celloutput(i).gonad);
    end
    %Making lists of rachis surface data files specific to the gonad
    if i == 1 | tf == 0
    gonad = Celloutput(i).gonad;
    boo = strfind(fileList, [gonad, '_']); 
    foo = find(~cellfun('isempty', boo));
    sp_fileList = fileList(foo, 1);
    
    gigi = strfind(sp_fileList,'_coord_');
    gege = strfind(sp_fileList,'_faceNormal_');
    gaga = strfind(sp_fileList,'_normal_');
    gugu = strfind(sp_fileList,'_index_');

    giogio =  find(~cellfun('isempty', gigi));
    geogeo =  find(~cellfun('isempty', gege));
    gaogao =  find(~cellfun('isempty', gaga));
    guoguo =  find(~cellfun('isempty', gugu));

    CSV_fileList_coord = sp_fileList(giogio, 1);
    CSV_fileList_faceNormal = sp_fileList(geogeo, 1);
    CSV_fileList_normal = sp_fileList(gaogao, 1);
    CSV_fileList_index = sp_fileList(guoguo, 1);

    giigii = strfind(CSV_fileList_coord,gonad);
    giiogiio =  find(~cellfun('isempty', giigii));
    wrl_fileList_coords = CSV_fileList_coord(giiogiio, 1);
    
    giagia = strfind(CSV_fileList_index,gonad);
    giaogiao =  find(~cellfun('isempty', giagia));
    wrl_fileList_index = CSV_fileList_index(giaogiao, 1);
    
    giegie = strfind(CSV_fileList_normal,gonad);
    gieogieo =  find(~cellfun('isempty', giegie));
    wrl_fileList_normal = CSV_fileList_normal(gieogieo, 1);
    
    giugiu = strfind(CSV_fileList_faceNormal,gonad);
    giuogiuo =  find(~cellfun('isempty', giugiu));
    wrl_fileList_faceNormal = CSV_fileList_faceNormal(giuogiuo, 1);
    
    
    %Sort the lists according to the frames
     
    
     for j = 1:1:length(wrl_fileList_coords);
        file = wrl_fileList_coords{j,1};
        mm = strfind(file, '\'); % change to '\' for Windows OS
        filename = file(1, (mm(1,length(mm))+1):length(file));
        nn = strfind(filename, '.csv');
        oo = strfind(filename, '_coord_');
        frame = filename(1, (oo(1,1)+7:nn(1,1)-1));
        frameIdx(j,1) = str2num(frame);
        wrl_fileList_coords{j,2} = str2num(frame);
    end
    
    wrl_fileList_coords = sortrows(wrl_fileList_coords,2);
    
    for j = 1:1:length(wrl_fileList_faceNormal);
        file = wrl_fileList_faceNormal{j,1};
        mm = strfind(file, '\'); % change to '\' for Windows OS
        filename = file(1, (mm(1,length(mm))+1):length(file));
        nn = strfind(filename, '.csv');
        oo = strfind(filename, '_faceNormal_');
        frame = filename(1, (oo(1,1)+12:nn(1,1)-1));
        frameIdx(j,1) = str2num(frame);
        wrl_fileList_faceNormal{j,2} = str2num(frame);
    end
    
    wrl_fileList_faceNormal = sortrows(wrl_fileList_faceNormal,2);
    
    for j = 1:1:length(wrl_fileList_normal);
        file = wrl_fileList_normal{j,1};
        mm = strfind(file, '\'); % change to '\' for Windows OS
        filename = file(1, (mm(1,length(mm))+1):length(file));
        nn = strfind(filename, '.csv');
        oo = strfind(filename, '_normal_');
        frame = filename(1, (oo(1,1)+8:nn(1,1)-1));
        frameIdx(j,1) = str2num(frame);
        wrl_fileList_normal{j,2} = str2num(frame);
    end
   
    wrl_fileList_normal = sortrows(wrl_fileList_normal,2);
    
    for j = 1:1:length(wrl_fileList_index);
        file = wrl_fileList_index{j,1};
        mm = strfind(file, '\'); % change to '\' for Windows OS
        filename = file(1, (mm(1,length(mm))+1):length(file));
        nn = strfind(filename, '.csv');
        oo = strfind(filename, '_index_');
        frame = filename(1, (oo(1,1)+7:nn(1,1)-1));
        wrl_fileList_index{j,2} = str2num(frame);
        frameIdx(j,1) = str2num(frame);
    end

    wrl_fileList_index = sortrows(wrl_fileList_index,2);
    
        
    % F is n x m matrix where n = number of faces that form the object and 
    % m = number of vertices for each face (i.e. m = 3 for triangular faces). 
    % Each value is an index which corresponds to the vertex given in V. 
    % e.g. F = 3 located at F(1,3) is the vertex represented by the x, y, z 
    % coordinates in row 3 of V, i.e. V(3,:). N is an n x 3 matrix where n = 
    % number of faces. Each row contains the x, y, z coordinates for the normal
    % vector for each face
    Fvals = cell(1,length(wrl_fileList_index));
    Vvals = cell(1,length(wrl_fileList_coords));
    Nvals = cell(1,length(wrl_fileList_faceNormal));
    
    for j = 1:1:length(wrl_fileList_index);
        file = wrl_fileList_index{j,1};
        [num,txt,raw] = xlsread(file);
        Fvals{1,j} = num;
    end
    system('taskkill /F /IM EXCEL.EXE');
    
    for j = 1:1:length(wrl_fileList_coords);
        file = wrl_fileList_coords{j,1};
        [num,txt,raw] = xlsread(file);
        Vvals{1,j} = num;
    end
    system('taskkill /F /IM EXCEL.EXE');
    
    for j = 1:1:length(wrl_fileList_faceNormal);
        file = wrl_fileList_faceNormal{j,1};
        [num,txt,raw] = xlsread(file);
        Nvals{1,j} = num;
    end
    system('taskkill /F /IM EXCEL.EXE');
    
    % Calculate the area of each face in Fvals, convert the unit vectors
    % in Nvals into position vectors, calculate the centroid of each face,
    % which simplifies things below
    F_area = cell(1,length(wrl_fileList_faceNormal));
    Pos_vecs = cell(1,length(wrl_fileList_faceNormal));
    F_cents = cell(1,length(wrl_fileList_faceNormal));
    for j = 1:1:length(wrl_fileList_faceNormal);
        centroids = Vvals{1,j};
        V1 = NaN(length(Fvals{1,j}),3);
        V2 = NaN(length(Fvals{1,j}),3);
        V3 = NaN(length(Fvals{1,j}),3);
        for k = 1:1:length(Fvals{1, j});
        V1(k,1:3) = centroids((Fvals{1, j}(k,1))+1,1:3);
        V2(k,1:3) = centroids((Fvals{1, j}(k,2))+1,1:3);
        V3(k,1:3) = centroids((Fvals{1, j}(k,3))+1,1:3);
        end
        
        centroids = (V1+V2+V3)./3;
        F_cents{1,j} = centroids;
        V1c{1,j} = V1;
        V2c{1,j} = V2;
        V3c{1,j} = V3;
        v = V2-V1;
        w = V3-V1;
        xprod = cross(v,w);
        mags = sqrt(xprod(:,1).^2+xprod(:,2).^2+xprod(:,3).^2);
        areas = mags.*2;
        F_area{1,j} = areas;
        Pos_vecs{1,j} = Nvals{1,j};
        
    end
    end

            frms = Celloutput(i).meas(:,1);
            spinmid = Celloutput(i).meas(:,4:6);
            spinvec = Celloutput(i).meas(:,7:9);

        out = NaN(length(frms),8);
        
        for k = 1:1:length(frms);
            fr = frms(k,1);
            if sum(frameIdx == fr) == 1;
                % extract the face centroid coords, face areas and face normal
                % position vectors for the relevant time point (frame)
                centroids = F_cents{1,frameIdx == fr};
                V1 = V1c{1,frameIdx == fr};
                V2 = V2c{1,frameIdx == fr};
                V3 = V3c{1,frameIdx == fr};
                rach_vecs = Pos_vecs{1,frameIdx == fr};
                F_areas = F_area{1,frameIdx == fr};
                sm = spinmid(k,:);
                sm = repmat(sm, max(size(centroids)),1);                
                % calculate the distance between the spindle midpoint and
                % each face centroid
                dists = sqrt(sum(((centroids-sm).^2),2));
                % Define the radius of the sphere
                r = 0;
                % logical array with 1 for every centroid that is within r
                % microns of spindle midpoint 
               
                foo = dists<=r;
                % calculate the surface area of the rachis that falls
                % within r microns of spindle midpoint
                SA = sum(F_areas(foo,1));
                % define a minimum rachis surface area for analysis.
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
                          while SA < min_area &&  r < max_radius;
                              r = r+0.01;
                              foo = dists<=r;
                              SA = sum(F_areas(foo,1));  
                          end
                          
                          if SA<min_area    
                          out(k,1) = NaN;
                          out(k,2) = NaN;
                          out(k,3) = NaN; 
                          out(k,4) = NaN;
                          out(k,5:7) = NaN;
                          out(k,8) = NaN;   
                          else
                         
                          %Calculate the normal vector of the Area
                          rach = sum(rach_vecs(foo,1:3));
                          spin = spinvec(k,1:3);%spindle vector
                          
                          %Calculate the angle between the spindle vector
                          %and the normal vector
                          angle = (acos(dot(rach,spin)/(norm(rach)*norm(spin))))*180/pi();
                          if angle > 90
                              angle = 180 - angle;
                          end
                          %Calculate le mean distance between Spindle
                          %midpoint and centroids
                          meandist = mean(dists(foo,1));
                          
                          %Save the data into the array out
                          out(k,1) = angle;
                          out(k,2) = SA;
                          out(k,3) = sum(foo); 
                          out(k,4) = meandist;
                          out(k,5:7) = rach;
                          out(k,8) = r;
                          end
                          
                          %Save the coordinates of the specific triangles
                          %into output
                          
                             Celloutput(i).sp_centroids{1,k}(:,1:3) = centroids(foo,1:3);%centroids of triangles specific to the dividing cell
                             Celloutput(i).sp_rach_vecs{1,k}(:,1:3) = rach_vecs(foo,1:3);%normal vectors of triangles specific to the dividing cell
                             Celloutput(i).sp_V1{1,k}(:,1:3) = V1(foo,1:3);%xyz coordinates of the first vertex of triangles specific to the dividing cell
                             Celloutput(i).sp_V2{1,k}(:,1:3) = V2(foo,1:3);%xyz coordinates of the second vertex of triangles specific to the dividing cell
                             Celloutput(i).sp_V3{1,k}(:,1:3) = V3(foo,1:3);%xyz coordinates of the third vertex of triangles specific to the dividing cell

                          clear r foo SA angle meandist rach dists
            end
        end
        
        %Save the array out into Celloutput.meas

        Celloutput(i).meas(1:length(frms),10:17)=out;
        clear out 
        numbertodo = length(Celloutput) - i(1,1);
    X = [Celloutput(i).cell,' of gonad ',Celloutput(i).gonad, ' is done, remains ',num2str(numbertodo),' cells to do'];
    disp(X);
end
 clearvars -except Germlineoutput Celloutput fileList

    
