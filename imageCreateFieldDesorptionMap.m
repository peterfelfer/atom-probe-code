function [FDM, ctr] = imageCreateFieldDesorptionMap(epos,resolution,plotAxis)
% imageCreateFieldDesorptionMap calculates field desorption map. resolution
% is the number of pixels across. Try use powers of 2. ctr are the bin 
% centers. If a plot axis is parsed, the image will be plotted (scaled 
% appropriately to data).
%
% INPUT
% epos:         table with spatial, chemical, and detector hit information
%               contains x- and y-coordinates of detector hit events (detx
%               and dety, respectively)
%
% resolution:   specification of number of pixels in x- and y-direction
%
% plotAxis:     if specified, the FDM will be plotted in the given figure
%
% OUTPUS
% FDM:          mxm matrix with hit values for each cell, depicting the 
%               field desorption map if plotted in figure
%
% ctr:          cell with two row vectors containing the bin centers
%
% NOTE:         For the creation of an element-specific FDM use the 
%               provided FDM workflow
%
% (c) by Prof. Peter Felfer Group @FAU Erlangen-Nürnberg

%% calculating bin centers for FDM
detx = epos.detx;
dety = epos.dety;
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
    axis equal;
end