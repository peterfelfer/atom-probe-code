function multi = convertMultiplicity(multi)
%% takes the hitmultiplicity from an epos file, which has zeros after a
%% mltiple event and coverts these zeros into the hitmultiplicity of that
%% event.
multi = uint8(multi);

maxMulti = max(multi);

idx = ~multi;


for mul = 1:maxMulti   
    newIdx = [idx(2:end); false];
    multi(idx) = multi(newIdx);
    idx = ~multi;
end