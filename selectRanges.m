function posOut = selectRanges(pos,ranges)
%selects all atoms within a list of ranges of the form:
%[mcbegin mcend]


posOut = [];

for rng = 1:length(ranges(:,1))
    posOut = [posOut; pos(pos(:,4) > ranges(rng,1) & pos(:,4) <= ranges(rng,2), :)];
end