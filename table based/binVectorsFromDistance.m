function [binCenters, binEdges] = binVectorsFromDistance(dist,bin,mode)
% creates set of grid vectors to be used in nD binning. The bounds are
% calculated such that they dont go beyond the size of the dataset.
% dist is the distance variable to be binned, one colum per dimension
% bin is the bin 'distance' per bin in either a distance metric or a count
% mode can be constant 'distance' or constant 'count'
% constant count only makes sense for 1D!
% in constant count last bin will have a different count if length(dist) is not N x bin
% constant count: bin centers are the distance of the dist in the bin
% middle by index

isConstantCount = strcmp(mode, 'count');
isConstantDistance = strcmp(mode, 'distance');

numDim = length(bin);

% input checking
if ~(numDim == length(dist(1,:))) % throw error when dimensions incompatible
    error('dimensions of distance variable and bin variable not the same');
end
if isConstantCount & numDim ~= 1
    error('constant count mode only avialable for 1D binning');
end


%% calculate bin centers based on constant bin distance interval
if isConstantDistance
    for dim = 1:numDim
        % calculating bin centers
        binvectorRaw{dim} = linspace(0,10000*bin(dim),10001);
        binvectorRaw{dim} = [fliplr(uminus(binvectorRaw{dim}(2:end))) binvectorRaw{dim}];
        binCenters{dim} = binvectorRaw{dim}(binvectorRaw{dim}>=min(dist(:,dim)) - bin(dim) & binvectorRaw{dim}<=max(dist(:,dim)) + bin(dim));
        
        % calculating bin edges
        binEdges{dim} = (binCenters{dim}(2:end) + binCenters{dim}(1:end-1)) / 2;
        binEdges{dim} = [binCenters{dim}(1) - (binCenters{dim}(2) - binCenters{dim}(1))/2,...
            binEdges{dim},...
            binCenters{dim}(end) + (binCenters{dim}(end) - binCenters{dim}(end-1))/2];
    end
end


%% calculate bin centers based on constant bin count interval
if isConstantCount
    dist = sort(dist);
    idxEdge = 1:bin:length(dist);
    
    % if length of dist is not equal N x bin
    if idxEdge(end) < length(dist); idxEdge = [idxEdge, length(dist)]; end
    
    idxCent = round( (idxEdge(2:end) + idxEdge(1:end-1)) / 2 );
    binCenters{1} = dist(idxCent);
    binEdges{1} = dist(idxEdge);
    binEdges{1}(1) = binEdges{1}(1) - 0.0001; % to avoid opening up extra bins because of atoms on the edge
    binEdges{1}(end) = binEdges{1}(end) + 0.0001; % to avoid opening up extra bins because of atoms on the edge
end