function handles = markPeaks(spec,minSeparation,minHeight)
% puts a stem plot on each peak in a mass spectrum for selection
% the output is an array of handles to the plots.

x = spec.XData;
y = spec.YData;

[pks,locs] = findpeaks(y,x,'MinPeakDistance',minSeparation,'MinPeakHeight',minHeight);

for i = 1:length(pks)
    handles(i) = stem(locs(i),pks(i));
end