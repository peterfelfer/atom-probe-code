function [pkcnt pkdata] = countsPeakBackgroundCorrected(options,bgRegion,massSpec)
% Fits a linear background (least squares) to a peak in a mass spectrum
% based on 'brushed' background bins. 
% For this, the mass spectrum has to be in the active axes, with the background bins marked. 
% Also plots the results.
%
% [pkcnt pkdata] = countsPeakBackgroundCorrected();
% [pkcnt pkdata] = countsPeakBackgroundCorrected(options);
% [pkcnt pkdata] = countsPeakBackgroundCorrected(options,bgRegion);
% [pkcnt pkdata] = countsPeakBackgroundCorrected(options,bgRegion,massSpec);
%
% INPUT
% options:              'r': add a fictional range and calculate the signal to 
%                       background for that range
%                       'a': same as 'r', but automatically creates ranges by optimising the
%                       ratio of missed atoms / background atoms = 1
%
% bgRegion/ctRegion:    table, is the option of parsing the background estimate and 
%                       mass spec for use in further automation
%
% massSpec:             table, mass spectrum
% 
% HINT: bgRegion and massSpec must be tables with .mc and .cts fields.
%
% OUTPUT
% pkcnt:                scalar with peak count in percent
%
% pkdata:               structure with peak data, peak location in Da
%
% HINT: keep in mind not to use a 'normalised' mass spectrum plot, if you
%       want to know the number of ions in a peak
%
% (c) by Prof. Peter Felfer Group @FAU Erlangen-N�rnberg

rngLabelHeight = 0.65; % height of the stem plot delineating the range


% determine mc range
%% all mass-to-charge and counts in the interval


if ~exist('massSpec','var')
    handles = get(gca,'Children');
    
    mc = get(handles(end),'Xdata');
    cnt = get(handles(end),'Ydata');
else
    
    mc = massSpec.mc;
    cnt = massSpec.cts;
    
end

numAtoms = sum(cnt);


%% get baseline input

if ~exist('bgRegion','var')
    % selection of BG region before
    sel = getrect;
    BGbeforeXmin = sel(1);
    BGbeforeXmax = sel(1) + sel(3);
    inBefore = mc>BGbeforeXmin & mc<BGbeforeXmax;
    
    % selection of BG region after
    sel = getrect;
    BGafterXmin = sel(1);
    BGafterXmax = sel(1) + sel(3);
    inAfter = mc>BGafterXmin & mc<BGafterXmax;
    
    in = or(inBefore, inAfter);
    
    mcData = mc(in);
    cntData = cnt(in);

else
    if isnumeric(bgRegion)
        mcData = bgRegion(:,1);
        cntData = bgRegion(:,2);
    elseif isstruct(bgRegion)
        mcData = bgRegion.mc;
        cntData = bgRegion.cts;
    end
end



idxBeg = find(mc == min(mcData));
idxEnd = find(mc == max(mcData));

mc = mc(idxBeg:idxEnd);
cnt = cnt(idxBeg:idxEnd);

pkloc = mc(cnt == max(cnt));


%% calculate linear fit of baseline
lin_reg = polyfit(mcData,cntData,1);

a1 = lin_reg(1);
b1 = lin_reg(2);

fitCts = a1*mc+b1;

sumFitCnt = sum(fitCts);
sumCnt = sum(cnt);      





pkcnt = sumCnt - sumFitCnt;






%% plotting of results
pct = pkcnt/numAtoms * 100;
sym = ' %';


if pct < 0.1
    pct = pct/100 * 1E6;
    sym = ' ppm';
end


f = figure();
plot(mc,cnt);
hold on
plot(mc,fitCts,'r','LineWidth',2);


set(gcf, 'Color', [1 1 1]);
set(gcf, 'Name', 'Background fit for peak');
set(get(gca,'XLabel'),'String','mass-to-chargestate [Da]');
set(get(gca,'YLabel'),'String','frequency');

legend('mc spectrum','bg fit');






xLim = get(gca,'XLim');
yLim = get(gca,'YLim');

txtPos = [xLim(1) + 0.02 * (xLim(2) - xLim(1)); ...
    yLim(1) + 0.8 * (yLim(2) - yLim(1))];


txt = {['ions in peak: ' num2str(round(pkcnt))],...
    ['pct of all ions: ' num2str(pct,3) sym],...
    ['peak location: ' num2str(pkloc) ' Da']};


