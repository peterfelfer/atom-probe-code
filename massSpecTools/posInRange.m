% @Martina and/or Benedict: Please delete the following lines, they are
% just a hint for you.
% Be aware, that the input variable "rng" has nothing to do with the
% output variable of the function readrrng (often used like rng = readrrng)!

function pos = posInRange(pos,rng)
% gives all ions within a given range [mcbeg1, mcend1; mcbeg2, mcend2 ...
%
% INPUT:
%   pos: table, pos file with .mc field
%   rng: array, pairs of begin and end values of mc [mcbeg1, mcend1;
%        mcbge2, mcend2; ...]
%
% OUTPUS:
%   pos: table, pos file with only the ions within the ranges of rng
%

isIn = false(height(pos(:,1)),1);

for r = 1:length(rng(:,1))
    in = pos.mc>=rng(r,1) & pos.mc<=rng(r,2);
    isIn = isIn | in;
end


pos = pos(isIn,:);