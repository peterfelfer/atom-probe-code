function in = lineDistanceClipping(pos, line, distance)
%function that outputs a logical variable of which coordinates in 'pos' are within a
% certain distance 'distance' from a line object 'line'

%line has the components line.vertices (N x 3) and line.edges (M x 2, integer)

% distances are calculated perpendicular to the line elements.
[lineVector, lengthOut] = lineVectors(line.vertices,line.edges);

%% tessellation and distance calculation
% for overall pos file
% finding closest point for each atomic position
closest = dsearchn(line.vertices,pos(:,1:3));

%vector from atom to closest vertex
vec = pos(:,1:3) - line.vertices(closest,1:3); 
vecLen = sqrt(sum(vec.^2,2));
%distance along line vector
distLV = dot(vec, lineVector(closest,:), 2);
%distance normal to line vector
dist = sqrt(vecLen.^2 - distLV.^2); 


in = dist < distance;