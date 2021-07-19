function slicedvap = createSlicedVap(pos,verts, normals)
%creates a cell array, where cell i contains the atomic positions
%associated with vertex i

%INPUT
% pos     x,y,x,m/c      atom probe pos variable
% verts   x,y,z          analysis object vertices
% normals x,y,z          normalized vertex normals or line vectors

%OUTPUT
% vap variable contains:
% x, y, z, m/c, closestVertex, distance to vertex,  distandce along normal,
% distance from normal

% for line objects, 7 = distance along line vector, 8 = distance to line
% vector


% finding closest vertex
closest = dsearchn(verts(:,1:3),delaunayn(verts(:,1:3)),pos(:,1:3));


vap = pos;

vap(:,5) = closest;

vec = pos(:,1:3) - verts(closest,1:3); %vector from atom to closest vertex

vap(:,6) = sqrt(sum(vec.^2,2)); %distance to vertex

vap(:,7) = dot(vec, normals(closest,:), 2); %distance along normal

vap(:,8) = sqrt(vap(:,6).^2 - vap(:,7).^2); %distance perpendiculat ot normal



% creating the cell array for each vertex
for sl = 1:length(verts(:,1))
    slicedvap{sl} = vap(closest == sl,:);
end
