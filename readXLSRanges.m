function readXLSRanges(excelRng,pos,decomposeType)
%reads ranges out of a variable pasted from Excel. If a pos variable is
%parsed, the posfile will be decomposed. By default by ions ('ionic'). If
%'atomic' is parsed as decomposeType, variables of the atomic species are
%created.

OFFSETINCREMENT = 0.01; %if complex ions are decomposed, each iteration fo the positions will be shifted by this value


%% input query
usePos = exist('pos','var');
if usePos
    if exist('decomposeType','var')
        atomic = strcmp(decomposeType,'atomic');
    end
end


%% variable setup
elements = excelRng(1,3:end);
numEl = length(elements);

elementCount = cell2mat(excelRng(2:end,3:end));
ranges = cell2mat(excelRng(2:end,1:2));
numRng = length(ranges(:,1));

[ions, idxa, idxc] = unique(elementCount,'rows');
numIon = length(ions(:,1));

for i = 1:numIon
    
    %% determining the name of the ion
    ionName = '';
    for el = 1:numEl
        if ions(i,el) > 0
            if ions(i,el) == 1
                ionName = [ionName, elements{el}];
            else
                ionName = [ionName, elements{el}, num2str(ions(i,el))];
            end
        end
    end
    
    %% determining the ranges of the ion
    rngIdx = idxc == i;
    rng = ranges(rngIdx,:);
    
    %% writing the range variable to the base workspace
    assignin('base',[ionName 'rng'],rng);
    
    if usePos && ~atomic
        tmpPos = selectRanges(pos,rng);
        assignin('base',[ionName 'pos'],tmpPos);
    end
    
    
end


if atomic
    allRng = [];
    for el = 1:numEl
        count = elementCount(:,el); %multiplicity of element in each range
        tmpPos = [];
        
        for rng = 1:numRng
            if count(rng) > 0
                for i = 1:count(rng)
                    tmpPos = [tmpPos; selectRanges(pos,ranges(rng,:)) + OFFSETINCREMENT * (i -1) ];
                end
            end
            
        end
        
        
        
        elementName = elements{el};
        assignin('base',[elementName 'pos'],tmpPos);
        allRng = [allRng; tmpPos];
        
        %calculating elemental concentrations
        conc{el,1} = elementName;
        conc{el,2} = length(tmpPos);
        
        
    end
    assignin('base','allRanged',allRng);   
    
    
    %calculating elemental concentraitons contd.
    numAtom = sum(cell2mat(conc(:,2)));
    for el = 1:numEl
        conc{el,3} = conc{el,2} / numAtom;
    end
    assignin('base','atomicConc',conc);
end
