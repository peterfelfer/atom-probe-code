function [h, txt] = addRange(spec,colorScheme)
%adds a range to a spectrum using graphical input
%output is the handle to the area plot and the corresponding text

% set current axes
ax = spec.Parent;
axes(ax);

% user input
lim = ginput(2);
lim = lim(:,1);
lim = sort(lim);


isIn = (spec.XData > lim(1)) & (spec.XData < lim(2));
h = area(spec.XData(isIn),spec.YData(isIn));
h.FaceColor = [1 1 1];
h.UserData.plotType = "range";


%% search for ions in mass spectrum plot
plots = ax.Children;
isIon = false(length(plots),1);
for pl = 1:length(plots)
    try
        isIon(pl) = strcmp(plots(pl).UserData.plotType,"ion");
    end
end
ionPlots = plots(isIon);

% find ions in range (if there are any)
potentialIon = {};
potentialIonChargeState = [];
potentialIonPeakHeight = [];
if ~isempty(ionPlots)
    for pl = 1:length(ionPlots)
        isIn = (ionPlots(pl).XData > lim(1)) & (ionPlots(pl).XData < lim(2));
        if any(isIn)
            potentialIon{end+1} = ionPlots(pl).UserData.ion{isIn};
            potentialIonChargeState(end+1) = ionPlots(pl).UserData.chargeState(isIn);
            potentialIonPeakHeight(end+1) = ionPlots(pl).YData(isIn);
        end
    end
    
end


%select which ion it is if necessary

    % manual input
if isempty(potentialIon) 
    txt = inputdlg('manually enter range name','ion selection');
    [ion, chargeState] = convertIonName(txt{1});
    h.UserData.ion = ion;
    h.UserData.chargeState = chargeState;
    h.DisplayName = convertIonName(h.UserData.ion,h.UserData.chargeState);
    h.FaceColor = colorScheme.color(colorScheme.ion == convertIonName(h.UserData.ion.element),:);
    
    
    % clear choice
elseif length(potentialIon) == 1
    h.UserData.ion = potentialIon{1};
    h.UserData.chargeState = potentialIonChargeState(1);
    h.DisplayName = convertIonName(h.UserData.ion,h.UserData.chargeState);
    h.FaceColor = colorScheme.color(colorScheme.ion == convertIonName(h.UserData.ion.element),:);
    
       
else % selection
    numPotIon = length(potentialIon);
    for i = 1:numPotIon
        names{i} = [convertIonName(potentialIon{i}, potentialIonChargeState(1)) '   ' num2str(potentialIonPeakHeight(i))];
    end
    % select the ion, defaulting to most abundant.
    [idx, ~] = listdlg('ListString',names,'PromptString','Select ion species','SelectionMode','single',...
        'InitialValue',find(potentialIonPeakHeight == max(potentialIonPeakHeight)));
    
    h.UserData.ion = potentialIon{idx};
    h.UserData.chargeState = potentialIonChargeState(idx);
    h.DisplayName = convertIonName(h.UserData.ion,h.UserData.chargeState);
    h.FaceColor = colorScheme.color(colorScheme.ion == h.UserData.ion.element(1),:);%XXXXXfix
end

% define for all hit multiplicities
h.UserData.hitMultiplicities = [0 Inf];

% add text to denote range
txt = text(h.XData(1),max(h.YData)*1.4,convertIonName(h.UserData.ion,h.UserData.chargeState,'LaTeX'),'clipping','on');
txt.UserData.plotType = "text";

