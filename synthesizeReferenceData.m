% creates two test files, one with an artificial grain boundary and one
% with an artificial phase boundary

addpath('Resources');

mc1 = 1; %mass to charge of bulk
mc2 = 2; %mass to charge of solute

%% synthesis of grain and phase boundary data
% size of volume
sz = 20;
step = 0.5; % stepsize of reference distribution
z = -sz : step : sz ;
atomDens = 100;

numStep = length(z);

segWidth = 2;


% concentration values 
baseConc = 1;%
GB1fac = 5;% IE of GB
GB2fac = 15;% IE of GB
phaseConc = 10;%


% synthesis of reference distribution
zconc = ones(1,numStep) * baseConc;


excess = normpdf(z,0,segWidth);

GB1conc = zconc + excess * GB1fac;
GB2conc = zconc + excess * GB2fac;

pbconc = zeros(1,numStep);
pbconc(find(z==0):end) = phaseConc;

PBconc = zconc + excess * GB2fac + pbconc;



% synthesis of position data
numAtom = (sz * 2)^3 * atomDens;
pos = rand(numAtom,3);
pos = unique(pos,'rows');
pos = pos * sz * 2 - sz;
pos = sortrows(pos,3);


GB1propval = interp1(z,GB1conc/100,pos(:,3));
GB2propval = interp1(z,GB2conc/100,pos(:,3));
PBpropval = interp1(z,PBconc/100,pos(:,3));

sample = rand(length(pos),1);

isGB1 = sample < GB1propval;
isGB2 = sample < GB2propval;
isPB = sample < PBpropval;


% sythesis of m/c data


mcGB1 = mc2 * isGB1;
mcGB1(~isGB1) = mc1;

mcGB2 = mc2 * isGB2;
mcGB2(~isGB2) = mc1;

mcPB = mc2 * isPB;
mcPB(~isPB) = mc1;


% saving of pos files
% phase boundary
savepos([pos, mcPB],'testPB.pos');


% grain boundary
pos(:,1) = pos(:,1) - sz;
GBpos = [pos, mcGB1];
pos(:,1) = pos(:,1) + 2*sz;
GBpos = [GBpos; [pos, mcGB2]];
savepos(GBpos,'testGB.pos');


%% synthesis of spherical precipitate
% sperical with constant concentration and excess at boundary
% excess is different for left and right side of precipitate

precRad = 10;
precConc = 25; % e.g. Ni3Al
baseConc = 1; %
interfacialExcessL = 25;
interfacialExcessR = 50;
segWidth = 1;


rmax = sqrt(3* sz^2) *1.1;


% synthesis of position data
numAtom = (sz * 2)^3 * atomDens;
pos = rand(numAtom,3);
pos = unique(pos,'rows');
pos = pos * sz * 2 - sz;
pos = sortrows(pos,3);

% creating reference distribution
r = 0: sample: rmax;
concL = ones(size(r));
concL(r <= precRad) = precConc;
concR = concL;



excess = normpdf(r,precRad,segWidth);

concL = concL + excess * interfacialExcessL;
concR = concR + excess * interfacialExcessR;

% sampling
atomRad = sqrt(sum(pos.^2,2));
isL = pos(:,1) < 0;

precPropVal(isL) = interp1(r,concL/100,atomRad(isL));% probability of an atom to be solute
precPropVal(~isL) = interp1(r,concR/100,atomRad(~isL));

isSol = sample < precPropVal';

mcPrec(isSol) = mc2;
mcPrec(~isSol) = mc1;

savepos([pos,mcPrec'],'testPrecipitate.pos');

%% synthesis of 'cluster' array
%tbi

%% synthesis of random solid solution
%tbi


disp('all reference files synthesized');






























