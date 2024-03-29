function fv = removeTrappedVertex(fv)

NOT DEBUGGED

% takes a patch and removes any vertex that has belongs to only three
% edges. It is replaces by a triangle.

DEBUG = true;


numVerts = length(fv.vertices(:,1));

tri = triangulation(fv.faces,fv.vertices);

%% find vertex topology

topo = topology(fv.vertices,[],fv.faces,[]);

% indices of vertices with three edges 
...that are not boundary vertices (todo)
isTrapped = topo.vertices(topo.vertices(:,1) == 3,4);


% finding triangles these vertices are part of.
ti = vertexAttachments(tri,isTrapped);


%% creating new triangles / remove 'trapped' triangles
newTris = zeros(length(isTrapped),3);
toRemove = [];
for i = 1:length(ti)
    triTmp = tri.ConnectivityList(ti{i},:);
    toRemove = [toRemove, ti{i}];
    
    %form a triangle out of the indices of the attached triangles
    triTmp = unique(triTmp);
    triTmp = triTmp(TriTmp ~= isTrapped(i));
    
    newTris(i,:) = triTmp;
end


fv.faces(toRemove,:) = [];    
fv.faces = [fv.faces; newTris];

%% removing unused vertices
isUsed = unique(fv.faces(:));
unUsed = true(numVerts,1);
unUsed(isUsed) == false;


fv.faces(unUsed,:) = [];



if DEBUG
    figure('Name','fixed mesh');
    patch(fv,'FaceColor',[0 0 1],'FaceAlpha',1); rotate3d on; axis equal;
end



