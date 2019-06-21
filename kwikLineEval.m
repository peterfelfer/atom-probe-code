function kwikLineEval(pos,parentPos,line,vertices)
%calculates the average line excess for a line object with an
%interactive interface for the IE determination

%%reads a pos file [x,y,z] converted to a Matlab variable and a vertex file
%%[x,y,z] and assigns every atom to the closest vertex.

%vap: m y z mc vert# disttovert distalongnormal( or to line element)
%shiftdistance
%vertex: x y z obj# nx ny nz d A(or l)

addpath('resources');

%calculation of line vectors and segment lengths
[lineVector, lengthOut] = lineVectors(line.vertices,line.edges);

numVerts = length(line.vertices);
%% tessellation and distance clipping
% finding closest point for each atomic position
closest = dsearchn(line.vertices,parentPos(:,1:3));


%if local IE values are calcualted, only atomic positions associated with
%the vertices on the vertex list are used.
if exist('vertices','var')
    isLocal = ismember(closest,vertices);
    parentPos = parentPos(isLocal,:);
    closest = closest(isLocal,:);
    
    lengthOut = lenghtOut(vertices);
end


%distance through dot product
%vector from atom to closest vertex
vec = parentPos(:,1:3) - line.vertices(closest,1:3); 
vecLen = sqrt(sum(vec.^2,2));
%distance along line vector
distLV = dot(vec, lineVector(closest,:), 2);
%distance normal to line vector
dist = sqrt(vecLen.^2 - distLV.^2); 

%calcualtion of overall line length
lengthOut = sum(lengthOut);




%% calcualting cumulative diagram

% indices of atoms that are part of the species in question
idx = ismember(parentPos(:,1:3),pos(:,1:3),'rows');
[useless, sortIdx] = sort(dist);
idx = idx(sortIdx);

cumulative = cumsum(idx);

%% index of interface location
interfaceLoc = 1;


lineExcessGUI(cumulative,lengthOut);



end




















