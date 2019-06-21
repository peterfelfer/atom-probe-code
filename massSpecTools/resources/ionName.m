function string = ionName(ion)
%% returns a string with the ions name as in Fe56Fe56O16

string = '';

for nuc = 1:length(ion(:,1))
    
    string = [string sym4number(ion(nuc,1)) num2str(ion(nuc,2))];
    
end



end