Germlines = cell(length(Celloutput),1);
Germlineoutput = struct;
for i = 1:1:length(Celloutput)
    Germlines{i} = Celloutput(i).gonad;
end

Germlines = unique(Germlines);

for i = 1:1:length(Germlines)
    Germlineoutput(i).gonad = Germlines{i};
end



