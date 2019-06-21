function [pass, Nmin, clusterCutoff, clusteredAtoms] = clusterDetermination(clusterPos,pos,Nmin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
NBINS = 100;

if exist('Nmin','var')
    NminTmp = Nmin;
end


figName = [];

%% actual Voronoi cluster analysis
figure;
figName = ['Voronoi volume analysis of ' figName];

[numClustered, clusterCutoff, experimental,random, experimentalVolumes, randomVolumes, randPos] = ...
    voronoiVolumeAnalysis(clusterPos, pos,true);

figure;
%% analysis of cluster sizes
% experimental
[clusterIdx, numClusters] = identifyClusters(clusterPos,clusterCutoff,experimentalVolumes);

% random
[randomClusterIdx, randomNumClusters] = identifyClusters(randPos, clusterCutoff, randomVolumes);

clusterSizes = hist(clusterIdx, numClusters);
randomClusterSizes = hist(randomClusterIdx, randomNumClusters);
Nmin = analyzeClusterSizes(clusterSizes, randomClusterSizes)

if exist('NminTmp','var')
    disp('Nmin override');
    Nmin = NminTmp;
end

%% Kolmogorov - Smirnov test:
significanceLimit = 1.92 / sqrt(length(clusterPos(:,1)));

pass = (numClustered/length(clusterPos(:,1))) > significanceLimit

clusterPct = (numClustered/length(clusterPos(:,1))) * 100
significanceLimit

%% identifying clustered atoms
significantClusterIdx = find(clusterSizes >= Nmin);

% actually creating the atomic positions
isClustered = ismember(clusterIdx,significantClusterIdx);
clusteredAtoms = [clusterPos(isClustered,:), clusterIdx(isClustered)'];


end

