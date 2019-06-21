% a script that produces reference data for a cluster search

% points are distributed randomly in a cubic volume, and all atoms closer
% than a set distance are labelled as solute according to a probability
% function. Default is linear.


volSize = 50; %nm
dens = 50; %at/nm3
clustDens = 10; %E5 clust/µm3
clustRad = 0.75; %nm
randBG = 0.01; % fraction of solute still in solution

% creating the randomly distributed atoms
pos = rand(volSize^3 * dens,3);
pos = pos * volSize;
pos(:,4) = ones(length(pos),1);

% creating the clusters
numClust = round((volSize/1000)^3 * clustDens * 1E5);
clustLoc = rand(numClust,3) * volSize;


% allocating the solute atoms
closest = dsearchn(clustLoc,pos(:,1:3));
distVec = pos(:,1:3) - clustLoc(closest,:);
dist = sqrt(sum(distVec.^2,2));

prob = 1 - dist./clustRad;
dice = rand(length(pos),1);

pos(~(dice > prob),4) = 2;
pos(randsample(length(pos),round(length(pos)*randBG)),4) = 2;

% display result
sol = pos(pos(:,4) == 2,:);
scatter3(sol(:,1),sol(:,2),sol(:,3),'.'); axis equal; rotate3d on;