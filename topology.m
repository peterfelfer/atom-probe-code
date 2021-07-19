function topo = topology(vertices,edges,triangles,tetra)

NOT DEBUGGED

% function that assesses the topology of a piecwise linear approximation
% the topo struct has the following entries:

%{
number of n-simplices a simplex is part of

topo.vertices(:,1) = number of edges, including edges from faces
             (:,2) = number of faces, including faces of tetrahedra
             (:,3) = number of tetrahedra
             (:,4) = vertex indices (essentially just 1:numVerts)

topo.edges(:,1) = number of faces, including faces of tetrahedra
          (:,2) = number of tetrahedra
          (:,3:4) = vertex indices

topo.faces(:,1) = number of tetrahedra
          (:,2:4) = vertex indices
%}


numVert = length(vertices(:,1));


noEdges = isempty(edges);
noTris = isempty(triangles);
noTet = isempty(tetra);


% calculate edge list from all simplices
if noEdges
    edgesTri = [];
else
    edgesTri = [triangles(:,[1 2]); triangles(:, [2 3]); triangles(:, [3 1]);];
end

if noTet
    edgesTet = [];
else
    edgesTet = [tetra(:,[1 2]); tetra(:,[2 3]); tetra(:,[3 4]);...
        tetra(:,[1 3]); tetra(:,[1 4]); tetra(:,[2 4]);];
end


% calculate face list from all simplices
if noTet
    triTet = [];
else
    triTet = [tetra(:,[1 2 3]); tetra(:,[2 3 4]); tetra(:,[1 3 4]); tetra(:,[1 2 4])];
end

%% vertex topology
tmpEdg = unique(sort([edges; edgesTri; edgesTet],2),'rows');
topo.vertices(:,1) = hist(tmpEdg(:),numVert);

tmpTri = unique(sort([triangles; triTet],2),'rows');
topo.vertices(:,2) = hist(tmpTri(:),numVert);

tmpTet = unique(sort(tetra,2),'rows');
topo.vertices(:,3) = hist(tmpTet(:),numVert);

topo.vertices(:,4) = 1:numVert;




%% edge topology

