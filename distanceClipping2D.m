function in = distanceClipping2D(fv,pos,dist)
% clips all atoms that are further away from the interface FV than dist. If
% dist has two components, the first one is the clipping distance in the
% negative direction, the second one in the positive direction as given by
% the vertex normals.
% newer version that produces logical variable

addpath('patch_normals');

normals = patchnormals(fv);


% distance clipping in single value case
if length(dist) == 1
    dist(2) = - dist(1);
    dist = uminus(dist);
end

% clipping

%% tessellation and distance clipping - species
numAtom = length(pos(:,1));
numVerts = length(fv.vertices);

% finding closest point for each atomic position
closest = dsearchn(fv.vertices,pos(:,1:3));
distVec = pos(:,1:3) - fv.vertices(closest,:);

%distance through dot product
d = sum(normals(closest,:) .* distVec,2);

in = d > dist(1) & d > dist(2);


end