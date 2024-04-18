
    for m = 1:1:length(Celloutput(l).sp_centroids)
    for l = 1:1:length(Celloutput)   
       rachcentr = Celloutput(l).sp_centroids{1,m};
       if isempty(rachcentr)  
          Celloutput(l).sp_centroids{2,m} = NaN;
          Celloutput(l).sp_centroids{3,m} = NaN;
       else
           if length(rachcentr(:,1)) < 2
              Ta = 1;
              Celloutput(l).sp_centroids{2,m} = Ta;
              Celloutput(l).sp_centroids{3,m} = 1;     
           else
              Ya = pdist(rachcentr);    
              Za = linkage(Ya);
              C = 1;
              Ta = cluster(Za,'Cutoff',C,'Criterion','distance');
              Celloutput(l).sp_centroids{2,m} = Ta;
              Celloutput(l).sp_centroids{3,m} = nanmax(real(Ta));  
           end

       end

    end
    end



%%%Celloutput(l).sp_centroids{2,:}: For each triangle of the surface,
%%%identification to which patch they belong. eg: 1 = triangle belong to
%%%patch 1.

%%%Celloutput(l).sp_centroids{3,:}: number of patch that constitute the
%%%surface extracted.




    for j = 1:1:length(Celloutput)
        for k = 1:1:length(Celloutput(j).sp_centroids)
        vectmaxpatch{1,1}(k,j) = abs(Celloutput(j).sp_centroids{3,k});
        end
      vectmaxpatch{1,1}(vectmaxpatch{1,1} == 0) = NaN;
      vectmaxpatch{2,1} = nanmax(vectmaxpatch{1,1});
    end
    
    
    figure(1)
    bar((vectmaxpatch{2,1})','stacked')
    xlabel('cells')
    ylabel({'maximum number of surfaces'})
    title(['maximum number of surfaces per cell'])
    
    

    for j = 1:1:length(Celloutput)
    Tpatch{1,j} = NaN(5,3);
        T = tabulate(vectmaxpatch{1,1}(:,j));
        for t = 1:1:length(T(:,1))
            for tt = 1:1:length(T(1,:))
        Tpatch{1,j}(t,tt) = T(t,tt);
            end
        end
    end

 
for i = 1:1:length(Tpatch(:,1))
    for j = 1:1:length(Tpatch)
        
        ones(i,j) = Tpatch{i,j}(1,2); 
        twos(i,j) = Tpatch{i,j}(2,2); 
        threes(i,j) = Tpatch{i,j}(3,2); 
        fours(i,j) =  Tpatch{i,j}(4,2);
        fives (i,j) =  Tpatch{i,j}(5,2);
    end
end



one = ones(1,:)';
two = twos(1,:)';
three = threes(1,:)';
four = fours(1,:)';
five = fives(1,:)';
% Create a stacked bar chart using the bar function
figure(2)

bar(1:length(ones(1,:)), [one two three four five], 0.5, 'stack')

% Adjust the axis limits

set(gca, 'XTick', 1:length(Celloutput));

% Add title and axis labels
 title(['number of patches per frame'])
xlabel('cells')
ylabel('total number of frames')

% Add a legend
legend('one patch', 'two patches', 'three patches', 'four patches', 'five patches')

