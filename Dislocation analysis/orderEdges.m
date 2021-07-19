function [edgesOut verticesOut] = orderEdges(edges,vertices)
%takes an Nx2 edge list and orders the line elements so that it starts with
%one and line elements are consecutive

DEBUG = true;


% we are always starting with vertex at the end or vertex # 1 for a loop


%% finding endpoints
occur = tabulate(edges(:));
occur = occur(:,2);

loop = ~ (occur == 1); %loop: every element occurs twice

if  loop
    connIdx = 1;
else
    connIdx = min(find(occur == 1));
end


%% finding the first edge
containsVert = find((edges(:,1) == connIdx) | (edges(:,2) == connIdx));
ed = containsVert(1);

edgesOut(1,:) = edges(ed,:);
if ~(edgesOut(1,1) == connIdx)
    edgesOut(1,:) = fliplr(edgesOut(1,:));
end
edges(ed,:) = [];

connIdx = edgesOut(1,2);

%% connecting up the other edges
while ~isempty(edges)
    containsVert = find((edges(:,1) == connIdx) | (edges(:,2) == connIdx));
    
    edgesOut(end+1,:) = edges(containsVert,:);
    if ~(edgesOut(end,1) == connIdx)
        edgesOut(end,:) = fliplr(edgesOut(end,:));
    end
    
    edges(containsVert,:) = [];
    
    connIdx = edgesOut(end,2);
    
end


%% re - ordering vertices
if exist('vertices','var')
    [C,ia,ic] = unique([edgesOut(:,1); edgesOut(end,2)]);
    verticesOut = vertices(ic,:);
    
    edgesOut = [(1:length(edgesOut))', (2:(length(edgesOut)+1))'];
    
    
    if loop
        edgesOut(end,2) = 1;
        verticesOut(end,:) = [];
    end
    
    
    if DEBUG
        
        figure('Name','vertex indices')
        
        scatter3(verticesOut(:,1),verticesOut(:,2),verticesOut(:,3),'or');
        hold on;
        
        for i=1:length(verticesOut)
            text(verticesOut(i,1),verticesOut(i,2),verticesOut(i,3),num2str(i),'FontSize', 20);
            hold on;
        end
        
        
        axis equal; rotate3d on;
        
    end
    
end


