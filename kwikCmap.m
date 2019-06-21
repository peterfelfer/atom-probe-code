function Cmap = kwikCmap(pos,parentPos,interface,lim,deloc)
% calculates a concentration map for the patch 'interface' for the atoms in 'pos'
% within 'lim' nm of the interface

DEBUG = false;

addpath('patch_normals');

normals = patchnormals(interface);

%% tessellation and distance clipping - species
numAtom = length(pos(:,1));
numVerts = length(interface.vertices);

% finding closest point for each atomic position
closest = dsearchn(interface.vertices,delaunayn(interface.vertices),pos(:,1:3));
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


%% tessellation and distance clipping - parentPos
numAtom = length(parentPos(:,1));

% finding closest point for each atomic position
closest = dsearchn(interface.vertices,delaunayn(interface.vertices),parentPos(:,1:3));
distVec = parentPos(:,1:3) - interface.vertices(closest,:);

%distance through dot product
dist = sum(normals(closest,:) .* distVec,2);
dist = abs(dist);

%pos = pos(dist <= lim);
closest = closest(dist<=lim);

for v = 1:numVerts
    % raw count of IE atoms per vertex
    parentCount(v) = sum(closest == v);
end


if DEBUG
    hist(dist,20);
end


Cmap = speciesCount./parentCount;


%% visualising the results
interface.facevertexcdata = Cmap;

f = figure('Name','Concentration map');
trisurf(interface.faces,interface.vertices(:,2),interface.vertices(:,1),interface.vertices(:,3),Cmap);
axis equal;
rotate3d on;
shading interp;
colorbar;

%% export to *.ply?
%property gets normalized

minC = min(Cmap);
maxC = max(Cmap);

limits = ['comment concentration map ranges: ' num2str(minC*100,3) 'pct to ' num2str(maxC*100,3) 'pct'];


CmapPly = Cmap - minC;
CmapPly = CmapPly/(maxC-minC);
CmapPly = CmapPly';

[file path] = uiputfile('*.ply','save quick conc map as ply','IEmap');

if file
    patch2ply(interface,[CmapPly, CmapPly, CmapPly],[path file], limits);
end