%% executing optional commands
if exist('options','var')
    
    switch options
        case 'r'
            
            % signal/background for range
            rec = getrect(gca);
            
            mcmin = rec(1);
            mcmax = mcmin + rec(3);
            
            rngCtsPk = sum(cnt((mc>mcmin) & (mc<mcmax)));
            rngCtsBg = sum(fitCts((mc>mcmin) & (mc<mcmax)));
            
            BGfraction = rngCtsBg/(rngCtsPk+rngCtsBg)*100;
            
            rngBgGlobal = rngCtsBg/(numAtoms * (mcmax - mcmin));
            
            sym = ' %';
            if BGfraction < 0.1
                BGfraction = pct/100 * 1E6;
                sym = ' ppm';
            end
            
            txt{end+1} = ' ';
            txt{end+1} = ['range: ' num2str(mcmin) ' - ' num2str(mcmax) ' Da'];
            txt{end+1} = ['range background: ' num2str(BGfraction,3) sym];
            txt{end+1} = ['range background: ' num2str(rngBgGlobal*1E6,3) ' ppm/Da'];
            
            
            missedAt = 100 - (rngCtsPk - rngCtsBg)/pkcnt *100;
            txt{end+1} = ['missed atoms: ' num2str(missedAt) ' %'];
            
            
            stem([mcmin mcmax],[yLim(2)*rngLabelHeight yLim(2)*rngLabelHeight],'k','Marker','none','LineWidth',2);
            
            
        case 'a'
            
            % auto range optimisation; moves borders of range until the
            % peak background matches the amount of ions missed
            
            % pkloc = peak location
            % cnt = counts per bin
            % mc = mass to charge center of bin
            
            % divide into before and after peak
            
            % before
            ctsBeforePk = cnt(mc<pkloc);
            
            mcBeforePk = mc(mc<pkloc);
            fitCtsBeforePk = fitCts(mc<pkloc);
            
            rngCtsPk = cumsum(ctsBeforePk);
            rangeCtsBg = cumsum(fitCtsBeforePk);
            
            BGincluded = rangeCtsBg(end) - rangeCtsBg;
            missedAtoms = rngCtsPk - rangeCtsBg;
            
            bal = BGincluded - missedAtoms;
            
            mcBegin = min(mcBeforePk(bal<0));
            
            
            
            
            % after
            ctsAfterPk = cnt(mc>=pkloc);
            ctsAfterPk = fliplr(ctsAfterPk);
            
            mcAfterPk = mc(mc>=pkloc);
            mcAfterPk = fliplr(mcAfterPk);
            
            fitCtsAfterPk = fitCts(mc>=pkloc);
            fitCtsAfterPk = fliplr(fitCtsAfterPk);
            
            rngCtsPk = cumsum(ctsAfterPk);
            rangeCtsBg = cumsum(fitCtsAfterPk);
            
            BGincluded = rangeCtsBg(end) - rangeCtsBg;
            missedAtoms = rngCtsPk - rangeCtsBg;
            
            bal = BGincluded - missedAtoms;
            
            mcEnd = min(mcAfterPk(bal>0));
            
            
            
            % determination of mislabeled atoms
            mcmin = mcBegin;
            mcmax = mcEnd;
            
            rngCtsPk = sum(cnt((mc>mcmin) & (mc<mcmax)));
            rngCtsBg = sum(fitCts((mc>mcmin) & (mc<mcmax)));
            
            BGfraction = rngCtsBg/(rngCtsPk+rngCtsBg)*100;
            
            rngBgGlobal = rngCtsBg/(numAtoms * (mcmax - mcmin));
            
            pkdata.mcbegin = mcBegin;
            pkdata.mcend = mcEnd;
            
            sym = ' %';
            if BGfraction < 0.1
                BGfraction = pct/100 * 1E6;
                sym = ' ppm';
            end
            
            txt{end+1} = ' ';
            txt{end+1} = ['range: ' num2str(mcmin) ' - ' num2str(mcmax) ' Da'];
            txt{end+1} = ['range background: ' num2str(BGfraction,3) sym];
            txt{end+1} = ['range background: ' num2str(rngBgGlobal*1E6,3) ' ppm/Da'];
            
            
            
            missedAt = 100 - (rngCtsPk - rngCtsBg)/pkcnt *100;
            txt{end+1} = ['missed atoms: ' num2str(missedAt) ' %'];
            
            
            stem([mcmin mcmax],[yLim(2)*rngLabelHeight yLim(2)*rngLabelHeight],'k','Marker','none','LineWidth',2);
    end
end



%% plotting numerical results



text(txtPos(1),txtPos(2),txt);


pkdata.loc = pkloc;



% exports the figure to the clipboard on Windows
if ispc
    hgexport(f,'-clipboard');
end

end