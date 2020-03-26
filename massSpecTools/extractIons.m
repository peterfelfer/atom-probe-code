function ionTable = extractIons(spec)
% pulls all ions and corresponding information from a mass spectrum plot

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
    
    if type == "ion"
        ion{idx,:} = plots(pl).UserData.ion{1}.element; % do not extract isotope information
        chargeState(idx,:) = plots(pl).UserData.chargeState(1);
        ionName{idx,:} = convertIonName(plots(pl).UserData.ion{1}.element);
        color(idx,:) = plots(pl).Color;
        
        idx = idx + 1;
        
    end
    
end

ionName = categorical(ionName);
ionTable = table(ionName,chargeState,ion,color);
