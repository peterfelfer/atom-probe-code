function w = ionWeight(ion, isotopeTable, chargeState)
%calculates the weight of an ion, based on the provided ion table
%
% w = ionWeight(ion, isotopeTable);
% w = ionWeight(ion, isotopeTable, chargeState);
%
% INPUTS
% ion: the definition of the ion as a table with ion.element and ion.isotope.
% Both are categorical
% isotopeTable: table of all isotopes from APT Toolbox database
%
% OUTPUTS
% w: weight of ion in amu (w/o chargeState) or Da

%% extract the individual ions and get weight

w = 0;
for i = 1:height(ion)
    w = w + isotopeTable.weight(isotopeTable.element == ion.element(i) ...
        & isotopeTable.isotope == ion.isotope(i));
end

%% devide by chargestate if applicable
if exist('chargeState','var')
    w = w/chargeState;
end
