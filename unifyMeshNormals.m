function [f_out, facesFlipped] = unifyMeshNormals( f, toFaceNo )
%UNIFYMESHNORMALS Aligns mesh normals to all point in a consistent direction.
%
% F_OUT = UNIFYMESHNORMALS(F) takes an N-by-3 array of faces F, and returns
% an equivalent set of faces F_OUT with all adjacent faces in F_OUT
% pointing in a consistent direction.
%
% FV_OUT = UNIFYMESHNORMALS(FV) instead take a structure array with field
% "faces" (and "vertices"), returning that structure with adjacent faces
% aligned consistently as above.
%
% [F_OUT, FLIPPED] = UNIFYMESHNORMALS(...) also returns FLIPPED, an N-by-1
% logical mask showing which faces in F/FV were flipped during unification.
%
% [...] = UNIFYMESHNORMALS(F,FACENO) also specifies a face number to
% "trust" that will not be flipped. All other faces will be aligned to be
% consistent with the direction of the trusted FACENO.
%
%   Example:
%       tmpvol = zeros(20,20,20);       % Empty voxel volume
%       tmpvol(5:15,8:12,8:12) = 1;     % Turn some voxels on
%       tmpvol(8:12,5:15,8:12) = 1;
%       tmpvol(8:12,8:12,5:15) = 1;
%       fv = isosurface(tmpvol, 0.99);  % Create the patch object
%       % Display patch object normal directions
%       facets = fv.vertices';
%       facets = permute(reshape(facets(:,fv.faces'), 3, 3, []),[2 1 3]);
%       edgeVecs = facets([2 3 1],:,:) - facets(:,:,:);
%       allFacNorms = bsxfun(@times, edgeVecs(1,[2 3 1],:), edgeVecs(2,[3 1 2],:)) - ...
%           bsxfun(@times, edgeVecs(2,[2 3 1],:), edgeVecs(1,[3 1 2],:));
%       allFacNorms = bsxfun(@rdivide, allFacNorms, sqrt(sum(allFacNorms.^2,2)));
%       facNorms = num2cell(squeeze(allFacNorms)',1);
%       facCents = num2cell(squeeze(mean(facets,1))',1);
%       facEdgeSize = mean(reshape(sqrt(sum(edgeVecs.^2,2)),[],1,1));
%       figure
%       patch(fv,'FaceColor','g','FaceAlpha',0.2), hold on, quiver3(facCents{:},facNorms{:},facEdgeSize), view(3), axis image
%       title('All normals point IN')
%       % Turn over some random faces to point the wrong way
%       flippedFaces = rand(size(fv.faces,1),1)>0.75;
%       fv_turned = fv;
%       fv_turned.faces(flippedFaces,:) = fv_turned.faces(flippedFaces,[2 1 3]);
%       figure, patch(fv_turned,'FaceColor','flat','FaceVertexCData',double(flippedFaces))
%       colormap(summer), caxis([0 1]), view(3), axis image
%       % Fix them to all point the same way
%       [fv_fixed, fixedFaces] = unifyMeshNormals(fv_turned);
%       figure, patch(fv_fixed,'FaceColor','flat','FaceVertexCData',double(xor(flippedFaces,fixedFaces)))
%       colormap(summer), caxis([0 1]), view(3), axis image
%
%   See also SPLITFV, INPOLYHEDRON, STLWRITE

%   Copyright Sven Holcombe
%   $Date: 2013/07/3 $

%% Extract f and v

if nargin<2
    toFaceNo = 1;
end

if isstruct(f) && isfield(f,'faces')
    f_out = f;
    f = f.faces;
    FVstructInput = true;
elseif isnumeric(f) && size(f,2)==3
    FVstructInput = false;
    % f and v are already defined
else
    error('unifyMeshNormals:badArgs','Input must be a faces N-by-3 array or a faces/vertices structure.')
end

%%
% Get the list of all edges to all faces. Boundary edges will belong to
% only one face. Shared edges SHOULD have one face with the edge given in
% ascending order, one face with it given in descending order.
facesSz = size(f);
numFaces = size(f,1);
fromCols = 1:facesSz(2);
toCols = circshift(fromCols,[0 -1]);
edges = cat(3, f(:,fromCols), f(:,toCols));
% Work out which edges are ordered in ascending order
[~,tmpMinIdx] = min(edges,[],3);
edgeAscOrderMask = tmpMinIdx==1;
% Get edges in list form, and work out which edges partner with each other
edgesFlat = reshape(edges,[],2);
edgesFlat(~edgeAscOrderMask,:) = edgesFlat(~edgeAscOrderMask,[2 1]);
[~,~,edgeGrpNos] = unique(edgesFlat,'rows');
% Determine which edges are nicely partnered (asc/desc), and the face
% number that they link to.
edgeGrpIsUnified = false(size(edgeGrpNos));
numEdges = size(edgesFlat,1);
edgePartnerFaceNo = deal(nan(numEdges,1));
for i = 1:max(edgeGrpNos)
    mask = edgeGrpNos==i;
    edgeGrpIsUnified(mask) = nnz(mask)==2 && sum(edgeAscOrderMask(mask))==1;
    inds = find(mask);
    if length(inds)==2
        [edgePartnerFaceNo(inds),~] = ind2sub(facesSz, flipud(inds));
    end
end

%% Collect connected faces/edges
% March from the first face to each of its nicely (asc/desc) connected
% neighbour faces. Label each connected "set" of faces.
faceSets = zeros(numFaces,1,'uint32');
currentSet = 0;
facesLocked = false(numFaces,1);
edgesConsidered = false(numEdges,1);
currFaces = [];

while any(~facesLocked)
    % If we're not connected to anything, we must start a new set
    if isempty(currFaces)
        currFaces = find(~facesLocked,1);
        currentSet = currentSet + 1;
    end
    facesLocked(currFaces) = true;
    faceSets(currFaces) = currentSet;
    % Grab the edges of the current faces
    currEdgeInds = bsxfun(@plus, currFaces, 0:numFaces:numEdges-1);
    % Find which edges are nicely connected to unvisited faces
    currEdgeIndsToFollowMask = edgeGrpIsUnified(currEdgeInds) & ~edgesConsidered(currEdgeInds);
    % Show that we've visited all edges of the current faces
    edgesConsidered(currEdgeInds) = true;
    % Determine the new faces we would reach if we stepped via nice edges
    linkedFaces = edgePartnerFaceNo(currEdgeInds(currEdgeIndsToFollowMask));
    currFaces = linkedFaces(~isnan(linkedFaces) & ~facesLocked(linkedFaces));
end

%% Work out which sets need to be flipped and which stay the same
[setsTouched, setsToFlip] = deal(false(currentSet,1));
currentSets = [];

while any(~setsTouched)
    % If no current sets, pick the first one available. Any (next) sets
    % found touching it will need to be flipped
    if isempty(currentSets)
        currentSets = find(~setsTouched,1,'first');
        flipTheNextSet = true;
    end
    % We've now touched the current sets. Find these sets' faces.
    setsTouched(currentSets) = true;
    setsFaceInds = find(ismember(faceSets, currentSets));
    % Find edges that border these faces (includes edges from other sets)
    edgeIndsSharingBorder = find(ismember(edgePartnerFaceNo, setsFaceInds));
    % Find all the faces that share these edges
    [faceNosSharingBorder,~] = ind2sub(facesSz, edgeIndsSharingBorder);
    unqFaceNosSharingBorder = unique(faceNosSharingBorder);
    % Avoid flipping faces on any sets already touched
    unqFaceNosToFlipMask = ~setsTouched(faceSets(unqFaceNosSharingBorder));
    faceNosToFlip = unqFaceNosSharingBorder(unqFaceNosToFlipMask);
    % These will only be the border faces. Get the sets they belong to
    setNosToFlip = unique(faceSets(faceNosToFlip));
    % Flip those sets if we should. The first (root) set WON'T have been
    % flipped. Any touching it WILL get flipped. Any touching *those* will
    % already be in the same direction as the root set, so they WON'T be
    % flipped. The next WILL, WON'T, WILL, WON'T, etc.
    if flipTheNextSet
        setsToFlip(setNosToFlip) = true;
    end
    flipTheNextSet = ~flipTheNextSet;
    % Let the loop continue using the sets we just flipped as a source.
    currentSets = setNosToFlip;
end

%% Perform the actual flipping of all sets that require it
facesFlipped = ismember(faceSets, find(setsToFlip));
if facesFlipped(toFaceNo)
    facesFlipped = ~facesFlipped;
end
f(facesFlipped,:) = f(facesFlipped,[2 1 3]);

%% Return either an FV struct or a faces array, depending on input type
if FVstructInput
    f_out.faces = f;
else
    f_out = f;
end