function conc = binApplyConcentrationFunction(vox,binCenters, concentrationFunction, distanceUnits)
% takes a voxelisation and applies a concentration function to it
% the binCenters are put into the concentration values for plotting
% for 1D, a table is output, otherwise a cell array of concentration tables

% To DO: implement distance variable assignement for numDim > 1
% maybe rename distance to location as it fits better with numDim > 1

% concentration calculation per voxel
conc = cellfun(concentrationFunction, vox, 'UniformOutput',false);

numDim = length(binCenters);

dist = cell(size(conc));


% allocation of distance vector
%conc = cellfun(@(conc, dist) allocateDistanceVector(conc, dist),conc, dist, 'UniformOutput',false);


% create list for 1D
if isvector(vox)
    conc{1}.distance(:) = binCenters{1}(1);
    concOut = conc{1};
    for i = 2:numel(conc)
        conc{i}.distance(:) = binCenters{1}(i);
        concOut = [concOut; conc{i}];
    end
    conc = concOut;
    conc.Properties.VariableUnits{strcmp(conc.Properties.VariableNames,'distance')} = distanceUnits{1};
end

end


function conc = allocateDistanceVector(conc, dist)
conc.distance(:) = repmat(dist,[3,1]);
end