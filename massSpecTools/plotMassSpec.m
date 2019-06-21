function handle = plotMassSpec(mc, bin, mcmax)

if length(mc(1,:)) > 1
    mc = mc(:,4);
end

if ~exist('bin', 'var')
    bin = 0.025;
end

if ~exist('mcmax','var')
    mcmax = max(mc);
end


x = linspace(0,mcmax,round(mcmax/bin));

y = hist(mc,x);

%med = median(y);

handle = area(x,y,'FaceColor',[.8 .8 .8]);

set(gca,'YScale','Log');
set(gcf, 'Name', 'Mass spectrum');
set(gcf, 'Color', [1 1 1]);
set(get(gca,'XLabel'),'String','mass-to-chargestate [Da]');
set(get(gca,'YLabel'),'String','frequency');
set(gca,'XLim', [0 mcmax]);


%% determining the background at 4Da

upperLim = 4.5; %Da
lowerLim = 3.5; %Da



BG4 = sum(y((x >= lowerLim) & (x <= upperLim)))/(upperLim-lowerLim);
BG4 = BG4/length(mc) * 1E6;


txt = {['bin width: ' num2str(bin) ' Da'], ['num atoms: ' num2str(length(mc)) ], ['backG @ 4Da: ' num2str(BG4,3) ' ppm/Da']};

%text(mcmax*.6,max(y)*.9,txt);

zoom xon
