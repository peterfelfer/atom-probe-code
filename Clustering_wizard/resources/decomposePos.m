function decomposedPos = decomposePos(pos,xrng,mode)

%outputs a struct with the posfile (epos file) separated into a cell array with every
%cell being a pos array (or epos). The decomposition modes are 'isotopic',
%'atomic', 'ranges', 'ionic'. If charge states are required, 'ranges' needs to be used. 
%If GPU = true, it will be carried out on the GPU 
%(requires Jacket, www.accelereyes.com)
%
%the struct consists of three parts: the cell array of pos files and the
%properties cell array explaining what each cell array contains. the third
%variable shows what composition was used
%
%example: decomposedPos{i}.pos
%         decomposedPos{i}.property{k}.name
%         decomposedPos{i}.property{k}.value
%
%properties (all integer):
% mode = 'atomic',   property{1}.value = atomicNumber
%                    property{1}.name = 'atomic number'
%
% mode = 'isotopic', property{1}.value = atomicNumber
%                    property{1}.name = 'atomic number'
%                    property{2}.value = isotope
%                    property{2}.name = 'isotope'
%
% mode = 'ionic',    property{1}.value = ionType = [atomicnumber isotope;...]
%                    property{1}.name = 'ion type'
%                    property{2}.value = chargeState
%                    property{2}.name = 'charge state'
%
% mode = 'epos',     property{1}.value = ionType = [atomicnumber isotope;...]
%                    property{1}.name = 'ion type'
%                    property{2}.value = chargeState
%                    property{2}.name = 'charge state'
%                    property{3}.value = hitMultiplicity
%                    property{3}.name = 'hit multiplicity



switch mode
    case 'isotopic'
        
        decomposedPos = decomposeIsotopic(pos,xrng);
        
    case 'atomic'
        
        decomposedPos = decomposeAtomic(pos,xrng);
        
    case 'ionic'
        
        decomposedPos = decomposeIonic(pos,xrng);

        
end

end




function decomposedPos = decomposeAtomic(pos,xrng)

%if complex ions are decomposed, the constituent atoms are shifted with
%respect to each other by EPSILON, to avoid identical coordinates
%(important for voronoi analysis)
EPSILON = 0.01;

numRng = length(xrng.ranges);
numAtoms = length(pos(:,1));
rangedAtoms = false(numAtoms,1);

%% creating the output struct (empty pos cells will be removed at the end)
decomposedPos = cell(100,1);
for Z = 1:100
    decomposedPos{Z}.property{1}.name = 'atomic number';
    decomposedPos{Z}.property{1}.value = Z;
    decomposedPos{Z}.pos = [];
end


%% cycling through ranges and creating pos variables
inRange = false(numAtoms,1);

wb = waitbar(0,'decomposing posfile, mode = atomic');

for rng = 1:numRng
    mcbegin = xrng.ranges(rng).masstochargebegin;
    mcend = xrng.ranges(rng).masstochargeend;
    
    inRange(:,:) = false;
    inRange = (pos(:,4) >= mcbegin) & (pos(:,4) <= mcend);
    rangedAtoms = rangedAtoms | inRange;
    
    numions = length(xrng.ranges(rng).ions);
    
    for ion = 1:numions
        
        numatoms = length(xrng.ranges(rng).ions(ion).atoms);
        
        for atom = 1:numatoms
            
            Z = xrng.ranges(rng).ions(ion).atoms(atom).atomicnumber;
            
            decomposedPos{Z}.pos = [decomposedPos{Z}.pos; pos(inRange,:) + EPSILON*(atom-1)];
            
        end
        
        
    end
    
    waitbar(rng/numRng,wb);
    
end

delete(wb);

%% removing empty cells

pop = false(100,1);
for Z = 1:100
    if isempty(decomposedPos{Z}.pos)
        pop(Z) = true;
    end
end

decomposedPos(pop) = [];


%% adding a field for the unranged atoms
decomposedPos{end+1}.property{1}.name = 'atomic number';
decomposedPos{end}.property{1}.value = 'unranged';
decomposedPos{end}.pos = pos(~rangedAtoms,:);

