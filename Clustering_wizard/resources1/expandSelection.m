function [selection unselected] = expandSelection(points,selection,N,delaunayTri)
%adds all points to a selection that are connected to a point of the
%initial selection, does N repetitions (optional, 1 is default)

if ~exist('N','var')
    N = 1;
end

if ~exist('delaunayTri','var')
    tet = delaunayn(points(:,1:3));
else
    tet = delaunayTri;
end


%creating the edge list
tetEdge = [1,2; 1,3; 1,4; 2,3; 2,4; 3,4];
delEdge = [];
for ed = 1:6
    delEdge = [delEdge; tet(:,tetEdge(ed,:))];
end


for i=1:N
    %find all edges that contain one selected and one unselected point
    isSelection = ismember(delEdge,selection);
    
    isSelectionEdge = sum(isSelection,2) == 1;
    
    
    
    %add these unselected points to the selection
    
    isSelectionEdge = repmat(isSelectionEdge,[1 2]);
    
    addToSelection = delEdge(isSelectionEdge & ~isSelection);
    
    selection = [selection addToSelection'];
end

selection = unique(selection);

unselected = ones(length(points(:,1)),1); 
unselected(selection) = 0; 
unselected = find(unselected);

end
