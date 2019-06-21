function time = tof(massToCharge,voltage,flightDistance)
%calculates time of flight in ns based on mass in AMU, voltage in V and
%distance in mm

AMU = 1.66054e-27;%kg
elementaryCharge = 1.6E-19;

massToCharge = massToCharge * AMU;
flightDistance = flightDistance / 1000; %mm to m

time = sqrt(massToCharge * flightDistance^2 ./(2 * elementaryCharge * voltage));
time = time * 1E9;


