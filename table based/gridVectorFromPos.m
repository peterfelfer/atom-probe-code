function gv = gridVectorFromPos(pos,bin)
% creates set of grid vectors to be used in voxelisations. The bounds are
% calculated such that they dont go beyond the size of the dataset. If bin
% is a scalar, isotropic grid, otherwise anisotopic


if isscalar(bin)
    bin = [bin bin bin];
end

% calculating bin centers
for dim = 1:3
    binvectorRaw{dim} = linspace(0,10000*bin(dim),10001);
    binvectorRaw{dim} = [fliplr(uminus(binvectorRaw{dim}(2:end))) binvectorRaw{dim}];
end

% clippping to actual dataset size
gv{1} = binvectorRaw{1}(binvectorRaw{1}>=min(pos.x) - bin(1) & binvectorRaw{1}<=max(pos.x) + bin(1));
gv{2} = binvectorRaw{2}(binvectorRaw{2}>=min(pos.y) - bin(2) & binvectorRaw{2}<=max(pos.y) + bin(2));
gv{3} = binvectorRaw{3}(binvectorRaw{3}>=min(pos.z) - bin(3) & binvectorRaw{3}<=max(pos.z) + bin(3));

