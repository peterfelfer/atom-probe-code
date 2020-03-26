function rangeTable = extractRanges(spec)
% pulls all ranges and additional information from a mass spectrum plot

% get all plots connected to the mass spectrum
plots = spec.Parent.Children;

idx = 1;
for pl = 1:length(plots)
    
    % find all the ones that are ranges
    try
        type = plots(pl).UserData.plotType;
    catch
        type = "unknown";
    end
    
    if type == "range"
        mcbegin(idx,:) = plots(pl).XData(1);
        mcend(idx,:) = plots(pl).XData(end);
        rangeName{idx,:} = convertIonName(plots(pl).UserData.ion.element);
        volume(idx,:) = 0;
        ion{idx,:} = plots(pl).UserData.ion;
        color(idx,:) = plots(pl).FaceColor;
        chargeState(idx,:) = plots(pl).UserData.chargeState;
        
        
        idx = idx +1;
    end
    
end

rangeName = categorical(rangeName);
rangeTable = table(rangeName,chargeState,mcbegin,mcend,volume,ion,color);
rangeTable = sortrows(rangeTable,'mcbegin','ascend');