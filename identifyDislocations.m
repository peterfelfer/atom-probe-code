%% coonect up the dots for line features. Connects to the 2 closest
%% vertices. The vectors between the two lines need to be anti-parrallel,
%% otherwise only the closest vertex is connected. Outliers are identified
%% as vertices whose closest (two) vertices are not connecting to them.
%% returns a pos file where the 4th value is the object index. The arrays
%% are ordered from one end to the other. The 'linevector' output contains
%% the vector leading from one vertex to the next (normalized) and the
%% length of the line element associated with each vertex.


%ITEMS TO FIX
%equal distance bug
%write loopdetection
%write linevectors/length for loops


function [dislocations,linevectors] = identifyDislocations(gridin)

HUGE = 10000;

grid = gridin;

numgrid = length(grid);

idx = zeros(numgrid,2); %indices of 2 closest vertices

connectedvertex = zeros(numgrid,1);



%% first, create a list of the indices of the two closest vertices of every
%% vertex

% will crap out if 2 points have the exact same dist... FIX!

distmat = squareform(pdist(gridin(:,1:3))); %distances between all points

for i=1:numgrid
    
    distvec = distmat(:,i);
    
    distvec(i) = HUGE;
    
    idx(i,1) = find(distvec == min(distvec));
    
    distvec(idx(i,1)) = HUGE;
    
    idx(i,2) = find(distvec == min(distvec));
       
end




%% identify and eliminate outliers

for i=1:numgrid
    
    connected = sum((idx(idx(i,1),:) == i) + (idx(idx(i,2),:) == i));
    
    if connected < 1
        
        idx(i,:) = [0,0];
        
        connectedvertex(i) = 1; % so vertex wont be copied to disloc obj
        
    end
end




%% identify end points of dislocations by antiparralellism. For endpoints,
%% set the second index to 0!

isendpoint = zeros(numgrid,1);
endpoints = 0;

for i=1:numgrid
    
    if ~connectedvertex(i)
        
            if ~antiparallell(grid(i,1:3), grid(idx(i,1),1:3), grid(idx(i,2),1:3)) && ~connectedvertex(i)
        
                isendpoint(i) = true;
        
                idx(i,2) = 0;
               
            end
    end
    

    
end
    
endpointidx = find(isendpoint);

endpoints = length(endpointidx);



%% connect the dots. start from an endpoint or if there is none, from the first point on the list. connect until another endpoint is reached or the first point appears again. start from list beginning and remove connected
%% elements. Preallocate half list length, then squeeze. Sort connected.

dislocations = {};

dislocation = [];

d = 0;
% first, detect all dislocations with endpoints

while ~isempty(endpointidx)
    
    dislocation(1) = endpointidx(1);
    connectedvertex(dislocation(1)) = true;
    
    dislocation(2) = idx(dislocation(1),1);
    connectedvertex(dislocation(2)) = true;
    
    endpointidx(1) = [];
    
    i = 3;
    
    while length(unique(dislocation)) == length(dislocation)
        

        dislocation(i) = idx(dislocation(i-1),~(idx(dislocation(i-1),:) == dislocation(i-2)));
        
        connectedvertex(dislocation(i)) = true;
        
        
        if isendpoint(dislocation(i))
            
            
            endpointidx(endpointidx == dislocation(i)) = [];
            
            break;
            
        end
        
        i = i+1;
        
    end
    
    
    d = d+1;
    dislocations{d} = dislocation';
    
    dislocation = [];
    
    
    
    
    
    
    
    
end
        %nextidx = find(~(idx(dislocation(i-1),:) == dislocation(i-2)));
        %nextidx = idx(dislocation(i-1),~(idx(dislocation(i-1),:) == dislocation(i-2)));


% now, detect all dislocation loops (only if there are any of course)
if sum(~connectedvertex)
    
    %loop detection
    
    
    
end




%% calculate linevectors/length


linevectors = {};
linevector = [];


for i=1:d
    
    
    vertices = gridin(dislocations{i},:);
    
    linevector = zeros(size(vertices,1),4);
    
    
    % first element of linear dislocation
    linevector(1,1:3) = (vertices(2,1:3) - vertices(1,1:3))/norm(vertices(2,1:3) - vertices(1,1:3));
    
    linevector(1,4) = norm(vertices(2,1:3) - vertices(1,1:3));
    
    
    %last element of linear dislocation
    linevector(end,1:3) = (vertices(end,1:3) - vertices(end-1,1:3))/norm(vertices(end,1:3) - vertices(end-1,1:3));
    
    linevector(end,4) = norm(vertices(end,1:3) - vertices(end-1,1:3));
    
    
    %vector1 goes from the i-1th element to the ith
    vector1 = vertices(2:end-1,1:3) - vertices(1:end-2,1:3);
    %vector2 goes from the ith element to the i+1th
    vector2 = vertices(3:end,1:3) - vertices(2:end-1,1:3);
    
    %normalize that vector
    vector = vector1+vector2;
    len = repmat( sqrt( sum( vector.^2,2)), 1,3);
    
    
    vector = vector./len;
    
    %assign
    linevector(2:end-1,1:3) = vector;
    
    
    %calculate line length
    linevector(2:end-1,4) = (sqrt( sum( vector1.^2,2)) + sqrt( sum( vector2.^2,2)))./2;
    
    linevectors{i} = linevector;

end




end





function [isanti] = antiparallell(point, firstp, secondp)



firstp = firstp - point;
secondp = secondp-point;


firstp = firstp/norm(firstp);
secondp = secondp/norm(secondp);


isanti = dot(firstp,secondp);

if isanti <=0
    isanti = 1;
    
else isanti = 0;
    
end


end