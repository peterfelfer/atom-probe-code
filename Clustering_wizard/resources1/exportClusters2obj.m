function vlist = exportClusters2obj(unfilteredPos,clusterIdx,Nmin)
% exports the locations of clusters to a Wavefront obj and also creates a
% vertex list that can be used for feature analysis in openVA. If the obj
% export is cancelled, only a vertex list is produced.

numClusters = median(max(clusterIdx));
clustSizes = hist(clusterIdx,numClusters);


%filters for Nmin
if ~exist('Nmin','var')
    % the graph connectivity algorithm breaks the network up into connected
    % regions. Clusters with N = 1 are simply uncalssified atoms and
    % classified atoms without a classified (vol<thresh) neighbor.
    Nmin = 1;
end

significantClustIdx = find(clustSizes > Nmin)';


%% produces obj file for vertex analysis, placing a vertex at the center of every cluster

numVerts = length(significantClustIdx(:,1));
vertCoord = zeros(numVerts,3);

for clust = 1:numVerts
    vertCoord(clust,:) = mean(unfilteredPos(clusterIdx == significantClustIdx(clust),1:3));   
end

[file path] = uiputfile('*.obj','save obj file as');

if file
    fid = fopen([path file],'wt');
    
    fprintf(fid, '# openVA cluster to obj exporter, (c) Peter Felfer, The University of Sydney 2013 \n');
    fprintf(fid, 'v %f %f %f\n', vertCoord(:,1:3)');
    fprintf(fid, ['# exported ' num2str(numVerts) ' vertices \n']);
    
    for i = 1:numVerts
        fprintf(fid, ['p ' num2str(i) ' \n']);
    end
    fprintf(fid, ['# exported ' num2str(i) ' clusters \n']);
    
    fclose(fid);
end

vlist = [vertCoord ones(numVerts,2) zeros(numVerts,2) ones(numVerts,2)];
end