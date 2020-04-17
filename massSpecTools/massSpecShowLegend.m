function massSpecShowLegend(spec,items)
<<<<<<< Updated upstream
% shows the legend of a mass spectrum plot, with only selected items as
% shown below, order of items is editable.
%
% massSpecShowLegend (spec)
% massSpecShowLegend (spec,items)
%
% INPUTS
% spec:     spec is the name of the areaplot that contains the
%           massspectrum, area.
% items:    set what kind of information is writen in the legend
%           "ion" gives back the type of ion, e.g. all Fe-peaks are one Fe
%           ion.
%           "range" gives back one entry for every range, e.g. every
%           Fe-peak has its one entry.
=======
% shows the legend of a mass spectrum plot, with selected item in focus. 
% Unknown ions will not be shown in the legend.
%
% massSpecShowLegend (spec)
% massSpecShowLegend (spec,"item1")
% massSpecShowLegend (spec,["item1","item2"])
%
% INPUTS
% spec:     spec is the name of the areaplot that contains the
%           mass spectrum, area.
% items:    defines which information is written down in the legend
%           "ion": List of elements by type
%           "range": Distribution of the elements on their isotopes
%           "massSpectrum": only the grey mass spectrum is listed in the
%           legend
>>>>>>> Stashed changes
%           default item is "ion"
%
% OUTPUTS
%           Shows the legend of the ranged ions in the mass spectrum.
%           

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
    