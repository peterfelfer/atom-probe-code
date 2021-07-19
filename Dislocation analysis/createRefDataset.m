%script that creates reference dislocation dataset

vol = [20 20 20];
dens = 100;
dia = 0.5;
pct = 1;


numAtom = prod(vol)*dens;
obj = read_wobj_v2;
verts = obj.vertices;
scatter3(verts(:,2),verts(:,1),verts(:,3),'ob'); axis equal; rotate3d on;
pos = rand(numAtom,3).*repmat(vol,numAtom,1) - repmat(vol/2,numAtom,1);
mc = ones(numAtom,1);

closest = dsearchn(verts,delaunayn(verts),pos(:,1:3));
distVec = pos(:,1:3) - verts(closest,:);
dist = sqrt(sum(distVec.^2,2));
prob = normpdf(dist,0,dia);
prob = prob/max(prob);
randVar = rand(numAtom,1);
prob = prob > randVar;

mc(prob) = 2;

sample = randsample(numAtom,round(numAtom*pct/100));
mc(sample) = 2;

pos = [pos, mc];

scatter3( pos(pos(:,4) == 2,1) ,pos(pos(:,4) == 2,2),  pos(pos(:,4) == 2,3),'.k');
axis equal; rotate3d on;
savepos(pos);