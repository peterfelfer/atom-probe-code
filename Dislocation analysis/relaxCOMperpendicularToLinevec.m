%% COM relaxation step WITH LINE NORMALS
function verts = relaxCOMperpendicularToLinevec(pos,verts,linevec,radius)


numVerts = length(verts(:,1));
numatoms = length(pos);
%pos(:,4) = pos(:,1:3);

temppos = pos;
distpos = pos;
dist = zeros(numatoms,1);

grid = verts;

%matrix with the center of masses
dcommat = zeros(numVerts,3);


KD = KDTreeSearcher(pos);

%% actual DCOM step
for i=1:numVerts
    idx = rangesearch(KD,verts(i,:),radius);
    tmpPos = pos(idx{1},:) - repmat(verts(i,:),[length(idx{1}),1]);
    dcommat(i,:) = mean(tmpPos,1);
end



alongLineVec = dot(dcommat,linevec,2);
alongLineVec = linevec.*repmat(alongLineVec,1,3);

dcommat = dcommat - alongLineVec;
grid(:,1:3) = verts(:,1:3) + dcommat;

verts = grid;

end