end







function decomposedPos = decomposeIsotopic(pos,xrng)


numRng = length(xrng.ranges);
numAtoms = length(pos(:,1));
rangedAtoms = false(numAtoms,1);

%% creating the output struct (empty pos cells will be removed at the end)
decomposedPos = cell(100,250);
for Z = 1:100
    for N = 1:250
        decomposedPos{Z,N}.property{1}.name = 'atomic number';
        decomposedPos{Z,N}.property{1}.value = Z;
        decomposedPos{Z,N}.property{2}.name = 'isotope';
        decomposedPos{Z,N}.property{2}.value = N;
        decomposedPos{Z,N}.pos = [];
    end
end


%% cycling through ranges and creating pos variables
inRange = false(numAtoms,1);

wb = waitbar(0,'decomposing posfile, mode = isotopic');

for rng = 1:numRng
    mcbegin = xrng.ranges(rng).masstochargebegin;
    mcend = xrng.ranges(rng).masstochargeend;
    
    inRange(:,:) = false;
    inRange = (pos(:,4) >= mcbegin) & (pos(:,4) <= mcend);
    rangedAtoms = rangedAtoms | inRange;
    
    numions = length(xrng.ranges(rng).ions);
    
    for ion = 1:numions
        
        numatoms = length(xrng.ranges(rng).ions(ion).atoms);
        
        for atom = 1:numatoms
            
            Z = xrng.ranges(rng).ions(ion).atoms(atom).atomicnumber;
            N = xrng.ranges(rng).ions(ion).atoms(atom).isotope;
            
            decomposedPos{Z,N}.pos = [decomposedPos{Z,N}.pos; pos(inRange,:)];
            
        end
        
        
    end
    
    waitbar(rng/numRng,wb);
    
end

delete(wb);

%switching to linear indexing?

%% removing empty cells
pop = cellfun(@(x) isempty(x.pos),decomposedPos);

decomposedPos(pop) = [];
decomposedPos = decomposedPos';

%% adding a field for the unranged atoms
decomposedPos{end+1}.property{1}.name = 'ion type';
decomposedPos{end}.property{1}.value = 'unranged';
decomposedPos{end}.pos = pos(~rangedAtoms,:);

end


function decomposedPos = decomposeIonic(pos,xrng)

numRng = length(xrng.ranges);
numAtoms = length(pos(:,1));
rangedAtoms = false(numAtoms,1);

decomposedPos = cell(numRng,1);

for rng = 1:numRng
    decomposedPos{rng}.property{1}.name = 'ion type';
    ionType = [];
    for atom = 1:length(xrng.ranges(rng).ions(1).atoms)
        ionType = [ionType; xrng.ranges(rng).ions(1).atoms(atom).atomicnumber xrng.ranges(rng).ions(1).atoms(atom).isotope];
    end
    decomposedPos{rng}.property{1}.value = ionType;
    decomposedPos{rng}.property{2}.name = 'charge state';
    decomposedPos{rng}.property{2}.value = xrng.ranges(rng).ions(1).chargestate;
    decomposedPos{rng}.pos = [];
end

%% cycling through ranges and creating pos variables
inRange = false(numAtoms,1);

wb = waitbar(0,'decomposing posfile, mode = ionic');

for rng = 1:numRng
    mcbegin = xrng.ranges(rng).masstochargebegin;
    mcend = xrng.ranges(rng).masstochargeend;
    
    inRange(:,:) = false;
    inRange = (pos(:,4) >= mcbegin) & (pos(:,4) <= mcend);
    rangedAtoms = rangedAtoms | inRange;
    
    
    decomposedPos{rng}.pos = [decomposedPos{rng}.pos; pos(inRange,:)];
    
    waitbar(rng/numRng,wb);
    
end

delete(wb);

%% adding a field for the unranged atoms
decomposedPos{end+1}.property{1}.name = 'ion type';
decomposedPos{end}.property{1}.value = 'unranged';
decomposedPos{end}.pos = pos(~rangedAtoms,:);
end

