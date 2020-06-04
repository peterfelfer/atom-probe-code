function massSpecSaxeyPlot(mc,multi)
% creates a correlative ion plot aka Saxey plot for data with the
% mass-to-charge values mc and the hit multiplicity multi. For a 2D
% diagram, only multiplicities of 2 are considered.
%
% INPUTS:   mc: column of mass-to-charge values, e.g., epos.mc 
%           
%           multi: hit multiplicity values, e.g., epos.multi
%
% OUTPUTS: no outputs allowed


% automatically converts hit multiplicites if 0s are present.
if ~ isempty(multi == 0)
    multi = convertMultiplicity(multi);
    disp('zeros were removed from hit multiplicity');
end

% automatically takes the 4th column if a pos file or epos file is parsed
if ~exist('mc', 'var')
        if length(mc(1,:) > 1)
        mc = mc(:,4);
        end
end


idx = multi == 2;

everySecond = logical(repmat([1; 0], sum(idx), 1));

idx1 = idx(everySecond);
idx2 = idx(~everySecond);

mc1(:,1) = mc(idx1);
mc1(:,2) = mc(idx2);

mc1 = sort(mc1,2);
mc1 = fliplr(mc1);

% query settings for plot
prompt = {'maximum m/c','bin width'};
dlg_title = 'bin width';
def = {'200','0.2'};

maxMC = inputdlg(prompt,dlg_title,1,def,'on');

if isempty(maxMC)
    return;
end


binWidth = str2num(maxMC{2});
maxMC = str2num(maxMC{1});
numBins = round(maxMC/binWidth);

isIn = ~((mc1(:,1)>maxMC) | (mc1(:,2)>maxMC));

mc1 = mc1(isIn,:);



figure;
scatter(mc1(:,1),mc1(:,2),'.k');
% 
% [his, centers] = hist3([mc1(:,1) mc1(:,2)],[numBins numBins]);
% surf(centers{1},centers{2},his);
% shading interp;
% 
% 
% set(gca,'ZScale','Log');
end

