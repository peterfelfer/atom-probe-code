function proxigram = advancedProxigram(slicedvap,xrng,binwidth,dim,vertexlist)
% information needed: ranges, vap file, bin width, analysis vertices, distance metric (dimansionality).
% every point in the proxigram has a +- concentration and a +- in distance
% and a +- in gradient! The gradient is measured at the spatial point!

%the vertexlist is optional, if its not present, all vertices are used.

%% first, we calculate split up the subvolumes and send all of them to the
%% program that calculates the atomic concentrations. remember its
%% parallellized, so the communication involved is important.




%dimensionality translates into the distance metric used. 0D means we use
%the distance to the vertex (6th value in the vap file), 1D means we use
%the distance to the vertex normal (8th vap value), 2D means we use
%distance along the vertex normal (7th value).

switch dim
    case 0
        dim = 6;
    case 1
        dim = 8;
    case 2
        dim = 7;
    otherwise
        disp('Please choose a valid dimensionality!');
end







%% again, the vertexlist is optional, if its not present, all vertices are used.
if ~exist('vertexlist','var')
    numverts = length(slicedvap);
    vertexlist = 1:numverts;
end

numverts = length(vertexlist);

%so we remove all slices that are not used
toremove = 1:length(slicedvap);
toremove(vertexlist) = [];

slicedvap(toremove)=[];

%disp('unused volumes removed');








%% find maximum and minimum elements in terms of distance metric to set up the amount of bins needed.

maxdist = 0;
mindist = 0;


for i=1:numverts
    
    tempmax = max(slicedvap{i}(:,dim));
    tempmin = min(slicedvap{i}(:,dim));
    
    if tempmax>maxdist
        maxdist = tempmax;
    end
    if tempmin<mindist
        mindist = tempmin;
    end
    
    
end

maxdist = fix(maxdist/binwidth)*binwidth;
mindist = fix(mindist/binwidth)*binwidth;


totaldist = maxdist - mindist;
numbins = fix(totaldist/binwidth);

binbounds = linspace(mindist,maxdist,numbins+1)-binwidth/2;

% the total amount of volumes we need to calculate the concentration for is
% the amount of vertices times the amount of bins. This means we use linear
% indexing for the volumes. For bin x in volume y, the linear idx = x + bins*(y-1)


% also need to calculate the amount of atoms in each volume!
atomcount = zeros(numverts,numbins);



numvols = numverts*numbins;

mc = cell(numvols);

%disp('forming bins for concentration calculations');

for vertex = 1:numverts
    
    for bin = 1:numbins
        
        upperbound =  binbounds(bin+1);
        lowerbound =  binbounds(bin);
        
        distances = slicedvap{vertex}(:,dim);
        
        mc{bin + numbins*(vertex-1)} = slicedvap{vertex}((distances>lowerbound) & (distances<upperbound),4);
        atomcount(vertex,bin) = length(mc{bin + numbins*(vertex-1)});
        
    end
    
end

%% sending it off to the actual concentration calculation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('performing concentration calculations');

[conc,~] = atomicConcentration(mc,xrng);

disp('concentrations calculated');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% now we need to form a matrix of concentration vs. bin# and vertex# for each
%% element.






%preallocating the memory
proxigram = struct;
proxigram.distances = binbounds(1:end-1)+binwidth/2;
proxigram.binbounds = binbounds;
proxigram.binwidth = binwidth;
proxigram.xrng = xrng;

concentrations = cell(100,1);
avgconc = cell(100,1);
deltadist = cell(100,1);
deltaconc = cell(100,1);
deltagrad = cell(100,1);

for i=1:100
    concentrations{i} = zeros(numverts,numbins);
    avgconc{i} = zeros(numbins,1);
    deltadist{i} = zeros(numbins,1);
    deltaconc{i} = zeros(numbins,1);
    deltagrad{i} = zeros(numbins,1);
end


%wow... that was a lot of preallocation, now let's distribute the
%concentration values
for vertex = 1:numverts
    for bin = 1:numbins
        for element=1:100
            concentrations{element}(vertex,bin) = conc{bin + numbins*(vertex-1)}(element);
        end
    end  
    
    
end

clear conc;
%disp('concentration values redistributed');


%% next is the calculation of average concentrations per bin and
%% concentration variance

% first thing we will calculate is the average concentration of each bin
% and the standard deviation in concentration

atomcountperbin = sum(atomcount,1);



for element=1:100
    
    for bin=1:numbins
        
        avgconc{element}(bin)  =  sum(concentrations{element}(:,bin).*atomcount(:,bin))/atomcountperbin(bin);
        
        deltaconc{element}(bin) = sqrt(var( concentrations{element}(:,bin) , atomcount(:,bin)));
        
                
    end
    
    
   
    
end

proxigram.concentrationprofile = avgconc;
proxigram.concentrationstddeviation = deltaconc;



%% last is the calculation of spatial variance and variance in concentration gradient, using linear interpolation

%conoccur = zeros(numbins,1);

for element=1:100
    
    for bin=1:numbins
        
        for vert=1:numverts
            
            try
                %conoccur(vert) = concentrationOccurance(proxigram.distances, concentrations{element}(vert,:), avgconc{element}(bin),proxigram.distance(bin));
                
            catch
                %conoccur(vert) = proxigram.distances(bin);
                
            end
                
        end
        
        
        %deltadist{element}(bin) = sqrt(var(conoccur));%,atomcount(vert,:)));
        
    end
    
end

%proxigram.distancestddeviation = deltadist;

%missing:
% distdelta
% gradientdelta



end










function distance = concentrationOccurance(coord,values,conc,dist)

%coord is the coordinate vector of the vertex for this element
%values are the corresponding concentration values
%conc is the average concentration of the bin
%dist is the pseudo-1D coordinate of the bin we are looking at


smaller = values < conc;

%% first we need search for all intervals where the concentration profile
%% is intersecting

crossing = smaller(1:end-1)~=smaller(2:end);

crossing = find(crossing);

distance = zeros(length(crossing),1);

for i=1:length(crossing)
    distance(i) = interp1q([values(crossing(i)); values(crossing(i)+1)], [coord(crossing(i)); coord(crossing(i)+1)], conc);
end


[~,distance] = dsearchn(distance,dist);
distance = distance(1);


end































