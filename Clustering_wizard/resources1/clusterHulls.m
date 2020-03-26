% forms the convex hulls in a patch for all clusters in exportIdx

function hullPatch = clusterHulls(pos, clusterIdx, exportIdx)
pos = pos(:,1:3);

vertices = [];
faces = [];


for idx = 1:length(exportIdx)
    
    % identify which atoms form the convex hull
    tmpPos = pos(ismember(clusterIdx,exportIdx(idx)),:);
    [hull vol] = convhull(tmpPos(:,1),tmpPos(:,2),tmpPos(:,3));
    
    
    % take only these atoms
    
    hull = unique(hull);
    tmpPos = tmpPos(hull,:);
    
    [hull vol] = convhull(tmpPos(:,1),tmpPos(:,2),tmpPos(:,3));
    
    numVerts = length(vertices);
    
    vertices = [vertices; tmpPos];
    faces = [faces; hull + numVerts];
    
end

hullPatch.vertices = vertices;
hullPatch.faces = faces;
