function split = splitpos(pos,xrng,element)

% returns a struct with one cell per range, containing the ions within that
% range and one cell with the unranged ions (last cell).




for range = 1:length(xrng.ranges)
   split{range} = pos(pos(:,4)>=xrng.ranges{range}.masstochargebegin & pos(:,4)<=xrng.ranges{range}.masstochargeend,:);   
end





if exist('element','var')
    
    posout = [];
    for range = 1:length(xrng.ranges)
        for ion = 1:length(xrng.ranges{range}.ions)
            for atom = 1:length(xrng.ranges{range}.ions{ion}.atoms)
                if xrng.ranges{range}.ions{ion}.atoms{atom}.atomicnumber == element
                    posout = [posout; split{range}];
                end
            end
        end
    end
    
    split = posout;
                      
    
    
end


end