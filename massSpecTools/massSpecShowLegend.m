function massSpecShowLegend(spec,items)
% shows the legend of a mass spectrum plot, with only selected items as
% shown in the default below
%
% massSpecShowLegend (spec)
%
% INPUTS
% spec:     spec is the name of the areaplot that contains the
%           massspectrum, area.
%
% OUTPUTS
%           Shows the legend of the ranged ions in the massspectrum.
%           Unknown ions will not be shown in the legend.

if ~exist('items','var')
    items = ["ion", "unknown"]; % "ion" "text" "massSpectrum" "range"
end

% get plot type
plots = spec.Parent.Children;
for pl = 1:length(plots)
    try
        plotType(pl,:) = plots(pl).UserData.plotType;
    catch
        plotType(pl,:) = "unknown";
    end
end

% determine which one is a selected item
isLegend = any(plotType == items,2);

legend(plots(isLegend));
    