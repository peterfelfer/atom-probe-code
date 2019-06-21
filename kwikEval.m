function kwikEval(pos,parentPos,interface,vertices)
%calculates the average interfacial excess for an interface with an
%interactive interface for the IE determination

%%reads a pos file [x,y,z] converted to a Matlab variable and a vertex file
%%[x,y,z] and assigns every atom to the closest vertex.

%vap: m y z mc vert# disttovert distalongnormal( or to line element)
%shiftdistance
%vertex: x y z obj# nx ny nz d A(or l)

addpath('dualMesh');
addpath('patch_normals');
addpath('resources');

normals = patchnormals(interface);

numVerts = length(interface.vertices);
%% tessellation and distance clipping
% finding closest point for each atomic position
closest = dsearchn(interface.vertices,delaunayn(interface.vertices),parentPos(:,1:3));

% calculation of vertex area
[cp,ce,pv,ev] = makedual2(interface.vertices,interface.faces);
[pc,area] = geomdual2(cp,ce,pv,ev);


%if local IE values are calcualted, only atomic positions associated with
%the vertices on the vertex list are used.
if exist('vertices','var')
    isLocal = ismember(closest,vertices);
    parentPos = parentPos(isLocal,:);
    closest = closest(isLocal,:);
    
    area = area(vertices);
end


distVec = parentPos(:,1:3) - interface.vertices(closest,:);
%distance through dot product
dist = sum(normals(closest,:) .* distVec,2);
area = sum(area);






%% calcualting cumulative diagram

% indices of atoms that are part of the species in question
idx = ismember(parentPos(:,1:3),pos(:,1:3),'rows');
[useless, sortIdx] = sort(dist);
idx = idx(sortIdx);

cumulative = cumsum(idx);

%% index of interface location
interfaceLoc = median(find(abs(dist(sortIdx)) == min(abs(dist))));


excessGUI(cumulative,area,interfaceLoc);



end




















