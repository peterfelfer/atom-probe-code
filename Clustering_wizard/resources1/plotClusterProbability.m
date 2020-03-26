function plotClusterProbability(prob, batch)



if ~exist('batch','var');
    
    % for one dataset
    labels = {};
    
    for vol =1:length(prob)
        y(vol) = prob{vol}.percentage;
        N(vol) = prob{vol}.num;
        
        if prob{vol}.property{1}.name == 'atomic number'
            labels{vol} = sym4number(prob{vol}.property{1}.value);
            
        end
        
    end
    
    h = bar(y);
    set(gca,'XTickLabel',labels);
    
else
    
    %to compare batch processed datasets
    
    labels = {};
    numDataSets = length(prob);
    
    for dat = 1:numDataSets
        for vol =1:length(prob{dat})
            y(vol,dat) = prob{dat}{vol}.percentage;
            N(vol,dat) = prob{dat}{vol}.num;
            
            %assumes for now, that all datasets have the same atomic
            %species defined. tbc
            if prob{dat}{vol}.property{1}.name == 'atomic number'
                labels{vol,dat} = sym4number(prob{dat}{vol}.property{1}.value);
                
            end
            
        end
        
    end
    
    uniqueLabels = unique(labels);
    
    
    %creating an array where the datasets that are missing a specific
    %element are padded with zeros
    size(labels)
    n=0;
    y = zeros(length(uniqueLabels),numDataSets);
    for el = 1:length(uniqueLabels)
        
        for dat = 1:numDataSets
            
            for label = 1:length(prob{dat})
                
                if labels{el,dat} == uniqueLabels{el}
                    n=n+1
                    y(el,dat) = prob{dat}{label}.percentage;
                end
                
            end
        end
    end 
    
    
    h = bar(y);
    set(gca,'XTickLabel',uniqueLabels);
    
end

end
