function addIonLabel(elements, complexFormers, chargestate, complex, thresh)
% Adds labels for a specific ion to the currently active mass spectrum plot.

addpath('resources');

span = 2; %Da (span in which peaks are searched for)


%% get inputs
maxComplex = complex;
baseElements = elements;
%complexFormers = 'same';
chargeStates = chargestate;
abundanceThreshold = thresh;

ionList = createIonList(baseElements,chargeStates,maxComplex,complexFormers,abundanceThreshold);



mc = getrect(gca);
mcbegin = mc(1);
mcend = mc(1)+mc(3);

% find highest peak within that range


handles = get(gca,'Children');

bins = get(handles(end),'Xdata');
hist = get(handles(end),'Ydata');

interval = bins>=mcbegin & bins<=mcend;
tempHist = hist .* interval;
maxIdx = median(find(tempHist == max(tempHist)));
mcMax = bins(maxIdx);


%% open Dialogue with ion suggestions
suggestFigure = figure;
set(suggestFigure,'Color',[1 1 1]);
suggestAxes = axes;
set(suggestAxes,'YScale','log','XLim',[mcMax-span mcMax+span],'YLim',[1 max(tempHist)*2]);
hold on;
massSpec = plot(bins,hist);
suggestedIonPlot = stem(ionList.massToCharge, ones(length(ionList.massToCharge))*max(tempHist));

for ion = 1 : length(ionList.massToCharge)
    currName = ionName(ionList.ionSpecies{ion});
    for cs = 1:ionList.chargeState(ion)
        currName = [currName '+'];
    end
    
    
    ionNames{ion} = currName;
    ionNamesDist{ion} = [currName '  ' num2str(ionList.massToCharge(ion)-mcMax,2) '  ' num2str(ionList.relativeAbundance(ion),3)];
    dist(ion) = ionList.massToCharge(ion)-mcMax;
    
    text(ionList.massToCharge(ion), max(tempHist) * 1.1, currName , 'HorizontalAlignment', 'left','Rotation',75);
end


idxIn = (ionList.massToCharge>=(mcMax-span)) & (ionList.massToCharge<=(mcMax+span));
ionNamesIn = ionNames(idxIn);
ionNamesDistIn = ionNamesDist(idxIn);
dist = dist(idxIn);

if isempty(ionNamesDistIn)
    disp('no matching ions found in vicinity of peak');
    close(suggestFigure);
    return
end

dist = abs(dist);
initialSelection = floor(median(find(dist == min(dist))));
[selection ok] = listdlg('ListString',ionNamesDistIn,'SelectionMode','single','Name','choose ion','InitialValue',initialSelection);

if ~ok
    close(suggestFigure);
    return
    
end
close(suggestFigure);
%selected ion will be displayed with relative abundances in main axis

selectedIon = find(idxIn);
selectedIon = selectedIon(selection);


% find identical ions with same chargestate
sameIonsIdx = (ionList.ionID == ionList.ionID(selectedIon)) & (ionList.chargeState == ionList.chargeState(selectedIon));

% mark in main axis

sameIonsMC = ionList.massToCharge(sameIonsIdx);
sameIonsNames = ionNames(sameIonsIdx);
scalingFactor = max(tempHist)/ionList.relativeAbundance(selectedIon);

sameIonsAbundance = ionList.relativeAbundance(sameIonsIdx)*scalingFactor;


hold on
currPlot = stem(gca,sameIonsMC,sameIonsAbundance,'r','fill','LineWidth',2);
for ion = 1 : length(sameIonsMC)
   txt(ion) = text(sameIonsMC(ion), sameIonsAbundance(ion) * 1.1, ['   ' sameIonsNames{ion}], 'HorizontalAlignment', 'left','Rotation',75);
end

typeName = '';
for i = 1: length(ionList.ionSpecies{selectedIon}(:,1))
    typeName = [typeName sym4number(ionList.ionSpecies{selectedIon}(i,1))];
end

for cs = 1:ionList.chargeState(selectedIon)
    typeName = [typeName '+'];
end

end