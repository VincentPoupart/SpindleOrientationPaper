folder = uigetdir;
A = '/DPaxis/';
for i = 1:1:length(Germlineoutput)
    gonad = Germlineoutput(i).gonad;
    filenameA = char([folder,A,gonad,'_DPaxis.csv']);
    if exist(filenameA)
        numA = readmatrix(filenameA);
        Germlineoutput(i).DPaxis = numA;
        for j = 1:1:length(Germlineoutput(i).DPaxis(:,1))
            Germlineoutput(i).DPaxisVector(j,1) = Germlineoutput(i).DPaxis(j,2)-Germlineoutput(i).DPaxis(j,3);
            Germlineoutput(i).DPaxisVector(j,2) = Germlineoutput(i).DPaxis(j,4)-Germlineoutput(i).DPaxis(j,5);
            Germlineoutput(i).DPaxisVector(j,3) = Germlineoutput(i).DPaxis(j,6)-Germlineoutput(i).DPaxis(j,7);
        end
    end
end

