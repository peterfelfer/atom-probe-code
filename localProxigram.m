function [binvector, proxi, error, counts] = localProxigram(parentPos,interface,speciesPos,binWidth, vertices)
%Input: parentPos, interface, speciesPos, binWidth, vertices
%‘vertices’ is optional.

%Output: binvector, proxi, error, counts (number of species atoms in bin)

% calculates a proxigram for the patch 'interface' for the atoms in 'parentPos'
% with a binwidth of 'binWidth'. 'speciesPos' can be a pos containing the
% atoms of the species of interest or it can be a cell array containing pos
% arrays and/or structs with 'speciesPos.name' containing the species name
% and 'speciesPos.pos' containing the pos array. Alternatively a proxigram
% can be calculated for a selection of vertices, the indices of which are
% contained in the array 'vertices'. The proxigram is plotted with or
% without error bars (depending 'PlotErrorBars' below). 'binvector'
% contains the values of the bin centres, 'proxi' contains the molefractions
% at each bin for each species. 'error' contains the error in molefraction
% and 'counts' contains the number of species atoms in each bin.

%Uses runProxigram

addpath('Resources');

DEBUG = false;
PlotErrorBars = false;

%% creation of group parentPos

% for overall pos file
% finding closest point for each atomic position
try
    Pclosest = dsearchn(interface.vertices,delaunayn(interface.vertices),parentPos(:,1:3));
catch
    offset = rand(size(interface.vertices)) * 0.01;
    interface.vertices = interface.vertices + offset;
    Pclosest = dsearchn(interface.vertices,delaunayn(interface.vertices+offset),parentPos(:,1:3));
end

%Creation of group parent pos
if exist('vertices')
    matrix = ismember(Pclosest,vertices);
    groupPpos = parentPos(matrix, :);
end
%% creation of group speciesPos and proxigram creation


if exist('vertices')
    %checks if speciesPos is a cell array or numerical array
    if iscell(speciesPos)
        %Runs through each species
        for i = 1:length(speciesPos)
            if isstruct(speciesPos{i})
                
                % Finds the closest vertex for each atom
                Sclosest = dsearchn(interface.vertices,delaunayn(interface.vertices),speciesPos{i}.pos(:,1:3));
                
                %Selects the atoms whose closest vertex is one in vertices
                matrix = ismember(Sclosest, vertices);
                groupSpos{i} = speciesPos{i}.pos(matrix,:);
                
            elseif isnumeric(speciesPos{i})
                
                % Finds the closest vertex for each atom
                Sclosest = dsearchn(interface.vertices,delaunayn(interface.vertices),speciesPos{i}(:,1:3));
                
                %Selects the atoms whose closest vertex is one in vertices
                matrix = ismember(Sclosest, vertices);
                groupSpos{i} = speciesPos{i}(matrix,:);
            else 
                disp('speciesPos may only contain structs and/or numerical arrays')
            end
            
            % Calculates the proxigram for each species
            [binvector(:,i), proxi(:,i), error(:,i), counts(:,i)] = runProxigram(groupPpos, interface, groupSpos{i}, binWidth);
        end
        
    else
        
        % Finds the closest vertex for each atom
        Sclosest = dsearchn(interface.vertices,delaunayn(interface.vertices),speciesPos(:,1:3));
        
        %Selects the atoms whose closest vertex is one in vertices
        matrix = ismember(Sclosest,vertices);
        groupSpos = speciesPos(matrix, :);
        
        %Calculates the proxigram for the species
        [binvector(:,1), proxi(:,1), error(:,1), counts(:,1)] = runProxigram(groupPpos, interface, groupSpos, binWidth); 
    end
