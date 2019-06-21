function in = inRng(pos,rng)
% determines which atoms are within a list of ranges in the format [mcbegin
% mcend; mcbegin mcend; ....]


% input validation
if isvector(pos)
    mc = pos;
else
    mc = pos(:,4);
end


% calculation
in = false(length(pos(:,1)),1);

for range = 1:length(rng(:,1))
    in = in | ((mc >= rng(range,1)) & (mc <= rng(range,2)));
end

    
    
    
% output validation

overlap = sum(in > 1);

if overlap
    warning('some atoms are in multiple ranges');
end

