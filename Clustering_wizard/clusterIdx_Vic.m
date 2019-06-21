
% start this script in the Voronoi volume analysis folder!
% the cluster index of each atom (number of cluster it belongs to can be
% found in handles.clusterIdx. handles.isClustered is a logical variable
% showing which atoms are in clusters > Nmin. handles.significantClusterIdx
% is the indices of the clusters > Nmin

addpath('resources')
addpath('pos_tools')
addpath('xml_tools')


%% loading of data (can be replaced by variables from the workspace)
handles.pos = readpos; %entire posfile
handles.clusterPos = readpos; %posfile of cluster atoms

NBINS = 100;


%% actual Voronoi cluster analysis

figName = 'Voronoi volume analysis';
handles.voronoiFigureHandle = figure('Name',figName);


[handles.numClustered handles.clusterCutoff handles.experimental handles.random handles.experimentalVolumes handles.randomVolumes randPos] = ...
    voronoiVolumeAnalysis(handles.clusterPos, handles.pos,true);


%% analysis of cluster sizes
% experimental
[handles.clusterIdx handles.numClusters] = identifyClusters(handles.clusterPos,handles.clusterCutoff,handles.experimentalVolumes);

% random
[handles.randomClusterIdx handles.randomNumClusters] = identifyClusters(randPos,handles.clusterCutoff,handles.randomVolumes);



handles.clusterSizes = hist(handles.clusterIdx, handles.numClusters);
handles.randomClusterSizes = hist(handles.randomClusterIdx, handles.randomNumClusters);



handles.clusterSizeFigureHandle = figure('Name',['size distribution of ' figName ' clusters']);
Nmin = analyzeClusterSizes(handles.clusterSizes, handles.randomClusterSizes);
handles.Nmin = num2str(Nmin);



%% Kolmogorov - Smirnov test:
significanceLimit = 1.92 / sqrt(length(handles.clusterPos(:,1)));

pass = (handles.numClustered/length(handles.clusterPos(:,1))) > significanceLimit;


%% analysis of cluster sizes
% experimental
[handles.clusterIdx handles.numClusters] = identifyClusters(handles.clusterPos,handles.clusterCutoff,handles.experimentalVolumes);

% random
[handles.randomClusterIdx handles.randomNumClusters] = identifyClusters(randPos,handles.clusterCutoff,handles.randomVolumes);



handles.clusterSizes = hist(handles.clusterIdx, handles.numClusters);
handles.randomClusterSizes = hist(handles.randomClusterIdx, handles.randomNumClusters);



handles.clusterSizeFigureHandle = figure('Name',['size distribution of ' figName ' clusters']);
Nmin = analyzeClusterSizes(handles.clusterSizes, handles.randomClusterSizes);
handles.Nmin = num2str(Nmin);



%% Kolmogorov - Smirnov test:
significanceLimit = 1.92 / sqrt(length(handles.clusterPos(:,1)));

pass = (handles.numClustered/length(handles.clusterPos(:,1))) > significanceLimit;








%% finding the clusters that are significant

Nmin = handles.Nmin;
% create the posfile for export
%keywords: max N1 (only export largest clusters) N1 - N2 (range) - N2 (up to N2)

% cluster sizes:
clusterSizes = handles.clusterSizes;
clusterIdx = handles.clusterIdx;




% only use Nmin
Nmin = str2num(Nmin);

significantClusterIdx = find(clusterSizes >= Nmin);


% actually creating the atomic positions
handles.isClustered = ismember(clusterIdx,significantClusterIdx);

handles.significantClusterIdx = significantClusterIdx;


