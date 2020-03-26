function varargout = convertIonName(varargin)
%converts an ion name to a table variable and reverse
%formats:

%name:
% (isotope element count) x N chargestate e.g.   '56Fe2 16O3 ++'
% (element count) x N chargestate                'Fe2 O3 ++'
% (element count) x N                            'Fe2 O3'
% individual nucleides will be sorted by atomic number descending e.g. 'O H2'
% use:
% ionTable = convertIonName(ionName);
% [ionTable chargeState] = convertIonName(ionName);

%table:
% element isotope x N
% use:
% ionName = convertIonName(ionTable,chargeState,format);
% ionName = convertIonName(ionTable,chargeState);
% ionName = convertIonName(ionTable,NaN,format);
% ionName = convertIonName(ionTable);
% format can be 'plain' or 'LaTeX'

%categorical;
% ionName = convertIonName(ionCategorical,chargeState,format);
% ionName = convertIonName(ionCategorical,chargeState);
% ionName = convertIonName(ionCategorical)
% format can be 'plain' or 'LaTeX'

%% conversion from table to name
if istable(varargin{1})
    ionTable = varargin{1};
    if nargin == 3
        format = varargin{3};
    else
        format = 'plain';
    end
    
    % add atomic number to table
    numAtom = height(ionTable);
    for at = 1:numAtom
        atomicNumber(at) = number4sym(char(ionTable.element(at)));
    end
    ionTable = addvars(ionTable, atomicNumber','NewVariableNames','atomicNumber');
    
    % sort by atomic number descending
    ionTable = sortrows(ionTable,{'atomicNumber','isotope'},{'descend','descend'},'MissingPlacement','first');
    
    % get multiplicity of atom occurances in ion and write out names
    ionName = [];
    
    
    isotopeGroup = sortedFindgroups(ionTable);
    for i = 1:max(isotopeGroup)
        idx = find(isotopeGroup == i,1);
        if strcmp(format,'LaTeX')
            ionName = [ionName '^{' char(ionTable.isotope(idx)) '}' char(ionTable.element(idx))];
        else
            ionName = [ionName ' ' char(ionTable.isotope(idx)) char(ionTable.element(idx))];
        end
        
        if sum(isotopeGroup == i) > 1
            if strcmp(format,'LaTeX')
                ionName = [ionName '_{' num2str(sum(isotopeGroup == i)) '}'];
            else
                ionName = [ionName num2str(sum(isotopeGroup == i))];
            end
        end
    end
    
    % add + (or -) for chargestates
    if nargin > 1
        chargeState = varargin{2};
        if ~isnan(chargeState) %NaN for undefined chargestate, e.g. in noise
            if chargeState < 0
                sym = '-';
            else
                sym = '+';
            end
            if strcmp(format,'LaTeX')
                ionName = [ionName ' ^{' repmat(sym,1,abs(chargeState)) '}'];
            else
                ionName = [ionName repmat(sym,1,abs(chargeState))];
            end
        end
    end
    
    
    varargout{1} = strtrim(ionName);
end



%% conversion from categorical to name
if iscategorical(varargin{1})
    element = varargin{1};
    
    if nargin == 3
        format = varargin{3};
    else
        format = 'plain';
    end
    
    numAtom = length(element);
    for at = 1:numAtom
        atomicNumber(at,:) = number4sym(char(element(at)));
    end
    ionTable = table(element,atomicNumber);
    
    % sort by atomic number descending
    ionTable = sortrows(ionTable,{'atomicNumber'},{'descend'});
    
    % get multiplicity of atom occurances in ion and write out names
    ionName = [];
    isotopeGroup = sortedFindgroups(ionTable);
    for i = 1:max(isotopeGroup)
        idx = find(isotopeGroup == i,1);
        ionName = [ionName ' ' char(ionTable.element(idx))];
        
        if sum(isotopeGroup == i) > 1
            if strcmp(format,'LaTeX')
                ionName = [ionName '_{' num2str(sum(isotopeGroup == i)) '}'];
            else
                ionName = [ionName num2str(sum(isotopeGroup == i))];
            end
        end
    end
    
    
    
    % add + (or -) for chargestates
    if nargin > 1
        chargeState = varargin{2};
        if ~isnan(chargeState) %NaN for undefined chargestate, e.g. in noise
            if chargeState < 0
                sym = '-';
            else
                sym = '+';
            end
            if strcmp(format,'LaTeX')
                ionName = [ionName ' ^{' repmat(sym,1,abs(chargeState)) '}'];
            else
                ionName = [ionName repmat(sym,1,abs(chargeState))];
            end
        end
    end
    
    
    varargout{1} = strtrim(ionName);
    
end




%% conversion from name to table
if ischar(varargin{1})
    ionName = varargin{1};
    
    %check for chargestate
    if any(ionName == '+')
        chargeState = sum(ionName == '+');
        ionName(ionName == '+') = [];
    elseif any(ionName == '-')
        chargeState = uminus(sum(ionName == '-'));
        ionName(ionName == '-') = [];
    else
        chargeState = NaN;
    end
    
    ionName = strtrim(ionName); %remove any whitespace
    
    % split individual elemental / isotopic parts
    parts = strsplit(ionName);
    numElements = length(parts);
    isotope = categorical();
    elementOut = categorical();
    isotopeOut = categorical();
    
    for el = 1:numElements
        % find the chemical element
        element = parts{el}(isstrprop(parts{el},'alpha'));
        
        isDigit = isstrprop(parts{el},'digit');
        % find the isotope
        if isDigit(1) == true
            isotope = parts{el}(1:find(~isDigit,1)-1);
        else
            isotope = '<undefined>';
        end
        
        % find the count
        if isDigit(end) == true
            count = str2num(parts{el}(find(~isDigit,1,'last')+1:end));
        else
            count = 1;
        end
        
        for cnt = 1:count
            elementOut(end+1) = element;
            isotopeOut(end+1) = isotope;
        end
        
    end
    element = elementOut';
    isotope = isotopeOut';
    
    varargout{1} = table(element,isotope);
    varargout{2} = chargeState;
    
end

function group = sortedFindgroups(ionTable)

isotopeGroup = findgroups(ionTable); % need to re-sort REALLY HOPE THAT WONT MAKE PROBLEMS
groupIdx = unique(isotopeGroup,'stable');
[~, idx] = sort(groupIdx);
for i = 1:length(isotopeGroup)
    isotopeGroup(i) = idx(isotopeGroup(i));
end

group = isotopeGroup;







