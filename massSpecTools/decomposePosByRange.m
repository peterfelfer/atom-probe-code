function decomposePosByRange(pos,rng,decomposeType)
%splits pos file by range, provided as a struct by the readrrng
%the posfile will be decomposed. By default by range type ('rangeName'). If
%'atomic' is parsed as decomposeType, variables of the atomic species are
%created.

%decomposeType:
%'range' - one pos variable per range

%'rangeName' - one pos variable per unique range type. Will mostly be by
%ion, but can use other range names such as 'noise' or 'unknownA'. Avoid
%the use of trailing number for naming as they would be interpreted as
%multipliers in 'type' decomposition.

%'type' - splits up ranges with complex ions and adds them to single type
% variables. Types will in general be chemical elements, but anything can
% be used e.g. 'D2 O', '2H2 O', 'noise' or 'unknown' . Multipliers will be take from the end of
% the individual string!

%important: only use range names that can be used as variable names!!!



OFFSETINCREMENT = 0.01; %if complex ions are decomposed, each iteration fo the positions will be shifted by this value


if ~exist('decomposeType','var')
    decomposeType = 'atomic';
end

numRanges = length(rng);

elements = {};
for r = 1:numRanges
    for e = 1:length(rng(r).atoms)
        elements{end+1} = rng(r).atoms(e).atom;
    end
end

elements = unique(elements);
numEl = length(elements);

%% pull subpos for each range
allRng = [];
for r = 1:numRanges
    rng(r).pos = pos(pos(:,4)>=rng(r).mcbegin & pos(:,4)<rng(r).mcend,:);
end



%% decompose by range
if strcmp(decomposeType,'range');
    
    
    
    for r = 1:numRanges
        %adding range limits to name
        rngName = [rng(r).rangeName(~isspace(rng(r).rangeName)) '_' num2str(round(rng(r).mcbegin))];
        
        %writing range to base workspace
        assignin('base',[rngName 'pos'],rng(r).pos);
        
        %build up variable of ranged atoms
        allRng = [allRng; rng(r).pos];
    end
    
    assignin('base','allRanged',allRng); %creates a variable only containing ranged ions
    
end


%% decompose by range type (e.g. ion)
if strcmp(decomposeType,'rangeName')
    %build list of all ion types
    types = struct2cell(rng);
    types = types(1,:);
    types = unique(types);
    
    for t = 1:length(types)
        tmpPos = [];
        for r = 1:numRanges
            if strcmp(rng(r).rangeName,types{t})
                tmpPos = [tmpPos; rng(r).pos];
                allRng = [allRng; rng(r).pos];
            end
        end
        assignin('base', [types{t}(~isspace(types{t})) '_pos'],tmpPos);
        conc{t,1} = types{t};
        conc{t,2} = length(tmpPos);
        
        
    end
    
    assignin('base','allRanged',allRng);
    
    %calculating concentration per type
    numAtom = sum(cell2mat(conc(:,2)));
    for el = 1:length(types)
        conc{el,3} = conc{el,2} / numAtom;
    end
    assignin('base','ionicConc',conc);
    
end

%% decompose by type (e.g. chemical element)
if strcmp(decomposeType,'type');
    %build list of all 'types' and multipliers in range variable
    types = struct2cell(rng);
    types = types(1,:);
    rng(r).types = {};
    rng(r).multi = [];
    uniqueTypes = {};
    
    for r = 1:numRanges
        parts = strsplit(types{r});
        %find multipliers e.g. C2
        for t = 1:length(parts)
            tmp = parts{t}(1:find(isletter(parts{t}),1,'last'));
            rng(r).types{end+1} = tmp;
            uniqueTypes{end+1} = tmp;
            if length(parts{t}) > find(isletter(parts{t}),1,'last')
                rng(r).multi(end+1) = str2num(parts{t}(find(isletter(parts{t}),1,'last')+1:end));
            else
                rng(r).multi(end+1) = 1;
            end
        end
        
    end
    
    %find unique types
    uniqueTypes = unique(uniqueTypes);
    numTypes = length(uniqueTypes);
    
    %create pos variables for each type
    for t = 1:numTypes
        type = uniqueTypes{t};
        tmpPos = [];
        
        %cycle through ranges and pull out sub-pos
        for r = 1:numRanges
            numTypes = length(rng(r).types);
            for ti = 1:numTypes
                offset = 0;
                if strcmp(type,rng(r).types{ti});
                    for m = 1:rng(r).multi
                        tmpPos = [tmpPos; rng(r).pos + offset];
                        allRng = [allRng; rng(r).pos + offset];
                        offset = offset + OFFSETINCREMENT;
                    end
                end
            end
        end
        
        assignin('base', [type '_pos'],tmpPos);
        conc{t,1} = uniqueTypes{t};
        conc{t,2} = length(tmpPos);
        
        
    end
    
    assignin('base','allRanged',allRng);
    
    %calculating concentration per type
    numAtom = sum(cell2mat(conc(:,2)));
    for el = 1:length(uniqueTypes)
        conc{el,3} = conc{el,2} / numAtom;
    end
    assignin('base','atomicConc',conc);
    
end
