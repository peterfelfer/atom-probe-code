function ionList = ionsCreateList(elements,chargeStates,maxComplexity,complexFormers,abundanceThreshold,isotopeTable)
% creates a list of all possible ions up to a max complexity
% maxComplexity of elements (can be a list of atomic numbers, symbols or
% 'all' for a list of chargeStates e.g. [1,2,3]. Complex formers can be
% specified.
%
% Output is a struct with .massToCharge (sorted), ionType{},
% relativeAbundance()
%
% if complexformers = 'std' complexformers = H, H2, H3, He, B, C, C2, C3,
% N, O, O2, Ne. If complexFormers = 'and C P ....' it takes the elements
% in elements and adds the additional specified elements

ionList = createIonList(elements,chargeStates,maxComplexity,complexFormers,abundanceThreshold);

ions = cell(length(ionList.ionSpecies),1); % in this variable all ions will be stored in table format
ion = ions;
ionIsotopic = ions;
ionLaTeX = ions;

for i = 1:length(ions)
    sym4number(66)
    element = categorical(arrayfun(@(sym) sym4number(sym), ionList.ionSpecies{i}(:,1), 'UniformOutput', false));
    isotope = ionList.ionSpecies{i}(:,2);
    ions{i} = table(element,isotope); 
    
    ion{i} = convertIonName(ions{i}.element);
    ionIsotopic{i} = convertIonName(ions{i},ionList.chargeState(i));
    weight(i) = ionWeight(ions{i},isotopeTable,ionList.chargeState(i));
    ionLaTeX{i} = convertIonName(ions{i},ionList.chargeState(i), 'LaTeX');
end

ion = categorical(ion);
ionIsotopic = categorical(ionIsotopic);


ionList = table(ion,ionIsotopic,weight,ionLaTeX);
