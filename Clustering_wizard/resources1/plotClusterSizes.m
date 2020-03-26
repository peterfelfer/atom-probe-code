function plothandle = plotClusterSizes(clusterSizes)

%plotting the cluster sizes as a histogram
% the y axis is the 'concentration' the occurences. This is the invertse of
% the 1d voronoi tessellation of the occurences, or N for N occurences
% of the same value.


clusterSizes = sort(clusterSizes);

uniqueSizes = unique(clusterSizes);

for idx = 1:length(uniqueSizes)
    multiplicity(idx) = sum(clusterSizes == uniqueSizes(idx));
    
    
    
end


dist = uniqueSizes(2:end) - uniqueSizes(1:end-1);

domainSize = [dist(1) (dist(1:end-1)+dist(2:end))/2 dist(end)];

y = multiplicity./domainSize;

plothandle = plot(uniqueSizes(2:end),y(2:end),'-k','LineWidth',2,'Marker','o');

set(gca,'YScale','log');
set(gcf,'Color','w');

legend('cluster size distribution');
xlabel('cluster size [atoms]');
ylabel('frequency [cts]');

