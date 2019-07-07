function handle = plotMassSpec(mc, bin, rng, oldPlot)

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
    hold on;
    
    f = get(ax,'Parent');
    
else
    f = figure('Name','mass spectrum');
    
    mcmax = max(mc);
    
    x = linspace(0,mcmax,round(mcmax/bin));
    
    % calculate as counts/(Da * totalCts) so that mass spectra with different
    % count numbers are comparable
    y = hist(mc,x) / bin / length(mc) *100;
    
    %med = median(y);
    
    % plot all mass spectrum
    handle = area(x,y,'FaceColor',[.9 .9 .9]);
    hold on;
    ax = get(handle,'Parent');
    
    set(gca,'YScale','Log');
    set(gcf, 'Name', 'Mass spectrum');
    set(gcf, 'Color', [1 1 1]);
    set(get(gca,'XLabel'),'String','mass-to-chargestate [Da]');
    set(get(gca,'YLabel'),'String','frequency [% / Da]');
    
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
    t.Position = [.6 .8 .27 .1];
    pan xon
    zoom xon
end





if exist('rng','var')
    %populate with plots of ranges
    for r=1:length(rng)
        inRng = (x>=rng(r).mcbegin) & (x<rng(r).mcend);
        rngPlotHandles(r) = area(x(inRng),y(inRng),'Parent',ax);
        rngPlotHandles(r).FaceColor = rng(r).color;
        
        %find peak and add label
        peakloc = find(y(inRng) == max(y(inRng)));
        peakloc = peakloc(1);
        locs = y(inRng);
        locs = locs(peakloc);
        
        th = text(rng(r).mcbegin,max(y(inRng)) * 1.25,rng(r).rangeName,'clipping','on');
        %th.Color = [.5 .5 .5];
        
        
        
    end
end




