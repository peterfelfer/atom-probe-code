function h = addIon(spec,ionIn,chargeStatesIn,isotopeTable,colorScheme,sumMargin,minAbundance,maxHeight,maxSeparation)
%creates a stem plot of the relative abundance of an ion for the charge
%states given in te axis ax. maxHeight is the height of the most abundant
%isotope (counts or relative frequency); il is the handle to the stem plot.
%the parsed iostopeTable is the basis of the relative abundances. sumMargin
%specifies a Margin within which two peaks will be summed up. maxSeparation
%is used when peak detection is used (maxHeight = 'most abundant' or 'least
%squares'). Tme maximum of the mass spectrum within this range will be used
%for scaling.

% ion can be a scalar string or a string array. If ion is a string array,
% chargeStates can be a scalar, a vector of chargeStates for all ions (e.g.
% [1 2 3]) or a vector with the same number of entries as the ion list

%maxheight will default to the YScale of the plotaxis by default. If a
%numeric value is given, this value will be used. For specific scaling, use
%'select'. This will use a graphical input to select a peak, to which the
%nearest isotopic combination will be scaled.

%THE FOLLOWING WILL BE STORED IN THE USER DATA SECTION OF THE PLOT:
%plotType = 'ion'
%isotopicCombinations: list of peaks vs. nucleides in the ion and
%chargestate

% convert if ionIn is a categorical
if iscategorical(ionIn)
    ionIn = string(ionIn);
end

numIon = 1;
if isstring(ionIn)
    numIon = length(ionIn);
    if length(ionIn) > 1
        if length(chargeStatesIn) == 1
            chargeStatesIn = repmat(chargeStatesIn,numIon,1); % multiple ions with same chargeState
        elseif ~(length(chargeStatesIn) == length(ionIn))
            chargeStatesIn = repmat(chargeStatesIn,numIon,1); % multiple charge states for each ion
        end
    end
else
    ionIn = string(ionIn);
end

ax = spec.Parent;

for ionIdx = 1:numIon
    
    ionIdx
    %% extract individual ions from list if applicable
    ion = ionIn(ionIdx);
    ion = char(ion);
    chargeStates = chargeStatesIn(ionIdx,:);
    
    
    %% interpret ion name into a table [element count]
    %{
    parts = strsplit(ion);
    numElements = length(parts);
    
    for el = 1:numElements
        element{el} = parts{el}(isstrprop(parts{el},'alpha'));
        if ~sum(isstrprop(parts{el},'digit'))
            count(el) = 1;
        else
            count(el) = str2num(parts{el}(isstrprop(parts{el},'digit')));
        end
    end
    element = categorical(element')
    count = count'
    atomList = table(element,count);
    %}
    ionTable = convertIonName(ion);
    [count, element] = histcounts(ionTable.element);
    count = count';
    numElements = length(count);
    element = categorical(element');
    atomList = table(element, count);
    
    %% create individual isotopic abundances
    
    % create seperate isotope combination lists for each element
    for el = 1:numElements
        isos = isotopeTable(isotopeTable.element == atomList.element(el),:);
        isoList{el} = isos.isotope(nreplacek(height(isos),atomList.count(el)));
        idx{el} = 1:length(isoList{el}(:,1)); %used later for indexing into ion List
    end
    % get combinations of elemental ion combinations
    grid = cell(1,numel(idx));
    [grid{:}] = ndgrid(idx{:});
    combos = reshape(cat(numElements+1,grid{:}), [], numElements);
    numCombos = length(combos(:,1));
    
    % calculate relative abundances and weights
    for c = 1:numCombos
        weight(c) = 0;
        abundance(c) = 1;
        ionType{c} = table("",[0],'VariableNames',{'element','isotope'});
        nucCount = 0;
        for el = 1:numElements
            isos = isoList{el}(combos(c,el),:);
            for iso = 1:length(isos)
                nucCount = nucCount + 1;
                weight(c) = weight(c) + isotopeTable.weight((isotopeTable.element == atomList.element(el)) & (isotopeTable.isotope == isos(iso)));
                abundance(c) = abundance(c) * isotopeTable.abundance((isotopeTable.element == atomList.element(el)) & (isotopeTable.isotope == isos(iso))) /100;
                warning('off');
                ionType{c}.element(nucCount) = char(atomList.element(el));
                ionType{c}.isotope(nucCount) = isos(iso);
            end
        end
        ionType{c}.element = categorical(ionType{c}.element);
        ionType{c}.isotope = categorical(ionType{c}.isotope);
    end
    
    abundance = abundance/sum(abundance); % normalize. Abundances wont sum up exactly to 1
    
    
    %% sum Peaks if sumMargin > 0
    if (sumMargin > 0) & (length(abundance) > 1)
        
        % sort by molecular weight
        [weight, sortIdx] = sort(weight);
        abundance = abundance(sortIdx);
        ionType = ionType(sortIdx);
        
        % determine which peaks are closer than a margin and group them in
        % clusters
        diffs = weight(2:end) - weight(1:end-1);
        isClose = diffs < sumMargin;
        
        peakCluster = 1;
        peakClusterIdx(1) = peakCluster;
        for i = 1:numCombos-1
            if isClose(i)
                peakClusterIdx(i+1) = peakCluster;
            else
                peakCluster = peakCluster + 1;
                peakClusterIdx(i+1) = peakCluster;
            end
        end
        
        %merge individual peaks
        for i = 1:peakCluster
            weightTmp(i) = mean(weight(peakClusterIdx == i));
            abundanceTmp(i) = sum(abundance(peakClusterIdx == i));
            % ion type will be taken from the most abundant ion in the cluster
            ionTypePkClust = ionType(peakClusterIdx == i);
            ionTypeTmp{i} = ionTypePkClust{abundance(peakClusterIdx == i) == max(abundance(peakClusterIdx == i))};
        end
        weight = weightTmp;
        abundance = abundanceTmp;
        ionType = ionTypeTmp;
    end
    
    
    
    
    
    %% eliminate peaks that are blow minAbundance
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
    
    
    
    
    %% create table with nucleides for each peak
    % if peaks are summed up, the dominant peak will be taken!
    
    
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
    h = stem(ax,plotWeight, plotAbundance);
    try
        h.Color = colorScheme.color(colorScheme.ion == ion,:);
    catch
        warning('ion color undefined');
    end
    
    if length(chargeStates) == 1
        h.DisplayName = [ion repmat('+',1,chargeStates)];
    else
        h.DisplayName = ion;
    end
    h.LineWidth = 2;
    h.UserData.plotType = "ion";
    h.UserData.ion = ionTypeCS;
    h.UserData.chargeState = ionCS;
    
    %change stem line depending on chargesate if only one charge state is given
    if length(chargeStates) == 1
        switch chargeStates
            case 1
                h.LineStyle = '--';
            case 2
                h.LineStyle = ':';
            case 3
                h.LineStyle = '-.';
            case 4
                h.LineStyle = '-';
                
        end
    end
    
    clearvars('element');
    
end
