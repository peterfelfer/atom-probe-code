function fv = combinePatches(fvs)

numPatches = length(fvs);
numverts = 0;

fv.vertices = [];
fv.faces = [];

for i=1:numPatches
    fv.vertices = [fv.vertices; fvs(i).vertices];
    fv.faces = [fv.faces; fvs(i).faces + numverts];
    numverts = numverts + length(fvs(i).vertices);
end