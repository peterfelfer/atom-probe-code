function ch = ROIcreateBox(width,height,ax)
%creates cylinder in current or parsed axis with specified radius and
%height. Output is handle to the object for later manipulation.

if not(exist('ax','var'))
    ax = gca;
end

wh = width/2;
hh = height/2;

x = [wh, wh, -wh, -wh, wh, wh, -wh, -wh];
y = [wh, -wh, wh, -wh, wh, -wh, wh, -wh];
z = [hh, hh, hh, hh, -hh, -hh, -hh, -hh];

faces = convhull(x,y,z);
fv.faces = faces;
fv.vertices = [x',y',z'];

ch = patch(fv);
ch.FaceColor = [.5 , .5 , .5];
ch.FaceAlpha = 0.5;
ch.UserData.ROIzaxis = [0,0,0 ; 0,0,height];
ch.UserData.ROIyaxis = [0,0,0 ; 0,width,0];
ch.UserData.ROIxaxis = [0,0,0 ; width,0,0];