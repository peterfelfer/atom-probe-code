function [isClustered clusterIdx] = neighbourhood_reclassification(clusterAtomPos,clusterIdx,isClustered,significantClusterIdx)

%% calculating Voronoi diagram
tet = delaunayn(double(ClusterAtomPos(:,1:3)));

% adjacency matrix containing the links to clustered atoms
adjacencyMat_clust = delaunay2adjacencyMat(tet,find(isClustered));

% adjacency matrix containing the links to all atoms
adjacencyMat_all = delaunay2adjacencyMat(tet,1:length(clusterAtomPos(:,1)));


%% calculating the ratio of clustered to all neighbours for each atom

connectionRatio = sum(adjacencyMat_clust,2)./ sum(adjacencyMat_all);





%% calculating the number of expected neighbours for each atom

% cycling through clusters and calculating cluster 
%TBP




%% reclassification






%% recalcualtion of graph connectivity





end