function clusterPos = exportClusters2pos(unfilteredPos,clusterIdx,Nmin)

numClusters = median(max(clusterIdx));
clustSizes = hist(clusterIdx,numClusters);


%filters for Nmin
if ~exist('Nmin','var')
    % the graph connectivity algorithm breaks the network up into connected
    % regions. Clusters with N = 1 are simply uncalssified atoms and
    % classified atoms without a classified (vol<thresh) neighbor.
    Nmin = 1;
end

significantClustIdx = find(clustSizes > Nmin);
clusterPos = unfilteredPos(ismember(clusterIdx,significantClustIdx),:);


%% produces obj file for vertex analysis, placing a vertex at the center of every cluster

vertcoord = zeros(length(signifantClustIdx),3);
for clust = 1:length(significantClustIdx)
    vertCoord(clust,:) = mean(unfilteredPos(clusterIdx == significantClustIdx(clust),:));   
end



end