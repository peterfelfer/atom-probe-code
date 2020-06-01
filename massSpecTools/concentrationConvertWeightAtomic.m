function conc = concentrationConvertWeightAtomic(conc,type,isotopeTable)
% converts a concentration from atomic to weight or reverse
% 'type' is the input type, either 'atomic' or 'weight'
% the input concentration is in the form of a table with the columns for
% the atoms having 'atom' as the column description. Can be multiple lines
% of concentrations
% conversion is currently based on the parsed 'isotopeTable'

if strcmp(type,'atomic')
    % find which entires are elements
    isElement = find(conc.Properties.VariableDescriptions == "atom");
    
    % calculate average elemental weights based on isotope table
    element = conc.Properties.VariableNames(isElement);
    weight = cellfun(@(el) atomicWeight(el,isotopeTable), element);
    
    % do conversion to weight pct
    denominator = sum(table2array(conc(:,isElement)).* weight);
    conc{:,isElement} = table2array(conc(:,isElement)).* weight/ denominator;  
    conc.type = categorical("weight");
    
elseif strcmp(type,'weight')
    
    
else
    error('conversion type not recognized');
end