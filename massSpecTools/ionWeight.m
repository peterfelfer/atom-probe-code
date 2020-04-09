function w = ionWeight(ion, isotopeTable, chargeState)
%calculates the weight of an ion, based on the provided isotope table
%
% w = ionWeight(ion, isotopeTable);
% w = ionWeight(ion, isotopeTable, chargeState);
%
% INPUTS
% ion: the definition of the ion as a table with ion.element (categorical vector of chemical element)
% and ion.isotope (int vector of isotope number)
% isotopeTable: table of all isotopes from APT Toolbox database
% chargeState: charge state of ion, optional
%
% OUTPUTS
% w: weight of ion in amu (w/o chargeState) or Da

%% extract the individual ions and get weight

w = 0;
for i = 1:height(ion)
    w = w + isotopeTable.weight(isotopeTable.element == ion.element(i) ...     
        & isotopeTable.isotope == ion.isotope(i));
end

%% divide by chargestate if applicable
if exist('chargeState','var')
    w = w/chargeState;
end
