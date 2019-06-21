function adjacencyMatrix = delaunay2adjacencyMat(delTet,qualifiedPointsIdx)
%transforms a Delaunay trinagulation of specified points into a sparse
%adjacency matrix
%tic;

% determining in the delaunay triangulation which atoms are clustered

%delIsClustered = arrayfun(@(x) sum(x == qualifiedPointsIdx),delTet);
%delIsClustered = ismember(delTet,qualifiedPointsIdx);

%disp('calculating perms');
% creating all delaunay edges
permut = [1,2;2,3;3,4;1,3;1,4;2,4];

%building adjacency indices (= Delaunay edges) list of all atoms
delAdjacencyIdx = zeros(length(delTet)*6,2);
numTet = length(delTet);

for perm = 1:6
    %disp(['permutation ' num2str(perm)]);
    p = permut(perm,:);
    
    delAdjacencyIdx(numTet*(perm-1)+1:numTet*perm,:) = delTet(:,p);
    
end

delAdjacencyIdx = [delAdjacencyIdx; [delAdjacencyIdx(:,2) delAdjacencyIdx(:,1)]];

% removing the edges which contain atoms that are not qualified
%disp('calculating memebership of edges');
%delAdjacencyIdxIsIn = arrayfun(@(x) sum(x == qualifiedPointsIdx),delAdjacencyIdx);
delAdjacencyIdxIsIn = ismember(delAdjacencyIdx,qualifiedPointsIdx);
%size(delAdjacencyIdxIsIn)
%sum(delAdjacencyIdxIsIn)

unqualifiedEdges = ~(delAdjacencyIdxIsIn(:,1) .* delAdjacencyIdxIsIn(:,2));

%sum(unqualifiedEdges)

%length(delAdjacencyIdx)
delAdjacencyIdx(unqualifiedEdges,:) = [];
%length(delAdjacencyIdx)

adjacencyMatrix = sparse(delAdjacencyIdx(:,1),delAdjacencyIdx(:,2),1);

%toc;
end