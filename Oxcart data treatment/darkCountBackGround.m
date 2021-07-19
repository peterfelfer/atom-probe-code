function bg = darkCountBackGround(numPulse,darkCountRate, binWidth)
% Calculates the dark count background in a tof spectrum based on the pulse
% number of pulses used in the experiment and the dark count rate. If the
% bin width is given, it will give counts per bin.
%
% INPUTS: numPulse: number of pulses in the experiment
%           darkCountRate: dark count rate in cts/sec
%            binWidth: width of time bins in ns


ctsPerNsTotal = darkCountRate *1e-9 * numPulse;

bg = ctsPerNsTotal * binWidth;
