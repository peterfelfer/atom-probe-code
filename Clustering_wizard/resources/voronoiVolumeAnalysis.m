function [numClustered clusterCutoff experimental random experimentalVolumes randomVolumes randpos] = voronoiVolumeAnalysis(clusterPos, pos,vis,Vmax,bins)

addpath('pos_tools');

if ~exist('bins','var')
    bins = 50;
end

if ~exist('pos','var')
    [file path] = uigetfile('*.pos','choose pos file of clustered atoms');
    clusterPos = readpos([path file]);
    disp(['to be cluster tested: ' file])
    
    [file path] = uigetfile('*.pos','choose posfile the clustering is a subset of',path);
    pos = readpos([path file]);
    disp(['entire dataset: ' file]);
end


%% calculating the volume of the Voronoi cell of each atom
vol = vertexVolume(double(clusterPos(:,1:3)));

%calculating the volume of the Voronoi cells of a random sample of atoms
randpos = pos(randsample(length(pos),length(clusterPos)),1:3);
randVol = vertexVolume(double(randpos));

%% determine maximum volume to plot to
if ~exist('Vmax','var')
    VmaxE = median(vol);
    VmaxR = median(randVol);
    
    Vmax = max(VmaxE,VmaxR) * 3;
end


volHis = hist(vol(vol<Vmax),bins);
volHisRand = hist(randVol(randVol<Vmax),bins);
emr = volHis - volHisRand;
cs = cumsum(emr);



%% determining the clustering parameters
numClustered = max(cs);
mx = find(cs == numClustered,1);

x = linspace(0,Vmax,bins);
clusterCutoff = x(mx);




% creating an array where experimental and random are ordered by volume and
% experimental volumes are +1 and random ones are -1. The maximum of the
% integral (cumulative sum) is the number of clustered atoms (or ordered
% atoms). The volume of the atom ath the maximum is the cluster cutoff.
%{
allVols = [vol; randVol];
isRand  = [ones(length(vol),1); ones(length(randVol),1)*(-1)];

[sortedVols idx] = sort(allVols);
isRand = isRand(idx);

cumulative = cumsum(isRand);
numClustered = median(max(cumulative))
maxIdx = find(cumulative == numClustered,1);
clusterCutoff = sortedVols(maxIdx)
%}

%% plotting
if exist('vis','var')
    %plotting results

    plot(x,volHis,'LineWidth',2,'DisplayName','experimental','XDataSource','x','YDataSource','volHis');
    hold on;
    plot(x,volHisRand,'g','LineWidth',2,'DisplayName','random','XDataSource','x','YDataSource','volHisRand');
    
    %experimental - random
    
    hold on;
    plot(x,emr,'r','LineWidth',2,'DisplayName','experimental - random','XDataSource','x','YDataSource','emr');
    
    legend('experimental','random','experimental - random');
    
    
    xlabel('Voronoi volume of atom [nm3]');
    ylabel('frequency [cts]');
    %set(gca,'XLabel','Voronoi volume of atom [nm3]','YLabel','frequency [cts]');
    set(gca,'YGrid','on');
    set(gcf,'Color','w');
    %clstTxt = ['clustering level: ' num2str(numClustered/length(clusterPos)*100,3) '%'];
    %text(0,0,clstTxt);
end



%% calculating the amount of solute that is clustered above random (integral of experimental - random until first zero). This is the maximum of the integral (cumsum) of exp-rand.
%this is assuming unimodal clustering





%% set outputs
experimental = volHis;
random = volHisRand;
experimentalVolumes = vol;
randomVolumes = randVol;
end
