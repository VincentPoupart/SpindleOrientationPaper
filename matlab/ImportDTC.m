folder = uigetdir;
A = '/DTC/';
for i = 1:1:length(Germlineoutput)
    gonad = Germlineoutput(i).gonad;
    filenameA = char([folder,A,gonad,'_DTC.csv']);
    if exist(filenameA)
        numA = readmatrix(filenameA);
        Germlineoutput(i).DTC = numA;
        
    end
end