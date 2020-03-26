function in = cropDetectorRegion(detx,dety,center,radius)

detx = detx - center(1);
dety = dety - center(1);

dist2 = detx.^2 + dety.^2;

in = dist2 < radius^2;