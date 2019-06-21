function [comps sizes] = splitVolumes(pos,usedVerts)

%splits the pos into regions that were connected before all not used verts
%were removed

addpath('matlab_bgl');
addpath('toolbox_graph');

numCoords = length(pos(:,1));
del = delaunayn(pos(:,1:3));


%% creating an adjacency matrix A from the delaunay tess

tetEdge = [1,2; 1,3; 1,4; 2,3; 2,4; 3,4];

%creating the edge list
delEdge = [];
for ed = 1:6
    delEdge = [delEdge; del(:,tetEdge(ed,:))];
end

%creating the adjacency matrix
A = zeros(numCoords);

for i=1:length(delEdge)
    A(delEdge(i,1),delEdge(i,2)) = 1;
end
%A(delEdge) = 1;
%A([delEdge(:,2) delEdge(:,1)] = 1;


%change the adjacency matrix so that the unused vertices are only connected
%to themselves

unusedVerts = 1:numCoords;
unusedVerts = unusedVerts(~usedVerts);

for i=1:length(unusedVerts)
    A(unusedVerts(i),:)=zeros(1,numCoords);
    A(:,unusedVerts(i))=zeros(numCoords,1);
end

A(unusedVerts,unusedVerts) = 1;

%actual component calculation using the matlab_bgl toolbox
[comps sizes] = components(sparse(A));


end