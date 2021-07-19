function IE = posCalculateExcessAuto(parentPos,speciesPos,cutoff, interfaceThickness)
% posCalculateExcess is a kernel function that calculates the excess of a
% certain species with respect to a distancxe coordinate 'distance' that is
% a column of the pos variables. A cutoff distance cn be difined in order
% to eliminate far-field concentration effects (precipitation, other
% interfaces, etc.).
%
% Methods: if an interface thickness is defined, we calculate the concentra
%
%
% If no interface thickness is defined, the local interface thickness is