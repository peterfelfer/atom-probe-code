function mat = pcaMatrix(pos, voxelSize, bin, mcMax)
% calculates PCA scoring for the mass spectrum of pos in the volume domain.
% the mass spectrum has bins with a bin width of bin and mcMax maximum m/c


%Defaults:
if ~exist('mcMax','var')
    mcMax = 100;
end

if ~exist('nBins','var')
    bin = 1;
end

%% calculation of voxelisation

voxIdx = round(pos(:,1:3)/voxelSize); % gives bin indices
occupiedVox = unique(voxIdx,'rows');

numVox = length(occupiedVox);
nSpecBins = round(mcMax/bin);

mat = zeros(numVox,nSpecBins);

for sp = 1:numVox
    inVox = ismember(voxIdx,occupiedVox(sp,:),'rows');
    mat(sp,:) = quickMassSpec(pos(inVox,4),nSpecBins,mcMax);
end



function spec = quickMassSpec(mc, nSpecBins, mcMax)
%calculates the normalised mass spectrum
numAtoms = length(mc);
spec = hist(mc(mc<mcMax), nSpecBins)/numAtoms;