function pos = clipAPTdata(pos,loc,span)
%clips APT data to center of loc = [x,y,z], with the span = [spanX, SpanY,
%spanZ]. span can be a scalar to clip a cube.

if isscalar(span)
    span = [span span span];
end

span = span/2;

min = loc - span;
max = loc + span;

in = pos(:,1) > min(1) & pos(:,1) < max(1) & pos(:,2) > min(2) & pos(:,2) < max(2) & pos(:,3) > min(3) & pos(:,3) < max(3);
pos = pos(in,:);
end

