function [vox gridVec]= voxelCreateFromPos(pos,bin,gridVec)
% voxelisation of the point cloud stored in pos, bin is the binwidth 
% grid vectors can be parsed
% 
% [vox gridVec]= voxelCreateFromPos(pos,bin,gridVec)
% [vox gridVec]= voxelCreateFromPos(pos,bin)
% 
% INPUT
% pos:      pos File 
% bin:
% gridVec:
% 
% OUTPUT
% vox:
% gridVec:

%% Table based or Array 
% only coordinates
if istable(pos)
    posTable(:,1) = pos.x;
    posTable(:,2) = pos.y;
    posTable(:,3) = pos.z;
    pos = posTable;

else 
    pos = pos(:,1:3);
end

%% Calculating Grid vectors
bin = [bin bin bin];


if ~exist('gridVec','var')
    
    
    % calculating bin centers
    binvectorRaw = linspace(0,1000*bin(1),1001);
    binvectorRaw = [fliplr(uminus(binvectorRaw(2:end))) binvectorRaw];
    
    
    %mins and maxs
    mins = min(pos) - 2*bin;
    maxs = max(pos) + 2*bin;
    
    for d = 1:3
        gridVec{d} = binvectorRaw(binvectorRaw>=mins(d) & binvectorRaw<=maxs(d));
    end
    
else
    bin = [gridVec{1}(2)-gridVec{1}(1) gridVec{2}(2)-gridVec{2}(1) gridVec{3}(2)-gridVec{3}(1)];
    
end


%% calcualting 3d histogram

% calculating bin association
for d = 1:3
    edgeVec{d} = [gridVec{d}-bin(d)/2 gridVec{d}(end)+bin(d)/2];
    [useless loc(:,d)] = histc(pos(:,d),edgeVec{d},1);
    sz(d) = length(edgeVec{d})-1;
end
clear useless

% for points on the border
sz = max([sz; max(loc,[],1)]);

% count of atoms in each voxel
vox = accumarray(loc,1,sz);


end



