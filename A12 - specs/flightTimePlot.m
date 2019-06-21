% Script to make a plot of flight times and pulse frequency limitations
flightPathLength = 110;%mm
detectorDiameter = 40;%mm
distance = sqrt(flightPathLength^2 + (detectorDiameter/2)^2);
detectorVeto = 20;
maxPulseAmplitude = 3200;%V
pulseFraction = 0.2;
maxAPTVoltage = 0;

minVolt = 1000;
maxVolt = 20000;
voltage = minVolt:10:maxVolt;
textLoc = 2000; % voltage at which labels should be plot

amu = [1, 12.5, 50, 100, 200];
pulseFrequencies = [500, 1000]; % in kHz

% special species to label
species = true;
sp(1).amu = 27;
sp(1).name = 'Al27+';
sp(1).color = [0 0 .8];

sp(2).amu = 71;
sp(2).name = 'Ga71+';
sp(2).color = [1 0 0];

sp(3).amu = 6;
sp(3).name = 'C12++';
sp(3).color = [0.52 0.4 0.25];

f = figure;
set(f,'Name','tof spectra');
set(gcf,'color','w');


%% plotting tof lines for constant m/c
numAMU = length(amu);
for i=1:numAMU
    plot(voltage,tof(amu(i),voltage,distance), 'k');
    text(textLoc*1.1,tof(amu(i),textLoc,distance),[num2str(amu(i)) ' Da']);
    hold on;
end

if species
    for i=1:length(sp)
        plot(voltage,tof(sp(i).amu,voltage,distance),'Color',sp(i).color);
        text(textLoc*1.1,tof(sp(i).amu,textLoc,distance),sp(i).name);
        hold on;
    end
end

%% plotting limit lines for pulse frequencies
numFrequ = length(pulseFrequencies);
for i=1:numFrequ
    pulsePeriod = 1/(pulseFrequencies(i) * 1000) * 1E9;
    line([minVolt,maxVolt * .88],[pulsePeriod, pulsePeriod]);
    text(maxVolt * .9, pulsePeriod, [num2str(pulseFrequencies(i)) ' kHz']);
end

ylabel('flight time [ns]');
xlabel('evaporation voltage [V]');

xl = xlim;
yl = ylim;
text(xl(2) * .7, yl(2) *.9, ['flight path length: ' num2str(flightPathLength) ' mm'])
