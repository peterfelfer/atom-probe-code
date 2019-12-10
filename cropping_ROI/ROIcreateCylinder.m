function ch = ROIcreateCylinder(radius,height,ax)
%creates cylinder in current or parsed axis with specified radius and
%height. Output is handle to the object for later manipulation.

if not(exist('ax','var'))
    ax = gca;
end

numSegments = 32; % number of segments for the circle


[x, y, z] = cylinder(radius,numSegments);

z = z * height - height/2;
x = x';
y = y';
z = z';
x = x(:);
y = y(:);
z = z(:);
fv.vertices = [x,y,z];

faces = convhull(x,y,z);
fv.faces = faces;


ch = patch(fv);
ch.FaceColor = [.5 , .5 , .5];
ch.FaceAlpha = 0.5;
ch.UserData.ROIzaxis = [0,0,0 ; 0,0,height];
ch.UserData.ROIyaxis = [0,0,0 ; 0,radius,0];
ch.UserData.ROIxaxis = [0,0,0 ; radius,0,0];



