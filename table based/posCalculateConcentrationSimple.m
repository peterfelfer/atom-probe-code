function conc = posCalculateConcentrationSimple(pos, detEff, excludeList,volumeName)
% calculates the concentration of a categorical list of atoms or ions
% the output is a table with categories for each category of atom/ion and
% its count, concentration and statistical scatter. 
%
% detEff is the detection efficiency
%
% concentrations are only calculated for elements not on exclude list.
% unranged atoms appear as 'unranged'
%
% statistical deviation calculated after Danoix et al., https://doi.org/10.1016/j.ultramic.2007.02.005
% variance(conc) = conc*(1-conc)/numAtomsDetected * (1 - detEff)

%detector efficiency can be in % or as a fraction
if detEff > 1
    detEff = detEff/100;
end


%% check if atomic or ionic concentration is calculated
if any(ismember(pos.Properties.VariableNames,'atom'))
    type = 'atomic';
    columnType = 'atom';
    atoms = pos.atom;
else
    type = 'ionic';
    columnType = 'ion';
    atoms = pos.ion;
end

if ~exist('volumeName','var')
    volumeName = inputname(1);
end

% need to assign, otherwise not counted in countcats 
atoms(isundefined(atoms)) = 'unranged';

%% check for excluded types
cats = categories(atoms);
if exist('excludeList','var')
    isExcluded = ismember(cats,excludeList);
else
    isExcluded = false(size(cats));
end
isExcluded = isExcluded';

%% calculate concentrations for not excluded variables
counts = countcats(atoms);
counts = counts';
counts(2,:) = counts./sum(counts(~isExcluded));
counts(2,isExcluded) = 0;
counts(3,:) = counts(2,:).*(1- counts(2,:))./counts(1,:) * (1-detEff);

%% creating output table
conc = array2table(counts,'VariableNames',cats');
conc.Properties.VariableDescriptions = repmat({columnType},size(cats'));

conc = [table(categorical({volumeName;volumeName;volumeName}),'VariableNames',{'volume'})...
    table([0;0;0],'VariableNames',{'distance'} )...
    table(categorical({type;type;type}),'VariableNames',{'type'}),...
    table(categorical({'count'; 'concentration';'variance'}),'VariableNames',{'format'}),...
    conc];

