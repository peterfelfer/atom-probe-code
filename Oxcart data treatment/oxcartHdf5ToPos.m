function [pos, instrument, raw] = oxcartHdf5ToPos(fileName)
%function to load HDF5 raw data file from the Oxcart atom probe

% INPUTS
% fileName ... name of the file, including path
%
% OUTPUTS
% pos
% instrument ... instrument parameter measurements during run (vacuum etc.)
% raw ... raw delayline TDC time bins

if ~exist('fileName','var')
    [file, path] = uigetfile({'*.h5'},'Select an oxcart HDF5 raw data file');
    fileName = [path file];
    disp(['file ' file ' loaded']);
end

%% constants
TOFFACTOR = 27.432/(1000 * 4); % 27.432 ps/bin, tof in ns, data is TDC time sum
DETBINS = 4900;
BINNINGFAC = 2;
XYFACTOR = 78/DETBINS*BINNINGFAC; % XXX mm/bin
XYBINSHIFT = DETBINS/BINNINGFAC/2; % to center detector


%% loading in data fields from HDF5
% dld data
detx = double(h5read(fileName,'/dld/x'));
detx = (detx - XYBINSHIFT) * XYFACTOR;
dety = double(h5read(fileName,'/dld/y'));
dety = (dety - XYBINSHIFT) * XYFACTOR;

tof = double(h5read(fileName,'/dld/t'));
tof = tof * TOFFACTOR;

VDC = double(h5read(fileName,'/dld/high_voltage'));
VP = double(h5read(fileName,'/dld/pulse_voltage'));

startCount = h5read(fileName,'/dld/start_counter');
deltaP = [0; startCount(2:end)-startCount(1:end-1)];

numAtom = length(detx);
ionIdx = (1:numAtom)';
x = nan([numAtom 1]);
y = nan([numAtom 1]);
z = nan([numAtom 1]);
mc = nan([numAtom 1]);
multi = nan([numAtom 1]);


% instrument data
VDCinstrument = h5read(fileName,'/oxcart/high_voltage');
VPinstrument = h5read(fileName,'/oxcart/pulse_voltage');
MCvacuum = h5read(fileName,'/oxcart/main_chamber_vacuum');
eventCount = h5read(fileName,'/oxcart/num_events');
stageTemperature = h5read(fileName,'/oxcart/temperature');
readoutTime = h5read(fileName,'/oxcart/time_counter');

% tdc raw data
tdcChannel = h5read(fileName,'/tdc/channel');
VDCtdc = h5read(fileName,'/tdc/high_voltage');
VPtdc = h5read(fileName,'/tdc/pulse_voltage');
startCountTdc = h5read(fileName,'/tdc/start_counter');
readoutTimeTdc = h5read(fileName,'/tdc/time_data');

% time in 


%% converting into usual formats


%% building variables
% pos
pos = table(ionIdx,x,y,z,mc,tof,VDC,VP,detx,dety,deltaP,multi);
pos.Properties.VariableNames = {'ionIdx','x','y','z','mc','tof','VDC','VP','detx','dety','deltaP','multi'};
pos.Properties.VariableUnits = {'1','nm','nm','nm','Da','ns','V','V','mm','mm','1','1'};    

% instrument
instrument = 'not implemented yet';

% raw
raw = 'not implemented yet';

disp(['Oxcart raw data file ' file ' loaded']);