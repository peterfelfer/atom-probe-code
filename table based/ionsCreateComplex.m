function ionList = ionsCreateComplex(elements,maxComplexity,isotopeTable,chargeStates)
% ionsCreateComplex creates a list of all complex ions that can be formed
% by the given elements, based on the isotopeTable. chargeStates are
% optional, default is +1 - +3
%
% elements is a cellStr in the form {'Fe','Cr','O',...} and can be directly
% extracted e.g. from the decomposed pos file

if ~exist('chargeStates','var')
    chargeStates = [1, 2, 3];
end