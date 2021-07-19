function [linevector, lengthOut] = lineVectors(vertices,edges)
%calcuates the line vectors of a line object (e.g. dislocation) for analysis and/or DCOM
%relaxation.

%inputs are: vertices (x,y,z).... N x 3 matrix of vertices of the line object
%            edges (n1, n2)  .... K x 2 matrix of line segment indices


%outputs are: linevectors of individual elements (x,y,z)
%             length of individual line segments


DEBUG = true;

if ~(edges == orderEdges(edges))
    error('edge/vertex lists needs to be ordered');
end


% ordering vertices
idxList = [edges(:,1); edges(end,2)];
vertices = vertices(idxList,:);



% check is line object is a loop
if edges(1,1) == edges(end,2)
    loop = true
else
    loop = false
end

% memory allocation
numVerts = size(vertices,1);
linevector = zeros(numVerts,3);
lengthOut = zeros(numVerts,1);

%% for linear line objects

% first element of linear dislocation
linevector(1,1:3) = (vertices(2,1:3) - vertices(1,1:3))/norm(vertices(2,1:3) - vertices(1,1:3));
lengthOut(1) = norm(vertices(2,1:3) - vertices(1,1:3))/2;


%last element of linear dislocation
linevector(end,1:3) = (vertices(end,1:3) - vertices(end-1,1:3))/norm(vertices(end,1:3) - vertices(end-1,1:3));
lengthOut(end) = norm(vertices(end,1:3) - vertices(end-1,1:3))/2;


%% calculate individual line vectors
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
lengthOut(2:end-1) = (sqrt( sum( vector1.^2,2)) + sqrt( sum( vector2.^2,2)))./2;


if loop %first and last element are the same
    linevector(1,:) = mean([linevector(1,:); linevector(end,:)],1);
    linevector(end,:) = [];
    lengthOut(1) = lengthOut(1) + lengthOut(end);
    lengthOut(end) = [];
    vertices(end,:) = [];
end



%% visualize results if debugging is on
if DEBUG
    figure('Name','line vectors');
    scatter3(vertices(:,1),vertices(:,2),vertices(:,3),'.r');
    hold on;
    quiver3(vertices(:,1),vertices(:,2),vertices(:,3),linevector(:,1),linevector(:,2),linevector(:,3));
    axis equal; rotate3d on;
end


    
end


















