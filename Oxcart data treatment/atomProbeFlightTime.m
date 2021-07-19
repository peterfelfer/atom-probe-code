function [position, positionFieldFree, timeOfFlight, timeOfFlightFieldFree] = atomProbeFlightTime(voltage,angle,detectorPotential,flightPathLength,particleMassToChargestate, timeStep)
% calculates the flight path length and time of flight of a particle
% departing from a tip with a not field free drift region

electricField = [0 detectorPotential/flightPathLength];

%timeStep = 1e-9;             % Time step (sec)

protonMass = 1.660539e-27;    % Da to kg
elementaryCharge = 1.602177e-19;       % elementary charge [C]
particleChargeToMass = elementaryCharge/(particleMassToChargestate * protonMass);

position(1,:) = [0 0];
velocityScalar = sqrt(2 * particleChargeToMass * voltage);
[vx, vy] = pol2cart(pi/2 - angle, velocityScalar);
velocity(1,:) = [vx vy];

flightPathLengthFieldFree = sqrt((tan(angle) * flightPathLength)^2 + flightPathLength^2);
timeOfFlightFieldFree = flightPathLengthFieldFree/velocityScalar;
positionFieldFree = [0 0; tan(angle) * flightPathLength flightPathLength];

time = 0;
nStep = 1000;

time = zeros(nStep+1,1);

for i = 1:nStep
    accel = particleChargeToMass * electricField;
    velocity(i+1,:) = velocity(i,:) + timeStep * accel;
    position(i+1,:) = position(i,:) + timeStep * velocity(i+1,:);
    time(i+1) = time(i) + timeStep;
    
end

timeTMP = time(position(:,2) < flightPathLength);
timeOfFlight = timeTMP(end);

position = table(time,position);


