function handle = plotMassSpec(mc, bin, mode, rng, oldPlot)
% plotMassSpec plots the data from pos to get a Massspectrum
%
% handle = plotMassSpec(mc, bin, mode, rng, oldPlot)
%
% INPUTS
% mc:       is the mass-to-charge(mc)-ratio [Da] of the events in the 
%           APT-Measurement stored in pos, table
% bin:      is the width of the steps in which the plot is performed, 
% mode:     Specifies the way the counts are applied
%           'count' records the number of counts
%           'normalised' records the number of counts if the bin was one Da
%           wide over the overall number of counts
% rng:      loads existing ranges from rng if paresed before
% oldPlot:  if old Plot is parsed, it will be deleted and replaced, zoom 
%           limits will be kept
% 
% OUTPUTS
%           figure that contains plot of counts or
%           (counts/Dalton)/totalCounts over Dalton. Used in further
%           analysis to find new ions


% count is default mode
if ~exist('mode','var')
    mode = 'count';
end

if istable(mc)
    mc = mc.mc;
end

if length(mc(1,:)) > 1
    mc = mc(:,4);
end

%if old Plot is parsed, it will be deleted and replaced, zoom limits will
%be kept
if exist('oldPlot','var')
    ax = get(oldPlot,'Parent');
    XLim = ax.XLim;
    plots = get(get(oldPlot,'Parent'),'Children');
    x = oldPlot.XData;
    y = oldPlot.YData;
    delete(plots);
    handle = area(ax,x,y,'FaceColor',[.9 .9 .9]);
    handle.UserData.plotType = "massSpectrum";
    hold on;
    
    f = get(ax,'Parent');
    
else
    f = figure('Name','mass spectrum');
    ax = axes(f);
    
    mcmax = max(mc);
    
    x = linspace(0,mcmax,round(mcmax/bin));
    
    if strcmp(mode,'count')
        y = hist(mc,x);
    elseif strcmp(mode,'normalised')
        % calculate as counts/(Da * totalCts) so that mass spectra with different
        % count numbers are comparable
        y = hist(mc,x) / bin / length(mc);
        %med = median(y);
    end
    
    % plot all mass spectrum
    handle = area(x,y,'FaceColor',[.9 .9 .9]);
    handle.UserData.plotType = "massSpectrum";
    hold on;
    ax = get(handle,'Parent');
    
    set(gca,'YScale','Log');
    set(gcf, 'Name', 'Mass spectrum');
    set(gcf, 'Color', [1 1 1]);
    set(get(gca,'XLabel'),'String','mass-to-chargestate [Da]');
    
    if strcmp(mode,'count')
        ylabel('frequency [counts]');
    elseif strcmp(mode,'normalised')
        ylabel('frequency [cts / Da / totCts]');
    end
    
    
    %% annotation with range stats
    t = annotation('textbox');
    % determining the background at 4Da
    upperLim = 4.5; %Da
    lowerLim = 3.5; %Da
    BG4 = sum(y((x >= lowerLim) & (x <= upperLim)))/(upperLim-lowerLim);
    BG4 = BG4/length(mc) * 1E6;
    t.String = {['bin width: ' num2str(bin) ' Da'], ['num atoms: ' num2str(length(mc)) ], ['backG @ 4Da: ' num2str(BG4,3) ' ppm/Da']};
    t.BackgroundColor = 'w';
    t.FaceAlpha = 0.8;
    t.Position = [.15 .8 .27 .1];
    pan xon
    zoom xon
end





if exist('rng','var')
    %populate with plots of ranges
    for r=1:length(rng)
        inRng = (x>=rng(r).mcbegin) & (x<rng(r).mcend);
        rngPlotHandles(r) = area(x(inRng),y(inRng),'Parent',ax);
        rngPlotHandles(r).FaceColor = rng(r).color;
        rngPlotHandles(r).DisplayName = rng(r).rangeName;
        rngPlotHandles(r).UserData.plotType = "range";
        
        %find peak and add label
        peakloc = find(y(inRng) == max(y(inRng)));
        peakloc = peakloc(1);
        locs = y(inRng);
        locs = locs(peakloc);
        
        th(r) = text(rng(r).mcbegin,max(y(inRng)) * 1.25,rng(r).rangeName,'clipping','on');
        %th.Color = [.5 .5 .5];
        th(r).UserData.plotType = "rangeName";
        
        
    end
end

handle.DisplayName = 'mass spectrum';



