function Dmap = kwikDmap(pos,interface,lim,deloc)
% calculates a density map for the patch 'interface' for the atoms in 'pos'
% within 'lim' nm of the interface

DEBUG = false;

addpath('patch_normals');

normals = patchnormals(interface);

%% tessellation and distance clipping - species
numAtom = length(pos(:,1));
numVerts = length(interface.vertices);

% finding closest point for each atomic position
closest = dsearchn(interface.vertices,pos(:,1:3));
distVec = pos(:,1:3) - interface.vertices(closest,:);

%distance through dot product
dist = sum(normals(closest,:) .* distVec,2);
dist = abs(dist);

%pos = pos(dist <= lim);
closest = closest(dist<=lim);

for v = 1:numVerts
    % raw count of IE atoms per vertex
    speciesCount(v) = sum(closest == v);
end


%% calculation of vertex area
[cp,ce,pv,ev] = makedual2(interface.vertices,interface.faces);
[pc,area] = geomdual2(cp,ce,pv,ev);


if DEBUG
    hist(dist,20);
end


Dmap = speciesCount./(area' * lim);


%% visualising the results
interface.facevertexcdata = Dmap;

f = figure('Name','Density map');
trisurf(interface.faces,interface.vertices(:,2),interface.vertices(:,1),interface.vertices(:,3),Dmap);
axis equal;
rotate3d on;
shading interp;
colorbar;

%% export to *.ply?
%property gets normalized

minC = min(Dmap);
maxC = max(Dmap);

limits = ['comment denity map ranges: ' num2str(minC*100,3) 'at/nm2 ' num2str(maxC*100,3) 'at/nm2'];


CmapPly = Dmap - minC;
CmapPly = CmapPly/(maxC-minC);
CmapPly = CmapPly';

[file path] = uiputfile('*.ply','save quick density map as ply','IEmap');

if file
    patch2ply(interface,[CmapPly, CmapPly, CmapPly],[path file], limits);
end


