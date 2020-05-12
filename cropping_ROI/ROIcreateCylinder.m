function ch = ROIcreateCylinder(radius,height,location,numSegments,ax)
% creates cylinder in current or parsed axis with specified radius and
% height. 
% Output is handle to the object for later manipulation.
%
% ch = ROIcreateCylinder()
% ch = ROIcreateCylinder(raadius)
% ch = ROIcreateCylinder(radius,height)
% ch = ROIcreateCylinder(radius,height,location)
% ch = ROIcreateCylinder(radius,height,location,numSegemnts)
% ch = ROIcreateCylinder(radius,height,location,numSegemnts,ax)
%
% INPUTS
% radius:       radius of the cylinder, default is 5   
% height:       height of the cylinder, default is 10
% location:     startcoordinates of the cylinder, default is [0 0 0]
% numSegments:  number of segements of the cylinder, default is 32
%
% OUTPUTS
% ch:           handle to the ROIcylinder
%% sets default radius to 5
if not(exist('radius','var'))
    radius = 5;
end
%% sets default height is 10
if ~exist('height','var')
    height = 10;
end
%% sets default location is [0, 0, 0]
if ~exist('location','var')
    location = [0 0 0];
end
%% sets default numSegments
if not(exist('numSegments','var'))
    numSegments = 32;
end
%% gets axis
if not(exist('ax','var'))
    ax = gca;
end
%% making the cylinder
[x, y, z] = cylinder(radius,numSegments);

z = z * height - height/2;
x = x';
y = y';
z = z';
x = x(:);
y = y(:);
z = z(:);
x0 = location(1,1);% getting x coordinat of location
y0 = location(1,2);% getting y coordinat of location
z0 = location(1,3);% getting z coordinat of location
x = x + x0;% calculate shifted x coordinates
y = y + y0;% calculate shifted x coordinates
z = z + z0;% calculate shifted x coordinates
fv.vertices = [x,y,z];

faces = convhull(x,y,z);
fv.faces = faces;

%% plotting the pathc object
ch = patch(fv);
ch.FaceColor = [.5 , .5 , .5];
ch.FaceAlpha = 0.5;
ch.DisplayName = 'ROI cylinder';




