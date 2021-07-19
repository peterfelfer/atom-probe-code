function [verticesOut, edgesOut] = rebin1D(verticesIn,edgesIn,bindist)
% rebinning of a line feature (will double up on the endpoints for loops)
%inputs are:

%test if it's a closed loop
occur = tabulate(edgesIn(:));
occur = occur(:,2);

loop = ~~sum(~ (occur == 1)) %loop: every element occurs twice




verticesIn = verticesIn(:,1:3);

dislength = verticesIn(edgesIn(:,2),:) - verticesIn(edgesIn(:,1),:);

vectors = dislength;

dislengthperline = sqrt(sum(dislength.^2,2));

dislength = sum(dislengthperline);

verts = round(dislength/bindist);

bindist = dislength/verts;

grid = zeros(verts,3);


% actual rebinning


for i=1:verts
    
    targetdist = bindist * (i-1);
    
    currentdist =0;
    endidx = 0;
    while currentdist <= targetdist
        endidx = endidx + 1;
        currentdist = currentdist + dislengthperline(endidx);
    end
    
    %currentdist = sum(dislengthperline(1:endidx))
    
    targetdist = targetdist - currentdist;
    
    vertexposition = verticesIn(edgesIn(endidx,2),:);
    
    inc = vectors(endidx,:)*(targetdist/norm(vectors(endidx,:)));
    
    vertexposition = vertexposition + inc;
    
    grid(i,:) = vertexposition;
    
end

grid = [grid; verticesIn(edgesIn(end,2),:)];

verticesOut = grid;



if loop
    verticesOut(end,:) = [];
    edgesOut = [(1: (verts))', [(2:(verts))'; 1]];
else
    edgesOut = [1:(verts-1), 2:(verts)];
end




end