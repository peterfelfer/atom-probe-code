function out = findPeakOffset(isotopeTable)
% finds offset of peak by selecting one stem with the correct peak and
% selecting the corresponding isotope (currenlty just single element). The
% chargestate is determined automatically

peakStem = gco;
actual = peakStem.XData;

listString = {};

for iso = 1:height(isotopeTable)
    listString{iso} = [char(isotopeTable.element(iso)), num2str(isotopeTable.isotope(iso)), ' ' num2str(isotopeTable.weight(iso)), '  ',num2str(isotopeTable.abundance(iso)) ];
end

[idx,tf] = listdlg('ListString',listString,'SelectionMode','single');

correct = isotopeTable.weight(idx);
chargeState = round(correct/actual);
correct = correct/chargeState;

out = [actual correct correct/actual];