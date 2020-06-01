function weight = atomicWeight(element,isotopeTable)
% calculates the average atomic weight of an element based on the provided
% isotopeTable

isotopeTable = isotopeTable(isotopeTable.element == element,:);

isPct = max(isotopeTable.abundance) > 1; %check if abundacne is in pct or fraction
if isPct
    isotopeTable.abundance = isotopeTable.abundance/100;
end

weight = sum(isotopeTable.weight .* isotopeTable.abundance);