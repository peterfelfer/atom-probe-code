function [gridin,dislocation,linevector] = tesselateLine(gridin, bindist)

%% tesselation of vertices (travelling salesman) and rebinning

% creating a dislocation using the travelling salesman solution
[dislocation,~] = tspo_ga(gridin);


%rebinning it to match bindist

gridin = rebin1D(gridin,dislocation,bindist);

dislocation = 1:length(gridin(:,1));






%% calculation of linevectors

vertices = gridin(dislocation,:);
    
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




    

end



%% Auxillary functions


function dispVec(verts,vectors)

figure('Name','Rebinned dislocation and line vectors ','Numbertitle','off');

quiver3(verts(:,1),verts(:,2),verts(:,3),vectors(:,1),vectors(:,2),vectors(:,3));

axis equal

cameratoolbar

end









function [grid] = rebin1D(gridin,disl,bindist)

disl1(:,1) = disl(1:end-1);
disl1(:,2) = disl(1+1:end);

%disl = disl1;
if size(gridin,2) == 4
    gridin(:,4) = [];
end


dislength = gridin(disl1(:,2),:) - gridin(disl1(:,1),:);

vectors = dislength;

dislengthperline = sqrt(sum(dislength.^2,2));

dislength = sum(dislengthperline);

verts = round(dislength/bindist);

bindist = dislength/verts;

grid = zeros(verts,3);


% actual rebinning


for i=1:verts
    
    targetdist = bindist * (i-1);
    
    currentdist =0;
    endidx = 0;
    while currentdist <= targetdist
        endidx = endidx + 1;
        currentdist = currentdist + dislengthperline(endidx);
    end
    
    %currentdist = sum(dislengthperline(1:endidx))
    
    targetdist = targetdist - currentdist;
    
    vertexposition = gridin(disl1(endidx,2),:);
    
    inc = vectors(endidx,:)*(targetdist/norm(vectors(endidx,:)));
    
    vertexposition = vertexposition + inc;
    
    grid(i,:) = vertexposition;
    
end

grid = [grid; gridin(disl1(end,2),:)];

grid(:,4) = 1:verts+1;





end

%%%%%%%%%% slightly modified version Peter Felfer


