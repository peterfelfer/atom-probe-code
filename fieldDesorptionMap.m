function [FDM, ctr] = fieldDesorptionMap(detx,dety,resolution,plotAxis)
% calculates field desorption map. resolution is the number of pixels
% across. Try use powers of 2. ctr are the bin centers. 
% if a plot axis is parsed, the image will be plotted (scaled appropriately to data)

%% calculating bin centers for FDM

mi = min(min(detx),min(dety));
mx = max(max(detx),max(dety));


ctr{1} = linspace(mi,mx,resolution);
ctr{2} = ctr{1};

FDM = hist3([detx, dety],ctr);

if exist('plotAxis','var')
    axes(plotAxis);
    hold on;
    x = [mi mx];
    imagesc(plotAxis,x,x,FDM);
end