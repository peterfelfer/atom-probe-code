function in = containmentTest(fv,pts,offset)
%containment test for NON WATERTIGHT surfaces. points are in, if they are
%on the side of their nearest surface vertex the surface normal is
%pointing away from. The output variable IN is a logical variable
%designating all points inside the surface.

addpath('patch_normals');

if ~exist('offset','var')
    offset = 0;
end

% calculate vertex normals
normals = patchnormals(fv);


% calculate closest vertex for each test point
closest = dsearchn(fv.vertices,delaunay(fv.vertices),pts);


%% calculate distance vector and parallel/antiparallel

dotprod = dot(pts - fv.vertices(closest,:),normals(closest,:),2);

in = dotprod >= offset;



