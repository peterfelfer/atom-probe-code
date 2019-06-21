function pos = posInRange(pos,rng)
%gives all ions within a given range [mcbeg1, mcend1; mcbeg2, mcend2 ...

isIn = false(length(pos(:,1)),1);

for r = 1:length(rng(:,1))
    in = pos(:,4)>=rng(r,1) & pos(:,4)<=rng(r,2);
    isIn = isIn | in;
end


pos = pos(isIn,:);