else
    %checks if speciesPos is a cell array or numerical array
    if iscell(speciesPos)
        for i = 1:length(speciesPos)
            if isstruct(speciesPos{i})
               
                % Since groups are not being used speciesPos can be used
                groupSpos{i} = speciesPos{i}.pos;
            elseif isnumeric(speciesPos{i})
                groupSpos{i} = speciesPos{i};
            else 
                disp('speciesPos may only contain structs and/or numerical arrays')
            end
            
            % Calculates the proxigram for each species
            [binvector(:,i), proxi(:,i), error(:,i), counts(:,i)] = runProxigram(groupPpos, interface, groupSpos{i}, binWidth);
        end
        
    else
        groupSpos = speciesPos;
        groupPpos = parentPos;
        %Calculates the proxigram for the species
        [binvector(:,1), proxi(:,1), error(:,1), counts(:,1)] = runProxigram(groupPpos, interface, groupSpos, binWidth);
    end
end

%% Plotting

f = figure;
hold all;

% Plot the proxigrams. 'proxi' and 'error' are multiplied by 100 as they
% are plotted in percent instead of molefraction.
for i = 1:size(binvector,2)
    if PlotErrorBars == true
        errorbar(binvector(:,i),proxi(:,i)*100,error(:,i)*100);
    else
        plot(binvector(:,i),proxi(:,i)*100);
    end
end

% If speciesPos contains names these names are added to the variable
% 'speciesLegend' This variable is then used to create the legend
if iscell(speciesPos)
   for  i = 1:length(speciesPos)
       if isstruct(speciesPos{i})
            speciesLegend{i} = speciesPos{i}.name;
            
       else
           speciesLegend{i} = 'species';
           
       end
   end
else
    speciesLegend = 'species';
end

legend(speciesLegend)

set(gcf,'Name','proximity histogram');
set(gcf,'Color',[1 1 1]);

set(get(gca,'XLabel'),'String','distance [nm]');
set(get(gca,'YLabel'),'String','concentration [%]');



end

function [binvector, proxi, error, counts] = runProxigram(pos,interface,speciesPos,binWidth)

% calculates a proxigram for the patch 'interface' for the atoms in 'pos'
% with a binwidth of bin. Alternatively, a second pos file can be parsed in
% xrngORpos, which is then the basis of the proxigram. Parsing of multiple
% posfiles through a cell array is allowed.
% percentages are with respect to all RANGED ATOMS!

DEBUG = false;

%pos: posfile of atoms (all atoms)

%interface: mesh of the interface the interfacial excess is calculated for,
%as a Matlab patch (fv.vertices, fv.faces), can be loaded from *.obj file.

%xrng: ranging file, used to choose which species the IE is calculated for.
%Alternatively a *.pos file of this species. (Needs to be sub-set of pos)

%binWidth: width of each bin the proxigram is calculated for in nm

%addpath('patch_normals','xml_tools');
addpath('resources');%,'pos_tools');

%% variable setup




%numAtom = length(pos(:,1));
%numVerts = length(interface.vertices);

% distances are calculated along vertex normals.
normals = patchnormals(interface);


%% tessellation and distance calculation
% for overall pos file
% finding closest point for each atomic position
closest = dsearchn(interface.vertices,delaunayn(interface.vertices),pos(:,1:3));
distVec = pos(:,1:3) - interface.vertices(closest,:);
%distance through dot product
dist = sum(normals(closest,:) .* distVec,2);

% calculating bin centers
binvector = linspace(0,1000*binWidth,1001);
binvector = [fliplr(uminus(binvector(2:end))) binvector];
binvector(binvector<min(dist) | binvector>max(dist)) = [];

% number of atoms per bin
parent_count = hist(dist,binvector);


%% for element pos files

% finding closest point for each atomic position
closestS = dsearchn(interface.vertices,delaunayn(interface.vertices),speciesPos(:,1:3));
    
distVecS = speciesPos(:,1:3) - interface.vertices(closestS,:);
    
%distance through dot product
distS = sum(normals(closestS,:) .* distVecS,2);
    
% number of atoms per bin
counts = hist(distS,binvector);
proxi = counts./parent_count;

%% Error

stdev = sqrt(proxi.*(1-proxi)./parent_count);

error = stdev*1.96;



end