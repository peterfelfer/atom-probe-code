function ions = ionsInXRNG(xrng)
% function that plots all ranged ions of an xrng file into a cell array




%% collecting the information into array (numbers)
for rng = 1:length(xrng.ranges)
    
    for at = 1:(length(xrng.ranges(rng).ions(1).atoms) + 1)
        if at <= length(xrng.ranges(rng).ions(1).atoms)
            ions(rng,at) = xrng.ranges(rng).ions(1).atoms(at).atomicnumber;
        else
            ions(rng,at) = xrng.ranges(rng).ions(1).chargestate;
        end
        
        
    end
    
      
end

%% creating unique strings

ions = unique(ions,'rows');


for ion = 1:length(ions(:,1))
    
    currIon = ions(ion,:);
    currIon = currIon(currIon~=0);
    cs = currIon(end);
    currIon(end) = [];
    atoms = unique(currIon);
    
    
    strings{ion} = '';
    for at = 1:length(atoms)
        multiplier(at) = sum(currIon == atoms(at));
        
        strings{ion} = [strings{ion} sym4number(atoms(at)) ];
        
        if multiplier > 1
            strings{ion} = [strings{ion} num2str(multiplier(at))];
        end
        
    end
    
    for i=1:cs
        strings{ion} = [strings{ion} '+'];
    end
    
    
    
    
    
end

ions = unique(strings');









