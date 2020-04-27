function rangeEdit(range,mcbegin,mcend)
% edits range boundaries 
% 
% rangeEdit(gco,mcbegin,mcend) changes range boundaries of selected range 
% according to input values for mcbegin und mcend
%
% rangeEdit() or rangeEdit(gco) uses current selected object in the mass spectrum
% and lets the user edit the range boundaries manually within the mass spectrum 
% (if the object is a range)
%
% INPUTS: range, area
%         mcbegin, mcend, range boundaries
%        

if ~exist('range','var')
    range = gco;
end

%check if object is a range
try
    type = range.UserData.plotType;
catch
    type = "unknown";
end

if type == "range"
    
    % get data from mass spectrum
    plots = range.Parent.Children;
    for pl = 1:length(plots)
        try
            isMS = plots(pl).UserData.plotType == "massSpectrum";
        catch
            isMS = false;
        end 
        
        if isMS
            xData = plots(pl).XData;
            yData = plots(pl).YData;
        end
    end
    
    if ~exist('mcbegin','var') %get graphical input
        axes(range.Parent);
        lim = ginput(2);
        lim = lim(:,1);
        lim = sort(lim);
        mcbegin = lim(1);
        mcend = lim(2);
    end
    
    
    %change range limits
    isIn = xData > mcbegin & xData < mcend;
    range.XData = xData(isIn);
    range.YData = yData(isIn);
    
else
    error('selected object is not a range');
end
