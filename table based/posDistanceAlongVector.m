function distance = posDistanceAlongVector(pos,origin,direction)
% calculated the distance of entries in a pos file along a specified
% vector with an origin of 'origin' and a direction of 'direction'
%table based

points = [pos.x pos.y pos.z];
points = points - repmat(origin,[height(pos),1]); % re-center origin

direction = direction/norm(direction); %make axis unit length

distance = sum(points.*repmat(direction,[height(pos),1]),2);% dot product with scale axis for projected length