%TSPO_GA Open Traveling Salesman Problem (TSP) Genetic Algorithm (GA)
%   Finds a (near) optimal solution to a variation of the TSP by setting up
%   a GA to search for the shortest route (least distance for the salesman
%   to travel to each city exactly once without returning to the starting city)
%
% Summary:
%     1. A single salesman travels to each of the cities but does not close
%        the loop by returning to the city he started from
%     2. Each city is visited by the salesman exactly once
%
% Input:
%     XY (float) is an Nx2 matrix of city locations, where N is the number of cities
%     DMAT (float) is an NxN matrix of point to point distances/costs
%     POPSIZE (scalar integer) is the size of the population (should be divisible by 4)
%     NUMITER (scalar integer) is the number of desired iterations for the algorithm to run
%     SHOWPROG (scalar logical) shows the GA progress if true
%     SHOWRESULT (scalar logical) shows the GA results if true
%
% Output:
%     OPTROUTE (integer array) is the best route found by the algorithm
%     MINDIST (scalar float) is the cost of the best route
%
% Example:
%     n = 50;
%     xy = 10*rand(n,2);
%     popSize = 60;
%     numIter = 1e4;
%     showProg = 1;
%     showResult = 1;
%     a = meshgrid(1:n);
%     dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
%     [optRoute,minDist] = tspo_ga(xy,dmat,popSize,numIter,showProg,showResult);
%
% Example:
%     n = 50;
%     phi = (sqrt(5)-1)/2;
%     theta = 2*pi*phi*(0:n-1);
%     rho = (1:n).^phi;
%     [x,y] = pol2cart(theta(:),rho(:));
%     xy = 10*([x y]-min([x;y]))/(max([x;y])-min([x;y]));
%     popSize = 60;
%     numIter = 1e4;
%     showProg = 1;
%     showResult = 1;
%     a = meshgrid(1:n);
%     dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);
%     [optRoute,minDist] = tspo_ga(xy,dmat,popSize,numIter,showProg,showResult);
%
% Example:
%     n = 50;
%     xyz = 10*rand(n,3);
%     popSize = 60;
%     numIter = 1e4;
%     showProg = 1;
%     showResult = 1;
%     a = meshgrid(1:n);
%     dmat = reshape(sqrt(sum((xyz(a,:)-xyz(a',:)).^2,2)),n,n);
%     [optRoute,minDist] = tspo_ga(xyz,dmat,popSize,numIter,showProg,showResult);
%
% See also: tsp_ga, tsp_nn, tspof_ga, tspofs_ga, distmat
%
% Author: Joseph Kirk
% Email: jdkirk630@gmail.com
% Release: 1.3
% Release Date: 11/07/11
function varargout = tspo_ga(verts,popSize,numIter,showProg,showResult)





if size(verts,2) == 4
    verts(:,4)=[];
end


xy = verts;

n = length(verts);
a = meshgrid(1:n);


dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),n,n);




% Process Inputs and Initialize Defaults
nargs = 6;
for k = nargin:nargs-1
    switch k
        case 0
            xy = 10*rand(50,2);
        case 1
            N = size(xy,1);
            a = meshgrid(1:N);
            dmat = reshape(sqrt(sum((xy(a,:)-xy(a',:)).^2,2)),N,N);
        case 2
            popSize = 100;
        case 3
            numIter = 1e4;
        case 4
            showProg = 1;
        case 5
            showResult = 1;
        otherwise
    end
end

% Verify Inputs
[N,dims] = size(xy);
[nr,nc] = size(dmat);
if N ~= nr || N ~= nc
    error('Invalid XY or DMAT inputs!')
end
n = N;

% Sanity Checks
popSize = 4*ceil(popSize/4);
numIter = max(1,round(real(numIter(1))));
showProg = logical(showProg(1));
showResult = logical(showResult(1));

% Initialize the Population
pop = zeros(popSize,n);
pop(1,:) = (1:n);
for k = 2:popSize
    pop(k,:) = randperm(n);
end

% Run the GA
globalMin = Inf;
totalDist = zeros(1,popSize);
distHistory = zeros(1,numIter);
tmpPop = zeros(4,n);
newPop = zeros(popSize,n);


progressbar('segmenting line');
for iter = 1:numIter
    % Evaluate Each Population Member (Calculate Total Distance)
    for p = 1:popSize
        d = 0; % Open Path
        for k = 2:n
            d = d + dmat(pop(p,k-1),pop(p,k));
        end
        totalDist(p) = d;
    end

    % Find the Best Route in the Population
    [minDist,index] = min(totalDist);
    distHistory(iter) = minDist;
    if minDist < globalMin
        globalMin = minDist;
        optRoute = pop(index,:);

    end

    % Genetic Algorithm Operators
    randomOrder = randperm(popSize);
    for p = 4:4:popSize
        rtes = pop(randomOrder(p-3:p),:);
        dists = totalDist(randomOrder(p-3:p));
        [ignore,idx] = min(dists); %#ok
        bestOf4Route = rtes(idx,:);
        routeInsertionPoints = sort(ceil(n*rand(1,2)));
        I = routeInsertionPoints(1);
        J = routeInsertionPoints(2);
        for k = 1:4 % Mutate the Best to get Three New Routes
            tmpPop(k,:) = bestOf4Route;
            switch k
                case 2 % Flip
                    tmpPop(k,I:J) = tmpPop(k,J:-1:I);
                case 3 % Swap
                    tmpPop(k,[I J]) = tmpPop(k,[J I]);
                case 4 % Slide
                    tmpPop(k,I:J) = tmpPop(k,[I+1:J I]);
                otherwise % Do Nothing
            end
        end
        newPop(p-3:p,:) = tmpPop;
    end
    pop = newPop;
    
    progressbar(iter/numIter);
end



% Return Outputs
if nargout
    varargout{1} = optRoute;
    varargout{2} = minDist;
end

end