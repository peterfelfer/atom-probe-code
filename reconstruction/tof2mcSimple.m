function mc = tof2mcSimple(t,t0,V,xDet,yDet,flightPathLength)
%calculates m/c based on idealized geometry / electrostatics
% m/c = 2 e V (t/L)^2

t = t - t0; %t0 correction

t = t * 1E-9;% tof in ns
xDet = xDet * 1E-3;% xDet in mm
yDet = yDet * 1E-3;
flightPathLength = flightPathLength * 1E-3;
e = 1.6E-19; % coulombs per electron
amu = 1.66E-27; % conversion kg to Dalton

flightPathLength = sqrt(xDet.^2 + yDet.^2 + flightPathLength.^2);

mc = 2 * V .* e .* (t ./ flightPathLength).^2;
mc = mc/amu;
%mc = mc * ; % converstion from kg/C to Da 6.022E23 g/mol, 1.6E-19C/ec