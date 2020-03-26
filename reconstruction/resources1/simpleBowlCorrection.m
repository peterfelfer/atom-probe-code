function fac = simpleBowlCorrection(detx,dety,flightPathLength,center)
% calculates a simple geometric bowl correction based on hit location and
% projection center (optional)

if ~exist('center','var')
    center = [0,0];
end

detx = detx - center(1);
dety = dety - center(2);

fac = sqrt(sum([detx.^2, dety.^2],2) + flightPathLength^2)/flightPathLength;