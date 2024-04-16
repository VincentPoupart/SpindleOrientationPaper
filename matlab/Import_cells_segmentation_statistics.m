% for i = 1:1:length(Germlineoutput)
%     Germlines{i,1} = Germlineoutput(i).gonad;
% end


folder = uigetdir;
fileList = getAllFiles(folder);

for i = 1:1:length(fileList)
    if contains(fileList(i,1), '_Cell_Volume.csv')
        foa = string(extractAfter(fileList(i,1),"_Statistics\"));
        file = string(fileList(i,1));
        gonad = extractBefore(foa,"_Cell_Volume.csv");
        specific_gonad = matches(Germlines,gonad);
        specific_gonad=num2cell(specific_gonad);
        for op=1:1:length(specific_gonad)
            if isequal(specific_gonad{op,1},0)
                specific_gonad{op,1}=[];
            end
        end
        ffoo = find(~cellfun('isempty', specific_gonad));
        if isempty(ffoo) == false
            table = readtable(file);
           
            Germlineoutput(ffoo).Cell_Volume = table{:, [1,4,5,6]};
            [~,idx] = sort(Germlineoutput(ffoo).Cell_Volume(:,2)); % sort just the first column
            Germlineoutput(ffoo).Cell_Volume = Germlineoutput(ffoo).Cell_Volume(idx,:);   % sort the whole matrix using the sort indices
        end
    else
        if contains(fileList(i,1), '_Cell_Ellipticity_(oblate).csv')
            foa = string(extractAfter(fileList(i,1),"_Statistics\"));
            file = string(fileList(i,1));
            gonad = extractBefore(foa,"_Cell_Ellipticity_(oblate).csv");
            specific_gonad = matches(Germlines,gonad);
            specific_gonad=num2cell(specific_gonad);
            for op=1:1:length(specific_gonad)
                if isequal(specific_gonad{op,1},0)
                    specific_gonad{op,1}=[];
                end
            end
            ffoo = find(~cellfun('isempty', specific_gonad));
            if isempty(ffoo) == false
                table = readtable(file);
                Germlineoutput(ffoo).Cell_Ellipticity_oblate = table{:,[1,4,5,6]};
                [~,idx] = sort(Germlineoutput(ffoo).Cell_Ellipticity_oblate(:,2)); % sort just the first column
                Germlineoutput(ffoo).Cell_Ellipticity_oblate= Germlineoutput(ffoo).Cell_Ellipticity_oblate(idx,:);   % sort the whole matrix using the sort indices
            end
        else
            if contains(fileList(i,1), '_Cell_Ellipticity_(prolate).csv')
                foa = string(extractAfter(fileList(i,1),"_Statistics\"));
                file = string(fileList(i,1));
                gonad = extractBefore(foa,"_Cell_Ellipticity_(prolate).csv");
                specific_gonad = matches(Germlines,gonad);
                specific_gonad=num2cell(specific_gonad);
                for op=1:1:length(specific_gonad)
                    if isequal(specific_gonad{op,1},0)
                        specific_gonad{op,1}=[];
                    end
                end
                ffoo = find(~cellfun('isempty', specific_gonad));
                if isempty(ffoo) == false
                    table = readtable(file);
                    Germlineoutput(ffoo).Cell_Ellipticity_prolate =  table{:,[1,4,5,6]};
                    [~,idx] = sort(Germlineoutput(ffoo).Cell_Ellipticity_prolate(:,2)); % sort just the first column
                    Germlineoutput(ffoo).Cell_Ellipticity_prolate= Germlineoutput(ffoo).Cell_Ellipticity_prolate(idx,:);   % sort the whole matrix using the sort indices
                end
            else
                if contains(fileList(i,1), '_Cell_Ellipsoid_Axis_Length_A.csv')
                    foa = string(extractAfter(fileList(i,1),"_Statistics\"));
                    file = string(fileList(i,1));
                    gonad = extractBefore(foa,"_Cell_Ellipsoid_Axis_Length_A.csv");
                    specific_gonad = matches(Germlines,gonad);
                    specific_gonad=num2cell(specific_gonad);
                    for op=1:1:length(specific_gonad)
                        if isequal(specific_gonad{op,1},0)
                            specific_gonad{op,1}=[];
                        end
                    end
                    ffoo = find(~cellfun('isempty', specific_gonad));
                    if isempty(ffoo) == false
                        table = readtable(file);
                        Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_A = table{:,[1,4,5,6]};
                        [~,idx] = sort(Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_A(:,2)); % sort just the first column
                        Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_A = Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_A(idx,:);   % sort the whole matrix using the sort indices
                    end
                else
                    if contains(fileList(i,1), '_Cell_Ellipsoid_Axis_Length_B.csv')
                        foa = string(extractAfter(fileList(i,1),"_Statistics\"));
                        file = string(fileList(i,1));
                        gonad = extractBefore(foa,"_Cell_Ellipsoid_Axis_Length_B.csv");
                        specific_gonad = matches(Germlines,gonad);
                        specific_gonad=num2cell(specific_gonad);
                        for op=1:1:length(specific_gonad)
                            if isequal(specific_gonad{op,1},0)
                                specific_gonad{op,1}=[];
                            end
                        end
                        ffoo = find(~cellfun('isempty', specific_gonad));
                        if isempty(ffoo) == false
                            table = readtable(file);
                            Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_B = table{:,[1,4,5,6]};
                            [~,idx] = sort(Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_B(:,4)); % sort just the first column
                            Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_B = Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_B(idx,:);   % sort the whole matrix using the sort indices
                        end
                    else
                        if contains(fileList(i,1), '_Cell_Ellipsoid_Axis_Length_C.csv')
                            foa = string(extractAfter(fileList(i,1),"_Statistics\"));
                            file = string(fileList(i,1));
                            gonad = extractBefore(foa,"_Cell_Ellipsoid_Axis_Length_C.csv");
                            specific_gonad = matches(Germlines,gonad);
                            specific_gonad=num2cell(specific_gonad);
                            for op=1:1:length(specific_gonad)
                                if isequal(specific_gonad{op,1},0)
                                    specific_gonad{op,1}=[];
                                end
                            end
                            ffoo = find(~cellfun('isempty', specific_gonad));
                            if isempty(ffoo) == false
                                table = readtable(file);
                                Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_C = table{:,[1,4,5,6]};
                                [~,idx] = sort(Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_C(:,4)); % sort just the first column
                                Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_C = Germlineoutput(ffoo).Cell_Ellipsoid_Axis_Length_C(idx,:);   % sort the whole matrix using the sort indices
                            end
                        else
                            if contains(fileList(i,1), '_Cell_Position.csv')
                                foa = string(extractAfter(fileList(i,1),"_Statistics\"));
                                file = string(fileList(i,1));
                                gonad = extractBefore(foa,"_Cell_Position.csv");
                                specific_gonad = matches(Germlines,gonad);
                                specific_gonad=num2cell(specific_gonad);
                                for op=1:1:length(specific_gonad)
                                    if isequal(specific_gonad{op,1},0)
                                        specific_gonad{op,1}=[];
                                    end
                                end
                                ffoo = find(~cellfun('isempty', specific_gonad));
                                if isempty(ffoo) == false
                                    table = readtable(file);
                                    Germlineoutput(ffoo).Cell_Position = table;
                                end
                            else
                                if contains(fileList(i,1), '_Cell_Ellipsoid_Axis_A.csv')
                                    foa = string(extractAfter(fileList(i,1),"_Statistics\"));
                                    file = string(fileList(i,1));
                                    gonad = extractBefore(foa,"_Cell_Ellipsoid_Axis_A.csv");
                                    specific_gonad = matches(Germlines,gonad);
                                    specific_gonad = num2cell(specific_gonad);
                                    
                                    for op=1:1:length(specific_gonad)
                                        if isequal(specific_gonad{op,1},0)
                                            specific_gonad{op,1}=[];
                                        end
                                    end 
                                    ffoo = find(~cellfun('isempty', specific_gonad));
                                    if isempty(ffoo) == false
                                        table = readtable(file);
                                        Germlineoutput(ffoo).Cell_Ellipsoid_Axis_A = table;
                                    end
                                else
                                    if contains(fileList(i,1), '_Cell_Ellipsoid_Axis_B.csv')
                                        foa = string(extractAfter(fileList(i,1),"_Statistics\"));
                                        file = string(fileList(i,1));
                                        gonad = extractBefore(foa,"_Cell_Ellipsoid_Axis_B.csv");
                                        specific_gonad = matches(Germlines,gonad);
                                        specific_gonad=num2cell(specific_gonad);
                                        for op=1:1:length(specific_gonad)
                                            if isequal(specific_gonad{op,1},0)
                                                specific_gonad{op,1}=[];
                                            end
                                        end
                                        ffoo = find(~cellfun('isempty', specific_gonad));
                                        if isempty(ffoo) == false
                                            table = readtable(file);
                                            Germlineoutput(ffoo).Cell_Ellipsoid_Axis_B = table;
                                        end
                                    else
                                        if contains(fileList(i,1), '_Cell_Ellipsoid_Axis_C.csv')
                                            foa = string(extractAfter(fileList(i,1),"_Statistics\"));
                                            file = string(fileList(i,1));
                                            gonad = extractBefore(foa,"_Cell_Ellipsoid_Axis_C.csv");
                                            specific_gonad = matches(Germlines,gonad);
                                            specific_gonad=num2cell(specific_gonad);
                                            for op=1:1:length(specific_gonad)
                                                if isequal(specific_gonad{op,1},0)
                                                    specific_gonad{op,1}=[];
                                                end
                                            end
                                            ffoo = find(~cellfun('isempty', specific_gonad));
                                            if isempty(ffoo) == false
                                                table = readtable(file);
                                                Germlineoutput(ffoo).Cell_Ellipsoid_Axis_C = table;
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end


