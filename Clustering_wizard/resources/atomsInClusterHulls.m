% forms the convex hulls in a patch for all clusters in exportIdx

function [posOut posOutCells] = atomsInClusterHulls(pos, clusterPos, clusterIdx, exportIdx)

posOut = [];

wb = waitbar(0,'performing containment tests');

numClust = length(exportIdx);

posOutCells = cell(numClust,1);

%% cycling through all clusters and performing a contaiment test
for idx = 1:numClust
    
    % identify which atoms form the convex hull
    tmpPos = clusterPos(ismember(clusterIdx,exportIdx(idx)),1:3);
    hull = convhull(tmpPos(:,1),tmpPos(:,2),tmpPos(:,3));
    
    
    % take only these atoms
    
    hull = unique(hull);
    tmpPos = tmpPos(hull,:);
    
    
    %% only test atoms within the bounding box of a cluster hull
    bnd_up = max(tmpPos,[],1);
    bnd_lw = min(tmpPos,[],1);
    
    isIn = true(length(pos),1);
    for dim = 1:3
        isIn = isIn.*(pos(:,dim)<=bnd_up(dim) & pos(:,dim)>=bnd_lw(dim));
    end
    
    testPos = pos(logical(isIn),:);
    isIn = inhull(testPos(:,1:3),tmpPos(:,1:3));
    testPos = testPos(isIn,:);
    
    posOut = [posOut; testPos];
    posOutCells{idx} = testPos;
    
    waitbar(idx/numClust,wb);

    
end

close(wb);
