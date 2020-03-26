function showMassSpecLegend(spec,items)
%shows the legend of a mass spectrum plot, with only selected items as
%shown in the default below

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
    