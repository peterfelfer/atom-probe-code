function out = tofVoltageCurve(detx, dety,tof, V, N, minHeight, center, radius)
% creates track of peaks in tof spectrum vs field evaporation voltage in
% discrete blocks of N atoms. projection center and cropping radius are
% options. minHeight is the minium height of an individual peak in counts
% span is the span of voltage values in one bin. Should be as low as
% possible

%constants
MINSEP = 10; % minimum separation of peaks in tof spectrum in ns
BINWIDTH = 0.25; % bin width of tof spectrum in ns. Should be ca. timing resolution of the detector (Oxcart 0.17ns)

if ~exist('center','var')
    center = [0 ,0];
    radius = 2;
end

in = cropDetectorRegion(detx,dety,center,radius);
V = V(in);
tof = tof(in);
numAtoms = length(V);

%sort by voltage, so blocks of N atoms can easily be created
[V, idx] = sort(V);
tof = tof(idx);
blocks = 1:N:numAtoms;
pkTOF = [];
pkV = [];
pk = [];
span = [];
ismax = [];

f = figure;

w = warning ('off','all');
for i=1:length(blocks)-1
    % create tof histogram of the block and identify peaks
    h = histogram(tof(blocks(i):blocks(i+1)),'BinWidth',BINWIDTH);
    [pks,locs] = findpeaks(h.Values,'MinPeakDistance',MINSEP,'MinPeakHeight',minHeight);
    numPk = length(pks);
    
    maxTmp = pks == max(pks);
    ismax = [ismax; maxTmp'];
    
    pkTOFtmp = h.BinEdges(locs) + h.BinWidth/2;
    pkTOF = [pkTOF; pkTOFtmp'];
    pk = [pk; pks'];
    
    Vtmp = mean(V(blocks(i):blocks(i+1)));
    spanTmp = max(V(blocks(i):blocks(i+1))) - min(V(blocks(i):blocks(i+1)));
    
    pkV = [pkV; ones(numPk,1)*Vtmp];
    span = [span; ones(numPk,1)*spanTmp];
end
w = warning ('on','all');

delete(h);
delete(f);
ismax = logical(ismax);

% output as table
out = table(pkTOF, pk, pkV, span, ismax);

