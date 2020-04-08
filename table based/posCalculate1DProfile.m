function conc = posCalculate1DProfile(pos,bin,distance,concentrationKernel)
% calculates a 1D concentration profile for a pos variable with a bin width
% of 'bin' with a distance variable (distance of pos entry with respect to
% some reference object e.g. interface or axis vector) using a
% concentration determining function 'concentrationKernel' with the
% optional arguments, which are the arguments of the concentrationKernel
% function. 
% concentrationKernel is a function handle, e.g. 
% @(pos) posCalculateConcentrationSimple(pos,....) to a concentration
% calculating function where all parameters apart from pos have been
% defined!

% cn be displayed with special function, but also simply with
% sp = stackedplot(conc(conc.format == 'concentration',{'C','Mn','Fe','Si'},'XVariable',2);

% should maybe find a better way to calculate the bins with nothing hard
% coded

%% create individual bin centers
minDist = min(distance);
maxDist = max(distance);

binVec = linspace(0,10000*bin,10001);
binVec = [fliplr(uminus(binVec(2:end))) binVec];
binVec(binVec<minDist | binVec>maxDist) = [];

%% loop through individual bins
isIn = zeros(height(pos),1);
conc = table();

for b = 1:length(binVec)
    isIn = distance > binVec(b) - bin/2 & distance < binVec(b) + bin/2;
    concTmp = concentrationKernel(pos(isIn,:));
    concTmp.distance = repmat(binVec(b),size(concTmp.distance));
    conc = [conc; concTmp];
end

% set distance unit to 'nm'
conc.Properties.VariableUnits{strcmp(conc.Properties.VariableNames,'distance')} = 'nm';

% add description to distance
conc.Properties.VariableDescriptions{strcmp(conc.Properties.VariableNames,'distance')} = ...
    'distance to reference object';
