function vox = posNdBin(pos, distance, binEdges)
% creates a voxelisation of the data in 'pos' based on the bin centers in
% 'gridVectorstors', nD voxelisation for 1, 2 and 3 dimensions
% depending on how many distance entries are given
%
% vox = posNdBin(pos, distance, binEdges)
%
% INPUT
% pos:      decomposed pos file or with allocated ranges
%
% distance: dist is the distance variable to be binned. One column per
%           dimension. 
%           It is the generalized distance. Anything that is a metric can 
%           be used. Reguraly you can use xyz coordinates (from any pos
%           variable), distance to an object or detector coordinates
%
% binEdges: generated with the gridVectorsFromDistance Function,edges of 
%           each bin
%
% OUTPUT
% vox:      cell array with different pos files for each bin containing the
%           atoms/ions from the bin.
      


numDim = length(distance(1,:)); % number of dimensions
loc = zeros(height(pos),numDim); %memory pre-allocation
atomIdx = (1:height(pos))'; %atomic indices for allocation into bins



%% calcualting 3d bin association
for d = 1:numDim
    [~, loc(:,d)] = histc(distance(:,d),binEdges{d},1);
    sz(d) = length(binEdges{d})-1;
end



%% distribute atoms into bins

% for points on the border additional bins can be opened (see behaviour of
% histc in documentation)
sz = max([sz; max(loc,[],1)]);

% acummaray requires nonscalar size input
if isscalar(sz); sz = [sz, 1]; end

% indices of atoms in each voxel
idx = accumarray(loc,atomIdx,sz,@(x) {x});

% 'distribution function' simply copies all indexed atoms
distFunc = @(i) pos(i,:); 

% distribution of atoms in respective bins
vox = cellfun(distFunc, idx, 'UniformOutput',false);
