function distance = posDistanceToMesh(pos,interface)
% calculates the distance of individual atoms to a mesh representing e.g.
% an interface or any other object that can be displayed as a triangulation
% fv is a triangulation consisting of vertices and faces (Matlab 'patch')

% distances are calculated along vertex normals.
normals = patchnormals(interface);

% tessellation and distance calculation
% finding closest point for each atomic position
closestVertex = dsearchn(interface.vertices,delaunayn(interface.vertices),[pos.x, pos.y, pos.z]);

% distance vector to the nearest interface vertex
distVec = [pos.x, pos.y, pos.z] - interface.vertices(closestVertex,:);

%distance along normal through dot product
dist = sum(normals(closestVertex,:) .* distVec,2);