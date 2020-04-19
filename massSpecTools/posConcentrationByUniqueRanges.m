function conc = posConcentrationByUniqueRanges(pos,ranges,ions,isotopeTable)
% calculates the concentration of a pos variable based on ranges and
% defined ions.
% Raw counts are taken from ranges with no overlap, number of atoms without
% associated range is calculated based on the defined ions and the
% isotopeTable. 
% elements without unique range are calculated based 