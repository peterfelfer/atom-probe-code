function [clusterIdx numClusters] = identifyClusters(clusterPos,volThreshORpos,vol,posDelaunay)

%% if no inpots are provided, read in the atomic positions from file
if ~exist('clusterPos','var')
    helpdlg('Choose *.pos file of atoms the cluster analysis should be performed on');
    clusterPos = readpos();
end

if ~exist('volThreshORpos','var')
    helpdlg('Choose parent *.pos file containing ALL atoms');
    volThreshORpos = readpos();
end

if ~exist('vol','var')
    vol = vertexVolume(clusterPos(:,1:3));
end


%% checking if the volume threshold is defined. If not, it is calculated
if length(volThreshORpos) == 1
    volThresh = volThreshORpos;
else
    [nc volThresh] = voronoiVolumeAnalysis(clusterPos,volThreshORpos);
end

clear volThreshORpos;




%% defining the clustered atoms and calculating the Delaunay triangulation
clusteredAtomsIndices = find(vol<=volThresh);

if~exist('posDelaunay','var')
    posDelaunay = delaunay(clusterPos(:,1:3));
end




%% determining in the delaunay triangulation which atoms are clustered
delAdjacency = delaunay2adjacencyMat(posDelaunay,clusteredAtomsIndices);
[numClusters clusterIdx] = graphconncomp(delAdjacency,'Directed',false);




end