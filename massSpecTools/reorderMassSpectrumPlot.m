function reorderMassSpectrumPlot(spec,order)
%rearranges the mass spectrum visiblity in the selected order
%order is a cell array of strings as below. right is bottom 

if ~exist('order','var')
    order = ["text","ion","range","massSpectrum","unknown"];
end


plots = spec.Parent.Children;

for pl = 1:length(plots)
    mcbegin(pl,:) = 0;
    try
        plotType(pl,:) = plots(pl).UserData.plotType;
        
        if any(plotType(pl) == ["range", "ion"])
            mcbegin(pl,:) = plots(pl).XData(1);
        end
        
    catch
        plotType(pl,:) = "unknown";
    end
end

% ordinal categorical array is used to sort
plotType = categorical(plotType,order,'Ordinal',true);
sortTable = table(plotType,mcbegin);

[~, idx] = sortrows(sortTable);

spec.Parent.Children = spec.Parent.Children(idx);