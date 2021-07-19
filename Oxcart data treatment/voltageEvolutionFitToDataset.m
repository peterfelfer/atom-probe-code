function [VDC, VP] = voltageEvolutionFitToDataset(V,det,fitPoints)
%fits the recorded voltage curve of an APT experiment to the recorded data.
%To enable this, a n by 2 matrix of points equvalent between the Hit
%dataste and the voltage curve are required. First column: recorded voltage
%vurve, second column: recorded Hit dataset

hitIdx = (1:height(det))';

newIdx = interp1(fitPoints(:,2),fitPoints(:,1),hitIdx,'linear','extrap');

% cts are truncated upon labView Export. Need to remove duplicates
[~, idx] = unique(V.cts,'stable');
V = V(idx,:);

VDC = interp1(V.cts,V.VDC,newIdx,'linear','extrap');
VP = interp1(V.cts,V.VP,newIdx,'linear','extrap');