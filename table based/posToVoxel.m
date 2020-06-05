function [vox gridVec]= posToVoxel(pos,gridVecIn,species)
% posToVoxel creates a voxelisation of the data in 'pos' based on the bin centers in
% 'gridVec' for the atoms/ions in species. 
% 
% [vox gridVec]= posToVoxel(pos,gridVec,species)
% [vox gridVec]= posToVoxel(pos,gridVec)
% vox = posToVoxel(pos,gridVec,species)
% 
% INPUT
% pos:     posfile with allocated range. A decomposed pos file is also
%          possible.
% gridVec: are the gridVectors for the grid. If the grid vectors need to be
%          created, a binwidth can be parsed. The function creates the
%          gridVectors.
% species: Species can be a species list as in {'Fe', 'Mn'}. Ions or Atoms 
%          in pos can be parsed. Alternatively it can be a logical vector
%          with the same legth as the pos file.
%          If no species variable is given, all atoms/ions are taken.
%          To get all ranged atoms, use species = categories(pos.atoms)
%          To get all ranged ions, use species = categories(pos.ions)
% OUTPUT
% vox:     voxelisation of the point cloud stored in pos
% gridVec: Vecotors of the grid

%% Check for species
if ~exist('species','var')
    species = true(height(pos),1);
end


if iscell(species) % create logical vector with true for all elements to be included
    % check if atomic or ionic count is calculated
    if any(ismember(pos.Properties.VariableNames,'atom'))
        species = ismember(pos.atom,species);
        
    elseif any(ismember(pos.Properties.VariableNames,'ion'))
        species = ismember(pos.ion,species);
        
    else
        error('unknown table format');
    end   
end

pos = [pos.x(species), pos.y(species), pos.z(species)];

%% Calculating Grid vectors

% Check if gridVectors is the bin width -> yes -> than create the grid
% Vectors
if isnumeric(gridVecIn)
    bin = gridVecIn;
    bin = [bin bin bin];
    % calculating bin centers
    binvectorRaw = linspace(0,1000*bin(1),1001);
    binvectorRaw = [fliplr(uminus(binvectorRaw(2:end))) binvectorRaw];
    
    
    %mins and maxs
    mins = min(pos) - 2*bin;
    maxs = max(pos) + 2*bin;
    
    for d = 1:3
        gridVec{d} = binvectorRaw(binvectorRaw>=mins(d) & binvectorRaw<=maxs(d));
    end
    
else
    gridVec = gridVecIn;
    bin = [gridVec{1}(2)-gridVec{1}(1) gridVec{2}(2)-gridVec{2}(1) gridVec{3}(2)-gridVec{3}(1)];
    
end

%% calcualting 3d histogram

% calculating bin association (I do not pretend to know what all of this
% does)
for d = 1:3
    % calculate edge vecotrs from bin centers
    edgeVec{d} = [gridVec{d}-bin(d)/2 gridVec{d}(end)+bin(d)/2];
    
    [useless loc(:,d)] = histc(pos(:,d),edgeVec{d},1);
    sz(d) = length(edgeVec{d})-1;
end
clear useless

% for points on the border
sz = max([sz; max(loc,[],1)]);

% count of atoms in each voxel
vox = accumarray(loc,1,sz);
end
