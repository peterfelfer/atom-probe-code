function points = extractBowlPoints(detx, dety, mcin, pixelSize, minHeight)
% function that divides detector space in pixlels and calculates the
% local maxima in the mc for bowl fit.

%constants
MINSEP = .5; % minimum separation of peaks in tof or mc spectrum
BINWIDTH = 0.1; % bin width of tof spectrum
MINCOUNTS = 10; % minimum number of counts in a pixel to have points extracted

xId = round(detx/pixelSize);
yId = round(dety/pixelSize);
xOffset = min(xId) * pixelSize;
yOffset = min(yId) * pixelSize;

xId = xId - min(xId);
yId = yId - min(yId);

numXpix = length(unique(xId));
numYpix = length(unique(yId));


x = [];
y = [];
mc = [];
counts = [];
ismax = [];
f = figure;
w = warning ('off','all');
for ix = 1:numXpix
    for iy = 1:numYpix
        numCounts = sum(xId == ix & yId == iy);
        if numCounts > MINCOUNTS
            h = histogram(mcin(xId == ix & yId == iy),'BinWidth',BINWIDTH);
            [pks,locs] = findpeaks(h.Values,'MinPeakDistance',MINSEP,'MinPeakHeight',minHeight);
            
            numPks = length(pks);
            mcTmp = h.BinEdges(locs) + h.BinWidth/2;
            mc = [mc; mcTmp'];
            counts = [counts; pks'];
            maxTmp = pks == max(pks);
            ismax = [ismax; maxTmp'];
            
            xTmp = ix * pixelSize + xOffset;
            yTmp = iy * pixelSize + yOffset;
            
            x = [x; ones(numPks,1)*xTmp];
            y = [y; ones(numPks,1)*yTmp];
            
        end
        
    end
end
w = warning ('on','all');
delete(f);

ismax = logical(ismax);
points = table(x,y,mc,counts,ismax);
