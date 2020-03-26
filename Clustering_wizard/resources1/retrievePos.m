function pos = retrievePos(decomp,species)
% takes a decomposed posfile and fetches the sub-posfile of a certain
% species. returns 0 if the species is not present.

addpath('pos_tools','xml_tools');


%% producing a property struct to compare to the input
if ischar(species)
    
    % for now, only atomic
    atomType = species;
    clear species;
    
    species.property{1}.name = 'atomic number';
    species.property{1}.value = number4sym(atomType);
    
    
    
    
elseif isstruct(species)
    
    % well, do nothing.
    
    
end


pos = 0;

%% cycling through the decomposed posfile to find a match
for i = 1:length(decomp)
    
    cnt = 0;
    for prop = 1:length(decomp{i}.property)
        
        if decomp{i}.property{prop}.value == species.property{prop}.value
            
            cnt = cnt + 1;
        
        end
    end
    
    if cnt == prop
        
        pos = decomp{i}.pos;
    end
        
end



end