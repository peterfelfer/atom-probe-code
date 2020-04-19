%implement checking for duplicate ions

function h = addIon(spec,ion,chargeStates,isotopeTable,colorScheme,sumMargin,minAbundance,maxHeight,maxSeparation)
%creates a stem plot of the relative abundance of an ion for the charge
%states given in te axis ax. maxHeight is the height of the most abundant
%isotope (counts or relative frequency); il is the handle to the stem plot.
%the parsed iostopeTable is the basis of the relative abundances. sumMargin
%specifies a Margin within which two peaks will be summed up. maxSeparation
%is used when peak detection is used (maxHeight = 'most abundant' or 'least
%squares'). Tme maximum of the mass spectrum within this range will be used
%for scaling.
%
% the stem line will be according to charge state!
%
% ion can be a scalar string or a string array. If ion is a string array,
% chargeStates can be a scalar, a vector of chargeStates for all ions (e.g.
% [1 2 3]) or a vector with the same number of entries as the ion list
%
%maxheight will default to the YScale of the plotaxis by default. If a
%numeric value is given, this value will be used. For specific scaling, use
%'select'. This will use a graphical input to select a peak, to which the
%nearest isotopic combination will be scaled.
%
%THE FOLLOWING WILL BE STORED IN THE USER DATA SECTION OF THE PLOT:
%plotType = 'ion'
%isotopicCombinations: list of peaks vs. nucleides in the ion and
%chargestate

if isstring(ion)
    ion = char(ion);
end

ax = spec.Parent;

%% get individual isotopic combinations
[ionType, abundance, weight] = ionsCreateIsotopeList(ion, isotopeTable);


%% cluster Peaks together if Peaks if sumMargin > 0
% if peaks are summed up, the dominant peak will be taken!
if (sumMargin > 0) & (length(abundance) > 1)
    [ionType, abundance, weight] = ionsMergePeaks(ionType, abundance, weight, sumMargin);
end


%% eliminate peaks that are below minAbundance
weight(abundance <= minAbundance) = [];
ionType(abundance <= minAbundance) = [];
abundance(abundance <= minAbundance) = [];


%% create charge states
plotWeight = [];
plotAbundance = [];
ionTypeCS = [];
ionCS = [];
for cs = 1:length(chargeStates)
    plotWeight = [plotWeight, weight/chargeStates(cs)];
    plotAbundance = [plotAbundance, abundance];
    ionTypeCS = [ionTypeCS ionType];
    ionCS = [ionCS repmat(chargeStates(cs), 1, length(abundance))];
end


%% normalise height
if ~exist('maxHeight','var')
    % default is to height of current axis scaling
    maxPeak = max(abundance);
    maxDisp = ax.YLim(2);
    plotAbundance = plotAbundance * maxDisp / maxPeak;
elseif isnumeric('minHeight')
    warning('not implemented yet');
    
else
    if strcmp(maxHeight,'selection')
        % selection of individual peak
        rect = getrect(ax);
        mcbegin = rect(1);
        mcend = rect(1) + rect(3);
        xdata = spec.XData;
        ydata = spec.YData;
        
        maxDisp = max(ydata(xdata > mcbegin & xdata < mcend));
        peak = max(plotAbundance((plotWeight > mcbegin) & (plotWeight < mcend)));
        
        if isempty(peak)
            error('peak not within selected range');
        end
        
        plotAbundance = plotAbundance * maxDisp / peak;
    elseif strcmp(maxHeight,'most abundant')
        % adjusts the height of the most abundant peak to the closest peak in the mass
        % spectrum
        mostAbundant = find(plotAbundance == max(plotAbundance)); % if multiple chargestates are present, there are as many max height peaks as charge states
        mostAbundant = mostAbundant(1);
        peak = plotAbundance(mostAbundant);
        
        mi = plotWeight(mostAbundant) - maxSeparation;
        mx = plotWeight(mostAbundant) + maxSeparation;
        
        inRange = spec.XData > mi & spec.XData < mx;
        maxDisp = max(spec.YData(inRange));
        
        
        plotAbundance = plotAbundance * maxDisp / peak;
        
    elseif strcmp(maxHeight,'least squares')
        % adjusts the heights of the height of the peaks to least squares
        % match the peaks in the mass spectrum. Peaks that are close to
        % other assigned peaks are not used.
        error('least squares fitting not implemented yet');
    end
    
end



%% plot
h = ionStemPlot(ax, plotWeight, plotAbundance, ionTypeCS, chargeStates, colorScheme);


