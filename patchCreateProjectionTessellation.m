function fv =  patchCreateProjectionTessellation(alpha,points)
% calculates a projection tessellation based on the current projection in
% the current figure. An alpha shape is used for the tessellation
%
% fv =  projectionTessellation(alpha)
% fv =  projectionTessellation(alpha,points)
%
% INPUT
% alpha:        
%
% points:
%
% OUTPUT
% fv:           struct with field of faces and vertices    

% if the points are parsed in pts, the projection direction is estimated
% from least squares fit of the points

% addpath('alphaHull');
addpath('sampledAlphaHull');

DEBUG = false;


if DEBUG
    fig = true
else
    fig = false;
end

%% normal vector and data from view in figure
if ~exist('points','var');
    
    ax = gca;
    
    
    [az,el] = view;
    
    if DEBUG
        az
        el
    end
    
    % construct the normal vector to the viewing plane from these angles
    
    az = (az - 90)*pi/180;
    el = el*pi/180;
    
    normalvec=[1 0 0]*[cos(az) sin(az) 0;-sin(az) cos(az) 0;0 0 1];
    
    normalvec=normalvec*[cos(el) 0 sin(el);0 1 0;-sin(el) 0 cos(el)];
    
    % project into the viewing plane
    
    
    handles = get(ax,'Children');
    
    x = get(handles(end),'Xdata');
    y = get(handles(end),'Ydata');
    z = get(handles(end),'Zdata');
    
    
    points = [x' y' z'];
    
    
else
    %% normal vector from least squares plane fit to points
    COM = mean(points,1);
    points0 = points - repmat(COM,length(points(:,1)),1);
    M = LSE(points0);
    
    % Eigenvalues and Eigenvectors
    [V, lambda] = eig(M);
    lambda = sum(lambda,1);
    normalvec = V(:,lambda == min(lambda))';
    
end





uv = points * null(normalvec);


if DEBUG
    figure;
end

[A S] = alphavol(uv,alpha,fig);

fv.vertices = points;
fv.faces = S.tri;

figure('Name','tessellated object');
patch(fv,'FaceAlpha',0.5);
rotate3d on;
axis equal;

end






function M = LSE(pts)
% the least squares estimated matrix M is obtained by:
% M = 1/k sum_i=1^k(pi * pi^T - COM * COM^T)
% since we've already tranformed, COM = [0,0,0];

k = length(pts(:,1));

M = zeros(3,3);

for pt = 1:k
    
    M = M + pts(pt,:)' * pts(pt,:);
    
end

M = M / k;

end




