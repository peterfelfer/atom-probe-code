function [proxi, binvector] = kwikProxigram(pos,parentPos,interface,bin,vertexIndices)
% calculates a proxigram for the patch 'interface' for the atoms in 'pos',
% which are a subset of the atoms in 'parentPos' with a binwidth of bin.


% distances are calculated along vertex normals.
normals = patchnormals(interface);


%% tessellation and distance calculation
% for overall pos file
% finding closest point for each atomic position
closest = dsearchn(interface.vertices,delaunayn(interface.vertices),parentPos(:,1:3));
distVec = parentPos(:,1:3) - interface.vertices(closest,:);
%distance through dot product
dist = sum(normals(closest,:) .* distVec,2);


% calculating bin centers
binvector = linspace(0,10000*bin,10001);
binvector = [fliplr(uminus(binvector(2:end))) binvector];
binvector(binvector<min(dist) | binvector>max(dist)) = [];

% number of atoms per bin
posHist = hist(dist,binvector);


%% for element pos files
closestS = dsearchn(interface.vertices,delaunayn(interface.vertices),pos(:,1:3));
distVecS = pos(:,1:3) - interface.vertices(closestS,:);
%distance through dot product
distS = sum(normals(closestS,:) .* distVecS,2);

% number of atoms per bin
proxi = hist(distS,binvector)./posHist;


%% plotting
f = figure;
hold all;

plot(binvector,proxi*100);
set(gcf,'Name','proximity histogram');
set(gcf,'Color',[1 1 1]);
set(get(gca,'XLabel'),'String','distance [nm]');
set(get(gca,'YLabel'),'String','concentration [%]');

end

















